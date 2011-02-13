class Choice < ActiveRecord::Base
   validate :valid_title_and_description_lengths
   validates_associated :alternatives

   has_many :alternatives, :dependent=>:destroy
   accepts_nested_attributes_for :alternatives, :allow_destroy => true

   MIN_LENGTH = 12
   MIN_LENGTH_WORD = 'twelve'

   def valid_title_and_description_lengths(sino = false)
     title.strip!
     description.strip!
     checklen = false
     if title.length < MIN_LENGTH && sino && !(/^(yes|no)$/i =~ title)
       if description.empty?
          if title.empty?
            errors[:base] << 'One field must contain some text'
          else
            checklen = true;
          end
       elsif description.length < MIN_LENGTH
          checklen = true;
       end
     end
     if checklen
       errors[:base] << "Type at least #{MIN_LENGTH_WORD} characters"
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

   def ensureTwoAlternatives
     while alternatives.size < 2 do
       defaultTitle = (alternatives.size == 0 ? 'First' : 'Second') +
        ' alternative.'
       alternatives.build(:title => defaultTitle)
     end
   end

end 
