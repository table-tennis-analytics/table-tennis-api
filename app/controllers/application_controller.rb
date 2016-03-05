class ApplicationController < ActionController::API
  include ActionController::RespondWith

  respond_to :json

  def default_serializer_options
    { root: :data }
  end
end
