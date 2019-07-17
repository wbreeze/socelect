# Use this module to extend a preference with rank encoding

module Preference::RankCoding
  # return rank indexes for the alternatives in canonical order, which
  # is the order of the alternative id's
  def rank_encoding
    exprs = expressions.includes(:alternative).to_a.sort do |a,b|
      a.alternative_id <=> b.alternative_id
    end
    exprs.collect(&:sequence)
  end
end
