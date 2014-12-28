require 'premailer'

class TalifloMailer < ActionMailer::Base

  self.asset_host = nil

  def sponsorship_accepted_admin_notification(sponsorship)
    @sponsorship = sponsorship
    @admin = admin
    mail(:to => @admin.email, :subject => "Sponsorship Accepted") do |format|
      prerender(format, 'sponsorship_accepted_admin_notification')
    end
  end

  def sponsorship_cancelled_admin_notification(sponsorship)
    @sponsorship = sponsorship
    @admin = admin
    mail(:to => @admin.email, :subject => 'Sponsorship Cancelled') do |format|
      prerender(format, 'sponsorship_cancelled_admin_notification')
    end
  end

  def certificate_purchase(certificate)
    @certificate = certificate
    mail(:to => certificate.purchaser.email, :subject => 'Gift Certificate') do |format|
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