module Prawn
  class Document
    class BoundingBox
      def move_past_bottom
        if @document.page_number == @document.page_count
          if @document.page_number.odd?
            @document.start_new_page(margin: [5.cm,5.cm,2.cm,1.5.cm])
                                              #top,right,bottom,left 
          else
            @document.start_new_page(margin: [5.cm,1.5.cm,2.cm,5.cm])
          end
        else
          @document.go_to_page(@document.page_number + 1)
        end
      end

    end
  end
end
