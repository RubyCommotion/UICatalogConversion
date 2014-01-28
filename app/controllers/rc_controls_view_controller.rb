class RcControlsViewController < UITableViewController

        DISPLAY_CELL_ID = 'DisplayCellID'
  SOURCE_CELL_ID = 'SourceCellID'

  PROGRESS_INDICATOR_SIZE = 40.0
  PROGRESS_BAR_HEIGHT = 24.0
  PROGRESS_BAR_WIDTH = 160.0

  SLIDER_HEIGHT = 7.0
  VIEW_TAG = 1

  attr_accessor :progressIndSavedColor

  def viewDidLoad
    super

    self.title = 'ControlsTitle'.localized

    @data_source_array = [
      {
        :title => 'UISwitch', :label => 'Standard Switch',
        :source => "rc_controls_view_controller.rb:\n switch_control",
        :view => self.switch_control
      },
      {
        :title => 'UISlider', :label => 'Standard Slider',
        :source => "rc_controls_view_controller.rb:\n slider_control",
        :view => self.slider_control
      },
      {
        :title => 'UISlider', :label => 'Customized Slider',
        :source => "rc_controls_view_controller.rb:\n custom_slider_control",
        :view => self.custom_slider_control
      },
      {
        :title => 'UIPageControl', :label => 'Ten Pages',
        :source => "rc_controls_view_controller.rb:\n page_control",
        :view => self.page_control
      },
      {
        :title => 'UIActivityIndicatorView', :label => 'Style Gray',
        :source => "rc_controls_view_controller.rb:\n progress_indicator",
        :view => self.progress_indicator
      },
      {
        :title => 'UIProgressView', :label => 'Style Default',
        :source => "rc_controls_view_controller.rb:\n progress_bar",
        :view => self.progress_bar
      },
      {
        :title => 'UIStepper', :label => 'Stepper 1 to 10',
        :source => "rc_controls_view_controller.rb:\n stepper",
        :view => self.stepper
      }
    ]

    tintButton = UIBarButtonItem.alloc.initWithTitle('Tinted', style: UIBarButtonItemStyleBordered, target: self, action: 'tint_action:')
    self.navigationItem.rightBarButtonItem = tintButton

    self.tableView.registerClass(UITableViewCell, :forCellReuseIdentifier => DISPLAY_CELL_ID)
    self.tableView.registerClass(UITableViewCell, :forCellReuseIdentifier => SOURCE_CELL_ID)
  end

  # -----------------------------
  # Table View Delegates
  # -----------------------------

  def numberOfSectionsInTableView(table_view)
    @data_source_array.count
  end

  def tableView(table_view, titleForHeaderInSection:section)
    @data_source_array[section][:title]
  end

  def tableView(table_view, numberOfRowsInSection:section)
    2
  end

  def tableView(table_view, heightForRowAtIndexPath:index_path)
    index_path.row == 0 ? 50.0 : 38.0
  end

  def tableView(table_view, cellForRowAtIndexPath: index_path)
    cell = nil

    if (index_path.row == 0)
      cell = table_view.dequeueReusableCellWithIdentifier(DISPLAY_CELL_ID, forIndexPath: index_path)
      cell.selectionStyle = UITableViewCellSelectionStyleNone

      if viewToRemove = cell.contentView.viewWithTag(VIEW_TAG)
       viewToRemove.removeFromSuperview
      end

      cell.textLabel.text = @data_source_array[index_path.section][:label]

      control = @data_source_array[index_path.section][:view]

      # make sure this control is right-justified to the right side of the cell
      newFrame = control.frame;
      newFrame.origin.x = CGRectGetWidth(cell.contentView.frame) - CGRectGetWidth(newFrame) - 10.0
      control.frame = newFrame

      # if the cell is ever resized, keep the control over to the right
      control.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin

      cell.contentView.addSubview(control)

      if (control == self.progress_indicator)
        self.progress_indicator.startAnimating  # UIActivityIndicatorView needs to re-animate
      end
    else
      cell = table_view.dequeueReusableCellWithIdentifier(SOURCE_CELL_ID, forIndexPath: index_path)
      cell.selectionStyle = UITableViewCellSelectionStyleNone
      cell.textLabel.opaque = false
      cell.textLabel.textAlignment = NSTextAlignmentCenter
      cell.textLabel.textColor = UIColor.grayColor
      cell.textLabel.numberOfLines = 2
      cell.textLabel.highlightedTextColor = UIColor.blackColor
      cell.textLabel.font = UIFont.systemFontOfSize(12.0)
                        
      cell.textLabel.text = @data_source_array[index_path.section][:source]
    end

    cell
  end

  protected

  # -----------------------------
  # UI Control Rendering
  # -----------------------------

  def switch_control
    @switch_control ||= begin
      UISwitch.alloc.initWithFrame(CGRectMake(0.0, 12.0, 94.0, 27.0)).tap do |control|
        control.addTarget(self, action: 'switch_action:', forControlEvents: UIControlEventValueChanged)
        control.backgroundColor = UIColor.clearColor # in case the parent view draws with a custom color or gradient, use a transparent color
        control.setAccessibilityLabel('Standard Switch')
        control.tag = VIEW_TAG        # tag this view for later so we can remove it from recycled table cells
      end
    end
  end

  def slider_control
    @slider_control ||= begin
      UISlider.alloc.initWithFrame(CGRectMake(0.0, 12.0, 120.0, SLIDER_HEIGHT)).tap do |control|
        control.addTarget(self, action: 'slider_action:', forControlEvents: UIControlEventValueChanged)
        control.backgroundColor = UIColor.clearColor # in case the parent view draws with a custom color or gradient, use a transparent color
        control.setAccessibilityLabel('Standard Slider')
        control.minimumValue = 0.0
        control.maximumValue = 100.0
        control.continuous = true
        control.value = 50.0
        control.tag = VIEW_TAG
      end
    end
  end

  def custom_slider_control
    @custom_slider_control ||= begin
      UISlider.alloc.initWithFrame(CGRectMake(0.0, 12.0, 120.0, SLIDER_HEIGHT)).tap do |control|
        control.addTarget(self, action: 'slider_action:', forControlEvents: UIControlEventValueChanged)
        control.backgroundColor = UIColor.clearColor

        stetchLeftTrack = UIImage.imageNamed('/images/orangeslide.png').stretchableImageWithLeftCapWidth(10.0, topCapHeight: 0.0)
        stetchRightTrack = UIImage.imageNamed('/images/yellowslide.png').stretchableImageWithLeftCapWidth(10.0, topCapHeight: 0.0)

        control.setThumbImage(UIImage.imageNamed('/images/slider_ball.png'), forState: UIControlStateNormal)
        control.setMinimumTrackImage(stetchLeftTrack, forState: UIControlStateNormal)
        control.setMaximumTrackImage(stetchRightTrack, forState: UIControlStateNormal)
        control.minimumValue = 0.0
        control.maximumValue = 100.0
        control.continuous = true
        control.value = 50.0
        control.setAccessibilityLabel('Custom Slider')
        control.tag = VIEW_TAG
      end
    end
  end

  def page_control
    @page_control ||= begin
      UIPageControl.alloc.initWithFrame(CGRectMake(0.0, 14.0, 178.0, 20.0)).tap do |control|
        control.addTarget(self, action: 'page_action:', forControlEvents: UIControlEventTouchUpInside)
        control.backgroundColor = UIColor.grayColor
        control.numberOfPages = 10
        control.tag = VIEW_TAG
        end
      end
  end

  def progress_indicator
    @progress_indicator ||= begin
      UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray).tap do |indicator|
        self.progressIndSavedColor = indicator.color

        indicator.frame = CGRectMake(0.0, 12.0, PROGRESS_INDICATOR_SIZE, PROGRESS_INDICATOR_SIZE)
        indicator.sizeToFit
        indicator.tag = VIEW_TAG
        indicator.startAnimating
      end
    end
  end

  def progress_bar
    @progress_bar ||= begin
      UIProgressView.alloc.initWithFrame(CGRectMake(0.0, 20.0, PROGRESS_BAR_WIDTH, PROGRESS_BAR_HEIGHT)).tap do |bar|
        bar.progressViewStyle = UIProgressViewStyleDefault
        bar.progress = 0.5
        bar.tag = VIEW_TAG
      end
    end
  end

  def stepper
    @stepper ||= begin
      UIStepper.alloc.initWithFrame(CGRectMake(0.0, 10.0, 0.0, 0.0)).tap do |stepper|
        stepper.sizeToFit
        stepper.tag = VIEW_TAG
        stepper.value = 0
        stepper.minimumValue = 0
        stepper.maximumValue = 10
        stepper.stepValue = 1
        stepper.addTarget(self, action: 'stepper_action:', forControlEvents: UIControlEventValueChanged)
      end
    end
  end

  # -----------------------------
  # UI Control Actions
  # -----------------------------

  def tint_action(sender)
    tintColor = self.progress_bar.progressTintColor ? nil : UIColor.blueColor

    self.progress_bar.progressTintColor = tintColor
    self.progress_bar.trackTintColor = tintColor
    self.slider_control.minimumTrackTintColor = tintColor
    self.slider_control.thumbTintColor = tintColor
    self.switch_control.onTintColor = tintColor
    self.stepper.tintColor = tintColor

    self.switch_control.thumbTintColor = self.switch_control.thumbTintColor ? nil : UIColor.redColor

    self.progress_indicator.color = (self.progress_indicator.color != self.progressIndSavedColor) ? self.progressIndSavedColor : UIColor.blueColor
  end

  def switch_action(sender);end
  def slider_action(sender);end
  def page_action(sender);end
  def stepper_action(sender);end

end