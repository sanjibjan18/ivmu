module ApplicationHelper
  WillPaginate::ViewHelpers.pagination_options[:renderer] = 'MuviPagination'

  def ratingbar(rating)
    text = ""
    if rating.to_i >= 50
      text += "<div class='positive' style='width:#{rating}%;'>&nbsp;</div>"
    else
      text += "<div class='negative' style='width:#{rating}%;'>&nbsp;</div>"
    end
    text.html_safe
  end

  def thumb_class(rating)
    if rating.to_i >= 50
      return image_tag('thumbUp.png', :class => 'thumb', :title => 'Jhakaas')
    else
      return image_tag('thumbDown.png', :class => 'thumb', :title => 'Bakwaas')
    end
  end

  def meta_keywords_and_title(key, object)
    if key
      title =  Setting.find_by_key("#{key}_page_meta_title").value rescue nil
      keywords =  Setting.find_by_key("#{key}_page_meta_keywords").value rescue nil
      description =  Setting.find_by_key("#{key}_page_meta_description").value rescue nil
    else
      unless object.blank?
        title =  object.meta_detail.meta_title rescue nil
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

