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

    self.title = 'Controls'

    @data_source_array = [
			{
				:title => 'UISwitch', :label => 'Standard Switch',
				:source => 'rc_controls_view_controller.rb:\n switchControl',
				:view => self.switchControl
			},
			{
				:title => 'UISlider', :label => 'Standard Slider',
				:source => 'rc_controls_view_controller.rb:\n sliderControl',
				:view => self.sliderControl
			},
      {
        :title => 'UISlider', :label => 'Customized Slider',
        :source => 'rc_controls_view_controller.rb:\n customSliderControl',
        :view => self.customSliderControl
      },
			{
				:title => 'UIPageControl', :label => 'Ten Pages',
				:source => 'rc_controls_view_controller.rb:\n pageControl',
				:view => self.pageControl
			},
      {
        :title => 'UIActivityIndicatorView', :label => 'Style Gray',
        :source => 'rc_controls_view_controller.rb:\n progressIndicator',
        :view => self.progressIndicator
      },
      {
        :title => 'UIProgressView', :label => 'Style Default',
        :source => 'rc_controls_view_controller.rb:\n progressBar',
        :view => self.progressBar
      },
      {
        :title => 'UIStepper', :label => 'Stepper 1 to 10',
        :source => 'rc_controls_view_controller.rb:\n stepper',
        :view => self.stepper
      }
		]

    tintButton = UIBarButtonItem.alloc.initWithTitle('Tinted', style: UIBarButtonItemStyleBordered, target: self, action: 'tintAction:')
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

  def tableView(tableView, titleForHeaderInSection:section)
    @data_source_array[section][:title]
  end

  def tableView(tableView, numberOfRowsInSection:section)
    2
  end

  def tableView(tableView, heightForRowAtIndexPath:index_path)
    index_path.row == 0 ? 50.0 : 38.0
  end

  def tableView(tableView, cellForRowAtIndexPath: index_path)
		cell = nil

		if (index_path.row == 0)
			cell = tableView.dequeueReusableCellWithIdentifier(DISPLAY_CELL_ID, forIndexPath: index_path)
      cell.selectionStyle = UITableViewCellSelectionStyleNone

      if viewToRemove = cell.contentView.viewWithTag(VIEW_TAG)
      	viewToRemove.removeFromSuperview
      end

			cell.textLabel.text = @data_source_array[index_path.section][:label]

			control = @data_source_array[index_path.section][:view]

      # make sure this control is right-justified to the right side of the cell
      newFrame = control.frame;
      newFrame.origin.x = CGRectGetWidth(cell.contentView.frame) - CGRectGetWidth(newFrame) - 10.0
      control.frame = newFrame;
      
      # if the cell is ever resized, keep the control over to the right
      control.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
      
			cell.contentView.addSubview(control)

      if (control == self.progressIndicator)
        self.progressIndicator.startAnimating  # UIActivityIndicatorView needs to re-animate
      end
		else
			cell = tableView.dequeueReusableCellWithIdentifier(SOURCE_CELL_ID, forIndexPath: index_path)
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

  def switchControl
  	@switchControl ||= begin
	    UISwitch.alloc.initWithFrame(CGRectMake(0.0, 12.0, 94.0, 27.0)).tap do |control|
	    	control.addTarget(self, action: 'switchAction:', forControlEvents: UIControlEventValueChanged)
	    	control.backgroundColor = UIColor.clearColor # in case the parent view draws with a custom color or gradient, use a transparent color
				control.setAccessibilityLabel('Standard Switch')
				control.tag = VIEW_TAG	# tag this view for later so we can remove it from recycled table cells
			end
    end
  end

  def sliderControl
  	@sliderControl ||= begin
  		UISlider.alloc.initWithFrame(CGRectMake(0.0, 12.0, 120.0, SLIDER_HEIGHT)).tap do |control|
      	control.addTarget(self, action: 'sliderAction:', forControlEvents: UIControlEventValueChanged)
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

  def customSliderControl
    @customSliderControl ||= begin
      UISlider.alloc.initWithFrame(CGRectMake(0.0, 12.0, 120.0, SLIDER_HEIGHT)).tap do |control|
        control.addTarget(self, action: 'sliderAction:', forControlEvents: UIControlEventValueChanged)
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

  def pageControl
  	@pageControl ||= begin
  		UIPageControl.alloc.initWithFrame(CGRectMake(0.0, 14.0, 178.0, 20.0)).tap do |control|
      	control.addTarget(self, action: 'pageAction:', forControlEvents: UIControlEventTouchUpInside)
	    	control.backgroundColor = UIColor.grayColor
      	control.numberOfPages = 10
				control.tag = VIEW_TAG
			end
  	end
  end

  def progressIndicator
    @progressIndicator ||= begin
      UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray).tap do |indicator|
        self.progressIndSavedColor = indicator.color

        indicator.frame = CGRectMake(0.0, 12.0, PROGRESS_INDICATOR_SIZE, PROGRESS_INDICATOR_SIZE)
        indicator.sizeToFit
        indicator.tag = VIEW_TAG
        indicator.startAnimating
      end
    end
  end

  def progressBar
    @progressBar ||= begin
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
        stepper.addTarget(self, action: 'stepperAction:', forControlEvents: UIControlEventValueChanged)
      end
    end
  end

  # -----------------------------
  # UI Control Actions
  # -----------------------------

  def tintAction(sender)
    tintColor = self.progressBar.progressTintColor ? nil : UIColor.blueColor

    self.progressBar.progressTintColor = tintColor
    self.progressBar.trackTintColor = tintColor
    self.sliderControl.minimumTrackTintColor = tintColor
    self.sliderControl.thumbTintColor = tintColor
    self.switchControl.onTintColor = tintColor
    self.stepper.tintColor = tintColor

    self.switchControl.thumbTintColor = self.switchControl.thumbTintColor ? nil : UIColor.redColor

    self.progressIndicator.color = (self.progressIndicator.color != self.progressIndSavedColor) ? self.progressIndSavedColor : UIColor.blueColor
  end

  def switchAction(sender);end
  def sliderAction(sender);end
  def pageAction(sender);end
  def stepperAction(sender);end

end