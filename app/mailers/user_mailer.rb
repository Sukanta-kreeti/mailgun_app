class UserMailer < ApplicationMailer

  def account_activation(user, token)
    @user = user
    @token = token
    email = mail to: user.email, subject: "Activate your account"
    email.mailgun_options = { :tracking => '1' }
  end

  def account_activation_resend(user)
    @user = user
    mail to: user.email, subject: "Waiting to from you"
  end
end
