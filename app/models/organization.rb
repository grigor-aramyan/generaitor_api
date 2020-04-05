class Organization < ApplicationRecord
    has_one :user, as: :accountable
    has_many :products
end
