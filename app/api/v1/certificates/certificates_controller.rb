module V1
  module Certificates
    class CertificatesController < V1::Base

      resources :certificates do

        desc 'Creates a new certificate'
        post do
          _params = safe_params(params)
                        .require(:certificate)
                        .permit(:serial_number, :recipient, :amount, :sponsorship_id)
          @certificate = Certificate.create!(_params)
        end

        resource '/redeem' do
          desc 'Allows the user to redeem the certificate if they are the business'
          params do
            requires :redemption_code
          end
          put do
            authenticate!
            @certificate = Certificate.find_by_redemption_code( params[:redemption_code] )
            can_or_die :redeem, @certificate
            @certificate.update_attributes!({ :redeemed => true })
            present @certificate, :with => V1::Certificates::Entity
          end
        end

      end

    end
  end
end
