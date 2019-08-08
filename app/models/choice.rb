class Choice < ApplicationRecord
  include TitleDescriptionValidation
  include Tokenz

  TOKEN_LENGTH = 14

  validate :valid_title_and_description_lengths, :valid_alternative_count
  #apply_simple_captcha
  #validate :is_captcha_valid?, :only => [:new, :edit]
  validates_associated :alternatives
  token_column(:read_token, TOKEN_LENGTH)
  token_column(:edit_token, TOKEN_LENGTH)

  has_many :alternatives, :dependent=>:destroy
  accepts_nested_attributes_for :alternatives, allow_destroy: true,
   :reject_if => :all_blank

  has_many :preferences, :dependent=>:destroy

  def valid_alternative_count
   if alternatives.size < 2
     errors.add(:alternatives, "requires at least two alternatives")
   end
  end
end
