class Admin::Collect::PlacesController < Admin::AdminController

  before_action do |controller|
    controller.instance_variable_set(:@selected_menu, 'Collect::Places')
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    # render a not-found screen
  end

  rescue_from ActiveRecord::RecordNotDestroyed do |exception|
    # render a not-destroyed screen for exception.record
  end

  rescue_from Exception do |exception|
    # render an unknown error screen
  end

  before_action :load_object, only: [:edit, :update, :add_year, :remove_year, :destroy]

  def index
    @places = ::Collect::Place.all.paginate(:page => params[:page], :per_page => 50)
  end

  def new
    @place = ::Collect::Place.new
  end

  def create
    @place = ::Collect::Place.create(object_params)
    if @place.valid?
      redirect_to admin_collect_places_path, flash: {success: 'Punto creado exitosamente'}
    end
  end

  def edit
  end

  def update
    @place.update_attributes(object_params)
    if @place.valid?
      flash[:success] = 'Punto actualizado exitosamente'
    end
  end

  def add_year
    begin
      @place.year_places.create!(year: ::Collect::Year.find(params[:year_id]), place_leader: User.find(params[:user_id]))
      flash[:success] = 'Año agregado exitosamente'
    rescue ActiveRecord::RecordNotFound => exc
      if exc.model == User
        flash[:alert] = 'No se pudo agregar el año porque no existe el usuario seleccionado'
      else
        flash[:alert] = 'No se pudo agregar el año porque no existe'
      end
    end
    redirect_to edit_admin_collect_place_path(@place)
  end

  def remove_year
    begin
      @place.year_places.where(year: ::Collect::Year.find(params[:year_id])).delete_all
      flash[:success] = 'Año removido exitosamente'
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'No se pudo remover el año porque no existe'
    end
    redirect_to edit_admin_collect_place_path(@place)
  end

  def destroy
    @place.destroy!
    flash[:success] = 'Punto borrado exitosamente'
    redirect_to admin_collect_places_path
  end

  private

  def load_object
    @place = ::Collect::Place.find(params[:id])
  end

  def object_params
    params.require(:place).permit(:name, :city_id, :address, :lat, :lng)
  end

end
