class ListsController < ApplicationController
    def index
        @lists = Project.find(params[:project_id]).lists
        @paramenters = params
    end
    
    def new
        @project = Project.find(params[:project_id])
        @new_list = @project.lists.build
    end

    def create
        @project = Project.find(params[:project_id])
        @new_list = @project.lists.build(list_params)

        if @new_list.save
            redirect_to @project, notice: '列表創建成功'
        else
            render :new
        end
    end

    def edit
        @list = List.find(params[:id])
    end
    
    def update
        @list = List.find(params[:id])
        if @list.update(list_params)
            redirect_to project_path(@list.project.id)
        else
            render :edit
        end
    end
    
    def destroy
        @list = List.find(params[:id])
        @list.destroy
    end

    private
    def find_list
        @list = List.find(params[:list_id])
    end

    def list_params
        params.require(:list).permit(:title, :color, :delete_at, :row_order)
    end
    
end
