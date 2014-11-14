class V1::Certificates::CertificatesController < V1::Base

  resources :certificates do

    desc 'return a list of all certificates'
    get do
      @certificates = Certificate.all
      present @certificates, :with => V1::Certificates::Entity
    end

    desc 'creates a new gift certificate for a user'
    post do
      @certificate = Certificate.create(create_params)
    end

    private

    def create_params
      safe_params(params).permit(:purchaser_id, :sponsorship_id, :amount, :recipient)
    end

  end


end