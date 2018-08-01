class ModeStrict

  attr_reader :font, :font_size, :spacing

  def initialize(font, font_size, spacing)
    @font      = font
    @font_size = font_size
    @spacing   = spacing
  end

  def size(_)
    font_size.to_i
  end

  def headings(_)
    {font: font, size: font_size.to_i}
  end

  def alignment(align)
    align = align.downcase.to_sym
    if align == :left
      {align: :justify}
    else
      {align: align}
    end
  end

end
