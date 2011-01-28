module ChoicesHelper

def add_alternative_button(name)
   button_to_function name do |page|
      page.insert_html :bottom, :alternatives, :partial => 'alternative', 
         :object => Alternative.new
   end
end

end
