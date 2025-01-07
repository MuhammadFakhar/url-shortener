class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  before_action :authenticate_user

  private

  def authenticate_user
    authenticate_or_request_with_http_basic do |username, password|
      username == 'admin' && password == 'password'     # We can set it from ENV as well, for now I am making hardcoded here
    end
  end
end
