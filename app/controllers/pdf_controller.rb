class PdfController < ApplicationController
  
  def create
    filename = PdfCreator.new(all_params).create_pdf
    
    if create_png(filename)
      pdf_uri  = "http://jarvis.snappler.com:3000/pdf_folder/#{filename}.png"
    else
      pdf_uri = 'fallo conversion png'
    end
    render json: {pdf_uri: pdf_uri}
  end
  
  private
  
  def create_png(filename)
    full_path_pdf = File.join(Rails.root, "public/pdf_folder", "#{filename}.pdf")
    full_path_png = File.join(Rails.root, "public/pdf_folder", "#{filename}.png")
    pdf   = Grim.reap(full_path_pdf) 
    pdf[1].save(full_path_png)
  end
  
end
