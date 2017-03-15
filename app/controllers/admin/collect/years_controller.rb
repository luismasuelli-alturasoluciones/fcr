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
    if @year.valid?
      redirect_to admin_collect_years_path, flash: {success: 'Punto creado exitosamente'}
    end
  end

  def edit
  end

  def update
    @year.update_attributes(object_params)
    if @year.valid?
      flash[:success] = 'Año actualizado exitosamente'
    end
  end

  def add_place
    begin
      @year.year_places.create(place: Place.find(params[:place_id]), place_leader: User.find(params[:user_id]))
      flash[:success] = 'Punto agregado exitosamente'
    rescue ActiveRecord::RecordNotFound
      if exc.model == User
        flash[:alert] = 'No se pudo agregar el punto porque no existe el usuario seleccionado'
      else
        flash[:alert] = 'No se pudo agregar el punto porque no existe'
      end
    end
    redirect_to edit_admin_collect_year_path(@year)
  end

  def remove_place
    begin
      @year.year_places.where(place: Place.find(params[:place_id])).delete_all
      flash[:success] = 'Punto removido exitosamente'
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'No se pudo remover el punto porque no existe'
    end
    redirect_to edit_admin_collect_year_path(@year)
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