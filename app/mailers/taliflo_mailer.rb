class TalifloMailer < ActionMailer::Base
  default from: 'admin@taliflo.com'



  def sponsorship_accepted_admin_notification(sponsorship)
    @sponsorship = sponsorship
    @admin = admin
    mail(:to => @admin.email, :subject => "Sponsorship Accepted")
  end

  def sponsorship_cancelled_admin_notification(sponsorship)
    @sponsorship = sponsorship
    @admin = admin
    mail(:to => @admin.email, :subject => 'Sponsorship Cancelled')
  end

  private

  def admin
    admin = User.where(:role => 'admin').first
    raise "No admin exists." unless admin
    admin
  end

end