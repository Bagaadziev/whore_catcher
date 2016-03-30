module ViewHelper

  def social_link(provider)
    # content_tag(:span, provider)
    puts provider == :google_oauth2
    if provider == :google_oauth2
      new_provider = :google
    end
    if provider == :vkontakte
      new_provider = :vk
    end
    if provider == :facebook
      new_provider = :facebook
    end
    link_to "<span class='fa fa-#{new_provider}'></span>Sign in with #{OmniAuth::Utils.camelize(new_provider)}".html_safe, omniauth_authorize_path(resource_name, provider), class: "btn btn-block btn-social btn-sm btn-#{new_provider}"
  end

end
