class CeremoniesController < ApplicationController
  # GET /ceremonies
  def index
    ceremonies = Ceremony.order(event_date: :asc).page(params[:page]).per(params[:per_page])
    render json: {
      ceremonies: ceremonies.as_json(only: [ :id, :name, :event_date ]),
      meta: {
        current_page: ceremonies.current_page,
        total_pages: ceremonies.total_pages,
        total_count: ceremonies.total_count
      }
    }
  end

  # GET /ceremonies/:id
  def show
    ceremony = Ceremony.find(params[:id])
    render json: ceremony.as_json(only: [ :id, :name, :event_date ])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Ceremony not found" }, status: :not_found
  end

  # POST /ceremonies
  def create
    ceremony = Ceremony.new(ceremony_params)
    if ceremony.save
      render json: ceremony.as_json(only: [ :id, :name, :event_date ]), status: :created
    else
      render json: { errors: ceremony.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /ceremonies/:id
  def destroy
    ceremony = Ceremony.find(params[:id])
    if ceremony.soft_delete
      render json: { message: "Ceremony successfully deleted" }, status: :ok
    else
      render json: { errors: ceremony.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Ceremony not found" }, status: :not_found
  end

  # PUT/PATCH /ceremonies/:id
  def update
    ceremony = Ceremony.find(params[:id])
    if ceremony.update(ceremony_params)
      render json: ceremony.as_json(only: [ :id, :name, :event_date ]), status: :ok
    else
      render json: { errors: ceremony.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Ceremony not found" }, status: :not_found
  end

  private

  def ceremony_params
    params.require(:ceremony).permit(:name, :event_date)
  end
end
