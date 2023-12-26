class TasksController < ApplicationController

    def create
        @list = List.find(params[:list_id])
        @task = @list.tasks.build(task_params)

        if @task.save
            redirect_to @list.project
        else
            redirect_to @list.project, alert: '請填入代辦事項'
        end
    end

    def edit
        @task = Task.find(params[:id])
    end

    def update
        @task = Task.find(params[:id])
        if @task.update(task_params)
            redirect_to project_path(@task.list.project.id)
        else
            render :edit
        end
    end

    def destroy
        @task = Task.find(params[:id]) # 查找要删除的任务对象
        @task.destroy if @task # 如果找到了任务对象，则执行删除操作
        redirect_to project_path # 重定向到任务列表或其他页面
    end

    private
    def task_params
        params.require(:task).permit(:title, :description, :priority, :start_at, :estimated_complete_at)
    end
end
