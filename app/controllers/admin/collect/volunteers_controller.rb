class Admin::Collect::VolunteersController < Admin::AdminController

  rescue_from ActiveRecord::RecordNotFound do |exception|
    # render a not-found screen
  end

  before_action :load_object, only: [:show, :add_volunteer, :remove_volunteer]

  def index
    # This point does not list volunteers actually, but
    #   Year/Place instances. This displayed list should be
    #   able to be filtered by either year or place.
    @year_places = YearPlace.all
    @year_places = @year_places.where(year_id: params[:year_id]) if params[:year_id].present?
    @year_places = @year_places.where(place_id: params[:place_id]) if params[:year_id].present?
    @year_places = @year_places.paginate(:page => params[:page], :per_page => 50)
  end

  def show
    # This point does not show volunteers actually, but
    #   a chosen Year/Place instance. Then it displays the
    #   appropriate volunteers list.
  end

  def add_volunteer
    # This point does not create a volunteer, but picks one
    #   from the list (or an autocomplete! who knows...) and
    #   adds it to the current Year/Place instance.
    begin
      @year_place.year_place_volunteers.create(volunteer: Volunteer.find(params[:volunteer_id]))
      flash[:success] = 'Voluntario agregado exitosamente'
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'No se puede agregar el voluntario porque no existe'
    end
    redirect_to admin_collect_volunteer_path(@year_place)
  end

  def remove_volunteer
    # This point does not destroy a volunteer, but picks one
    #   from the list (or an autocomplete! who knows...) and
    #   adds it to the current Year/Place instance.
    begin
      @year_place.year_place_volunteers.where(volunteer: Volunteer.find(params[:volunteer_id])).delete_all
      flash[:success] = 'Voluntario removido exitosamente'
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'No se puede remover el voluntario porque no existe'
    end
    redirect_to admin_collect_volunteer_path(@year_place)
  end

  private

  def load_object
    @year_place = YearPlace.find(params[:id])
  end

end