class Alternative < ActiveRecord::Base
  belongs_to :choice
  has_many :expressions
end
