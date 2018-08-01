class ModeManager

  attr_reader :mode

  def initialize(mode, font, font_size, spacing)
    if mode == 'strict'
      @mode = ModeStrict.new(font, font_size, spacing)
    elsif mode == 'free'
      @mode = ModeFree.new # Aca podrian ir todos los estilos del documento
    end
  end

  def size(size)
    mode.size(size)
  end

  def headings(heading)
    mode.headings(heading)
  end

  def alignment(align)
    mode.alignment(align)
  end

end
