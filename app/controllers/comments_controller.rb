class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: :destroy

  def _list
    @comments = @post.comments.paginate(:page => params[:page], :per_page => 3)
  end

  def create
    @comment = @post.comments.new(comment_params)
    @comment.save
  end

  def destroy
    @comment.destroy
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
