require 'validTitleDescription'

class Choice < ApplicationRecord
   include TitleDescriptionValidation
   include Tokenz
   TOKEN_LENGTH = 14

   attr_accessor :opening_date, :opening_time, :deadline_date, :deadline_time

   validate :valid_title_and_description_lengths, :valid_alternative_count
   #apply_simple_captcha
   #validate :is_captcha_valid?, :only => [:new, :edit]
   validates_associated :alternatives
   after_initialize :ensure_default_dates
   before_validation :resolve_dates
   token_column(:read_token, TOKEN_LENGTH)
   token_column(:edit_token, TOKEN_LENGTH)

   has_many :alternatives, :dependent=>:destroy
   accepts_nested_attributes_for :alternatives, allow_destroy: true,
     :reject_if => :all_blank

   has_many :preferences, :dependent=>:destroy

   def ensure_default_dates
     self.opening ||= DateTime.current
     self.opening_date = self.opening.to_date
     self.opening_time = self.opening.to_time
     self.deadline ||= 1.day.from_now
     self.deadline_date = self.deadline.to_date
     self.deadline_time = self.deadline.to_time
   end

   def resolve_date_and_time(date_str, time_str)
     dd = date_str.to_datetime
     dt = time_str.to_datetime.utc
     DateTime.new(dd.year, dd.month, dd.day, dt.hour, dt.min, dt.sec)
   end

   def resolve_dates
     self.opening = resolve_date_and_time(opening_date, opening_time)
     self.deadline = resolve_date_and_time(deadline_date, deadline_time)
   end

   def valid_alternative_count
     if alternatives.size < 2
       errors.add(:alternatives, "requires at least two alternatives")
     end
   end
end
