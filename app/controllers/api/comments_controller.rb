module Api
    class CommentsController < ApplicationController
        def index
            render json: comments, status: :ok
        end

        def show
            render json: comment, status: :ok
        end

        def create
            params.inspect
            comment = Comment.create(name: comment_params[:name], description: comment_params[:description], trade: Trade.find(params[:trade_id]))
            if comment
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
