class RcControlsViewController < UITableViewController

	DISPLAY_CELL_ID = "DisplayCellID"
  SOURCE_CELL_ID = "SourceCellID"
  VIEW_TAG = 1

	def viewDidLoad
    super

    self.title = "Controls"

    @data_source_array = [
			{
				:title => "UISwitch", :label => "Standard Switch",
				:source => "rc_controls_view_controller.rb: standardSwitch",
				:view => self.standardSwitch
			}
		]

    self.tableView.registerClass(UITableViewCell, :forCellReuseIdentifier => DISPLAY_CELL_ID)
    self.tableView.registerClass(UITableViewCell, :forCellReuseIdentifier => SOURCE_CELL_ID)
  end

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

  # View methods
  def standardSwitch
  	@switchCtrl ||= begin
	    @switchCtrl = UISwitch.alloc.initWithFrame(CGRectMake(0.0, 12.0, 94.0, 27.0))
	    @switchCtrl.addTarget(self, action: "switchAction:", forControlEvents: UIControlEventValueChanged)
	    @switchCtrl.backgroundColor = UIColor.clearColor # in case the parent view draws with a custom color or gradient, use a transparent color
			@switchCtrl.setAccessibilityLabel("StandardSwitch")
			@switchCtrl.tag = VIEW_TAG	# tag this view for later so we can remove it from recycled table cells
			@switchCtrl
    end
  end

  # Actions
  def switchAction(sender)
  	puts "Nothing for now, Mr. Switch..."
  	true
  end

end