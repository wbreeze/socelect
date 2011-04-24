class Preference < ActiveRecord::Base
  belongs_to :choice
  has_many :expression

  # TODO get salt from configuration?
  SALT = 'prefs'

  # TODO override host=, ip= to auto encrypt
  # TODO provide <=> for host, ip that encrypts, then compares?
  # TODO no lookup host, ip?
  # TODO version crypt
  def chef_parameters(req)
    host = req.env['REMOTE_HOST'] || 'unknown host';
    host = host.crypt(SALT)
    ip = req.env['REMOTE_ADDR'] || 'unknown ip address';
    ip = ip.crypt(SALT)
    # TODO chef cookie
  end
end
