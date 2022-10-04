# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?

  private
 
  def current_company
    @current_company ||= current_user.company if user_signed_in?
  end
  helper_method :current_company

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

end
