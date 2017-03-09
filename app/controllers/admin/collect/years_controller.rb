class Admin::Collect::YearsController < Admin::AdminController

  rescue_from ActiveRecord::RecordNotFound do |exception|
    # render a not-found screen
  end

  rescue_from ActiveRecord::RecordNotDestroyed do |exception|
    # render a not-destroyed screen for exception.record
  end

  rescue_from Exception do
    # render an unknown error screen
  end

  before_action :load_object, only: [:edit, :update, :add_place, :remove_place, :destroy]

  def index
    @years = Year.all.paginate(:page => params[:page], :per_page => 50)
  end

  def new
    @year = Year.new
  end

  def create
    @year = Year.create(object_params)
  end

  def edit
  end

  def update
    @year.update_attributes(object_params)
  end

  def add_place
    @year.year_places.create(place: Place.find(params[:place_id]))
  rescue
    # render a year-not-found view
  end

  def remove_place
    @year.year_places.where(place: Place.find(params[:place_id])).delete_all
  rescue ActiveRecord::RecordNotFound
    # render a place-not-found view
  end

  def destroy
    @year.destroy!
  end

  private

  def load_object
    @year = Year.find(params[:id])
  end

  def object_params
    params_ = params.require(:year).permit(:year, :event_date)
    params_[:event_date] = Date.strptime(params[:event_date], "%d/%m/%Y") if params[:event_date].present?
    params_
  end

end