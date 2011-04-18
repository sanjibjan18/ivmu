module ApplicationHelper
  WillPaginate::ViewHelpers.pagination_options[:renderer] = 'MuviPagination'

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end


  def review_options
    option ||= [ ['Positive','pos'], ['Negative','neg'],['Neutral','neu'],['Ignore','ign']]
  end

  def link_to_add_fields(name, f, association, render_partial)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(render_partial, :ff => builder)
    end
    link_to_function(name, raw("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end


  def find_page(key)
    page =  Page.find_reference(key).first rescue nil
    page.blank? ? "#" : "/#{page.permalink}"
  end

  def ratingbar(rating=0)
    text = ""
    if rating.to_i >= 50
      text += "<div class='positive' style='width:#{rating}%;'>&nbsp;</div>"
    else
      text += "<div class='negative' style='width:#{rating}%;'>&nbsp;</div>"
    end
    text.html_safe
  end

  def thumb_class(rating=0)
    if rating.to_i >= 50
      return image_tag('thumbUp.png', :class => 'thumb', :title => 'Jhakaas', :alt => 'Jhakaas')
    else
      return image_tag('thumbDown.png', :class => 'thumb', :title => 'Bakwaas', :alt => 'Bakwaas')
    end
  end

  def rating_thumb(rating=0)
    if rating.to_f >= 2.5
      return image_tag('thumbUp.png', :class => 'thumb')
    else
      return image_tag('thumbDown.png', :class => 'thumb')
    end
  end

  def meta_keywords_and_title(key, object)
    if key
      title =  Setting.find_by_key("#{key}_page_meta_title").value rescue nil
      keywords =  Setting.find_by_key("#{key}_page_meta_keywords").value rescue nil
      description =  Setting.find_by_key("#{key}_page_meta_description").value rescue nil
    else
      unless object.blank?
        title =  object.meta_detail.meta_title rescue "#{object.name} Review, Trailers "
        keywords =  object.meta_detail.meta_keywords rescue nil
        description = object.meta_detail.meta_description rescue nil
      end
    end
    title ||= 'Hindi movie reviews, trailers and news: Muvi.in'
    keywords ||= "indian movies, hindi movies, bollywood movies, bollywood movie review, hindi movie review, telugu movies, telugu movies, telugu movie review, tamil movies, tamil movie review, hindi movie trailer, telugu movie trailer, tamil movie trailer"
    description ||= "indian movies, hindi movies, bollywood movies, bollywood movie review, hindi movie review, telugu movies, telugu movies, telugu movie review, tamil movies, tamil movie review, hindi movie trailer, telugu movie trailer, tamil movie trailer"

    content = "<title> #{title} </title> \n <meta name='keywords' content='#{keywords.chomp}' /> \n <meta name='description' content='#{description.chomp}' /> "
    content.html_safe
  end


end

