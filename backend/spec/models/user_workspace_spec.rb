require 'rails_helper'

RSpec.describe UserWorkspace, type: :model do
    let(:user) { User.create!(email: 'tester@example.com', name: 'Tester', password: 'password') }
    let(:workspace) { Workspace.create!(name: 'Test Workspace', description: 'Test description') }

    it 'is valid with a user and workspace' do
        user_workspace = UserWorkspace.new(user: user, workspace: workspace)
        expect(user_workspace).to be_valid
    end

    it 'is invalid without a user' do
        user_workspace = UserWorkspace.new(user: nil, workspace: workspace)
        user_workspace.valid?
        expect(user_workspace.errors[:user]).to include("must exist")
    end

    it 'is invalid without a workspace' do
        user_workspace = UserWorkspace.new(user: user, workspace: nil)
        user_workspace.valid?
        expect(user_workspace.errors[:workspace]).to include("must exist")
    end
end