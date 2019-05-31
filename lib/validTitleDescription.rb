module TitleDescriptionValidation
  MIN_LENGTH = 6
  MIN_LENGTH_WORD = 'six'

  def valid_title_and_description_allow_yes_no
    valid_title_and_description_lengths(true)
  end

  def valid_title_and_description_lengths(sino = false)
    checklen = false
    if title.length < MIN_LENGTH && !(sino && (/^(yes|no)$/i =~ title))
      if description.empty?
         if title.empty?
           errors[:base] << 'Title or description must contain some text'
         else
           checklen = true;
         end
      elsif description.length < MIN_LENGTH
         checklen = true;
      end
    end
    if checklen
      errors[:base] << 
        "Provide at least #{MIN_LENGTH_WORD} characters for title or description"
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
