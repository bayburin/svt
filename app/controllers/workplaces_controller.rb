class WorkplacesController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json do
        # @workplaces = Workplace.all
        render json: [
          { name: 'Место-714-1', type: 'Конструкторское', responsible: 'Байбурин Р.Ф.', location: '3а-321а', count: 4},
          { name: 'Место-714-2', type: 'Офисное', responsible: 'Байбурин Р.Ф.', location: '3а-321а', count: 2}
        ]
      end
    end
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
