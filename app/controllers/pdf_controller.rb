class PdfController < ApplicationController
  
  def create
    filename = PdfCreator.new(all_params).create_pdf
    pdf_uri  = "http://jarvis.snappler.com:3000/pdf_folder/#{filename}"
    render json: {pdf_uri: pdf_uri}
  end
  
end
