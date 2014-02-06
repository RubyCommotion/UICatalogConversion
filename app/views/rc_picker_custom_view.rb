class RcCustomView < UIView
  
  VIEW_WIDTH = 200
  VIEW_HEIGHT = 44
  LABEL_HEIGHT = 20
  MARGIN_SIZE = 10
  
  def self.view_width
    VIEW_WIDTH
  end
  
  def self.view_height 
    VIEW_HEIGHT
  end
  
  def initWithTitle(title, image: image)
    initWithFrame([[0.0, 0.0], [VIEW_WIDTH, VIEW_HEIGHT]])
    y_coord = (self.bounds.size.height - LABEL_HEIGHT) / 2
    
    @title_label = UILabel.alloc.initWithFrame([[MARGIN_SIZE + image.size.width + MARGIN_SIZE, y_coord], [CGRectGetWidth(self.frame) - MARGIN_SIZE + image.size.width + MARGIN_SIZE, LABEL_HEIGHT]])
    @title_label.text = title
    @title_label.backgroundColor = UIColor.clearColor
    self.addSubview @title_label
    
    y_coord = (self.bounds.size.height - image.size.height) / 2
    image_view = UIImageView.alloc.initWithFrame([[MARGIN_SIZE, y_coord], [image.size.width, image.size.height]])
    image_view.image = image
    self.addSubview image_view
    self
  end
  
  # Enable accessibility for this view.
  def isAccessibilityElement
    true
  end
  
  # Return a string that describes this view.
  def accessibilityLabel
    @title_label.text
  end
  
end