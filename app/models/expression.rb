class Expression < ActiveRecord::Base
  belongs_to :alternative
  belongs_to :preference
end
