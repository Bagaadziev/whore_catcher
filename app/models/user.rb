class User < ActiveRecord::Base

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable,
         :registerable,
         :confirmable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :omniauthable


  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def self.find_for_vkontakte_oauth(auth)
    puts '==========>'
    puts auth
    puts '==========>'


    puts '=========>'
    puts Identity.find_for_oauth(auth)
    user = Identity.find_for_oauth(auth).user
    puts user
    puts '=========>'

    if user.present?
      user
    else
      puts '<<<<<<<=-=-=-=-==-=-=-=-=='
      puts auth.info.inspect
      puts auth.info.email
      puts auth.info.first_name.inspect
      puts auth.info.last_name.inspect
      user = User.create!({ name: [auth.info.first_name, auth.info.last_name].join(' '), email: auth.info.email, password: Devise.friendly_token[0,20], confirmed_at: Time.now.utc})

      puts user.inspect
      return user
      #
      # Identity.create({})
    end

    self.check_user_exists


    # if user = User.where(:url => access_token.info.urls.Vkontakte).first
    #   user
    # else
    #   User.create!(:provider => access_token.provider, :url => access_token.info.urls.Vkontakte, :username => access_token.info.name, :nickname => access_token.extra.raw_info.domain, :email => access_token.extra.raw_info.domain+'@vk.com', :password => Devise.friendly_token[0,20])
    # end
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

end