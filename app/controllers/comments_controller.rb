# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @task = Task.find(params[:task_id])
    @project = @task.project
    @comment = @task.comments.new(comment_params)
    @comments = @task.comments
    
    unless @comment.save
      flash[:alert] = t('comment.context_blank_alert')
      render turbo_stream: turbo_stream.replace('comment-form', partial: 'comments/form', locals: { comment: @comment })
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to task_path(comment.task_id)
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(user: current_user)
  end
end
