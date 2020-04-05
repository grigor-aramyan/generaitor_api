class Product < ApplicationRecord
  belongs_to :organization

  validates :title, :description, presence: true
end
