require 'rails_helper'

RSpec.describe TaskAssignment, type: :model do
    let(:user) { User.create!(email: 'tester@example.com', name: 'Tester', password: 'password') }
    let(:workspace) { Workspace.create!(name: 'Test Workspace', description: 'Test description') }
    let(:task) { Task.create!(name: 'Test Task', description: 'Test description', status: 'pending', workspace: workspace) }

    it 'is valid with a user, task' do
        task_assignment = TaskAssignment.new(user: user, task: task)
        expect(task_assignment).to be_valid
    end

    it 'is invalid without a user' do
        task_assignment = TaskAssignment.new(user: nil, task: task)
        task_assignment.valid?
        expect(task_assignment.errors[:user]).to include("must exist")
    end

    it 'is invalid without a task' do
        task_assignment = TaskAssignment.new(user: user, task: nil)
        task_assignment.valid?
        expect(task_assignment.errors[:task]).to include("must exist")
    end
end