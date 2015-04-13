class UsersController < ApplicationController
  before_action :logged_in_user, only: [ :edit, :update, :index, :destroy ]
  before_action :correct_user, only: [ :edit, :update ]
  before_action :admin_user, only:  [ :destroy ]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.deliver_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_path
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Successfully updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.destroy(params[:id])
    flash[:success] = "User deleted"
    redirect_to users_path
  end
  
  private
    
    def user_params
      params[:user][:name].split.collect { |w| w.capitalize }.join(" ") unless params[:user][:name].nil?
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # Before filter
    
    # confirms a logged in user
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    #confirms correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # confirms admin user
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
    
end
