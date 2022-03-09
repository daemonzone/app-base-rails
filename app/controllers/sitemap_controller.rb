class SitemapController < ActionController::Base

  def index
    @root_url = [root_url]

    @categories = Category.where(:active => true).order(:title)

	@users = User.where(:usertype => User.usertypes[:partner])
				 .where("subscription_data is not null")
			     .where("CAST(subscription_data AS VARCHAR) like '%premium%'")                    
			     .where('public_url is not null')
				 .order(ragionesociale: :asc)
				 .page(params[:page]).per(10)

    respond_to do |format|
      format.xml
    end
  end

end
