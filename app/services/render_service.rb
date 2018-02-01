class RenderService

  attr_reader :json, :pdf

  #Element Types
  PARAGRAPH = 'PARAGRAPH'.freeze

  #Headings
  HEADINGS = {
    Title:    {size: 26},
    Subtitle: {size: 15},
    Heading1: {size: 20},
    Heading2: {size: 16},
    Heading3: {size: 14},
    Heading4: {size: 12},
    Heading5: {size: 11},
    Heading6: {size: 11, styles: [:italic]},
    Normal:   {size: 12, font: 'Times-Roman'}
  }

  def initialize(json, pdf)
    @json = json
    @pdf  = pdf
  end

  def render_elements
    json.each do |element|
      if element[:type] == PARAGRAPH
        pdf.formatted_text [render_paragraph(element)].flatten
      end
    end
  end

  private

  def text_heading(text_hash, heading)
    text_hash.merge(HEADINGS[heading.split.join.to_sym])
  end

  def add_attributes(text_hash, attributes)
    styles = attributes.map do |attr|
       attr.first.downcase.to_sym if ['BOLD', 'ITALIC', 'UNDERLINE'].include? attr.first
    end.compact

    attributes.each do |attr|      
      text_hash[:size] = attr.last if attr.first == "FONT_SIZE"
    end
    text_hash[:styles] = styles unless styles.empty?
    text_hash
  end

  def render_text(element, heading)
    res = []
    element[:inner_styles].each_with_index do |style, i|
      from = style[:pos]
      if element[:inner_styles][i + 1].nil?
        to = element[:text].size
      else
        to = element[:inner_styles][i + 1][:pos] - 1
      end

      # text_hash = {text: "|#{element[:text][from..to]}|"}
      text_hash = {text: element[:text][from..to]}
      text_hash = text_heading(text_hash, heading)
      res << add_attributes(text_hash, style[:attributes])
    end
    res
  end

  def render_paragraph(element)
    if element[:cant_childs].zero?
      {text: "\n"}
    else
      render_text(element[:childs].first, element[:heading])
    end
  end

end
