class AssessmentsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show, :search, :download]
  ASSESSMENTS_PER_PAGE = 1001

  # GET /assessments
  # GET /assessments.json
  def index
    @page = (params[:page].present? ? params[:page].to_i : 1)
    @page = 1 if @page < 1
    offset = (@page - 1) * ASSESSMENTS_PER_PAGE
    if user_signed_in?
      @assessments = Assessment.search(params).limit(ASSESSMENTS_PER_PAGE).offset(offset)
      @is_last_page = Assessment.search(params).count <= @page*ASSESSMENTS_PER_PAGE
    else
      @assessments = Assessment.where(published: true).search(params).limit(ASSESSMENTS_PER_PAGE).offset(offset)
      @is_last_page = Assessment.where(published: true).search(params).count <= @page*ASSESSMENTS_PER_PAGE
    end
    authorize! :read, Assessment
    @countries = Country.for_assessments @assessments

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @assessments }
    end
  end

  # POST /assessments/search
  def search
    @page = (params[:page].present? ? params[:page].to_i : 1)
    @page = 1 if @page < 1
    offset = (@page - 1) * ASSESSMENTS_PER_PAGE
    if user_signed_in?
      @assessments = Assessment.search(params).limit(ASSESSMENTS_PER_PAGE).offset(offset)
      @is_last_page = Assessment.search(params).count <= @page*ASSESSMENTS_PER_PAGE
    else
      @assessments = Assessment.where(published: true).search(params).limit(ASSESSMENTS_PER_PAGE).offset(offset)
      @is_last_page = Assessment.where(published: true).search(params).count <= @page*ASSESSMENTS_PER_PAGE
    end
    authorize! :read, Assessment

    @countries = Country.for_assessments @assessments

    respond_to do |format|
      format.js { render :layout => false }
      format.json { render json: @assessments }
    end
  end

  # GET /assessments/download
  def download
    require 'csv'

    if user_signed_in?
      @assessments = Assessment.search(params)
    else
      @assessments = Assessment.where(published: true).search(params)
    end
    authorize! :read, Assessment

    respond_to do |format|
      format.csv { render :layout => false }
    end
  end

  # GET /assessments/1
  # GET /assessments/1.json
  def show
    @assessment = Assessment.find(params[:id])
    authorize! :read, @assessment

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @assessment }
    end
  end

  # GET /assessments/1/download_assessment
  def download_assessment
    require 'csv'
    @assessment = Assessment.find(params[:id])
    authorize! :read, @assessment

    respond_to do |format|
      format.csv { render layout: false}
    end
  end

  # GET /assessments/new
  # GET /assessments/new.json
  def new
    @assessment = Assessment.new
    authorize! :create, @assessment

    @assessment.contacts.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @assessment }
    end
  end

  # GET /assessments/1/edit
  def edit
    @assessment = Assessment.find(params[:id])
    authorize! :update, @assessment
  end

  # POST /assessments
  # POST /assessments.json
  def create
    @assessment = Assessment.new(params[:assessment])
    authorize! :create, @assessment
    @assessment.last_editor = current_user

    respond_to do |format|
      if @assessment.save
        format.html { redirect_to @assessment, notice: 'Assessment was successfully created.' }
        format.json { render json: @assessment, status: :created, location: @assessment }
      else
        format.html { render action: "new" }
        format.json { render json: @assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /assessments/1
  # PUT /assessments/1.json
  def update
    @assessment = Assessment.find(params[:id])
    authorize! :update, @assessment
    @assessment.last_editor = current_user

    respond_to do |format|
      if @assessment.update_attributes(params[:assessment])
        format.html { redirect_to @assessment, notice: 'Assessment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assessments/1
  # DELETE /assessments/1.json
  def destroy
    @assessment = Assessment.find(params[:id])
    authorize! :destroy, @assessment

    @assessment.destroy

    respond_to do |format|
      format.html { redirect_to assessments_url }
      format.json { head :no_content }
    end
  end
end
