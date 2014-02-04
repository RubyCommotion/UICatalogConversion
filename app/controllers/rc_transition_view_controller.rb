class RcTransitionViewController < UIViewController
  IMAGE_HEIGHT        = 200.0
  IMAGE_WIDTH         = 250.0
  TRANSITION_DURATION = 0.75
  TOP_PLACEMENT       = 70.0 # 70.0 instead of 10.0 to work nice on iOS7

  def viewDidLoad
    super

    self.title = 'TransitionsTitle'.localized
    self.view.backgroundColor = UIColor.blackColor

    # create two toolbar buttons and center them with flexible space on both sides
    toolbar_buttons = [
      UIBarButtonItem.alloc.initWithBarButtonSystemItem( UIBarButtonSystemItemFlexibleSpace, target: nil, action: nil ),
      UIBarButtonItem.alloc.initWithTitle( 'FlipTitle'.localized, style: UIBarButtonItemStylePlain, target: self, action: 'flip_action:' ),
      UIBarButtonItem.alloc.initWithTitle( 'CurlTitle'.localized, style: UIBarButtonItemStylePlain, target: self, action: 'curl_action:' ),
      UIBarButtonItem.alloc.initWithBarButtonSystemItem( UIBarButtonSystemItemFlexibleSpace, target: nil, action: nil ),
    ]
    self.setToolbarItems( toolbar_buttons )

    # content frames
    container_frame = CGRectIntegral( [ [ ( CGRectGetWidth( self.view.bounds ) - IMAGE_WIDTH ) / 2.0, TOP_PLACEMENT], [ IMAGE_WIDTH, IMAGE_HEIGHT ] ] )
    # main_view and flip_to_view will use the same frame
    image_frame = [ [ 0.0, 0.0 ], [ IMAGE_WIDTH, IMAGE_HEIGHT ] ]

    # backdrop
    @container_view = UIView.alloc.initWithFrame( container_frame )
    @container_view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
    @container_view.setIsAccessibilityElement( true )
    @container_view.setAccessibilityLabel( 'ImagesTitle'.localized )

    # image 1
    @main_view = UIImageView.alloc.initWithFrame( image_frame )
    @main_view.image = UIImage.imageNamed( '/images/scene1.jpg' )

    # image 2
    @flip_to_view = UIImageView.alloc.initWithFrame( image_frame )
    @flip_to_view.image = UIImage.imageNamed( '/images/scene2.jpg' )

    # assemble
    @container_view.addSubview( @main_view )
    self.view.addSubview( @container_view )
  end

  # called after this controller's view will appear
  def viewWillAppear( animated )
    super

    # for asthetic reasons (the background is black), make the nav bar black for this particular page
    self.navigationController.navigationBar.tintColor = UIColor.blackColor
    self.navigationController.toolbar.tintColor = UIColor.blackColor

    # show the toolbar, we're going to need it
    self.navigationController.setToolbarHidden( false )
  end

  # called after this controller's view was dismissed, covered or otherwise hidden
  def viewWillDisappear( animated )
    super

    self.navigationController.setToolbarHidden( true )
  end

  #pragma mark - UIBarButtonItem actions

  # flip one image revealing the other
  def flip_action( sender )
    # decide which view to show (the one without a superview) and setup the animation
    if @flip_to_view.superview.nil?
      from_view = @main_view
      to_view = @flip_to_view
      transition = UIViewAnimationOptionTransitionFlipFromLeft
    else
      from_view = @flip_to_view
      to_view = @main_view
      transition = UIViewAnimationOptionTransitionFlipFromRight
    end

    # the XCode sample uses old-style animations - this is ruby so we use the
    # recommended new style / shorthand call to do just the same :)
    UIView.transitionFromView( from_view, toView: to_view, duration: TRANSITION_DURATION, options: transition, completion: nil )
  end

  # curl one image up / down revealing the other
  def curl_action( sender )
    # decide which view to show (the one without a superview) and setup the animation
    if @flip_to_view.superview.nil?
      from_view = @main_view
      to_view = @flip_to_view
      transition = UIViewAnimationOptionTransitionCurlUp
    else
      from_view = @flip_to_view
      to_view = @main_view
      transition = UIViewAnimationOptionTransitionCurlDown
    end

    # the XCode sample uses old-style animations - this is ruby so we use the
    # recommended new style / shorthand call to do just the same :)
    UIView.transitionFromView( from_view, toView: to_view, duration: TRANSITION_DURATION, options: transition, completion: nil )
  end
end
