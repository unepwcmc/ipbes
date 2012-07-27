class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  def to_s
    email
  end

  scope :unapproved, where("approved != true OR approved IS NULL")

  def active_for_authentication? 
    super && approved? 
  end 

  def inactive_message
    if approved?
      super # Use whatever other message
    else
      :not_approved 
    end
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  after_create :send_welcome_email
  after_update :send_approved_email

  private
    def send_welcome_email
      UserMailer.welcome_email(self).deliver
    end

    def send_approved_email
      UserMailer.approved_email(self).deliver if approved? && approved.changed?
    end
end
