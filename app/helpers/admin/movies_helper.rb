module Admin::MoviesHelper


  def celebrity_name(cc)
    return '' if cc.blank?
    Celebrity.find(cc).name rescue ''
  end

end

