class Choice < ActiveRecord::Base
   validate :valid_title_and_description_lengths
   validates_associated :alternatives

   has_many :alternatives, :dependent=>:destroy
   accepts_nested_attributes_for :alternatives, :allow_destroy => true

   MIN_LENGTH = 12
   MIN_LENGTH_WORD = 'twelve'

   def valid_title_and_description_lengths
     title.strip!
     description.strip!
     if title.length < MIN_LENGTH
       if description.empty?
          if title.empty?
            errors[:base] << 'One field must contain some text'
          else
            errors[:base] << "Type at least #{MIN_LENGTH_WORD} characters"
          end
       elsif description.length < MIN_LENGTH
          errors[:base] << "Type at least #{MIN_LENGTH_WORD} characters"
       end
     end
   end

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

end 
