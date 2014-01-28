class RcToolbarViewController < UIViewController

  # Seems to be extraneous code left in the Obj-C source code
  #def pickerFrameWithSize(size)
  #  screenRect = mainScreen.applicationFrame
  #  CGRectMake(0.0,CGRectGetHeight(screenRect) - 84.0 - size.height, size.width, size.height)
  #end

  def toolbar_clicked(id)
    puts "UIBarButtonItem clicked"
  end

  def createToolbarItems

    # match each of the toolbar item's style match the selection in the "UIBarButtonItemStyle" segmented control
    @buttonItemStyleSegControl = UISegmentedControl.alloc.init
    style = @buttonItemStyleSegControl.selectedSegmentIndex #UIBarButtonItemStyle

    #create the system-defined "OK or Done" button
    @currentSystemItem = UIBarButtonSystemItemDone
    systemItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemDone,target:self,action:toolbar_clicked(self))
    systemItem.style = style

    # flex item used to separate the left groups items and right grouped items
    flexItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace,target:nil,action:nil)

    # create a special tab bar item with a custom image and title
    style = UIBarButtonItemStyleDone
    segment_tools_image = UIImage.imageNamed("/images/segment_tools.png")
    infoItem = UIBarButtonItem.alloc.initWithImage(segment_tools_image,style:style,target:self,action:toolbar_clicked(self))

    # Set the accessibility label for an image bar item.
    infoItem.setAccessibilityLabel("ToolsIcon")

    # create a custom button with a background image with black text for its title:
    customItem1 = UIBarButtonItem.alloc.initWithTitle("Item1",style:UIBarButtonItemStyleBordered,target:self,action:toolbar_clicked(self))

    baseImage = UIImage.imageNamed("/images/whiteButton.png")
    backroundImage = baseImage.stretchableImageWithLeftCapWidth(12.0,topCapHeight:0.0)

    customItem1.setBackgroundImage(backroundImage, forState:UIControlStateNormal, barMetrics:UIBarMetricsDefault)

     textAttributes = { UITextAttributeTextColor=>UIColor.blackColor } # NSDictionary*

     customItem1.setTitleTextAttributes(textAttributes, forState:UIControlStateNormal)

    # create a bordered style button with custom title
    customItem2 = UIBarButtonItem.alloc.initWithTitle("Item2",style:style,target:self,action:toolbar_clicked(self))

    # apply the bar button items to the toolbar
    @toolbar.setItems([ systemItem, flexItem, customItem1, customItem2, infoItem ], animated:false)
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

    # this list appears in the UIPickerView to pick the system's UIBarButtonItem
    @picker_view_array = %W(Done Cancel Edit Save Add FlexibleSpace FixedSpace Compose Reply Action
                                Organize Bookmarks Search Refresh Stop Camera Trash Play Pause Rewind
                                FastForward Undo Redo PageCurl
                                )

    self.title = 'ToolbarTitle'.localized

    # create the UIToolbar at the bottom of the view controller
    @toolbar = UIToolbar.alloc.initWithFrame(CGRectZero)
    @toolbar.barStyle = UIBarStyleDefault
    #@toolbar.setAccessibilityLabel('toolbar')


    # size up the toolbar and set its frame
    self.adjustToolbarSize

    @toolbar.setFrame(CGRectMake(CGRectGetMinX(self.view.bounds),
                                         CGRectGetMinY(self.view.bounds) + CGRectGetHeight(self.view.bounds) - CGRectGetHeight(@toolbar.frame),
                                         CGRectGetWidth(self.view.bounds),
                                         CGRectGetHeight(@toolbar.frame)))

    # make so the toolbar stays to the bottom and keep the width matching the device's screen width
    @toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin

    self.view.addSubview(@toolbar)

    createToolbarItems()

    # set the accessibility label for the tint and image switches so that its context can be determined
    @tintSwitch.setAccessibilityLabel('TintSwitch')
    @imageSwitch.setAccessibilityLabel('ImageSwitch')

    # remember our scroll view's content height (a fixed size) later when we set its content size in viewWillAppear
    # @savedContentHightSize = @scroll_view.frame.size.height - CGRectGetHeight(self.navigationController.navigationBar.frame) -  @toolbar.frame.size.height

    @currentSystemItem = UIBarButtonSystemItemDone

    @scroll_view = UIScrollView.alloc.init
    @barStyleSegControl = UISegmentedControl.alloc.init
    @tintSwitch = UISwitch.alloc.init
    @imageSwitch = UISwitch.alloc.init
    @imageSwitchLabel = UILabel.alloc.init
    @buttonItemStyleSegControl = UISegmentedControl.alloc.init
    @systemButtonPicker = UIPickerView.alloc.init


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
    # @scroll_view.setContentSize(CGSizeMake(CGRectGetWidth(@scroll_view.frame), @savedContentHightSize))
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
    @currentSystemItem = pickerView.selectedRowInComponent(0)
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
end
