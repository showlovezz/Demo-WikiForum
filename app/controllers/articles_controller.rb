class ArticlesController < ApplicationController
	
	before_action :find_article, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, except: [:index, :show]

	def index
		if params[:category].blank?
			@articles = Article.order("created_at DESC")
		else
			@category_id = Category.find_by(name: params[:category]).id
			@articles = Article.where(category_id: @category_id).order("created_at DESC")
		end
	end

	def new
		@article = current_user.articles.build
	end

	def create
		@article = current_user.articles.build(article_params)
		if @article.save
			redirect_to articles_path, notice: "文章建立成功"
		else
			render "new", alert: "文章建立失敗，為什麼呢?"
		end
	end

	def show
	end

	def edit
	end

	def update
		if @article.update(article_params)
			redirect_to articles_path, notice: "文章修改成功"
		else
			render "edit", alert: "又少了什麼嗎?"
		end
	end

	def destroy
		@article.destroy
		redirect_to articles_path, alert: "文章已被刪除"
	end

	private

	def article_params
		params.require(:article).permit(:title, :content, :category_id)
	end

	def find_article
		@article = Article.find(params[:id])
	end
end
