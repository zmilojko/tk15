class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def error_404
    raise ActionController::RoutingError.new('Not Found')
  end
  
  def check_admin
    error_404 unless current_user.admin?
  end
end
