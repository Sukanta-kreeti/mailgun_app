class CheckAndResendActivationMailWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"

  def perform(user_id)
    user = User.find(user_id)
    if user && !user.activated? && !is_expired?(user)
      UserMailer.account_activation_resend(user).deliver_now
    end
  end

  def is_expired?(user)
    user.created_at >= 1.minute.ago && !in_supressed_list(user.email)
  end

  def in_supressed_list(email)
    settings = Rails.application.config.action_mailer.mailgun_settings
    client = MailgunSupress.new(settings[:api_key], settings[:domain])
    client.is_in_suppressions_list?(email)
  end
end
