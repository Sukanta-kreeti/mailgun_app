class SendActivationMailWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"

  def perform(user_id, token)
    user = User.find(user_id)
    if user
      UserMailer.account_activation(user, token).deliver
      CheckAndResendActivationMailWorker.perform_at(2.days.from_now, user_id)
    end
  end
end
