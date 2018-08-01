class PdfController < ApplicationController
  
  def create
    filename, full_path = PdfCreator.new(all_params).create_pdf
    
    pdf   = Grim.reap(full_path) 
    png   = pdf[1].save(full_path + '.png')

    pdf_uri  = "http://jarvis.snappler.com:3000/pdf_folder/#{filename}.png"
    render json: {pdf_uri: pdf_uri}
  end
  
end
