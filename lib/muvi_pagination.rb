class MuviPagination < ::WillPaginate::ViewHelpers::LinkRenderer

   def pagination
      [ :newer, :window, :older]
    end

  protected

    def newer
      previous_or_next_page(@collection.previous_page, "<img src='/images/paginationLeft.jpg'> " , 'next left')
    end

    def older
      previous_or_next_page(@collection.next_page, "<img src='/images/paginationRight.jpg'>", 'prev left')
    end

     def window
      base = @collection.offset
      high = base + @collection.per_page
      high = @collection.total_entries if high > @collection.total_entries

      # TODO: What's the best way to allow customization of this text, particularly "of"?
      entry_name =  @options[:entry_name].to_s
      entry_name = @collection.first.class.name.underscore.sub('_', ' ') if entry_name.blank?
      tag(:div, " #{base + 1} to #{high} of #{@collection.total_entries} #{entry_name.pluralize.capitalize} ",
          :class => 'pagination_detail left')
    end

end

