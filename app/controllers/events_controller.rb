class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  def today
    @events = Event.order(start_time: :asc).where(
        start_time: Date.today.beginning_of_day..Date.today.end_of_day,
        user_id: session[:user])
    render :today
  end

  def tomorrow
    @events = Event.where(start_time: Date.tomorrow.beginning_of_day..Date.tomorrow.end_of_day, user_id: session[:user])
    render :today
  end

  def notify

    notify_events = []
    ignore_events = []

    params[:events].each do |id, event|
      if event.has_key? :notify
        notify_events << event[:id].to_i
      else
        ignore_events << event[:id].to_i
      end
    end

    Event.where(id: notify_events).update_all(notify: true)
    Event.where(id: ignore_events).update_all(notify: false)

    redirect_to today_events_path
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :description, :participants, :start_time, :end_time, :user_id, :google_id)
    end
end
