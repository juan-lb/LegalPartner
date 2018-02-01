class ApplicationController < ActionController::API

  def all_params
    parameters = params.permit!.to_h.deep_symbolize_keys

    parameters
  end

end
