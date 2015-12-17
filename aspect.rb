require_relative "category"
require_relative "item"

class Aspect < ActiveRecord::Base
	belongs_to :category
	belongs_to :item
end
