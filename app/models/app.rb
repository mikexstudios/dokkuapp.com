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

require 'resolv'

class App < ActiveRecord::Base
  after_save :update_dns
  before_destroy :remove_dns

  validates :name, :presence => true,
                   :length => { :maximum => 255 }
  #http://stackoverflow.com/questions/3756184/rails-3-validate-ip-string
  validates :address, :presence => true, 
                      :format => { :with => Resolv::IPv4::Regex }

  def update_dns
  end

  def remove_dns
  end
end
