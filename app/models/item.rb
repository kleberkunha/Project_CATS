class Item < ApplicationRecord
  has_many :carts

  has_one_attached :photo
end
