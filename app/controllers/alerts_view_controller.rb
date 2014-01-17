class AlertsViewController < UITableViewController

  ALERT_CELL_ID = "AlertCellID"
  SOURCE_CELL_ID = "SourceCellID"

  UIACTION_SIMPLE_SECTION = 0
  UIACTION_OKCANCEL_SECTION = 1
  UIACTION_CUSTOM_SECTION = 2
  UIALERT_SIMPLE_SECTION = 3
  UIALERT_OKCANCEL_SECTION = 4
  UIALERT_CUSTOM_SECTION = 5
  UIALERT_SECURETEXT_SECTION = 6

  def viewDidLoad
    super
    self.title = "AlertTitle"
 
    @data_source_array = [
      { title: "UIActionSheet", label: "Show Simple", source: "AlertsViewController.m - dialogSimpleAction" },
      { title: "UIActionSheet", label: "Show OK-Cancel", source: "AlertsViewController.m - dialogOKCancelAction" },
      { title: "UIActionSheet", label: "Show Customized", source: "AlertsViewController.m - dialogOtherAction" },
      { title: "UIAlertView", label: "Show Simple", source: "AlertsViewController.m - alertSimpleAction" },
      { title: "UIAlertView", label: "Show OK-Cancel", source: "AlertsViewController.m - alertOKCancelAction" },
      { title: "UIAlertView", label: "Show Custom", source: "AlertsViewController.m - alertOtherAction" },
      { title: "UIAlertView", label: "Show Text Input", source: "AlertsViewController.m - alertSecureTextAction" }
    ]
  end

  def dialogSimpleAction
    action_sheet = UIActionSheet.alloc.initWithTitle("UIActionSheetTitle",
      delegate:self,
      cancelButtonTitle: nil,
      destructiveButtonTitle: "OKButtonTitle",
      otherButtonTitles: nil
    )
    action_sheet.actionSheetStyle = UIActionSheetStyleDefault
    action_sheet.showInView(self.view)
  end
 
  def dialogOKCancelAction
    action_sheet = UIActionSheet.alloc.initWithTitle("UIActionSheetTitle",
      delegate:self,
      cancelButtonTitle: "CancelButtonTitle",
      destructiveButtonTitle: "OKButtonTitle",
      otherButtonTitles: nil
    )
    action_sheet.actionSheetStyle = UIActionSheetStyleDefault
    action_sheet.showInView(self.view)
  end
 
  def dialogOtherAction
    action_sheet = UIActionSheet.alloc.initWithTitle("UIActionSheetTitle",
      delegate:self,
      cancelButtonTitle: nil,
      destructiveButtonTitle: nil,
      otherButtonTitles: "ButtonTitle1", "ButtonTitle2", nil
    )
    action_sheet.actionSheetStyle = UIActionSheetStyleDefault
    action_sheet.destructiveButtonIndex = 1
    action_sheet.showInView(self.view)
  end
 
 
  def alertSimpleAction
    alert = UIAlertView.alloc.initWithTitle("UIAlertViewTitle",
      message: "UIAlertViewMessageGeneric",
      delegate: self,
      cancelButtonTitle: "OKButtonTitle",
      otherButtonTitles: nil
    )
    alert.show
  end
 
  def alertOKCancelAction
    alert = UIAlertView.alloc.initWithTitle("UIAlertViewTitle",
      message: "UIAlertViewMessageGeneric",
      delegate: self,
      cancelButtonTitle: "CancelButtonTitle",
      otherButtonTitles: "OKButtonTitle", nil
    )
    alert.show
  end

  def alertOtherAction
    alert = UIAlertView.alloc.initWithTitle("UIAlertViewTitle",
      message: "UIAlertViewMessageGeneric",
      delegate: self,
      cancelButtonTitle: "CancelButtonTitle",
      otherButtonTitles: "ButtonTitle1", "ButtonTitle2", nil
    )
    alert.show
  end

  def alertSecureTextAction
    alert = UIAlertView.alloc.initWithTitle("UIAlertViewTitle",
      message: "UIAlertViewMessage",
      delegate: self,
      cancelButtonTitle: "CancelButtonTitle",
      otherButtonTitles: "OKButtonTitle", nil
    )
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput
    alert.show
  end

  def actionSheet(action_sheet, clickedButtonAtIndex: button_index)
    if button_index == 0
      NSLog("ok")
    else
      NSLog("cancel")
    end
  end
 
  def alertView(action_sheet, clickedButtonAtIndex: button_index)
    NSLog("Clicked alert view at index: #{button_index}")
    # use "buttonIndex" to decide your action
  end
 
  def numberOfSectionsInTableView(table_view)
    @data_source_array.count
  end
  
  def tableView(table_view, titleForHeaderInSection: section)
    @data_source_array[section][:title]
  end
 
  def tableView(table_view, numberOfRowsInSection: section)
    2
  end
 
  def tableView(table_view, heightForRowAtIndexPath: index_path)
    return index_path.row == 0 ? 50.0 : 22.0
  end

  def tableView(table_view, didSelectRowAtIndexPath: index_path)
    tableView.deselectRowAtIndexPath(table_view.indexPathForSelectedRow, animated: true)

    if index_path.row == 0
      case index_path.section
      when UIACTION_SIMPLE_SECTION
        dialogSimpleAction
      when UIACTION_OKCANCEL_SECTION
        dialogOKCancelAction
      when UIACTION_CUSTOM_SECTION
        dialogOtherAction
      when UIALERT_SIMPLE_SECTION
        alertSimpleAction
      when UIALERT_OKCANCEL_SECTION
        alertOKCancelAction
      when UIALERT_CUSTOM_SECTION
        alertOtherAction
      when UIALERT_SECURETEXT_SECTION
        alertSecureTextAction
      end
    end
  end

  def tableView(table_view, cellForRowAtIndexPath: index_path)
    cell = nil

    if index_path.row == 0
      cell = tableView.dequeueReusableCellWithIdentifier(ALERT_CELL_ID) || begin
        UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: ALERT_CELL_ID)
      end
      cell.textLabel.text = @data_source_array[index_path.section][:label]
    else

      cell = tableView.dequeueReusableCellWithIdentifier(SOURCE_CELL_ID) || begin
        UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: SOURCE_CELL_ID)
      end
      cell.selectionStyle = UITableViewCellSelectionStyleNone
        
      cell.textLabel.opaque = false
      cell.textLabel.textAlignment = NSTextAlignmentCenter
      cell.textLabel.textColor = UIColor.grayColor
      cell.textLabel.numberOfLines = 2
      cell.textLabel.font = UIFont.systemFontOfSize(12)
      
      cell.textLabel.text = @data_source_array[index_path.section][:source]
    end

    cell

  end

end