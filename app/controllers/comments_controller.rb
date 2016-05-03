class CommentsController < ApplicationController

	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, only: [:destroy]

	def new
		@comment = Comment.new(parent_id: params[:parent_id])
		@parent = Comment.find(params[:parent_id])
		#@micropost = Micropost.find(params[:micropost_id])
		@entry = Entry.find(params[:entry_id])
		@user = current_user
	end

	def create
			@comment = current_user.comments.build(comment_params)
		if @comment.save
			flash[:success] = 'Comment created!'
			if @parent.nil?
				redirect_to request.referer				
			else
				entry = @parent.entry
				redirect_to entry
			end
		else
			flash[:danger] = 'Something went wrong!'
			redirect_to request.referer
		end

	end

	def destroy
		if @comment.destroy
			flash[:success] = "Comment deleted"
    		redirect_to request.referrer || root_url
		end
	end

	private 
		def comment_params
			params.require(:comment).permit :content, :user_id, :entry_id
		end

		def handle_exception
			flash[:danger] = 'No comment exits!'
			redirect_to request.referer
		end

		def correct_user
			begin
				if current_user.admin?
					@comment = Comment.find(params[:id])
				else
					@comment = current_user.comments.find(params[:id])	
					if @comment.nil?
						handle_exception
					end
				end
			rescue Exception => e
					handle_exception
			end
		end
end