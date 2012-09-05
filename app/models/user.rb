class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :institution, :description, :email, :password, :password_confirmation, :remember_me

  validates :name, presence: true
  validates :description, presence: true
  validates :institution, presence: true

  has_many :assessments_where_last_editor, class_name: 'Assessment', foreign_key: :last_editor_id
  
  def to_s
    name.presence || email
  end

  scope :unapproved, where("approved != true OR approved IS NULL")
  scope :admins, where(admin: true)

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
  after_create :send_approval_request_email
  after_update :send_approved_email

  private
    def send_welcome_email
      UserMailer.welcome_email(self).deliver
    end

    def send_approval_request_email
      User.admins.each do |admin|
        UserMailer.approval_request_email(self, admin).deliver
      end
    end

    def send_approved_email
      UserMailer.approved_email(self).deliver if approved? && approved_changed?
    end
end
