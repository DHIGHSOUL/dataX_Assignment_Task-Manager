require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
    let(:user) { User.create!(email: 'tester@example.com', name: 'Tester', password: 'password') }
    let(:workspace) do
        w = Workspace.create!(name: 'Test Workspace')
        w.users << user
        w
    end

    before do
        post '/api/user/login', params: { user: { email: user.email, password: user.password } }
        @token = JSON.parse(response.body)['token']
    end

    let(:headers) { { 'Authorization' => "Bearer #{@token}" } }

    it 'allows authenticated user to create task' do
        post "/api/workspaces/#{workspace.id}/tasks", params: { task: { name: 'Test Task', status: 'pending', due_date: '2025-05-30'} }, headers: headers
        expect(response).to have_http_status(:created)
    end

    it 'rejects unauthenticated user' do
        post "/api/workspaces/#{workspace.id}/tasks", params: { task: { name: 'Test Task', status: 'pending', due_date: '2025-05-30' } }
        expect(response).to have_http_status(:unauthorized)
    end
end