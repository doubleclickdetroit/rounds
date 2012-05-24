class UploadsController < ApplicationController
  # GET /pictures/new
  # GET /pictures/new.json
  def new
    @picture = Picture.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @picture }
    end
  end

  # POST /pictures
  # POST /pictures.json
  def create
    @picture = Picture.new(params[:picture])

    respond_to do |format|
      if @picture.save
        format.html { redirect_to "/uploads/#{@picture.id}", notice: 'Picture was successfully created.' }
        format.json { render json: @picture, status: :created, location: @picture }
      else
        format.html { render action: "new" }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
    @picture = Picture.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @picture }
    end
  end





  # # GET /uploads
  # # GET /uploads.json
  # def index
  #   @uploads = Upload.all

  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @uploads }
  #   end
  # end

  # # GET /uploads/1/edit
  # def edit
  #   @upload = Upload.find(params[:id])
  # end

  # # PUT /uploads/1
  # # PUT /uploads/1.json
  # def update
  #   @upload = Upload.find(params[:id])

  #   respond_to do |format|
  #     if @upload.update_attributes(params[:upload])
  #       format.html { redirect_to @upload, notice: 'Upload was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @upload.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /uploads/1
  # # DELETE /uploads/1.json
  # def destroy
  #   @upload = Upload.find(params[:id])
  #   @upload.destroy

  #   respond_to do |format|
  #     format.html { redirect_to uploads_url }
  #     format.json { head :no_content }
  #   end
  # end
end
