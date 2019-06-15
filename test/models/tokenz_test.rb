require 'test_helper'

class TokenzTest < ActiveSupport::TestCase
  include Tokenz

  class TestRandomizr
    attr_reader :non_random, :calls, :max_calls
    DEFAULT_MAX_CALLS = 1

    def initialize(randomz, max_calls=DEFAULT_MAX_CALLS)
      @non_random = randomz
      @max_calls = max_calls
      @calls = 0
    end

    def alphanumeric(size)
      @calls += 1
      raise "Too many iterations" if max_calls < calls
      non_random
    end
  end

  test 'terminates when unable to make a token' do
    max_calls = 3
    randomizr = TestRandomizr.new('', max_calls + 1)
    token = generate_token(3, randomizr, max_calls)
    assert_empty(token)
  end

  test 'contains no vowels' do
    randomizr = TestRandomizr.new('aeioubbbuoieacccaeiou')
    token = generate_token(6, randomizr)
    assert_equal('bbbccc', token)
  end

  test 'contains no numbers' do
    randomizr = TestRandomizr.new('01234bbb56789ccc01359')
    token = generate_token(6, randomizr)
    assert_equal('bbbccc', token)
  end

  test 'does not contain most common consonants (English)' do
    randomizr = TestRandomizr.new('dhtnsbbbsnthdcccdhtns')
    token = generate_token(6, randomizr)
    assert_equal('bbbccc', token)
  end

  test 'returns a token with default size' do
    token = generate_token
    assert_equal(DEFAULT_TOKEN_SIZE, token.length)
  end
end
