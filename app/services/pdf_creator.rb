class PdfCreator

  require "prawn/measurement_extensions"
  
  attr_reader :json, :pdf, :filename, :full_path, :mode, :font, :font_size, :spacing

  SPACING = {'1' => 1, '2' => 7, '3' => 14}

  def initialize(post_params)
    
    @filename  = "#{SecureRandom.uuid}.pdf"
    @full_path = File.join(Rails.root, "public/pdf_folder", filename)
    @json      = JSON.parse(post_params[:pdf_json], symbolize_names: true)
    @mode      = post_params[:mode]
    @font      = post_params[:font]
    @font_size = post_params[:font_size]
    @spacing   = SPACING[post_params[:spacing]]
    @pdf       = Prawn::Document.new(page_size: post_params[:paper_size],
                                     font:      post_params[:font],
                                     margin:    [5.cm,1.5.cm,2.cm,5.cm])
                                                #top,right,bottom,left 
  end

  def create_pdf
    pdf.default_leading spacing

    pdf.font_families.update("arial" => {
      normal:      Rails.root.join('app', 'assets', 'fonts', 'arial.ttf'),
      italic:      Rails.root.join('app', 'assets', 'fonts', 'ariali.ttf'),
      bold:        Rails.root.join('app', 'assets', 'fonts', 'arialbd.ttf'),
      bold_italic: Rails.root.join('app', 'assets', 'fonts', 'arialbi.ttf')
    })

    pdf.font_families.update("trebuchet" => {
      normal:      Rails.root.join('app', 'assets', 'fonts', 'trebuc.ttf'),
      italic:      Rails.root.join('app', 'assets', 'fonts', 'trebucit.ttf'),
      bold:        Rails.root.join('app', 'assets', 'fonts', 'trebucbd.ttf'),
      bold_italic: Rails.root.join('app', 'assets', 'fonts', 'trebucbi.ttf')
    })

    RenderService.new(json, pdf, mode, font, font_size, spacing).render_elements
    pdf.render_file(full_path)
    filename, full_path
  end

end
