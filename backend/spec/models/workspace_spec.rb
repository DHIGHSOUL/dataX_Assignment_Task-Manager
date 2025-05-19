require 'rails_helper'

RSpec.describe Workspace, type: :model do
    it 'is valid with a name and description' do
        workspace = Workspace.new(name: 'Test Workspace', description: 'Test description')
        expect(workspace).to be_valid
    end

    it 'is invalid without a name' do
        workspace = Workspace.new(name: nil, description: 'Test description')
        workspace.valid?
        expect(workspace.errors[:name]).to include("can't be blank")
    end
end