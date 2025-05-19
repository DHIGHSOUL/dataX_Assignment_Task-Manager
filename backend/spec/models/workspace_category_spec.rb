require 'rails_helper'

RSpec.describe WorkspaceCategory, type: :model do
    let(:workspace) { Workspace.create!(name: 'Test Workspace') }

    it 'is valid with a name and color' do
        workspace_category = WorkspaceCategory.new(name: 'Test Category', color: 'FF5733', workspace: workspace)
        expect(workspace_category).to be_valid
    end

    it 'is invalid without a name' do
        workspace_category = WorkspaceCategory.new(name: nil, color: 'FF5733', workspace: workspace)
        workspace_category.valid?
        expect(workspace_category.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a workspace' do
        workspace_category = WorkspaceCategory.new(name: 'Test Category', color: 'FF5733', workspace: nil)
        workspace_category.valid?
        expect(workspace_category.errors[:workspace]).to include("must exist")
    end

    it 'is valid with a hex color code' do
        valid_colors = ['000000', 'FFFFFF', 'FF5733', '123456']
        valid_colors.each do |color|
            workspace_category = WorkspaceCategory.new(name: 'Test Category', color: color, workspace: workspace)
            expect(workspace_category).to be_valid
        end
    end

    it 'is invalid with an invalid color code' do
        invalid_colors = ['ZZZZZZ', '12345', '1234567', 'GHIJKL']
        invalid_colors.each do |color|
            workspace_category = WorkspaceCategory.new(name: 'Test Category', color: color, workspace: workspace)
            workspace_category.valid?
            expect(workspace_category.errors[:color]).to include("must be a valid hex color code")
        end
    end
end