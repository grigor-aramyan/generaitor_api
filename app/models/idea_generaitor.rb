class IdeaGeneraitor < ApplicationRecord
    has_one :user, as: :accountable
end
