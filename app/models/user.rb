class User < ActiveRecord::Base

  has_many  :scores,         dependent: :destroy
  has_many  :identities,     dependent: :destroy

  accepts_nested_attributes_for :identities

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
         :omniauthable,
         :omniauth_providers => [:vkontakte, :facebook, :google_oauth2]


  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    puts '=-=-=-====-=>>>>'
    puts '=-=-=-====-=>>>>'
    puts '=-=-=-====-=>>>>'
    puts '=-=-=-====-=>>>>'
    puts '=-=-=-====-=>>>>'
    puts '=-=-=-====-=>>>>'
    data = access_token.info
    user = User.where(:email => data["email"]).first
    unless user
      user = User.create(
          name: data["name"],
          email: data["email"],
          password: Devise.friendly_token[0,20],
          confirmed_at:     Time.now.utc
      )
    end
    user.update_attribute(:avatara_url, data[:image] ) unless user.avatara_url ==  data[:image]
    user
  end

  def self.find_for_vkontakte_oauth(auth)
    puts '==========>'
    puts auth
    puts '==========>'

    puts '=========>'
    identity = Identity.find_by_uid(auth.uid.to_s)
    puts '=========>'

    if identity.present?
      identity.user
    else
      # attributes = { name: [auth.info.first_name, auth.info.last_name].join(' '), email: auth.info.email, password: Devise.friendly_token[0,20], confirmed_at: Time.now.utc, identities_attributes: { provider: auth.provider, uid: auth.uid.to_s } }
      attributes = { name: [auth.info.first_name, auth.info.last_name].join(' '),
                     email: auth.info.email,
                     password: Devise.friendly_token[0,20],
                     confirmed_at: Time.now.utc
                   }
      puts "attributes"
      puts attributes
      puts "attributes"

      user = User.create!(attributes)

      identity = Identity.create({ provider: auth.provider, uid: auth.uid.to_s, user: user })

      puts '======-====-========'
      puts identity
      puts user.inspect

      return user
      # Identity.create({})
    end


    # if user = User.where(:url => access_token.info.urls.Vkontakte).first
    #   user
    # else
    #   User.create!(:provider => access_token.provider, :url => access_token.info.urls.Vkontakte, :username => access_token.info.name, :nickname => access_token.extra.raw_info.domain, :email => access_token.extra.raw_info.domain+'@vk.com', :password => Devise.friendly_token[0,20])
    # end
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def self.find_for_facebook_oauth (auth)

    puts '-=-=-=-=-=-=-=-=-=-=-=-=-=-=->'
    puts auth
    puts '-=-=-=-=-=-=-=-=-=-=-=-=-=-=->'


    identity = Identity.find_by_uid(auth.uid.to_s)
    if identity.present?
      identity.user
    else

      attributes = { name: [auth.info.name].join(' '), email: auth.info.email, password: Devise.friendly_token[0,20], confirmed_at: Time.now.utc }
      puts "attributes"
      puts attributes
      puts "attributes"

      user = User.create!(attributes)

      identity = Identity.create({ provider: auth.provider, uid: auth.uid.to_s, user: user })

      puts '======-====-========'
      puts identity
      puts user.inspect

      return user

      # User.create!(:provider => auth.provider, :url => access_token.info.urls.Facebook, :username => access_token.extra.raw_info.name, :nickname => access_token.extra.raw_info.username, :email => access_token.extra.raw_info.email, :password => Devise.friendly_token[0,20])
    end
  end

end