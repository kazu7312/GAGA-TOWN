class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :likes]
  before_action :correct_user,   only: [:edit, :update, :likes]
  #before_action :admin_user,     only: [:destroy]

  # def index
  #   @users = User.paginate(page: params[:page])
  # end
  #
  # def show
  #   @user = User.find(params[:id])
  # end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "GAGA TOWNへようこそ！"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to root_path
    else
      flash[:danger] = "プロフィール更新に失敗しました"
      render 'edit'
    end
  end

  # def destroy
  #   User.find(params[:id]).destroy
  #   flash[:success] = "User deleted"
  #   redirect_to users_url
  # end

  def likes
    @user = User.find(params[:id])
    @favproducts = @user.favproducts
  end


  private

    def user_params
       params.require(:user).permit(:name, :email, :postal_code,
                                    :address, :password,
                                    :password_confirmation)
    end

    # beforeアクション

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
