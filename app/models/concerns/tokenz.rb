module Tokenz
  extend ActiveSupport::Concern

  DEFAULT_TOKEN_SIZE = 17
  DEFAULT_RETRY_LIMIT = 12

  class_methods do
    def token_column(column_name, size=DEFAULT_TOKEN_SIZE)
      before_create do |model|
        model[column_name] = generate_token(size)
      end
    end
  end

  def generate_token(size = DEFAULT_TOKEN_SIZE, randomizr = SecureRandom,
      retry_limit = DEFAULT_RETRY_LIMIT)
    tries = 0
    begin
      token = randomizr.alphanumeric(
        size * 3
      ).downcase.delete('aeioudhtns0-9').slice(0, size)
      tries += 1
    end while token.length < size && retry_limit < tries
    token
  end
end
