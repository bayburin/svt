module Invent
  class ItemsController < ApplicationController
    def index
      respond_to do |format|
        format.html
        format.json do
          @index = Items::Index.new(params)

          if @index.run
            render json: @index.data
          else
            render json: { full_message: 'Ошибка. Обратитесь к администратору, т.50-32' }, status: 422
          end
        end
      end
    end

    def used
      @used = Items::Used.new(params[:type_id])

      if @used.run
        render json: @used.data
      else
        render json: { full_message: 'Ошибка. Обратитесь к администратору, т.50-32' }, status: 422
      end
    end

    def show
      @show = Items::Show.new(params[:item_id])

      if @show.run
        render json: @show.data
      else
        render json: { full_message: @show.errors.full_messages.join('. ') }, status: 422
      end
    end
  end
end
