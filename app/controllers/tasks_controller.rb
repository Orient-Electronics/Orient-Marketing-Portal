class TasksController < ApplicationController

  def index
      @created_tasks = current_user.created_tasks
      @assigned_tasks = current_user.assigned_tasks
      @complete_assigned_tasks = @created_tasks.where(:status => "completed").flatten
      @shops = Shop.all
      @task = Task.new
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @tasks }
      end
  end

  def new
    @task = Task.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  def create
    @task = Task.new(params[:task])
    respond_to do |format|
      if @task.save
        @task.create_activity :create, owner: current_user
        format.html { redirect_to tasks_path, notice: 'Task was successfully created.'}
        format.json { render json: tasks }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end


  def change_status
    @task = Task.find(params[:id])
    @task.status = params[:task][:status]
    if @task.save
      @task.create_activity :update, owner: current_user
      respond_to do |format|
        format.html {redirect_to '/'}
        format.json { render json: @tasks }
      end
    else
      format.html { redirect_to '/' }
      format.json { render json: @task.errors, status: :unprocessable_entity }
    end
  end

  def publish_report
    post = Post.find(params[:post_id])
    post.published = true
    post.status = "published"
    post.approved_id = current_user.id
    post.save
    post.create_activity :publish, owner: current_user
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Report was successfully published.'}
    end
  end

  def unpublish_report
    post = Post.find(params[:post_id])
    post.published = false
    post.approved_id = nil
    post.status = "unpublished"
    post.save
    post.create_activity :unpublish, owner: current_user
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Report was successfully unpublished.'}
    end
  end
  
  def draft_report
    post = Post.find(params[:post_id])
    post.published = false
    post.approved_id = nil
    post.status = "draft"
    post.save
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Report was status change successfully.'}
    end
  end
end