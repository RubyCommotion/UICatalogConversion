class RcCustomView < UIView
  
  VIEW_WIDTH = 200
  VIEW_HEIGHT = 44
  LABEL_HEIGHT = 20
  MARGIN_SIZE = 10
  
  def self.view_width
    return VIEW_WIDTH
  end
  
  def self.view_height 
    return VIEW_HEIGHT
  end
  
  def initWithTitle(title, image: image)
    initWithFrame([[0.0, 0.0], [VIEW_WIDTH, VIEW_HEIGHT]])
    yCoord = (self.bounds.size.height - LABEL_HEIGHT) / 2
    
    @titleLabel = UILabel.alloc.initWithFrame([[MARGIN_SIZE + image.size.width + MARGIN_SIZE, yCoord], [CGRectGetWidth(self.frame) - MARGIN_SIZE + image.size.width + MARGIN_SIZE, LABEL_HEIGHT]])
    @titleLabel.text = title
    @titleLabel.backgroundColor = UIColor.clearColor
    self.addSubview @titleLabel
    
    yCoord = (self.bounds.size.height - image.size.height) / 2
    imageView = UIImageView.alloc.initWithFrame([[MARGIN_SIZE, yCoord], [image.size.width, image.size.height]])
    imageView.image = image
    self.addSubview imageView
    self
  end
  
  # Enable accessibility for this view.
  def isAccessibilityElement
    return true
  end
  
  # Return a string that describes this view.
  def accessibilityLabel
    return @titleLabel.text
  end
  
end