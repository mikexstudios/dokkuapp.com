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

class App < ActiveRecord::Base
end
