class RcSegmentViewController < UIViewController

  SEGMENTCONTROL_HEIGHT = 40.0
  LABEL_HEIGHT = 20.0
  TOP_MARGIN = 20.0
  LEFT_MARGIN = 20.0
  RIGHT_MARGIN = 20.0
  TWEEN_MARGIN = 6.0

  # reusable method to generate a UILabel to title each segmented control
  def label_with_frame(frame, title:title)
    label = UILabel.alloc.initWithFrame(frame)
    #label.textAlignment = NSTextAlignmentLeft;
    label.text = title
    label.font = UIFont.boldSystemFontOfSize(17.0)
    label.textColor = UIColor.colorWithRed(76.0/255.0, green:86.0/255.0, blue:108.0/255.0, alpha:1.0)
    label.backgroundColor = UIColor.clearColor
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
    label
  end

  # user tapped one of the segmented controls
  def segment_action(sender)
  	#puts "segmentAction: selected segment = #{sender.class.name} #{sender.selectedSegmentIndex}"
  end


  def create_controls

    segment_text_content = ['Check', 'Search', 'Tools']

    # Label
    y_placement = TOP_MARGIN
    frame = CGRectMake(LEFT_MARGIN, y_placement, CGRectGetWidth(self.view.bounds) - (RIGHT_MARGIN * 2.0), LABEL_HEIGHT)
    @scroll_view.addSubview(label_with_frame(frame, title:'UISegmentedControl:'))

    # UISegmentedControl
    segmented_control = UISegmentedControl.alloc.initWithItems([UIImage.imageNamed('/images/segment_check-24.png'),
                        UIImage.imageNamed('/images/segment_search.png'), UIImage.imageNamed('/images/segment_tools.png') ])
    y_placement += TWEEN_MARGIN + LABEL_HEIGHT
    frame = CGRectMake(LEFT_MARGIN, y_placement, CGRectGetWidth(self.view.bounds) - (RIGHT_MARGIN * 2.0),SEGMENTCONTROL_HEIGHT)
    segmented_control.frame = frame
    segmented_control.addTarget(self, action:'segment_action:', forControlEvents:UIControlEventValueChanged)
    segmented_control.segmentedControlStyle = UISegmentedControlStylePlain
    segmented_control.selectedSegmentIndex = 1
    segmented_control.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
    @scroll_view.addSubview(segmented_control)

    # add appropiate accessibility label to each image
    segmented_control.imageForSegmentAtIndex(0).setAccessibilityLabel('CheckMarkIcon')
    segmented_control.imageForSegmentAtIndex(1).setAccessibilityLabel('SearchIcon')
    segmented_control.imageForSegmentAtIndex(2).setAccessibilityLabel('ToolsIcon')

    # Label
    y_placement += (TWEEN_MARGIN * 2.0) + SEGMENTCONTROL_HEIGHT
    frame = CGRectMake(LEFT_MARGIN, y_placement, CGRectGetWidth(self.view.bounds) - (RIGHT_MARGIN * 2.0), LABEL_HEIGHT)
    @scroll_view.addSubview(label_with_frame(frame, title:'UISegmentedControlStyleBordered:'))

    # UISegmentControlStyleBordered
    segmented_control = UISegmentedControl.alloc.initWithItems(segment_text_content)
    y_placement += TWEEN_MARGIN + LABEL_HEIGHT
    frame = CGRectMake(LEFT_MARGIN, y_placement, CGRectGetWidth(self.view.bounds) - (RIGHT_MARGIN * 2.0), SEGMENTCONTROL_HEIGHT)
    segmented_control.frame = frame
    segmented_control.addTarget(self, action:'segment_action:', forControlEvents:UIControlEventValueChanged)
    segmented_control.segmentedControlStyle = UISegmentedControlStyleBordered
    segmented_control.selectedSegmentIndex = 1
    segmented_control.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
    @scroll_view.addSubview(segmented_control)

    # Label
    y_placement += (TWEEN_MARGIN * 2.0) + SEGMENTCONTROL_HEIGHT
    frame = CGRectMake(LEFT_MARGIN, y_placement, CGRectGetWidth(self.view.bounds) - (RIGHT_MARGIN * 2.0), LABEL_HEIGHT)
    @scroll_view.addSubview(label_with_frame(frame, title:'UISegmentedControlStyleBar:'))

    # UISegmentControlStyleBar
    segmented_control = UISegmentedControl.alloc.initWithItems(segment_text_content)
    y_placement += TWEEN_MARGIN + LABEL_HEIGHT
    frame = CGRectMake(LEFT_MARGIN, y_placement, CGRectGetWidth(self.view.bounds) - (RIGHT_MARGIN * 2.0), SEGMENTCONTROL_HEIGHT)
    segmented_control.frame = frame
    segmented_control.addTarget(self, action:'segment_action:', forControlEvents:UIControlEventValueChanged)
    segmented_control.segmentedControlStyle = UISegmentedControlStyleBar
    segmented_control.selectedSegmentIndex = 1
    segmented_control.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
    @scroll_view.addSubview(segmented_control)

    # Label
    y_placement += (TWEEN_MARGIN * 2.0) + SEGMENTCONTROL_HEIGHT
    frame = CGRectMake(LEFT_MARGIN, y_placement, CGRectGetWidth(self.view.bounds) - (RIGHT_MARGIN * 2.0), LABEL_HEIGHT)
    @scroll_view.addSubview(label_with_frame(frame, title:'UISegmentedControlStyleBar: tint'))

    # UISegmentControlStyleBar
    segmented_control = UISegmentedControl.alloc.initWithItems(segment_text_content)
    y_placement += TWEEN_MARGIN + LABEL_HEIGHT
    frame = CGRectMake(LEFT_MARGIN, y_placement, CGRectGetWidth(self.view.bounds) - (RIGHT_MARGIN * 2.0), SEGMENTCONTROL_HEIGHT)
    segmented_control.frame = frame
    segmented_control.addTarget(self, action:'segment_action:', forControlEvents:UIControlEventValueChanged)
    segmented_control.segmentedControlStyle = UISegmentedControlStyleBar
    segmented_control.tintColor = UIColor.colorWithRed(0.70, green:0.171, blue:0.1, alpha:1.0)
    segmented_control.selectedSegmentIndex = 1
    segmented_control.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
    @scroll_view.addSubview(segmented_control)

    # Label
    y_placement += (TWEEN_MARGIN * 2.0) + SEGMENTCONTROL_HEIGHT
    frame = CGRectMake(LEFT_MARGIN, y_placement, CGRectGetWidth(self.view.bounds) - (RIGHT_MARGIN * 2.0), LABEL_HEIGHT)
    @scroll_view.addSubview(label_with_frame(frame, title:'UISegmentedControlStyleBar: image'))

    # UISegmentControlStyleBar
    segmented_control = UISegmentedControl.alloc.initWithItems(segment_text_content)
    y_placement += TWEEN_MARGIN + LABEL_HEIGHT
    frame = CGRectMake(LEFT_MARGIN, y_placement, CGRectGetWidth(self.view.bounds) - (RIGHT_MARGIN * 2.0), SEGMENTCONTROL_HEIGHT)
    segmented_control.frame = frame
    segmented_control.addTarget(self, action:'segment_action:', forControlEvents:UIControlEventValueChanged)
    segmented_control.segmentedControlStyle = UISegmentedControlStyleBar
    segmented_control.selectedSegmentIndex = 1
    segmented_control.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

    segmented_control.setBackgroundImage(UIImage.imageNamed('/images/segmentedBackground.png'), forState:UIControlStateNormal, barMetrics:UIBarMetricsDefault)
    segmented_control.setDividerImage(UIImage.imageNamed('/images/divider.png'), forLeftSegmentState:UIControlStateNormal,
                                      rightSegmentState:UIControlStateNormal, barMetrics:UIBarMetricsDefault)

    textAttributes = {UITextAttributeTextColor => UIColor.blueColor, UITextAttributeFont => UIFont.systemFontOfSize(13.0)}
    segmented_control.setTitleTextAttributes(textAttributes, forState:UIControlStateNormal)
    textAttributes = {UITextAttributeTextColor => UIColor.redColor, UITextAttributeFont => UIFont.systemFontOfSize(13.0)}
    segmented_control.setTitleTextAttributes(textAttributes, forState:UIControlStateNormal)

    @scroll_view.addSubview(segmented_control)

  end


  def viewDidLoad
    super
    self.title = 'SegmentTitle'.localized
    self.view.backgroundColor = UIColor.lightGrayColor

    @scroll_view = UIScrollView.alloc.initWithFrame(self.view.frame)
    self.view.addSubview(@scroll_view)

    # set the content size of our scroll view to match the entire screen,  this will allow the content to scroll in landscape
    @scroll_view.setContentSize(CGSizeMake(CGRectGetWidth(@scroll_view.frame),
                                           CGRectGetHeight(@scroll_view.frame) - CGRectGetHeight(self.navigationController.navigationBar.frame)))
    create_controls
  end

end
