class AdminController < ApplicationController
  def pundit_user
    current_admin_user
  end
end
