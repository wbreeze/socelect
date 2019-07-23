module TitleDescriptionValidation
  extend ActiveSupport::Concern

  included do
   before_validation :ensureTitleUsingDescription
  end

  MIN_LENGTH = 6
  MIN_LENGTH_WORD = 'six'
  SINO_MIN_LENGTH = 2
  SINO_MIN_LENGTH_WORD = 'two'

  def valid_title_and_description_allow_yes_no
    do_valid_title_and_description_lengths(
      SINO_MIN_LENGTH, SINO_MIN_LENGTH_WORD)
  end

  def valid_title_and_description_lengths(sino = false)
    do_valid_title_and_description_lengths(
      MIN_LENGTH, MIN_LENGTH_WORD)
  end

  def do_valid_title_and_description_lengths(min_length, min_length_word)
    checklen = false
    if title.length < min_length
      if description.empty?
         if title.empty?
           errors[:base] << 'Title or description must contain some text'
         else
           checklen = true;
         end
      elsif description.length < min_length
         checklen = true;
      end
    end
    if checklen
      errors[:base] <<
        "Provide at least #{min_length_word}"\
        " characters for title or description"
    end
  end

  def ensureTitleUsingDescription()
    self.title = self.title.nil? ? '' : self.title.strip
    self.description = self.description.nil? ? '' : self.description.strip
    if self.title.empty?
      md = self.description.match('[^.;!?]+\?') || 
           self.description.match('^[^.;!]+[.;!]');
      self.title = md ? md.to_s.strip : self.description.slice(0,40)
    end
  end

end
