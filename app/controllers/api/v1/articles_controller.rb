module Api
  module V1
    class ArticlesController < ApplicationController
      def index
        profile = params[:profile]
        if profile.blank?
          render json: { error: 'Profile parameter is required.' }, status: :bad_request
          return
        end

        articles = MediumFeedParser.fetch_articles(profile)
        render json: articles
      end
    end
  end
end
