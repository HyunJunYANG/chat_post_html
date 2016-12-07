class PostsController < ApplicationController

  before_action :set_bulletin
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  impressionist :actions => [:show]

  def index
    @search=[:params]
    if params[:search]
      @posts = @bulletin.posts.search(params[:search]).paginate(:page => params[:page], :per_page => 3).order("created_at DESC")
    else
      @posts = @bulletin.posts.all.paginate(:page => params[:page], :per_page => 3).order('created_at DESC')
    end
  end

  def show
    impressionist(@post)
  end

  def new
    @post = @bulletin.posts.new
  end

  def edit
  end

  def create
    @post = @bulletin.posts.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to [@post.bulletin, @post], notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to [@post.bulletin, @post], notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to bulletin_posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_bulletin
      @bulletin = Bulletin.find(params[:bulletin_id])
    end

    def set_post
      @post = @bulletin.posts.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, :picture, :picture_cache)
    end
end