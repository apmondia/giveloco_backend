class StripeCharge
  def self.call(opts = {})
    Stripe::Charge.create({
        :amount => opts[:amount] || (raise "No amount passed."),
        :currency => 'cdn',
        :card => opts[:card] || (raise "No card passed"),
        :description => "Gift Certificate for #{certificate.sponsorship.business.company_name}",
        :application_fee => opts[:application_fee] || (raise "No application fee passed")
                          }, opts[:access_token] || (raise "No access_token passed."))
  end
end