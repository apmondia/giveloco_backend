require 'rails_helper'

describe V1::Certificates::CertificatesController do

  it 'should return a list of certificates' do
    @certificates = create_list(:certificate, 10)

    get '/v1/certificates'


    expect( response.status ).to eq(200)
    json = JSON.parse(response.body)
    expect( json.length ).to eq(10)

  end

end