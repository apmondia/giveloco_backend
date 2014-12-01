require 'premailer'

class TalifloMailer < ActionMailer::Base

  self.asset_host = nil
  default from: 'admin@taliflo.com'

  def sponsorship_accepted_admin_notification(sponsorship)
    @sponsorship = sponsorship
    @admin = admin
    premailer mail(:to => @admin.email, :subject => "Sponsorship Accepted")
  end

  def sponsorship_cancelled_admin_notification(sponsorship)
    @sponsorship = sponsorship
    @admin = admin
    premailer mail(:to => @admin.email, :subject => 'Sponsorship Cancelled')
  end

  def certificate_purchase
    mail(:to => 'testalsdkfjasd@alsdfkjasd.com', :subject => 'Your Gift Certificate') do |format|
      prerender(format, 'certificate_purchase')
    end
  end

  private

  def admin
    admin = User.where(:role => 'admin').first
    raise "No admin exists." unless admin
    admin
  end

  def prerender(format, template)
    # format.text {
    #   Premailer.new( render(template), with_html_string: true).to_plain_text
    # }
    format.html {
      Premailer.new( render(template), with_html_string: true).to_inline_css
    }
  end

end