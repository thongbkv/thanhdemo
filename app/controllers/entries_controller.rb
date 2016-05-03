class EntriesController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, only: :destroy

	def create
		@entry = current_user.entries.build(entry_params)
		if @entry.save
			flash[:success] = "Entry created"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def show
		#debugger
		#ahihi.ahihi
		@comment = Comment.new
		@entry = Entry.find(params[:id])
		#@comments = @micropost.comments.paginate(page: params[:page])
		@comments = Comment.where("entry_id = ?", params[:id]).paginate(page: params[:page])
		@user = current_user
		if @entry.nil?
			flash[:danger] = 'Entry not found!'
			redirect_to request.referrer
		end
	end

	def index
		@entry = Entry.paginate(page: params[:page])
	end
	
	def destroy
		if @entry.destroy
			flash[:success] = "Entry deleted"
			edirect_to request.referrer || root_url
		end
	end

	private

		def entry_params
			params.require(:entry).permit(:title, :body)
		end

		def correct_user
			@entry = current_user.entries.find_by(id: params[:id])
			redirect_to root_url if @entry.nil?
		end
end
