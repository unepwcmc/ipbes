class UsersController < ApplicationController
  before_filter :authenticate_user!

  # GET /users
  # GET /users.json
  def index
    if params[:approved] == 'false'
      @users = User.unapproved
    else
      @users = User.all
    end
    authorize! :read, @users

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    authorize! :read, @user

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    authorize! :update, @user
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    authorize! :update, @user

    @user.name = params[:user][:name]
    @user.institution = params[:user][:institution]
    @user.description = params[:user][:description]
    @user.approved = params[:user][:approved]
    @user.admin = params[:user][:admin]

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
