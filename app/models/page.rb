class Page < ActiveRecord::Base
  validates :title, :presence => true
  has_permalink [:title], :update => true
  scope :find_reference, lambda {|ref| where("reference = ?", ref) }

  def to_param
    permalink
  end

end

