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
         :omniauthable


  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

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
      attributes = { name: [auth.info.first_name, auth.info.last_name].join(' '), email: auth.info.email, password: Devise.friendly_token[0,20], confirmed_at: Time.now.utc }
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

end