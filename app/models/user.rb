class User < ActiveRecord::Base
	has_many :trains
  
  validates_uniqueness_of :phone
  validates_presence_of :phone
end
