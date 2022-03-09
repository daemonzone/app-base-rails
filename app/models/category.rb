# frozen_string_literal: true

class Category < ApplicationRecord
  before_save :setkey
  has_one_attached  :cover
  
  has_many  :services

  def setkey
  	self.key = self.title.parameterize
  end

end
