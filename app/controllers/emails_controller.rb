class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :edit, :update, :destroy]

  protect_from_forgery except: :receive

  # GET /emails
  # GET /emails.json
  def index
    @emails = Email.all
  end

  def receive

    email_params = sendgrid_email_params

    # Make sure that all saved fields are UTF-8
    JSON.parse(params[:charsets]).each do |key, value|
      if email_params.key? key
        email_params[key] = email_params[key].encode(value, 'utf-8', :invalid => :replace, :undef => :replace)
      end
    end

    email = Email.create(email_params)

    if email.valid?

      google_id = /meeting_(.*)@/.match(email.to)[1]
      event = Event.find_by(google_id: google_id)
      event.participants.each do |participant|

        next if email.from.include? participant

        EmailReplyJob.new.async.perform(
            to: participant,
            from: email.from,
            subject: email.subject,
            reply_to: "meeting_#{event[:google_id]}@photato.co",
            text: email.text,
            html: email.html
        )
      end

      head :no_content
    else
      error 500
    end
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
  end

  # GET /emails/new
  def new
    @email = Email.new
  end

  # GET /emails/1/edit
  def edit
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = Email.new(email_params)

    respond_to do |format|
      if @email.save
        format.html { redirect_to @email, notice: 'Email was successfully created.' }
        format.json { render action: 'show', status: :created, location: @email }
      else
        format.html { render action: 'new' }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emails/1
  # PATCH/PUT /emails/1.json
  def update
    respond_to do |format|
      if @email.update(email_params)
        format.html { redirect_to @email, notice: 'Email was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email.destroy
    respond_to do |format|
      format.html { redirect_to emails_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_params
      params.require(:email).permit(:headers, :text, :html, :from, :to, :cc, :subject)
    end

    def sendgrid_email_params
      params.permit(:headers, :text, :html, :from, :to, :cc, :subject)
    end
end
