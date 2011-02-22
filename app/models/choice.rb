require 'validTitleDescription'
class Choice < ActiveRecord::Base
   include TitleDescriptionValidation
   before_validation :ensureTitleUsingDescription
   validate :valid_title_and_description_lengths
   #apply_simple_captcha
   #validate :is_captcha_valid?, :only => [:new, :edit]
   validates_associated :alternatives

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

   def ensureTwoAlternatives
     while alternatives.size < 2 do
       defaultTitle = (alternatives.size == 0 ? 'First' : 'Second') +
        ' alternative.'
       alternatives.build(:title => defaultTitle)
     end
   end

end 
