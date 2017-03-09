class Admin::Collect::PlacesController < Admin::AdminController

  rescue_from ActiveRecord::RecordNotFound do |exception|
    # render a not-found screen
  end

  rescue_from ActiveRecord::RecordNotDestroyed do |exception|
    # render a not-destroyed screen for exception.record
  end

  rescue_from Exception do
    # render an unknown error screen
  end

  before_action :load_object, only: [:edit, :update, :add_year, :remove_year, :destroy]

  def index
    @places = Place.all.paginate(:page => params[:page], :per_page => 50)
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.create(object_params)
  end

  def edit
  end

  def update
    @place.update_attributes(object_params)
  end

  def add_year
    @place.year_places.create!(year: Year.find(params[:year_id]))
  rescue
    # render a year-not-found view
  end

  def remove_year
    @place.year_places.where(year: Year.find(params[:year_id])).delete_all
  rescue ActiveRecord::RecordNotFound
    # render a year-not-found view
  end

  def destroy
    @place.destroy!
  end

  private

  def load_object
    @place = Place.find(params[:id])
  end

  def object_params
    params.require(:place).permit(:name, :city_id, :address, :lat, :lng)
  end

end
