class RcToolbarViewController < UIViewController

  # Seems to be extraneous code left in the Obj-C source code
  #def pickerFrameWithSize(size)
  #  screenRect = mainScreen.applicationFrame
  #  CGRectMake(0.0,CGRectGetHeight(screenRect) - 84.0 - size.height, size.width, size.height)
  #end

  def toolbar_clicked(sender)
    puts 'UIBarButtonItem clicked'
  end

  def createToolbarItems

    # match each of the toolbar item's style match the selection in the "UIBarButtonItemStyle" segmented control
    @buttonItemStyleSegControl = UISegmentedControl.alloc.init
    style = @buttonItemStyleSegControl.selectedSegmentIndex #UIBarButtonItemStyle

    #create the system-defined "OK or Done" button
    @current_system_item = UIBarButtonSystemItemDone
    systemItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemDone,
                                                                   target:self,
                                                                   action:toolbar_clicked(self))
    systemItem.style = style

    # flex item used to separate the left groups items and right grouped items
    flexItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace,
                                                                 target:nil,
                                                                 action:nil)

    # create a special tab bar item with a custom image and title
    style = UIBarButtonItemStyleDone
    segment_tools_image = UIImage.imageNamed('/images/segment_tools.png')
    infoItem = UIBarButtonItem.alloc.initWithImage(segment_tools_image,
                                                   style:style,
                                                   target:self,
                                                   action:toolbar_clicked(self))

    # Set the accessibility label for an image bar item.
    infoItem.setAccessibilityLabel("ToolsIcon")

    # create a custom button with a background image with black text for its title:
    customItem1 = UIBarButtonItem.alloc.initWithTitle('Item1',
                                                      style:UIBarButtonItemStyleBordered,
                                                      target:self,
                                                      action:toolbar_clicked(self))

    baseImage = UIImage.imageNamed('/images/whiteButton.png')
    backroundImage = baseImage.stretchableImageWithLeftCapWidth(12.0,
                                                                topCapHeight:0.0)

    customItem1.setBackgroundImage(backroundImage,
                                   forState:UIControlStateNormal,
                                   barMetrics:UIBarMetricsDefault)

     textAttributes = { UITextAttributeTextColor=>UIColor.blackColor } # NSDictionary*

     customItem1.setTitleTextAttributes(textAttributes,
                                        forState:UIControlStateNormal)

    # create a bordered style button with custom title
    customItem2 = UIBarButtonItem.alloc.initWithTitle('Item2',
                                                      style:style,
                                                      target:self,
                                                      action:toolbar_clicked(self))

    # apply the bar button items to the toolbar
    @toolbar.setItems([ systemItem,
                        flexItem,
                        customItem1,
                        customItem2,
                        infoItem ],
                        animated:false)
  end

  def adjustToolbarSize
    # size up the toolbar and set its frame
    @toolbar.sizeToFit

    # since the toolbar may have adjusted its height, it's origin will have to be adjusted too
    mainViewBounds = self.view.bounds
    @toolbar.setFrame(
      CGRectMake(
        CGRectGetMinX(mainViewBounds),
        CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - CGRectGetHeight(@toolbar.frame),
        CGRectGetWidth(mainViewBounds),
        CGRectGetHeight(@toolbar.frame)
        )
      )
  end

  # def loadView
  #   views = NSBundle.mainBundle.loadNibNamed "ToolbarViewController", owner:self, options:nil
  #   self.view = views[0]
  # end

  def viewDidLoad
    super
    # programmatic build out of the Obj-C IB with removal of any deprecated iOS6 code

    self.view.addSubview(bottom_toolbar)
    self.view.addSubview(scroll_view)

    container_view = UIView.alloc.initWithFrame(CGRectMake(0,0,343,134))
    container_view.backgroundColor = UIColor.lightGrayColor
    container_view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
    @scroll_view.addSubview(container_view)



    # this list appears in the UIPickerView to pick the system's UIBarButtonItem
    @picker_view_array = %W(Done Cancel Edit Save Add FlexibleSpace FixedSpace Compose Reply Action
                                Organize Bookmarks Search Refresh Stop Camera Trash Play Pause Rewind
                                FastForward Undo Redo PageCurl
                                )

    self.title = 'ToolbarTitle'.localized

    self.createToolbarItems

    # set the accessibility label for the tint and image switches so that its context can be determined
    @tintSwitch.setAccessibilityLabel('TintSwitch'.localized)
    @imageSwitch.setAccessibilityLabel('ImageSwitch'.localized)


    ui_bar_button_item_style = UILabel.alloc.initWithFrame(CGRectMake(20, 86, 280, 21))
    ui_bar_button_item_style.text =  'UIBarButtonItemStyle'
    ui_bar_button_item_style.clipsToBounds = true
    ui_bar_button_item_style.opaque = false
    ui_bar_button_item_style.minimumFontSize = 10
    ui_bar_button_item_style.userInteractionEnabled = false
    ui_bar_button_item_style.contentMode = UIViewContentModeScaleToFill
    ui_bar_button_item_style.textColor = UIColor.darkTextColor
    ui_bar_button_item_style.font = UIFont.fontWithName('Helvetica', size:12)
    container_view.addSubview(ui_bar_button_item_style)

    segment_names = %w(Default Black Translucent)
    segmented_control_bar = UISegmentedControl.alloc.initWithItems(segment_names)
    segmented_control_bar.frame = CGRectMake(20, 123, 280, 30)
    segmented_control_bar.clearsContextBeforeDrawing = false
    segmented_control_bar.contentMode = UIViewContentModeScaleToFill
    segmented_control_bar.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft
    segmented_control_bar.contentVerticalAlignment = UIControlContentVerticalAlignmentTop
    segmented_control_bar.tintColor = UIColor.blueColor
    container_view.addSubview(segmented_control_bar)

    @current_system_item = UIBarButtonSystemItemDone

    #@tintSwitch = UISwitch.alloc.init
    #@imageSwitch = UISwitch.alloc.init
    #@imageSwitchLabel = UILabel.alloc.init
    #@buttonItemStyleSegControl = UISegmentedControl.alloc.init
    #@systemButtonPicker = UIPickerView.alloc.init


  end

  def viewWillAppear(animated)
    super

    # self.adjustToolbarSize
    # adjust the scroll view's height since the toolbar may have been resized
    adjustedHeight = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(@toolbar.frame)
    newFrame = @scroll_view.frame
    newFrame.size.height = adjustedHeight
    @scroll_view.frame = newFrame

    # finally set the content size so that it scrolls in landscape but not in portrait
    # @scroll_view.setContentSize(CGSizeMake(CGRectGetWidth(@scroll_view.frame), @saved_content_height_size))
  end

  def toggleStyle(sender)  #IBAction
    UIBarButtonItemStyle style = UIBarButtonItemStylePlain

    case sender.selectedSegmentIndex

    when 0
      style = UIBarButtonItemStylePlain
    when 1
      style = UIBarButtonItemStyleBordered
    when 2
      style = UIBarButtonItemStyleDone
    end

    # change all necessary bar button items to the given style
    toolbarItems = @toolbar.items
    toolbarItems.each do |item|
      # skip setting the style of image-based UIBarButtonItems
      image = item.backgroundImageForState(UIControlStateNormal, barMetrics:UIBarMetricsDefault)
      item.style = style if image.nil?
    end
  end

  def toggleBarStyle(sender)
    case sender.selectedSegmentIndex
    when 0
      @toolbar.barStyle = UIBarStyleDefault
    when 1
      @toolbar.barStyle = UIBarStyleBlackOpaque
    when 2
      @toolbar.barStyle = UIBarStyleBlackTranslucent
    end
  end

  def toggleTintColor(sender)
    switchCtl = sender
    if switchCtl.on
      @toolbar.tintColor = UIColor.redColor
      @imageSwitch.enabled = @barStyleSegControl.enabled = false
      @imageSwitch.alpha = @barStyleSegControl.alpha = 0.50
    else
      if @imageSwitch.on
        @imageSwitch.enabled = @barStyleSegControl.enabled = false
      else
        @imageSwitch.enabled = @barStyleSegControl.enabled = true
      end
      @toolbar.tintColor = nil
      @imageSwitch.alpha = @barStyleSegControl.alpha = 1.0
    end
  end

  def toggleImage(sender)

    switchCtl = sender
    if switchCtl.on
      @toolbar.setBackgroundImage(imageNamed:'/images/toolbarBackground.png',
        forToolbarPosition:UIToolbarPositionBottom,
        barMetrics:UIBarMetricsDefault)

      @tintSwitch.enabled = @barStyleSegControl.enabled = false
      @tintSwitch.alpha = @barStyleSegControl.alpha = 0.50

    else

      toolbar.setBackgroundImage(nil,
        forToolbarPosition:UIToolbarPositionBottom,
        barMetrics:UIBarMetricsDefault)

      @tintSwitch.enabled = @barStyleSegControl.enabled = true
      @tintSwitch.alpha = @barStyleSegControl.alpha = 1.0
    end
  end


  def pickerView(pickerView, didSelectRow:row, inComponent:component)

    # change the left most bar item to what's in the picker
    @current_system_item = pickerView.selectedRowInComponent(0)
    self.createToolbarItems  # this will re-create all the items
  end

  def pickerView(pickerView, titleForRow:row, forComponent:component)
    @picker_view_array.objectAtIndex(row)
  end

  def pickerView(pickerView, widthForComponent:component)
    240.0
  end

  def pickerView(pickerView,rowHeightForComponent:component)
    40.0
  end

  def pickerView(pickerView, numberOfRowsInComponent:component)
    @picker_view_array.count
  end

  def numberOfComponentsInPickerView(pickerView)
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

    self.adjustToolbarSize
    # size up the toolbar and set its frame
    @toolbar.setFrame(
            CGRectMake(CGRectGetMinX(self.view.bounds),
            CGRectGetMinY(self.view.bounds) + CGRectGetHeight(self.view.bounds) - CGRectGetHeight(@toolbar.frame),
            CGRectGetWidth(self.view.bounds),
            CGRectGetHeight(@toolbar.frame)))
  end

  def scroll_view
    @scroll_view ||= UIScrollView.alloc.initWithFrame(CGRectMake(0,0,320,460)).tap do |sv|
      sv.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
      sv.backgroundColor = UIColor.redColor
    end
    # remember our scroll view's content height (a fixed size) later when we set its content size in viewWillAppear
    @saved_content_height_size = @scroll_view.frame.size.height -
                                    CGRectGetHeight(self.navigationController.navigationBar.frame) -
                                    @toolbar.frame.size.height
  @scroll_view
  end

  def container_view

  end

end

