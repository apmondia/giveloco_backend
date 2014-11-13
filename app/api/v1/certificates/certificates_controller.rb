class V1::Certificates::CertificatesController < V1::Base

  resources :certificates do

    desc 'return a list of all certificates'
    get do
      @certificates = Certificate.all
      present @certificates, :with => V1::Certificates::Entity
    end

  end


end