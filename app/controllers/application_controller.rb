class ApplicationController < ActionController::Base
  def set_link
    @link = Link.find ShortCode.decode(params[:id])
  end
end
