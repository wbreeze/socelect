require 'validTitleDescription'

class Choice < ApplicationRecord
   include TitleDescriptionValidation
   validate :valid_title_and_description_lengths, :valid_alternative_count
   #apply_simple_captcha
   #validate :is_captcha_valid?, :only => [:new, :edit]
   validates_associated :alternatives
   after_initialize :ensure_two_alternatives, :ensure_default_dates

   has_many :alternatives, :dependent=>:destroy
   accepts_nested_attributes_for :alternatives, :allow_destroy => true

   def existing_alternative_attributes=(attrs)
     alternatives.reject(&:new_record?).each do |alt|
       attributes = attrs[alt.id.to_s]
       if attributes
         alt.attributes = attributes
       else
         alternatives.delete(alt)
       end
     end
   end

   def new_alternative_attributes=(attrs)
     attrs.each do |alt|
       alternatives.build(alt)
     end
   end

   def ensure_two_alternatives
     while alternatives.size < 2 do
       default_title = (alternatives.size == 0 ? 'First' : 'Second') +
        ' option.'
       alternatives.build(:title => default_title)
     end
   end

   def ensure_default_dates
     self.opening = DateTime.current
     self.deadline = 1.day.from_now
   end

   def valid_alternative_count
     if alternatives.size < 2
       errors.add(:alternatives, "requires at least two alternatives")
     end
   end
end
