class LinksController < ApplicationController

  def destroy 
    link = Link.find(params[:id])
    link.delete
    @link_id = params[:id]
    respond_to do |format|
      format.html { redirect_to @topic, notice: 'Links deleted!' }
      format.js
    end
  end

  def add_notes
    @link = Link.find(params[:id])
    respond_to do |format|
      if @link.update_attributes(notes: params[:notes])
        format.html {redirect_to @link, notice: 'Notes added!' }
        format.js
      end
     end   
  end

end
