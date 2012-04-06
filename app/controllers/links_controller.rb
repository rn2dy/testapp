require 'json'
class LinksController < ApplicationController
  before_filter :authenticate_user!

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

  def link_surf 
    link = Link.find(params[:link_id]) 
    all_links = link.topic.links
    @all_links = all_links.map { |link| { link.title => link.url } }.to_json
    @current_link = link.url
    @current_link_idx = all_links.index(link) 
  end

end
