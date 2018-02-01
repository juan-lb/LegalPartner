class PdfCreator

  require "prawn/measurement_extensions"
  
  attr_reader :json, :pdf

  def initialize(post_params)
    @json = JSON.parse(post_params[:pdf_json])
    @pdf = Prawn::Document.new(page_size: 'LEGAL', margin: [5.cm,2.cm,1.5.cm,5.cm], font: 'Times-Roman')
                                                            #top,right,bottom,left 
  end

  def create_pdf
    pdf.default_leading 10
    RenderService.new(json, pdf).render_elements
    pdf.render
  end

end
