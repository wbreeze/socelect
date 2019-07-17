class DavenportComputer
  attr_reader :choice

  def initialize(choice)
    @choice = choice
  end

  def result_as_parto
    parto = choice.alternatives.collect do |alt|
      alt.id.to_s
    end
    parto.to_json
  end
end
