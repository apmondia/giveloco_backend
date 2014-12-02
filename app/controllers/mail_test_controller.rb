class MailTestController < ApplicationController

  #GET params id
  def certificate
    email = TalifloMailer.certificate_purchase( Certificate.find(params[:id]))
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