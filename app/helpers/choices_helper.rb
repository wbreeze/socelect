module ChoicesHelper

def add_alternative_button(name)
   button_to_function name do |page|
      page.insert_html :bottom, :alternatives, :partial => 'alternative', 
         :object => Alternative.new
   end
end

def checkAlternativeRemoveJSFunction
  "var alt = $(this).up('.alternative');" +
  "if (1 < alt.siblings('.alternative').length)" +
  "{alt.remove()}" +
  "else" +
  "{" +
  "var ahso = new Element('p',{'class':'fadeMessage'}).update('We need at least two to offer a choice');" +
  "this.insert({before:ahso});" +
  "ahso.fade({duration: 2.0, to:0.3}).fade({duration:0.5,from:0.3,queue:'end'});" +
  "}"
end

end
