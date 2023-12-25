class ListsController < ApplicationController
    def index
        @lists = List.rank(:row_order)
    end
end
