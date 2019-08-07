require 'validTitleDescription'

class Choice < ApplicationRecord
   include TitleDescriptionValidation
   include Tokenz
   TOKEN_LENGTH = 14

   attr_accessor :opening_date, :opening_time, :deadline_date, :deadline_time

   def self.time_str(time)
     time.strftime('%H:%M')
   end

   def self.date_str(date)
     date.strftime('%Y-%m-%d')
   end

   def opening_date
     @opening_date ||= self.class.date_str(Time.now.utc)
   end

   def opening_time
     @opening_time ||= self.class.time_str(Time.now.utc)
   end

   def deadline_date
     @deadline_date ||= self.class.date_str((Time.now + 1.day).utc)
   end

   def deadline_time
     @deadline_time ||= self.class.time_str(Time.now.utc)
   end

   validate :valid_title_and_description_lengths, :valid_alternative_count
   #apply_simple_captcha
   #validate :is_captcha_valid?, :only => [:new, :edit]
   validates_associated :alternatives
   after_find :populate_dates_and_times
   after_initialize :resolve_dates
   token_column(:read_token, TOKEN_LENGTH)
   token_column(:edit_token, TOKEN_LENGTH)

   has_many :alternatives, :dependent=>:destroy
   accepts_nested_attributes_for :alternatives, allow_destroy: true,
     :reject_if => :all_blank

   has_many :preferences, :dependent=>:destroy

   def populate_dates_and_times
     self.opening_date = self.class.date_str(self.opening)
     self.opening_time = self.class.time_str(self.opening)
     self.deadline_date = self.class.date_str(self.deadline)
     self.deadline_time = self.class.time_str(self.deadline)
   end

   def resolve_date_and_time(date_str, time_str)
     dd = date_str.to_datetime
     dt = time_str.to_datetime
     DateTime.new(dd.year, dd.month, dd.day, dt.hour, dt.min)
   end

   def resolve_dates
     self.opening ||= resolve_date_and_time(
       self.opening_date, self.opening_time)
     self.deadline ||= resolve_date_and_time(
       self.deadline_date, self.deadline_time)
   end

   def valid_alternative_count
     if alternatives.size < 2
       errors.add(:alternatives, "requires at least two alternatives")
     end
   end
end
