class UserMailer < ActionMailer::Base
  default from: "no-reply@unep-wcmc.org"

  def welcome_email(user)
    @user = user

    mail to: user.email, subject: 'IPBES Assessment Catalogue: Welcome'
  end

  def approval_request_email(user, admin)
    @user = user
    @url  = "#{APP_CONFIG['url']}/users/#{@user.id}/edit"

    mail to: admin.email, subject: "IPBES Assessment Catalogue: #{@user.name} requests approval" 
  end

  def approved_email(user)
    @user = user
    @url  = "#{APP_CONFIG['url']}/d/users/sign_in"

    mail to: user.email, subject: 'IPBES Assessment Catalogue: Approved account'
  end
end
