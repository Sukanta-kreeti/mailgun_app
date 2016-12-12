require 'rest_client'

class MailgunSupress
  attr_reader :api_key, :domain

  def initialize(api_key, domain)
    @api_key = api_key
    @domain = domain
  end

  def send_message(options)
    RestClient.post mailgun_url + "/messages", options
  end

  def bounces
    eval(RestClient.get mailgun_url + "/bounces")
  end

  def unsubscibers
    eval(RestClient.get mailgun_url + "/unsubscribes")
  end

  def complaints
    eval(RestClient.get mailgun_url + "/complaints")
  end

  def get_bounces
    eval(RestClient.get mailgun_url + "/events",
         :params => {
           :"event" => 'rejected OR failed'
         })
  end

  def get_clicked
    eval(RestClient.get mailgun_url + "/events",
         :params => {
           :"event" => 'clicked'
         })
  end

  def is_in_suppressions_list?(email)
    bounces = self.bounces
    unsubscribes = self.unsubscibers
    compalints = self.complaints
    data = bounces[:items] + unsubscribes[:items] + compalints[:items]
    data = data.select {|d| d[:address] == email}
    data.length > 0 ? true : false
  end

  def mailgun_url
    api_url
  end

  def api_url
    "https://api:#{api_key}@api.mailgun.net/v3/#{domain}"
  end
end
