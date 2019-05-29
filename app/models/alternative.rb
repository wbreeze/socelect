require 'validTitleDescription'
class Alternative < ApplicationRecord
  include TitleDescriptionValidation
  before_validation :ensureTitleUsingDescription
  validate :valid_title_and_description_allow_yes_no

  belongs_to :choice
  has_many :expressions
end
