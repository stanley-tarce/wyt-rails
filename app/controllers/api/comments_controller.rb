module Api
    class CommentsController < ApplicationController
        def index
            render json: comments, status: :ok
        rescue ActiveRecord::RecordNotFound
            render json: { message: 'Failed to get comments' }, status: 404
        end

        def show
            render json: comment, status: :ok
        end

        def create
            params.inspect
            comment = Comment.new(name: comment_params[:name], description: comment_params[:description], trade: Trade.find(params[:trade_id]))
            if comment.save
                render json: comment, status: :created
            else
                render json: { errors: comment.errors.full_messages }, status: 422
            end
        end

        def update
            if comment.update(comment_params)
                render json: comment, status: :ok
            else
                render json: { errors: comment.errors.full_messages }, status: 422
            end
        end

        def delete 
            if comment.destroy
                render json: { message: 'Comment Deleted' }, status: :ok
            end
        end
        private
        def comment_params
            params.require(:comment).permit(:name, :description)
        end
        def comments
            Trade.find(params[:trade_id]).comments
        end
        def comment
            Trade.find(params[:trade_id]).comments.find(params[:id])
        end
    end
end
