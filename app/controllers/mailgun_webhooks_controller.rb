class MailgunWebhooksController < ApplicationController
  def csv
    settings = Rails.application.config.action_mailer.mailgun_settings
    data = MailgunSupress.new(settings[:api_key], settings[:domain])
    flash[:info] = "Faced some problem in setting tracking the events"
    redirect_to root_url
  end
end
