require 'securerandom'
require 'json'
require 'ostruct'
class User < ApplicationRecord
  
  enum usertype: [:partner, :admin, :user]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable,  and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :confirmable, :trackable
  
  before_validation :smart_add_url_protocol

  has_one_attached :profilepic

  belongs_to :category, optional: true
  belongs_to :service, optional: true

  has_many :form_requests, foreign_key: "customer_id"
  has_many :requests, foreign_key: "user_id"
  has_many :messages, foreign_key: "user_id", class_name: "Message"
  has_many :customer_messages, foreign_key: "customer_id", class_name: "Message"
  has_many :documents
  has_many :transactions
  has_many :orders
  has_many :subscriptions

  has_rich_text :public_description
  has_rich_text :public_morestuff

  attr_accessor :auto_public_url, :display_name

  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.provider = auth.provider
  #     user.uid = auth.uid
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0, 20]
  #   end
  # end

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    if user
      if !user.provider
        user.update(uid: auth.uid, provider: auth.provider, image: auth.info.image)
      end
      return user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email     = auth.info.email
        user.password  = Devise.friendly_token[0, 20]
        user.full_name = auth.info.name   # assuming the user model has a name
        user.image     = auth.info.image # assuming the user model has an image
        user.uid       = auth.uid
        user.provider  = auth.provider
      end
    end
  end  

  def self.random_password
    SecureRandom.hex
  end

  def is_admin?
    self.usertype == 'admin'
  end
  
  def is_partner?
    self.usertype == 'partner'
  end

  def subscription
    # i.e.: {"subscription_type": "premium", "expiration": "2021-12-17 15:18:49.530661", "id": "15435b52-1ebd-41c1-9a1d-0577377f300f"}
    OpenStruct.new(subscription_data) unless subscription_data.nil?
  end

  def subscription_valid?
    self.subscription.expiration.to_datetime >= DateTime.now unless self.subscription.nil?
  end

  def subscription_expired?
    self.subscription.expiration.to_datetime < DateTime.now unless self.subscription.nil?
  end

  def auto_public_url
    unless self.ragionesociale.nil? || self.service_id.nil? || self.city.nil?
      [self.ragionesociale.parameterize, self.service.title.parameterize, self.city.parameterize].join("-")
    end
  end

  def display_name
    user_display_name = (self.ragionesociale.present? ? self.ragionesociale : self.fullname)
    user_display_name.size > 30 ? user_display_name[0..30].gsub(/$/, '...') : user_display_name
  end

  def public_display_name
    user_public_display_name = (self.public_ragionesociale.present? ? self.public_ragionesociale : self.ragionesociale)
    user_public_display_name.size > 30 ? user_public_display_name[0..30].gsub(/$/, '...') : user_public_display_name
  end

  def self.secure_params
    [:email, :fullname, :ragionesociale, :description, :address, :phone, :cap, :city, :prov, :vatcode, 
     :profilepic, :active, :password, :password_confirmation, :current_password, 
     :category_id, :service_id, 
     :public_ragionesociale, :public_email, :public_phone, :public_website, :public_url, :public_description,
     :public_morestuff, :public_address, :public_city, :public_prov, :public_certified,
     :public_hours, :public_facebook, :public_instagram, :public_linkedin, :public_youtube,
     :public_bkground,
     :edited, :docsuploaded, :marketing, :profiling
    ]
  end

  def after_confirmation
    NotificationMailer.with(resource: self).welcome_email.deliver_later
  end

  protected

  def smart_add_url_protocol
    if public_website.present?
      unless public_website[/\Ahttp:\/\//] || public_website[/\Ahttps:\/\//]
        self.public_website = "http://#{public_website}"
      end
    end
  end  

end
