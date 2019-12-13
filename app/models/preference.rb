class Preference < ApplicationRecord
  include Tokenz
  TOKEN_LENGTH = 14

  belongs_to :choice
  has_many :expressions
  after_save { |p| ResultState::NewPrefJob.perform_later(p.choice) }

  token_column(:token, TOKEN_LENGTH)

  # TODO get salt from configuration?
  SALT = 'prefs'

  # TODO override host=, ip= to auto encrypt
  # TODO provide <=> for host, ip that encrypts, then compares?
  # TODO no lookup host, ip?
  # TODO version crypt
  def set_chef_parameters(host, ip, chef)
    host = host.crypt(SALT)
    ip = ip.crypt(SALT)
    chef = chef
    # TODO chef cookie
  end
end
