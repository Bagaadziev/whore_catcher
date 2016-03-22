class Auth::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def check_user_exists()
    if @user.nil?
      redirect_to new_user_session_path, notice: 'ошибка входа через социальную сеть. возможно вы зарегистированы через другую социальую сеть' and return
    end

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    else
      session["devise.#{provider_name}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])
    self.check_user_exists()
  end


  def vkontakte
    @user = User.find_for_vkontakte_oauth(request.env["omniauth.auth"])
    self.check_user_exists()
  end

  def google_oauth2
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
    self.check_user_exists()
  end
  end
