class SessionsController < ApplicationController
  def create
    puts 'Logged in'
    @user = User.find_or_create_from_auth_hash(auth_hash)

    if @user.persisted?
      session[:user] = @user.id
      redirect_to events_path
    else
      redirect_to root_path
    end
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
