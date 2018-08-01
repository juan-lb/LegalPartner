class RenderService

  attr_reader :json, :pdf, :mode

  #Element Types
  PARAGRAPH = 'PARAGRAPH'.freeze
  LISTITEM = 'LISTITEM'.freeze

  def initialize(json, pdf, mode, font, font_size, spacing)
    @json = json
    @pdf  = pdf
    @mode = ModeManager.new(mode, font, font_size, spacing)
  end

  def render_elements
    json.each do |element|
      if element[:type] == PARAGRAPH
        pdf.formatted_text [render_paragraph(element)].flatten, mode.alignment(element[:alignment])
      elsif element[:type] == LISTITEM
        pdf.formatted_text [render_listitem(element)].flatten
      end
    end
  end

  private
  
  def render_listitem(element)
    res = render_text(element[:childs].first, element[:heading])
    indent = ("\xC2\xA0"*6) * (element[:nesting_level].to_i + 1)
    res.unshift({text: "#{indent}•  "})
  end

  def text_heading(text_hash, heading)
    text_hash.merge(mode.headings(heading.split.join.to_sym))
  end

  def add_attributes(text_hash, attributes)
    styles = attributes.map do |attr|
       attr.first.downcase.to_sym if ['BOLD', 'ITALIC', 'UNDERLINE'].include? attr.first
    end.compact

    attributes.each do |attr|      
      text_hash[:size] = mode.size(attr.last) if attr.first == "FONT_SIZE"
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
