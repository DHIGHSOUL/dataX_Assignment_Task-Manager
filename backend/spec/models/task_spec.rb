require 'rails_helper'

RSpec.describe Task, type: :model do
    it 'is valid with a name, description, status, due_date, workspace' do
        workspace = Workspace.create!(name: 'Test Workspace')
        %w[pending in_progress completed].each do |valid_status|
            task = Task.new(name: 'Sample Task', description: 'Test description', status: valid_status, due_date: Date.tomorrow, workspace: workspace)
            expect(task).to be_valid
        end
    end

    it 'is invalid without a name' do
        task = Task.new(name: nil)
        task.valid?
        expect(task.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a workspace' do
        task = Task.new(workspace: nil)
        task.valid?
        expect(task.errors[:workspace]).to include("must exist")
    end

    describe 'status validation' do
        let(:workspace) { Workspace.create!(name: 'Test Workspace') }
        it 'is valid with a valid status' do
            %w[pending in_progress completed].each do |valid_status|
                task = Task.new(name: 'Sample Task', due_date: Date.tomorrow, status: valid_status, workspace: workspace)
                expect(task).to be_valid
            end
        end
        it 'is invalid with an invalid status' do
            workspace = Workspace.create!(name: 'Test Workspace')
            task = Task.new(name: 'Sample Task', due_date: Date.tomorrow, status: 'invalid_status', workspace: workspace)
            task.valid?
            expect(task.errors[:status]).to include("is not included in the list")
        end
    end
end