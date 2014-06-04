tasks = Task.all
tasks.each do |task|
	assign_user = User.where(assigned_to: task.assigned_to).first
	task.destroy  if assign_user.nil?
	assigned_user = User.where(assigned_by: task.assigned_by).first
	task.destroy  if assigned_user.nil?
end