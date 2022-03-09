class Settings::SiteinfosController < ApplicationController
 
  def index
  end

  def edit
  	@siteinfo = SiteInfo.find(params[:id])
  end

  def update
  	@siteinfo = SiteInfo.find(params[:id])
    if @siteinfo.update_attributes(secure_params)
        Rails.configuration.siteinfos = Hash[SiteInfo.all.map { |u| [u.key, u] }]
        flash[:notice] = "Placeholder aggiornata con successo!"
    else
        flash[:alert] = "Errore durante l'aggiornamento del Placeholder"
    end  	
  end

  private
  
  def secure_params
    params.require(:site_info).permit([:title, :description, :key, :value, :icon_class])
  end
end
