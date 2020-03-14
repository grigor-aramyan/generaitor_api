class Organization < ApplicationRecord
    has_one :user, as: :accountable
end
