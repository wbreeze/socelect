# Use this module to extend a choice with Parto encoding and decoding behavior

module Choice::PartoCoding
  # Build and retern a JSON string with an array keys and descriptions
  def parto_items_encoding
    items = alternatives.collect do |alt|
      { key: alt.id.to_s, description: alt.title }
    end
    items.to_json
  end

  # Build and return a JSON string representing a parto
  # with items ranked together in random sequence
  def parto_random_initial
    keys = alternatives.collect do |alt|
      alt.id.to_s
    end
    [keys.shuffle].to_json
  end
end
