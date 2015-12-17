require_relative "aspect"
require_relative "item"
require_relative "photo"

class Category < ActiveRecord::Base
	has_many :aspects
	has_many :items
end
