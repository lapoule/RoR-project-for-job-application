class ArticlesController < ApplicationController

	http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]

	def index
		@articles = Article.all
	end

	def show
		@article = Article.find(params[:id])
	end

	def new
		@article = Article.new
	end

	def edit
		@article = Article.find(params[:id])
	end

	def create
		@article = Article.new(article_params)
		if @article.save
			redirect_to @article
		else
			render 'new' #Display the page again if data are invalid
		end
	end

	def update
		@article = Article.find(params[:id])
		if @article.update(article_params)
			redirect_to @article
		else
			render 'edit'
		end
	end

	def destroy
	#No need to add a view for this action
		@article = Article.find(params[:id])
		@article.destroy
		redirect_to articles_path
	end

	#All private methods are at then end of class definition
	private
	def article_params
		params.require(:article).permit(:title, :text)
	end
end
