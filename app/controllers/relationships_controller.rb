class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @user = User.find_by id: params[:user_id]
    if @user
      @title = params[:format]
      @users = @user.send(@title).paginate page: params[:page]
      render "users/show_follow"
    else
      flash[:danger] = "User not found!!!"
      redirect_to root_url
    end
  end

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      @relation = current_user.active_relationships.find_by
        followed_id: params[:followed_id]
      unless @relation
        flash[:danger] = "Not followed user to unfollow"
        redirect_to root_url
      end
      respond_to do |format|
        format.html {redirect_to @user}
        format.js
      end
    else
      flash[:danger] = "User not found!!"
      redirect_to root_url
    end
  end

  def destroy
    relationship = Relationship.find_by(id: params[:id]).followed
    if relationship
      @relation = current_user.active_relationships.build
      current_user.unfollow relationship
      @user = User.find_by id: relationship.id
      unless @user
        flash[:danger] = "User not found!!"
        redirect_to root_url
      end
      respond_to do |format|
        format.html {redirect_to @user}
        format.js
      end
    else
      flash[:danger] = "Not followed user to unfollow"
      redirect_to root_url
    end
  end
end
