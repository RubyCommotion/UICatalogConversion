class RcImagesViewController < UIViewController
  
  def viewDidLoad
    super
    
    self.title = "ImagesTitle"._
    self.view.backgroundColor = UIColor.blackColor
    
    @imageView = UIImageView.alloc.initWithFrame [[42, 20], [236, 174]]
    @imageView.contentMode = UIViewContentModeScaleAspectFit
    @imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin
    self.view.addSubview @imageView
    
    @slider = UISlider.alloc.init
    frame = @slider.frame
    frame.size.width = 284
    frame.origin.x = (CGRectGetWidth(self.view.frame) - frame.size.width) / 2
    frame.origin.y = CGRectGetHeight(self.view.frame) - frame.size.height - 40
    @slider.frame = frame
    @slider.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin
    @slider.minimumValue = 0.0
    @slider.maximumValue = 10.0
    @slider.value = 5.0
    self.view.addSubview @slider
    
    label = UILabel.alloc.initWithFrame [[0, 0], [65, 21]]
    frame = label.frame
    frame.origin.x = (CGRectGetWidth(self.view.frame) - frame.size.width) / 2
    frame.origin.y = CGRectGetHeight(self.view.frame) - frame.size.height - 20
    label.frame = frame
    label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin
    label.text = "Duration"._
    label.textColor = UIColor.whiteColor
    label.font = UIFont.systemFontOfSize(14.0)
    self.view.addSubview label
    
    # set up our UIImage with a group or array of images to animate (or in our case a slideshow)
    @imageView.animationImages = [
      UIImage.imageNamed("/images/scene1.jpg"),
      UIImage.imageNamed("/images/scene2.jpg"),
      UIImage.imageNamed("/images/scene3.jpg"),
      UIImage.imageNamed("/images/scene4.jpg"),
      UIImage.imageNamed("/images/scene5.jpg")
    ]
    @imageView.animationDuration = 5.0
    @imageView.stopAnimating
    
    # set actions
    @slider.addTarget(self, action: 'sliderAction:', forControlEvents: UIControlEventValueChanged)
    
    # Set the appropriate accessibility labels.
    @imageView.setIsAccessibilityElement true
    @imageView.setAccessibilityLabel self.title
    @slider.setAccessibilityLabel "DurationSlider"._
  end
  
  # slown down or speed up the slide show as the slider is moved
  def sliderAction(sender)
    durationSlider = sender
    @imageView.animationDuration = durationSlider.value
    
    @imageView.startAnimating unless @imageView.isAnimating
  end
  
  #pragma mark - UIViewController delegate methods
  
  # called after this controller's view was dismissed, covered or otherwise hidden
  def viewWillDisappear(animated)
    super
    
    @imageView.stopAnimating
  end
 
  # called after this controller's view will appear
  def viewWillAppear(animated)
    super
    
    @imageView.startAnimating
    
    # for aesthetic reasons (the background is black), make the nav bar black for this particular page
    self.navigationController.navigationBar.tintColor = UIColor.blackColor
  end
 
end