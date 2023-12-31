class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  # Role permissions
  before_action :authenticate_user!, except: %i[ index show ]
  before_action only: %i[ new create ] do
    authorize_request(["author", "admin"])
  end
  before_action only: %i[ edit update destroy] do
    authorize_request(["admin"])
  end

  # GET /articles or /articles.json
  def index
    @articles = Article.all.order(created_at: :desc)
  end

  # GET /articles/1 or /articles/1.json
  def show
    @comments = Comment.where(article_id: params[:id]).order(:created_at)
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles/1
  def comment
    @comment = Comment.create(comment_params.merge(user_id: current_user.id, article_id: params[:id]))
    redirect_to article_path
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content, :image, :user_id)
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
