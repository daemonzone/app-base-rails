class Account::DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_admin?, :only => [:approve, :reject] 
  before_action :is_partner? 
  before_action :set_document, :only => [:approve, :reject] 
  protect_from_forgery :except => [:upload]

  def index
  	redirect_to account_path if current_user.docsuploaded 

    # Getting the right select items based on what's already been uploaded...
      # current_user = User.find('e38ae7bd-0399-4c4f-a0ce-c0e6b8663f79')
      @uploaded_doc_types = current_user.documents.pluck(:doctype).collect{|c| c.split('_')[0]}.uniq    # => ["cf", "ci"]
      @uploaded_documents = current_user.documents.pluck(:doctype)                                      # => ["cf_fr", "ci_f", "ci_r"]
      @uploaded_documents_sums = {}

      @uploaded_doc_types.each do |doct|
        @uploaded_documents_sums[doct] = DocType.full_types.select{|k| @uploaded_documents.include? k.to_s}
                                                    .select{|k,v| v[2] == doct}
                                                    .select{|k,v| v[3] <= 2}.inject(0){ |sum, k| sum + k[1][3] }      
      end

      @select_doc_types = DocType.full_types.select{|k| !@uploaded_documents.include? k.to_s}
      @select_doc_types = @select_doc_types.select{|k,v| v[3] <= (2 - @uploaded_documents_sums[k.to_s.split('_')[0]].to_i)}
    # Wow...

  end

  def showmodal
  	@user = User.find(params[:id])
  	respond_to do |format|
    	format.html { render 'account/documents/modal', :layout => false }  		
  		format.json { render :json => @user.documents }
  	end
  end

  def confirm
  	current_user.docsuploaded = true
  	current_user.save

	  # Send Notification to Admin
	  message = current_user.fullname + " ha inviato i documenti relativi alla sua azienda"
    admins.each do |admin|
      @notification = Notification.create(:source => 'user', :user_id => admin.id, :notification_type => 'info', :message => message, :notification_url => edit_account_user_url(current_user) )
    end
    AdminNotificationMailer.with(notification: @notification, user: current_user).documents_submitted.deliver_later

  	flash[:notice] = "La documentazione è stata inviata correttamente. Riceverai un riscontro il più presto possibile."
  	redirect_to account_path
  end

  def upload
    @document = current_user.documents.build(:doctype => params[:doc_type], :name => params[:doc_name])
    @document.save
    @document.attachment.attach(params[:file])

    render json: {success: true}
  end

  def remove
    @document = Document.find(params[:document_id])
    @document.destroy
    # @document = ActiveStorage::Attachment.find(params[:document_id])
    # @document.purge
    redirect_to account_documents_path
  end

  def approve
    @document.update!(:status => Document.statuses[:approvato], :comments => nil)
    render 'account/documents/approve'
  end
  
  def reject
    @document.update!(:status => Document.statuses[:non_conforme], :comments => params[:notes])
    render 'account/documents/reject'    
  end


  private 

  def set_document
    @document = Document.find(params[:id])
  end
end