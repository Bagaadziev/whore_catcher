class UsersController < ApplicationController

  def index
  end

  def user_params
    params.require(:users).permit(:name, :email, :encrypted_password, :score, :total_time)
  end

end
