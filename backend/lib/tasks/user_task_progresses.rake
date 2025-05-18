namespace :user_task_progresses do
    desc "Collect task progress stats for each user in each workspace"
    task update: :environment do
        puts "Starting task progress update..."

        Workspace.find_each do |workspace|
            workspace.users.find_each do |user|
                tasks = Task.joins(:task_assignments).where(task_assignments: { user_id: user.id }, workspace_id: workspace.id)

                total = tasks.count
                completed = tasks.where(status: 'completed').count
                next if total == 0

                progress = (completed.to_f / total * 100).round(2)

                record = TaskProgress.find_or_initialize_by(user_id: user.id, workspace_id: workspace.id)
                record.total_tasks = total
                record.completed_tasks = completed
                record.progress_rate = progress  # ← 여기 수정됨
                record.save!

                puts "Updated progress for user #{user.id} in workspace #{workspace.id}: #{progress}%"
            end
        end

        puts "Task progress update completed."
    end
end