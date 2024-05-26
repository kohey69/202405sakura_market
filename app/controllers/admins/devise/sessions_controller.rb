# frozen_string_literal: true

class Admins::Devise::SessionsController < Devise::SessionsController
  layout 'admins'

  def after_sign_in_path_for(resource)
    admins_root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_administrator_session_path
  end
end
