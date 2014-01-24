class RcPickerViewController < UIViewController

  OPTIMUM_PICKER_HEIGHT = 216
  OPTIMUM_PICKER_WIDTH = 320

  # return the picker frame based on its size, positioned at the bottom of the page relative to the toolbar
  def picker_frame_with_size(size)
    height = size.height
    width = size.width

    if size.height < OPTIMUM_PICKER_HEIGHT
      # if in landscape, the picker height can be sized too small, so use a optimum height
      height = OPTIMUM_PICKER_HEIGHT
    end

    if (size.width > OPTIMUM_PICKER_WIDTH)
      # keep the width an optimum size as well
      width = OPTIMUM_PICKER_WIDTH
    end

    resultFrame = CGRectMake(0.0, -1.0, width, height)

    return resultFrame
  end

  #pragma mark - UIPickerView

  def create_picker
    @picker_view_array = ['John Appleseed', 'Chris Armstrong', 'Serena Auroux', 'Susan Bean', 'Luis Becerra', 'Kate Bell', 'Alain Briere']

    # note we are using CGRectZero for the dimensions of our picker view,
    # this is because picker views have a built in optimum size,
    # you just need to set the correct origin in your view.

    @my_picker_view = UIPickerView.alloc.initWithFrame CGRectZero

    @my_picker_view.sizeToFit
    @my_picker_view.frame = self.picker_frame_with_size(@my_picker_view.frame.size)

    @my_picker_view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

    @my_picker_view.showsSelectionIndicator = true # note this is defaulted to NO

    # this view controller is the data source and delegate
    @my_picker_view.delegate = self
    @my_picker_view.dataSource = self
    
    # add this picker to our view controller, initially hidden
    @my_picker_view.hidden = true
    @scroll_view.addSubview @my_picker_view
  end


  #pragma mark - UIPickerView - Date/Time

  def create_date_picker
    @date_picker_view = UIDatePicker.alloc.initWithFrame CGRectZero

    @date_picker_view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

    @date_picker_view.datePickerMode = UIDatePickerModeDate

    # note we are using CGRectZero for the dimensions of our picker view,
    # this is because picker views have a built in optimum size,
    # you just need to set the correct origin in your view.

    @date_picker_view.sizeToFit
    @date_picker_view.frame = self.picker_frame_with_size(@date_picker_view.frame.size)

    # add this picker to our view controller, initially hidden
    @date_picker_view.hidden = true
    @scroll_view.addSubview @date_picker_view
  end


  #pragma mark - UIPickerView - Custom Picker

  def create_custom_picker
    @custom_picker_view = UIPickerView.alloc.initWithFrame CGRectZero

    @custom_picker_view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

    # setup the data source and delegate for this picker
    @custom_picker_data_source = RcCustomPickerDataSource.alloc.init
    @custom_picker_view.dataSource = @custom_picker_data_source
    @custom_picker_view.delegate = @custom_picker_data_source

    # note we are using CGRectZero for the dimensions of our picker view,
    # this is because picker views have a built in optimum size,
    # you just need to set the correct origin in your view.

    @custom_picker_view.sizeToFit
    @custom_picker_view.frame = self.picker_frame_with_size(@custom_picker_view.frame.size)

    @custom_picker_view.showsSelectionIndicator = true

    # add this picker to our view controller, initially hidden
    @custom_picker_view.hidden = true
    @scroll_view.addSubview @custom_picker_view
  end


  #pragma mark - Actions

  def show_picker(picker)
    # hide the current picker and show the new one
    if @current_picker
      @current_picker.hidden = true
      @label.text = ''
    end
    picker.hidden = false

    @current_picker = picker # remember the current picker so we can remove it later when another one is chosen
  end

  # for changing the date picker's style
  def toggle_picker_style(sender)
    case (sender.selectedSegmentIndex)
    when 0 # Time
      @date_picker_view.datePickerMode = UIDatePickerModeTime
      @segment_label.text = 'UIDatePickerModeTime'
    when 1 # Date
      @date_picker_view.datePickerMode = UIDatePickerModeDate
      @segment_label.text = 'UIDatePickerModeDate'
    when 2 # Date & Time
      @date_picker_view.datePickerMode = UIDatePickerModeDateAndTime
      @segment_label.text = 'UIDatePickerModeDateAndTime'
    when 3 # Counter
      @date_picker_view.datePickerMode = UIDatePickerModeCountDownTimer
      @segment_label.text = 'UIDatePickerModeCountDownTimer'
    end

    # in case we previously chose the Counter style picker, make sure
    # the current date is restored
    @date_picker_view.date = NSDate.date
  end

  # for changing between UIPickerView, UIDatePickerView and custom picker
  def toggle_pickers(sender)
    case sender.selectedSegmentIndex
    when 0 # UIPickerView
      @picker_style_segmented_control.hidden = true
      @segment_label.hidden = true
      self.show_picker @my_picker_view

      # report the selection to the UI label
      @label.text = "#{@picker_view_array[@my_picker_view.selectedRowInComponent(0)]} - #{@my_picker_view.selectedRowInComponent(1)}"
    when 1 # UIDatePicker
      @picker_style_segmented_control.hidden = false
      @segment_label.hidden = false
      self.show_picker @date_picker_view

      self.toggle_picker_style @picker_style_segmented_control
    when 2 # Custom
      @picker_style_segmented_control.hidden = true
      @segment_label.hidden = true
      self.show_picker @custom_picker_view
    end
  end


  #pragma mark - View Controller

  def viewDidLoad
    super

    self.title = 'PickerTitle'.localized

    self.view.backgroundColor = UIColor.lightGrayColor
    
    @toolbar = UIToolbar.alloc.init
    frame = self.view.frame
    frame.size.height = 44.0
    frame.origin.y = CGRectGetHeight(self.view.frame) - frame.size.height
    @toolbar.frame = frame
    @toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth
    
    @button_bar_segmented_control = UISegmentedControl.alloc.initWithItems(['UIPicker', 'UIDatePicker', 'Custom'])
    @button_bar_segmented_control.frame = [[0, 0], [299, 30]]
    @button_bar_segmented_control.segmentedControlStyle = UISegmentedControlStyleBar
    @button_bar_segmented_control.tintColor = UIColor.darkGrayColor
    # @button_bar_segmented_control.segmentedControlStyle = UISegmentedControlStyleBar
    @button_bar_segmented_control.addTarget(self, action: 'toggle_pickers:', forControlEvents: UIControlEventValueChanged)

    flexibleSpace = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target: nil, action: nil)
    bar_button_item = UIBarButtonItem.alloc.initWithCustomView(@button_bar_segmented_control)
    @toolbar.setItems([flexibleSpace, bar_button_item, flexibleSpace], animated: false)

    @scroll_view = UIScrollView.alloc.init
    frame = self.view.frame
    frame.size.height = CGRectGetHeight(self.view.frame) - @toolbar.size.height
    @scroll_view.frame = frame
    @scroll_view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
    self.view.addSubview @scroll_view

    # @toolbar must be added after @scroll_view
    # otherwise, automaticallyAdjustsScrollViewInsets is uneffective
    self.view.addSubview @toolbar

    @picker_style_segmented_control = UISegmentedControl.alloc.initWithItems(['1', '2', '3', '4'])
    @picker_style_segmented_control.frame = [[57, 266], [207, 30]]
    @picker_style_segmented_control.tintColor = UIColor.darkGrayColor
    @picker_style_segmented_control.segmentedControlStyle = UISegmentedControlStyleBar
    @picker_style_segmented_control.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin
    @picker_style_segmented_control.addTarget(self, action: 'toggle_picker_style:', forControlEvents: UIControlEventValueChanged)
    @scroll_view.addSubview @picker_style_segmented_control
    
    @segment_label = UILabel.alloc.initWithFrame [[20, 243], [280, 21]]
    @segment_label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth
    @segment_label.font = UIFont.systemFontOfSize(14.0)
    @segment_label.textAlignment = NSTextAlignmentCenter
    @scroll_view.addSubview @segment_label

    # set the content size of our scroll view to match the frame,
    # this will allow the content to scroll in landscape

    @scroll_view.setContentSize [320, 416]

    self.create_picker
    self.create_date_picker
    self.create_custom_picker

    # label for picker selection output
    @label = UILabel.alloc.initWithFrame([[RC_LEFT_MARGIN, CGRectGetMaxY(@my_picker_view.frame) + 10.0], [CGRectGetWidth(self.view.bounds) - (RC_RIGHT_MARGIN * 2.0), 14.0]])
    @label.font = UIFont.systemFontOfSize(12.0)
    @label.textAlignment = NSTextAlignmentCenter
    @label.textColor = UIColor.blackColor
    @label.backgroundColor = UIColor.clearColor
    @label.autoresizingMask = UIViewAutoresizingFlexibleWidth
    @scroll_view.addSubview @label

    # start by showing the normal picker in date mode
    @button_bar_segmented_control.selectedSegmentIndex = 0
    @date_picker_view.datePickerMode = UIDatePickerModeDate

    @picker_style_segmented_control.selectedSegmentIndex = 1
  end

  #pragma mark - UIPickerViewDelegate

  def pickerView(picker_view, didSelectRow: row, inComponent: component)
    if picker_view == @my_picker_view # don't show selection for the custom picker
      # report the selection to the UI label
      @label.text = "#{@picker_view_array[picker_view.selectedRowInComponent(0)]} - #{picker_view.selectedRowInComponent(1)}"
    end
  end

  #pragma mark - UIPickerViewDataSource

  def pickerView(picker_view, attributedTitleForRow: row, forComponent: component)
    attributed_title = nil

    # note: for the custom picker we use custom views instead of titles
    if picker_view == @my_picker_view
      if row == 0
        if component == 0
          title = @picker_view_array[row]
        else
          title = row.to_s
        end
        # apply red text for normal state
        attributed_title = NSMutableAttributedString.alloc.initWithString(title)
        attributed_title.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor, range: NSMakeRange(0, attributed_title.length))
      end
    end

    attributed_title
  end

  def pickerView(picker_view, titleForRow: row, forComponent: component)
    string = ''

    # note: for the custom picker we use custom views instead of titles
    if picker_view == @my_picker_view
      if component == 0
        string = @picker_view_array[row]
      else
        string = row.to_s
      end
    end
    
    string
  end

  def pickerView(picker_view, widthForComponent: component)
    component_width = 0.0
    
    if component == 0
      component_width = 240.0 # first column size is wider to hold names
    else
      component_width = 40.0 # second column is narrower to show numbers
    end
    component_width
  end

  def pickerView(picker_view, rowHeightForComponent: component)
    40.0
  end

  def pickerView(picker_view, numberOfRowsInComponent: component)
    @picker_view_array.count
  end

  def numberOfComponentsInPickerView(picker_view)
    2
  end


  #pragma mark - UIViewController delegate methods

  # called after this controller's view was dismissed, covered or otherwise hidden
  def viewWillDisappear(animated)
    super

    @current_picker.hidden = true
  end

# called after this controller's view will appear
  def viewWillAppear(animated)
    super

    self.toggle_pickers(@button_bar_segmented_control) # make sure the last picker is still showing

    # for aesthetic reasons (the background is black), make the nav bar black for this particular page
    self.navigationController.navigationBar.tintColor = UIColor.blackColor
  end

end