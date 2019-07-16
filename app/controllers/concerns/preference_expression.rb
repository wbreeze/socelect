module PreferenceExpression
  extend ActiveSupport::Concern

  def derive_chef_to_preference(preference, request)
    host = request.env['REMOTE_HOST'] || 'unknown host';
    ip = request.env['REMOTE_ADDR'] || 'unknown ip address';
    # TODO chef cookie
    chef = 'chef'
    preference.set_chef_parameters(host, ip, chef)
  end

  def build_select_alternative_preference(choice, alternative)
    preference = Preference.new(:choice => @choice)
    expression = preference.expressions.build(:sequence => 1)
    expression.alternative = alternative
    preference
  end

  def build_parto_preference(choice, parto)
    rank = next_rank = 1
    preference = Preference.new(:choice => @choice)
    parto.each do |aidoa|
      if aidoa.kind_of? Array
        aidoa.each do |id|
          preference.expressions.build(alternative_id: id.to_i, sequence: rank)
          next_rank += 1
        end
      elsif aidoa.kind_of? String
        preference.expressions.build(alternative_id: aidoa.to_i, sequence: rank)
        next_rank += 1;
      else
        raise ArgumentError.new("Unexpected value #{aidoa} in parto")
      end
      rank = next_rank;
    end
    preference
  end

  def decode_group(group)
    if group.length == 1
      group[0].alternative.id.to_s
    else
      group.collect do |xpr|
        xpr.alternative.id.to_s
      end
    end
  end

  def parto_expression(preference)
    pexpr = []
    group = []
    last_rank = 0
    preference.expressions.includes(:alternative)
        .order(:sequence).each do |expr|
      if (expr.sequence != last_rank && !group.empty?)
        pexpr << decode_group(group)
        group = [expr]
      else
        group << expr
      end
      last_rank = expr.sequence
    end
    pexpr << decode_group(group)
    pexpr.to_json
  end
end
