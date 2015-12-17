require_relative "photo"

class Photo < ActiveRecord::Base
	belongs_to :item
end
