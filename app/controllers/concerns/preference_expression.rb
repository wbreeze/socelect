module PreferenceExpression
  extend ActiveSupport::Concern

  def derive_chef_to_preference(preference, request)
    host = request.env['REMOTE_HOST'] || 'unknown host';
    ip = request.env['REMOTE_ADDR'] || 'unknown ip address';
    # TODO chef cookie
    chef = 'chef'
    preference.set_chef_parameters(host, ip, chef)
  end

  def build_select_alternative_preference(choice, alternative)
    preference = Preference.new(:choice => @choice)
    expression = preference.expression.build(:sequence => 1)
    expression.alternative = alternative
    preference
  end
end
