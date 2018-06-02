class MicropostsController < ApplicationController
  before_action :set_micropost, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorized_user, only: [:edit, :update, :destroy]

  def index
    if current_user.present?
      following_ids_subselect = "SELECT followed_id FROM relationships WHERE  follower_id = #{current_user.id}"
      @microposts = Micropost.where("user_id IN (#{following_ids_subselect}) AND created_at >= :time_range", time_range: 24.hours.ago).order("buzz_count DESC")
    else
      @microposts = Micropost.where('created_at >= ?', 24.hours.ago).order("buzz_count DESC")
    end
  end

  def show
  end

  def new
    @micropost = current_user.microposts.build
  end

  def edit
  end

  def create
    @micropost = current_user.microposts.build(micropost_params.merge("buzz_count": buzzword_count))

    respond_to do |format|
      if @micropost.save
        format.html { redirect_to @micropost, notice: 'Micropost was successfully created.' }
        format.json { render :show, status: :created, location: @micropost }
      else
        format.html { render :new }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @micropost.update(micropost_params.merge("buzz_count": buzzword_count))
        format.html { redirect_to @micropost, notice: 'Micropost was successfully updated.' }
        format.json { render :show, status: :ok, location: @micropost }
      else
        format.html { render :edit }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @micropost.destroy
    respond_to do |format|
      format.html { redirect_to microposts_url, notice: 'Micropost was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_micropost
      @micropost = Micropost.find(params[:id])
    end

    def authorized_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to microposts_path, notice: "Not authorized to edit this micropost" if @micropost.nil?
    end

    def micropost_params
      params.require(:micropost).permit(:content, :buzzword_count)
    end

    def buzzword_count
      count = 0
      Buzzword.all.each do |a|
        if micropost_params["content"].downcase.include? a.name
          count += 1
        end
      end
      count
    end
end
