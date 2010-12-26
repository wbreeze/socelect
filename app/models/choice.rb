class Choice < ActiveRecord::Base
   has_many :alternatives, :dependent=>:destroy
end
