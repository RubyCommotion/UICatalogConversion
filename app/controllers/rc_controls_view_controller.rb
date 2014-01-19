class RcControlsViewController < UITableViewController

	DISPLAY_CELL_ID = "DisplayCellID"
  SOURCE_CELL_ID = "SourceCellID"
  SLIDER_HEIGHT = 7.0
  VIEW_TAG = 1

	def viewDidLoad
    super

    self.title = "Controls"

    @data_source_array = [
			{
				:title => "UISwitch", :label => "Standard Switch",
				:source => "rc_controls_view_controller.rb: switchControl",
				:view => self.switchControl
			},
			{
				:title => "UISlider", :label => "Standard Slider",
				:source => "rc_controls_view_controller.rb: sliderControl",
				:view => self.sliderControl
			},
			{
				:title => "UIPageControl", :label => "Ten Pages",
				:source => "rc_controls_view_controller.rb: pageControl",
				:view => self.pageControl
			}
		]

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

	    #TODO: Implement this   
      #if (control == self.progressInd)
      #	self.progressInd.startAnimating  # UIActivityIndicatorView needs to re-animate
      #end
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
	    	control.addTarget(self, action: "switchAction:", forControlEvents: UIControlEventValueChanged)
	    	control.backgroundColor = UIColor.clearColor # in case the parent view draws with a custom color or gradient, use a transparent color
				control.setAccessibilityLabel("StandardSwitch")
				control.tag = VIEW_TAG	# tag this view for later so we can remove it from recycled table cells
			end
    end
  end

  def sliderControl
  	@sliderControl ||= begin
  		UISlider.alloc.initWithFrame(CGRectMake(0.0, 12.0, 120.0, SLIDER_HEIGHT)).tap do |control|
      	control.addTarget(self, action: "sliderAction:", forControlEvents: UIControlEventValueChanged)
	    	control.backgroundColor = UIColor.clearColor # in case the parent view draws with a custom color or gradient, use a transparent color
				control.setAccessibilityLabel("StandardSlider")
      	control.minimumValue = 0.0
      	control.maximumValue = 100.0
      	control.continuous = true
      	control.value = 50.0
				control.tag = VIEW_TAG
			end
  	end
  end

  def pageControl
  	@pageControl ||= begin
  		UIPageControl.alloc.initWithFrame(CGRectMake(0.0, 14.0, 178.0, 20.0)).tap do |control|
      	control.addTarget(self, action: "pageAction:", forControlEvents: UIControlEventTouchUpInside)
	    	control.backgroundColor = UIColor.grayColor
      	control.numberOfPages = 10
				control.tag = VIEW_TAG
			end
  	end
  end

  # -----------------------------
  # UI Control Actions
  # -----------------------------

  def switchAction(sender);end
  def sliderAction(sender);end
  def pageAction(sender);end

end