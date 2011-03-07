module ApplicationHelper

  def ratingbar(rating)
    text = ""
    if rating.to_i >= 50
      text += "<div class='positive' style='width:#{rating}%;'> &nbsp;</div>"
    else
      text += "<div class='negative' style='width:#{rating}%;'> &nbsp; </div>"
    end
    text.html_safe
  end

end

