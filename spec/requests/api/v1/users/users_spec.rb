require 'rails_helper'

describe V1::Users::UsersController do

  describe 'GET /v1/users/role/cause' do

    it 'should not return anything' do
      get '/v1/users/role/cause'
      expect( JSON.parse(response.body).size ).to eq(0)
    end

    it 'should return all the causes' do

      @businesses = create_list(:business, 3)
      @causes = create_list(:cause, 4)

      get '/v1/users/role/cause'
      expect( response.status ).to eq(200)
      resp = JSON.parse(response.body)
      expect( resp.size ).to eq(4)

      expect( resp[0]['id'] ).to eq(@causes[0].id)
      expect( resp[1]['id'] ).to eq(@causes[1].id)
      expect( resp[2]['id'] ).to eq(@causes[2].id)
      expect( resp[3]['id'] ).to eq(@causes[3].id)

    end

  end

end