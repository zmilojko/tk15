class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :receipt]
  before_action :authenticate_user!
  
  def check_admin_or_me
    unless @user and current_user == @user
      check_admin
    end
  end
  
  # GET /users
  # GET /users.json
  def index
    check_admin
    @users = User.collection.find
  end

  # GET /users/1
  # GET /users/1.json
  def show
    check_admin_or_me
  end

  # GET /users/new
  def new
    check_admin
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    check_admin_or_me
  end

  # POST /users
  # POST /users.json
  def create
    check_admin
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    check_admin
    k = user_params.to_hash
    k.except! "password", "password_confirmation" if k["password"].blank?
    respond_to do |format|
      if @user.update(k)
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    check_admin
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def receipt
    if File.exist? Rails.root.join "receipts", @user.receipt_file + ".pdf"
      send_data File.binread(Rails.root.join "receipts", @user.receipt_file + ".pdf"),
        filename: "#{@user.name}_receipt.pdf",
        type: "application/pdf"
    elsif File.exist? Rails.root.join "receipts", @user.receipt_file + ".jpg"
      send_data File.binread(Rails.root.join "receipts", @user.receipt_file + ".jpg"),
        filename: "#{@user.name}_receipt.jpg",
        type: "application/jpg"
    else
      error_404
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin, 
                    :club, :dogs, :races, :competitions)
    end
end
