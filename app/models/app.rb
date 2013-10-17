# == Schema Information
#
# Table name: apps
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'resolv' #for validating IP address
require 'route53'

class App < ActiveRecord::Base
  before_save :update_dns #must be before_save since we need to check if record exists
  before_destroy :remove_dns

  validates :name, :presence => true, :uniqueness => true,
                   :length => { :maximum => 255 }
  #http://stackoverflow.com/questions/3756184/rails-3-validate-ip-string
  validates :address, :presence => true, 
                      :format => { :with => Resolv::IPv4::Regex }

  def get_hostname
    return '%s.%s' % [name, Rails.application.config.route53_zone]
  end

  private

  def update_dns
    r = get_route53_record
    #See if app entry already exists in database
    a = App.find_by name: name
    #To update an entry in route53, we need to delete it first (need to know 
    #previous address value before deleting).
    a.destroy if not a.nil?
    r.create
  end

  def remove_dns
    r = get_route53_record
    r.delete
  end

  def get_route53_record
    conn = Route53::Connection.new(ENV['AWS_ACCESS_KEY'],
                                   ENV['AWS_SECRET_KEY'])
    zone = Route53::Zone.new(Rails.application.config.route53_zone, 
                             '/hostedzone/%s' % Rails.application.config.route53_zoneid, 
                             conn)
    record = Route53::DNSRecord.new(get_hostname, 'A',
                                    Rails.application.config.route53_ttl,
                                    [address, ],
                                    zone)
    return record
  end
end
