class RcToolbarViewController < UIViewController

  # TODO Seems to be extraneous code left in the Obj-C source code
  def picker_frame_with_size(size)
    screen_rect = mainScreen.applicationFrame
    picker_rect = CGRectMake(0.0,CGRectGetHeight(screen_rect) - 84.0 - size.height, size.width, size.height)
    picker_rect
  end

  def action(sender=nil)
    #puts "sender: #{sender.inspect}"
    #puts 'UIBarButtonItem clicked'
  end

  def create_toolbar_items

    # match each of the toolbar item's style match the selection in the "UIBarButtonItemStyle" segmented control
   	style = @bar_style_segmented_control_bar.selectedSegmentIndex


    # create the system-defined "OK or Done" button

    system_item = UIBarButtonItem.alloc.initWithBarButtonSystemItem(@current_system_item,
                                                                      target:self,
                                                                      action: action)
    system_item.style = style

   	# flex item used to separate the left groups items and right grouped items
   	flex_item = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace,
   																			                         target:nil,
   																			                         action:nil)

   	# create a special tab bar item with a custom image and title
   	info_item = UIBarButtonItem.alloc.initWithImage(UIImage.imageNamed('/images/segment_tools'),
   																                 style: style,
   																                 target:self,
   																                 action: action)

   	# Set the accessibility label for an image bar item.
   	info_item.setAccessibilityLabel('ToolsIcon'.localized)

    # create a custom button with a background image with black text for its title:
    custom_item1 = UIBarButtonItem.alloc.initWithTitle('Item1',
                                                      style: UIBarButtonItemStyleBordered,
                                                      target: self,
                                                      action: action)

    base_image = UIImage.imageNamed('/images/whiteButton')
    # deprecated iOS 5
    background_image = base_image.stretchableImageWithLeftCapWidth(12.0, topCapHeight: 0.0)
    #background_image = base_image.resizableImageWithCapInsets(UIEdgeInsetsMake(0.0, 12.0, 0.0, 12.0))
    custom_item1.setBackgroundImage(background_image,
                                   forState: UIControlStateNormal,
                                   barMetrics: UIBarMetricsDefault)

    # NSDictionary conversion
    text_attributes = { NSForegroundColorAttributeName => UIColor.blackColor }

    custom_item1.setTitleTextAttributes(text_attributes,
                                       forState: UIControlStateNormal)

    # create a bordered style button with custom title
   	custom_item2 = UIBarButtonItem.alloc.initWithTitle( 'Item2',
   																	                   # note you can use "UIBarButtonItemStyleDone" to make it blue
   																	                   style: style,
   																                     target: self,
   																                     action: action)

   	# apply the bar button items to the toolbar
    @toolbar.setItems([system_item, flex_item, custom_item1, custom_item2, info_item],
                          animated: false)
  end


  def adjust_toolbar_size
    # size up the toolbar and set its frame
    @toolbar.sizeToFit

    # since the toolbar may have adjusted its height, it's origin will have to be adjusted too
    main_view_bounds = self.view.bounds
    @toolbar.setFrame(
      CGRectMake(
        CGRectGetMinX(main_view_bounds),
        CGRectGetMinY(main_view_bounds) + CGRectGetHeight(main_view_bounds) - CGRectGetHeight(@toolbar.frame),
        CGRectGetWidth(main_view_bounds),
        CGRectGetHeight(@toolbar.frame)
        )
      )
  end


  def viewDidLoad
    super
    # programmatic creation of Obj-C IB views


    # this list appears in the UIPickerView to pick the system's UIBarButtonItem
    @picker_view_array = %W(Done Cancel Edit Save Add FlexibleSpace FixedSpace Compose Reply Action
                                Organize Bookmarks Search Refresh Stop Camera Trash Play Pause Rewind
                                FastForward Undo Redo PageCurl
                                )

    self.title = 'ToolbarTitle'.localized

    self.view.addSubview(bottom_toolbar)
    self.view.addSubview(scroll_view)
    @scroll_view.addSubview(container_view)
    @scroll_view.addSubview(bar_btn_sys_item_lbl)
    @scroll_view.addSubview(picker)
    @container_view.addSubview(bar_style_lbl)
    @container_view.addSubview(bar_style_segmented_control_bar)
    @container_view.addSubview(image_switch_control_label)
    @container_view.addSubview(image_switch_control)
    @container_view.addSubview(tint_switch_control_label)
    @container_view.addSubview(tint_switch_control)
    @container_view.addSubview(bar_btn_item_style_lbl)
    @container_view.addSubview(button_style_segmented_control_bar)

    # when Obj-C declares current_system_item as a property it is assigned integer 0
    # in our case we have to move the @current_system_item assignment to be before the call create_too_bar_items
    @current_system_item = UIBarButtonSystemItemDone

    create_toolbar_items

    # set the accessibility label for the tint and image switches so that its context can be determined
    @tint_switch_control_label.setAccessibilityLabel('TintSwitch'.localized)
    @image_switch_control_label.setAccessibilityLabel('ImageSwitch'.localized)
  end

  def viewWillAppear(animated)
    super

    self.adjust_toolbar_size
    # adjust the scroll view's height since the toolbar may have been resized
    adjusted_height = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(@toolbar.frame)
    new_frame = @scroll_view.frame
    new_frame.size.height = adjusted_height
    @scroll_view.frame = new_frame

    # finally set the content size so that it scrolls in landscape but not in portrait
    @scroll_view.setContentSize(CGSizeMake(CGRectGetWidth(@scroll_view.frame), @saved_content_height_size))
  end

  def toggle_button_style(sender)  #IBAction
    style = UIBarButtonItemStylePlain

    case sender.selectedSegmentIndex

    when 0
      style = UIBarButtonItemStylePlain
    when 1
      style = UIBarButtonItemStyleBordered
    when 2
      style = UIBarButtonItemStyleDone
    end

    # change all necessary bar button items to the given style
    toolbar_items = @toolbar.items
    toolbar_items.each do |item|
      # skip setting the style of image-based UIBarButtonItems
      image = item.backgroundImageForState(UIControlStateNormal, barMetrics:UIBarMetricsDefault)
      item.style = style if image.nil?
    end
  end


  def toggle_bar_style(sender)
    case sender.selectedSegmentIndex
    when 0
      @toolbar.barStyle = UIBarStyleDefault
    when 1
      @toolbar.barStyle = UIBarStyleBlackOpaque
    when 2
      @toolbar.barStyle = UIBarStyleBlack
      @toolbar.tintColor = UIColor.grayColor
      @toolbar.translucent = true
    end
  end


  def toggle_tint_color(sender)
    switch_ctl = sender
    if switch_ctl.on?
      @toolbar.tintColor = UIColor.redColor
      @image_switch_control.enabled = @button_style_segmented_control_bar.enabled = false
      @image_switch_control.alpha = @button_style_segmented_control_bar.alpha = 0.50
    else
      if @image_switch_control.on?
        @image_switch_control.enabled = @button_style_segmented_control_bar.enabled = false
      else
        @image_switch_control.enabled = @button_style_segmented_control_bar.enabled = true
      end
      @toolbar.tintColor = nil
      @image_switch_control.alpha = @button_style_segmented_control_bar.alpha = 1.0
    end
  end

  def toggle_image(sender)

    switch_ctl = sender
    if switch_ctl.on?
      @toolbar.setBackgroundImage(UIImage.imageNamed('/images/toolbarBackground.png'),
        forToolbarPosition:UIToolbarPositionBottom,
        barMetrics:UIBarMetricsDefault)

      @tint_switch_control.enabled = @bar_style_segmented_control_bar.enabled = false
      @tint_switch_control.alpha = @bar_style_segmented_control_bar.alpha = 0.50
    else
      @toolbar.setBackgroundImage(nil,
        forToolbarPosition:UIToolbarPositionBottom,
        barMetrics:UIBarMetricsDefault)

      @tint_switch_control.enabled = @bar_style_segmented_control_bar.enabled = true
      @tint_switch_control.alpha = @bar_style_segmented_control_bar.alpha = 1.0
    end
  end

   #pragma mark UIPickerViewDataSource

  def pickerView(picker_view, didSelectRow:row, inComponent:component)

    # change the left most bar item to what's in the picker
    @current_system_item = picker_view.selectedRowInComponent(0)
    self.create_toolbar_items  # this will re-create all the items
  end


  def pickerView(picker_view, titleForRow: row, forComponent: component)

    @picker_view_array.objectAtIndex(row)
  end

  def pickerView(picker_view, widthForComponent: component)

  	240.0
  end

  def pickerView(picker_view, rowHeightForComponent: component)

  	40.0
  end

  def pickerView(picker_view, numberOfRowsInComponent: component)
    @picker_view_array.count
  end

  def numberOfComponentsInPickerView(picker_view)
  	1
  end



  private

  def bottom_toolbar
    # create the UIToolbar at the bottom of the view controller
    @toolbar ||= UIToolbar.alloc.initWithFrame(CGRectZero).tap do |bar|
      bar.barStyle = UIBarStyleDefault
      bar.setAccessibilityLabel('toolbar')
      # make so the toolbar stays to the bottom and keep the width matching the device's screen width
      bar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin
    end

    self.adjust_toolbar_size
    # size up the toolbar and set its frame

    @toolbar.setFrame(
            CGRectMake(CGRectGetMinX(self.view.bounds),
            CGRectGetMinY(self.view.bounds) + CGRectGetHeight(self.view.bounds) - CGRectGetHeight(@toolbar.frame),
            CGRectGetWidth(self.view.bounds),
            CGRectGetHeight(@toolbar.frame)))
    #@toolbar
    end

  def scroll_view

    @scroll_view ||= UIScrollView.alloc.initWithFrame(CGRectMake(0.0, 0.0, 320.0, 460.0)).tap do |sv|
      sv.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
      sv.backgroundColor = UIColor.whiteColor
    end
    # remember our scroll view's content height (a fixed size) later when we set its content size in viewWillAppear
    @saved_content_height_size = @scroll_view.frame.size.height -
                                    CGRectGetHeight(self.navigationController.navigationBar.frame) -
                                    @toolbar.frame.size.height

  @scroll_view
  end

  def container_view
    @container_view ||= UIView.alloc.initWithFrame(CGRectMake(0.0, 64.0, 343.0, 134.0)).tap do |cv|
      cv.backgroundColor = UIColor.lightGrayColor
      cv.autoresizingMask = UIViewAutoresizingFlexibleWidth
    end
  end

  def bar_btn_sys_item_lbl
    @bar_btn_sys_item_lbl ||= UILabel.alloc.initWithFrame(CGRectMake(20.0, 180.0, 280.0, 17.0)).tap do |bsi|
      bsi.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
      bsi.text =  'UIBarStyle'
      bsi.clipsToBounds = true
      bsi.opaque = false
      bsi.minimumFontSize = 10
      bsi.userInteractionEnabled = false
      bsi.contentMode = UIViewContentModeScaleToFill
      bsi.textColor = UIColor.darkTextColor
      bsi.font = UIFont.fontWithName('Helvetica', size:12)
    end
  end

  def picker
    # note we are using CGRectZero for the dimensions of our picker view,
    # this is because picker views have a built in optimum size,
    # you just need to set the correct origin in your view.

    @picker_view ||= UIPickerView.alloc.initWithFrame CGRectMake(0.0, 200.0, 320.0, 216.0) do |p|

    #p.sizeToFit
    #p.frame = self.picker_frame_with_size(p.frame.size)

    p.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

    #p.showsSelectionIndicator = true # note this is defaulted to NO

    # this view controller is the data source and delegate
    end

    @picker_view.delegate = self
    @picker_view.dataSource = self
    @picker_view

  end


  def bar_style_lbl
    @bar_style_lbl ||= UILabel.alloc.initWithFrame(CGRectMake(20.0, 5.0, 280.0, 21.0)).tap do |bs|
      bs.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
      bs.text =  'UIBarStyle'
      bs.clipsToBounds = true
      bs.opaque = false
      bs.minimumFontSize = 10
      bs.userInteractionEnabled = false
      bs.contentMode = UIViewContentModeScaleToFill
      bs.textColor = UIColor.darkTextColor
      bs.font = UIFont.fontWithName('Helvetica', size:12)
    end
  end

  def bar_style_segmented_control_bar
    segment_names = %w(Default Black Translucent)
    @bar_style_segmented_control_bar ||= UISegmentedControl.alloc.initWithItems(segment_names).tap do |scb|
        scb.frame = CGRectMake(20.0, 23.0, 280.0, 30.0)
        scb.clearsContextBeforeDrawing = false
        scb.contentMode = UIViewContentModeScaleToFill
        scb.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft
        scb.contentVerticalAlignment = UIControlContentVerticalAlignmentTop
        scb.tintColor = UIColor.blueColor
        scb.addTarget(self,
                      action: 'toggle_bar_style:',
                      forControlEvents:UIControlEventValueChanged
                     )
      end
  end


  def image_switch_control_label
    @image_switch_control_label ||= UILabel.alloc.initWithFrame(CGRectMake(30.0, 57.0, 48.0, 21.0)).tap do |bs|
      bs.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
      bs.text =  'Image'
      bs.clipsToBounds = true
      bs.opaque = false
      bs.minimumFontSize = 10
      bs.userInteractionEnabled = false
      bs.contentMode = UIViewContentModeScaleToFill
      bs.textColor = UIColor.darkTextColor
      bs.font = UIFont.fontWithName('Helvetica', size:12)
    end
  end


  def image_switch_control
    @image_switch_control ||= begin
      UISwitch.alloc.initWithFrame(CGRectMake(93.0, 56.0, 51.0, 31.0)).tap do |control|
        control.addTarget(self, action: 'toggle_image:', forControlEvents: UIControlEventValueChanged)
        control.backgroundColor = UIColor.clearColor # in case the parent view draws with a custom color or gradient, use a transparent color
        control.setAccessibilityLabel('Standard Switch')
      end
    end
  end


  def tint_switch_control_label
    @tint_switch_control_label ||= UILabel.alloc.initWithFrame(CGRectMake(173.0, 57.0, 48.0, 21.0)).tap do |bs|
      bs.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
      bs.text =  'Tinted'
      bs.clipsToBounds = true
      bs.opaque = false
      bs.minimumFontSize = 10
      bs.userInteractionEnabled = false
      bs.contentMode = UIViewContentModeScaleToFill
      bs.textColor = UIColor.darkTextColor
      bs.font = UIFont.fontWithName('Helvetica', size:12)
    end
  end


  def tint_switch_control
    @tint_switch_control ||= begin
      UISwitch.alloc.initWithFrame(CGRectMake(229.0, 56.0, 51.0, 31.0)).tap do |control|
        control.addTarget(self, action: 'toggle_tint_color:', forControlEvents: UIControlEventValueChanged)
        control.backgroundColor = UIColor.clearColor # in case the parent view draws with a custom color or gradient, use a transparent color
        control.setAccessibilityLabel('Standard Switch')
      end
    end
  end


  def bar_btn_item_style_lbl
    @bar_btn_item_style_lbl ||= UILabel.alloc.initWithFrame(CGRectMake(20.0, 86.0, 280.0, 21.0)).tap do |bbis|
      bbis.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
      bbis.text =  'UIBarButtonItemStyle'
      bbis.clipsToBounds = true
      bbis.opaque = false
      bbis.minimumFontSize = 10
      bbis.userInteractionEnabled = false
      bbis.contentMode = UIViewContentModeScaleToFill
      bbis.textColor = UIColor.darkTextColor
      bbis.font = UIFont.fontWithName('Helvetica', size:12)
    end
  end

  def button_style_segmented_control_bar
    segment_names = %w(Plain Bordered Done)
    @button_style_segmented_control_bar ||= UISegmentedControl.alloc.initWithItems(segment_names).tap do |scb|
        scb.frame = CGRectMake(20.0, 103.0, 280.0, 30.0)
        scb.clearsContextBeforeDrawing = false
        scb.contentMode = UIViewContentModeScaleToFill
        scb.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft
        scb.contentVerticalAlignment = UIControlContentVerticalAlignmentTop
        scb.tintColor = UIColor.blueColor
        scb.addTarget(self,
                      action: 'toggle_button_style:',
                      forControlEvents:UIControlEventValueChanged
                     )
      end
  end

end
