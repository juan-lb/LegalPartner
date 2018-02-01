class PdfController < ApplicationController

  def create
    pdf = PdfCreator.new(all_params).create_pdf
    send_data(pdf, filename: 'escrito.pdf', type: 'application/pdf')
  end

end
