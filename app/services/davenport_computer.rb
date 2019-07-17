require 'davenport'

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

  def result_as_parto
    alt_ct = choice.alternatives.count
    pg = Davenport::PreferenceGraph.new(alt_ct)
    choice.preferences.each do |pref|
      pref.extend(Preference::RankCoding)
      pref_rank = pref.rank_encoding
      while (pref_rank.length < alt_ct)
        pref_rank << alt_ct
      end
      pg.add_preference(pref_rank)
    end
    result_ranks = pg.davenport
    alt_ids = choice.alternatives.order(:id).collect do |alt|
      alt.id.to_s
    end
    ranked_alts = result_ranks.zip(alt_ids)
    sorted_ranked = ranked_alts.sort do |a,b|
      a[0] <=> b[0]
    end
    pexpr = []
    group = []
    last_rank = 0
    sorted_ranked.each do |alt|
      if (alt[0] != last_rank && !group.empty?)
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
end
