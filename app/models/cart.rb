class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_lines
  has_many :items, through: :cart_lines
end
