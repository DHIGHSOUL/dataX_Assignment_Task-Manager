require 'rails_helper'

RSpec.describe TaskProgress, type: :model do
    let(:user) { User.create!(email: 'tester@example.com', name: 'Tester', password: 'password') }
    let(:workspace) { Workspace.create!(name: 'Test Workspace', description: 'Test description') }
    let(:task) { Task.create!(name: 'Test Task', description: 'Test description', status: 'pending', workspace: workspace) }

    it 'is valid with a user, workspace, and progress' do
        task_progress = TaskProgress.new(user: user, workspace: workspace, progress_rate: 50)
        expect(task_progress).to be_valid
    end

    it 'is invalid without a user' do
        task_progress = TaskProgress.new(user: nil, workspace: workspace, progress_rate: 50)
        task_progress.valid?
        expect(task_progress.errors[:user]).to include("must exist")
    end

    it 'is invalid without a workspace' do
        task_progress = TaskProgress.new(user: user, workspace: nil, progress_rate: 50)
        task_progress.valid?
        expect(task_progress.errors[:workspace]).to include("must exist")
    end
end