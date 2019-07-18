require 'davenport'

# Compute the Kemeny-Young aggregate preference from the individual
# preference expressions for a choice
class DavenportComputer
  attr_reader :choice

  def initialize(choice)
    @choice = choice
  end

  def decode_group(group)
    if group.length == 1
      group[0][1]
    else
      group.collect do |alt|
        alt[1]
      end
    end
  end

  # sorted_ranked is an array of two element tuples
  # The first of each tuple (index 0) is the rank
  # The second of each tuple (index 1) is the alternative id
  # Returns the alternative id's arranged as a parto JSON string
  def sorted_ranked_to_parto(sorted_ranked)
    pexpr = []
    group = []
    last_rank = 0
    sorted_ranked.each do |alt|
      if alt[0] != last_rank && !group.empty?
        pexpr << decode_group(group)
        group = [alt]
      else
        group << alt
      end
      last_rank = alt[0]
    end
    pexpr << decode_group(group)
    pexpr.to_json
  end

  # arrange a parto JSON string of alternative id's according to result_ranks
  def convert_rank_to_parto(result_ranks)
    alt_ids = choice.alternatives.order(:id).collect do |alt|
      alt.id.to_s
    end
    ranked_alts = result_ranks.zip(alt_ids)
    sorted_ranked = ranked_alts.sort do |a, b|
      a[0] <=> b[0]
    end
    sorted_ranked_to_parto(sorted_ranked)
  end

  def result_as_parto
    alt_ct = choice.alternatives.count
    pg = Davenport::PreferenceGraph.new(alt_ct)
    choice.preferences.each do |pref|
      pref.extend(Preference::RankCoding)
      pref_rank = pref.rank_encoding
      pref_rank << alt_ct while pref_rank.length < alt_ct
      pg.add_preference(pref_rank)
    end
    convert_rank_to_parto(pg.davenport)
  end
end
