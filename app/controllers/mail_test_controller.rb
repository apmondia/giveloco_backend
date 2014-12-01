class MailTestController < ApplicationController

  def certificate
    email = TalifloMailer.certificate_purchase()
    render_email email
  end

  private
  def render_email(email)
    respond_to do |format|
      format.html { render html: email.decoded.html_safe }
      format.text { render text: email.decoded }
    end
  end
end