require 'validTitleDescription'

class Choice < ApplicationRecord
   include TitleDescriptionValidation
   attr_accessor :opening_date, :opening_time, :deadline_date, :deadline_time

   validate :valid_title_and_description_lengths, :valid_alternative_count
   #apply_simple_captcha
   #validate :is_captcha_valid?, :only => [:new, :edit]
   validates_associated :alternatives
   after_initialize :ensure_two_alternatives, :ensure_default_dates
   before_validation :resolve_dates

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
     self.opening ||= DateTime.current
     self.opening_date = self.opening.to_date
     self.opening_time = self.opening.to_time
     self.deadline ||= 1.day.from_now
     self.deadline_date = self.deadline.to_date
     self.deadline_time = self.deadline.to_time
   end

   def resolve_dates
     dt = opening_time.to_datetime
     self.opening = DateTime.new(
       opening_date.year, opening_date.month, opening_date.day,
       dt.hour, dt.min, dt.sec, dt.utc_offset)
     dt = deadline_time.to_datetime
     self.deadline = DateTime.new(
       deadline_date.year, deadline_date.month, deadline_date.day,
       dt.hour, dt.min, dt.sec, dt.utc_offset)
   end

   def valid_alternative_count
     if alternatives.size < 2
       errors.add(:alternatives, "requires at least two alternatives")
     end
   end
end
