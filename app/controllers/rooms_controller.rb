class RoomsController < ApplicationController
	before_action :authenticate_user!

	def index
		@rooms = Room.all
	end	
	
	def new
		@room = Room.new
  end

	def create
		@room = Room.new(room_params)
		if @room.save
			redirect_to rooms_path, notice: 'Created new ChatRoom!'
		else
			render :new
		end
	end

	def show
		find_room
	end

	def edit
		find_room
	end

	def update
		find_room
		if @room.update
			redirect_to rooms_path, notice: 'Updated ChatRoom Success!'
		else
			render :edit
		end
	end


	private

	def room_params
		params.require(:room).permit(:name)
	end
	
	def find_room
		@room = Room.find_by(id:params[:id])
	end

end
