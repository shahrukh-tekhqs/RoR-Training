class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]
  before_action :require_user, except: %i[index show]
  before_action :require_same_user, only: %i[edit update destroy]

  def index
    # @articles = Article.all
    @articles = Article.paginate(page: params[:page], per_page: 2)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:notice] = 'Article was created successfully.'
      # redirect_to article_path(@article)
      redirect_to @article
    else
      render 'new'
    end
  end

  def show; end

  def edit; end

  def update
    if @article.update(article_params)
      flash[:notice] = 'Article was updated successfully.'
      # redirect_to article_path(@article)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      # format.html { redirect_to users_url }
      format.js {render :layout => false }
    end
    # redirect_to articles_path if @article.destroy
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description)
  end

  def require_same_user
    if current_user != @article.user && !current_user.admin?
      flash[:alert] = 'You can only edit/delete your own articles'
      redirect_to @article
    end
  end
end
