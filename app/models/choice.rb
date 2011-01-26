class Choice < ActiveRecord::Base
   validate :valid_title_and_description_lengths

   has_many :alternatives, :dependent=>:destroy

    private

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

end 
