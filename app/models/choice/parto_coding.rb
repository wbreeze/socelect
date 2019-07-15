# Use this module to extend a choice with Parto encoding and decoding behavior

module Choice::PartoCoding
  # Build and retern a JSON object with an array keys and descriptions
  def parto_encoding
    alternatives.collect do |alt|
      { key: alt.id.to_s, description: alt.title }
    end
  end
end
