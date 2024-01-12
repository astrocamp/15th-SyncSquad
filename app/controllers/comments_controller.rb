# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    task = Task.find(params[:task_id])
    comment = task.comments.new(comment_params)
    @comments = task.comments
    if comment.save

    else
      redirect_to tasks_path(task)
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
