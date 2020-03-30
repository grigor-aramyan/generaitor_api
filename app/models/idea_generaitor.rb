class IdeaGeneraitor < ApplicationRecord
    has_one :user, as: :accountable
    has_many :ideas
end
