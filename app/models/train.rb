class Train < ActiveRecord::Base

	belongs_to :user
	validates_presence_of :time
	validates_presence_of :line
	validates_presence_of :stop
	validates_presence_of :user_id
	validates_presence_of :days

end
