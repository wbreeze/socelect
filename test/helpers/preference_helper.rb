module PreferenceHelper
  def create_preference(choice, attribs={})
    host = attribs.fetch(:host, nil) || Faker::Internet.domain_name
    ip = attribs.fetch(:ip, nil) || Faker::Internet.ip_v4_address
    chef = attribs.fetch(:chef, nil) ||
      Faker::String.random(Preference::TOKEN_LENGTH)
    preference = Preference.new(choice: choice)
    preference.set_chef_parameters(host, ip, chef)
    preference.save!
    preference
  end

  def create_preference_parto(choice, ranks=[])
    preference = create_preference(choice)
    alternatives = choice.alternatives.order(:id).to_a
    (alternatives.length - ranks.length).times do
      ranks << alternatives.length
    end
    alternatives.each_with_index do |alt, i|
      preference.expressions.create(alternative: alt, sequence: ranks[i])
    end
    preference
  end
end
