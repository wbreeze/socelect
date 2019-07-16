class PreferencesController < ApplicationController
  include PreferenceExpression

  # GET /preferences/:token
  def show
    @preference = Preference.find_by(token: params[:id])
    return head :not_found unless @preference
    @choice = @preference.choice
    @alternative = @preference.expressions[0].alternative
  end

  # POST /preferences/create
  def create
    @choice = Choice.find_by(read_token: choice_params[:read_token])
    return head :bad_request unless @choice
    if (params[:alternative])
      alternative = @choice.alternatives.find(alternative_param)
    elsif (choice_params[:parto])
      parto = choice_params[:parto]
      parto = JSON.parse(choice_params[:parto])
      first = parto[0]
      first = first[0] if (first.kind_of? Array)
      alternative = @choice.alternatives.find(first);
    else
      return head :bad_request
    end
    preference = build_select_alternative_preference(@choice, alternative)
    derive_chef_to_preference(preference, request)

    if preference.save
      redirect_to preference_path(preference.token)
    else
      render :controller => :choice, :action => 'show'
    end
  end

  def choice_params
    params.require(:choice).permit(:read_token, :parto) do |cp|
      cp.require(:read_token)
    end
  end

  def alternative_param
    params.require(:alternative)
  end
end
