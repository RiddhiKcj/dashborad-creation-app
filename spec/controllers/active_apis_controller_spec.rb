require 'rails_helper'
let(:user) { create(:user) }

let(:valid_attributes) {
  { name: "Marvel", api_url: "https://developer.marvel.com/" , api_key: "" }
}

let(:invalid_attributes) {
  { name: nil, api_url: nil }
}

before do
  payload = { user_id: user.id }
  session = JWTSessions::Session.new(payload: payload)
  @tokens = session.login
end

describe 'GET #index' do
  let!(:active_api) { create(:active_api, user: user) }

  it 'returns a success response' do
    request.cookies[JWTSessions.access_cookie] = @tokens[:access]
    get :index
    expect(response).to be_successful
    expect(response_json.size).to eq 1
    expect(response_json.first['id']).to eq active_api.id
  end

  # usually there's no need to test this kind of stuff 
  # within the resources endpoints
  # the quick spec is here only for the presentation purposes
  it 'unauth without cookie' do
    get :index
    expect(response).to have_http_status(401)
  end
end


describe 'POST #create' do

  context 'with valid params' do
    it 'creates a new active_api' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]
      request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
      expect {
        post :create, params: { active_api: valid_attributes }
      }.to change(active_api, :count).by(1)
    end

    it 'renders a JSON response with the new active_api' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]
      request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
      post :create, params: { active_api: valid_attributes }
      expect(response).to have_http_status(:created)
      expect(response.content_type).to eq('application/json')
      expect(response.location).to eq(active_api_url(active_api.last))
    end

    it 'unauth without CSRF' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]
      post :create, params: { active_api: valid_attributes }
      expect(response).to have_http_status(401)
    end
  end

  context 'with invalid params' do
    it 'renders a JSON response with errors for the new active_api' do
      request.cookies[JWTSessions.access_cookie] = @tokens[:access]
      request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
      post :create, params: { active_api: invalid_attributes }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json')
    end
  end
end


describe 'DELETE #destroy' do
  let!(:active_api) { create(:active_api, user: user) }

  it 'destroys the requested active_api' do
    request.cookies[JWTSessions.access_cookie] = @tokens[:access]
    request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
    expect {
      delete :destroy, params: { id: active_api.id }
    }.to change(active_api, :count).by(-1)
  end
end
RSpec.describe ActiveApisController, type: :controller do

end
