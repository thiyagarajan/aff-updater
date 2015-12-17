require_relative "category"
require_relative "photo"
require_relative "aspect"

class Item < ActiveRecord::Base
	has_many :aspects
	has_many :photos
	belongs_to :category
end
