class RcAlertsViewController < UITableViewController

  ALERT_CELL_ID = 'AlertCellID'
  SOURCE_CELL_ID = 'SourceCellID'

  #Ruby does not implement typedef enum - thus following work around
  UIACTION_SIMPLE_SECTION = 0
  UIACTION_OKCANCEL_SECTION = 1
  UIACTION_CUSTOM_SECTION = 2
  UIALERT_SIMPLE_SECTION = 3
  UIALERT_OKCANCEL_SECTION = 4
  UIALERT_CUSTOM_SECTION = 5
  UIALERT_SECURETEXT_SECTION = 6


  def viewDidLoad
    super
    self.title = 'Alerts'
 
    @data_source_array = [
      { title: 'UIActionSheet Class', label: 'Show Simple', source: 'rc_alerts_view_controller.rb - dialog_simple_action' },
      { title: 'UIActionSheet Class', label: 'Show OK-Cancel', source: 'rc_alerts_view_controller.rb - dialog_ok_cancel_action' },
      { title: 'UIActionSheet Class', label: 'Show Customized', source: 'rc_alerts_view_controller.rb - dialog_other_action' },
      { title: 'UIAlertView Class', label: 'Show Simple', source: 'rc_alerts_view_controller.rb - alert_simple_action' },
      { title: 'UIAlertView Class', label: 'Show OK-Cancel', source: 'rc_alerts_view_controller.rb - alert_ok_cancel_action' },
      { title: 'UIAlertView Class', label: 'Show Custom', source: 'rc_alerts_view_controller.rb - alert_other_action' },
      { title: 'UIAlertView Class', label: 'Show Secure Text Input', source: 'rc_alerts_view_controller.rb - alert_secure_text_action' }
    ]
    # register our cell IDs for later when we are asked for UITableViewCells
    self.tableView.registerClass(UITableViewCell, forCellReuseIdentifier: ALERT_CELL_ID)
    self.tableView.registerClass(UITableViewCell, forCellReuseIdentifier: SOURCE_CELL_ID)
  end


 # UIActionSheet

  #open a dialog with just an OK button
  def dialog_simple_action
    action_sheet = UIActionSheet.alloc.initWithTitle('UIActionSheetTitle'.localized,
      delegate:self,
      cancelButtonTitle: nil,
      destructiveButtonTitle: 'OKButtonTitle'.localized,
      otherButtonTitles: nil
    )
    action_sheet.actionSheetStyle = UIActionSheetStyleDefault
    action_sheet.showInView(self.view)
  end
 
  # open a dialog with an OK and cancel button
  def dialog_ok_cancel_action
    action_sheet = UIActionSheet.alloc.initWithTitle('UIActionSheetTitle'.localized,
      delegate:self,
      cancelButtonTitle: 'CancelButtonTitle'.localized,
      destructiveButtonTitle: 'OKButtonTitle'.localized,
      otherButtonTitles: nil
    )
    action_sheet.actionSheetStyle = UIActionSheetStyleDefault
    action_sheet.showInView(self.view)
  end
 
  # open a dialog with two custom buttons
  def dialog_other_action
    action_sheet = UIActionSheet.alloc.initWithTitle('UIActionSheetTitle'.localized,
      delegate:self,
      cancelButtonTitle: nil,
      destructiveButtonTitle: nil,
      otherButtonTitles: 'ButtonTitle1'.localized, 'ButtonTitle2'.localized, nil
    )
    action_sheet.actionSheetStyle = UIActionSheetStyleDefault
    action_sheet.destructiveButtonIndex = 1
    action_sheet.showInView(self.view)
  end
 
  # UIAlertView

  # open an alert with just an OK button
  def alert_simple_action
    alert = UIAlertView.alloc.initWithTitle('UIAlertViewTitle'.localized,
      message: 'UIAlertViewMessageGeneric'.localized,
      delegate: self,
      cancelButtonTitle: 'OKButtonTitle'.localized,
      otherButtonTitles: nil
    )
    alert.show
  end
 
  # open a alert with an OK and cancel button
  def alert_ok_cancel_action
    alert = UIAlertView.alloc.initWithTitle('UIAlertViewTitle'.localized,
      message: 'UIAlertViewMessageGeneric'.localized,
      delegate: self,
      cancelButtonTitle: 'CancelButtonTitle'.localized,
      otherButtonTitles: 'OKButtonTitle'.localized, nil
    )
    alert.show
  end

  # open an alert with two custom buttons
  def alert_other_action
    alert = UIAlertView.alloc.initWithTitle('UIAlertViewTitle'.localized,
      message: 'UIAlertViewMessageGeneric'.localized,
      delegate: self,
      cancelButtonTitle: 'CancelButtonTitle'.localized,
      otherButtonTitles: 'ButtonTitle1'.localized, 'ButtonTitle2'.localized, nil
    )
    alert.show
  end

  # open an alert with two custom buttons plus a secure text input field
  def alert_secure_text_action
    alert = UIAlertView.alloc.initWithTitle('UIAlertViewTitle'.localized,
      message: 'Secure Text Input',
      delegate: self,
      cancelButtonTitle: 'CancelButtonTitle'.localized,
      otherButtonTitles: 'OKButtonTitle'.localized, nil
    )
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput
    alert.show
  end

  # UIActionSheetDelegate
  def actionSheet(action_sheet, clickedButtonAtIndex: button_index)
    # use 'buttonIndex' to decide your action
    if button_index == 0
      #puts 'ok'
    else
      #puts 'cancel'
    end
  end
 
  # UIAlertViewDelegate
  def alertView(action_sheet, clickedButtonAtIndex: button_index)
    # use 'buttonIndex' to decide your action
    #puts "Clicked alert view at index: #{button_index}"
  end
 
  # UITableView delegates
  def numberOfSectionsInTableView(table_view)
    @data_source_array.count
  end
  
  def tableView(table_view, titleForHeaderInSection: section)
    @data_source_array[section][:title]
  end
 
  def tableView(table_view, numberOfRowsInSection: section)
    2
  end

  # to determine specific row height for each cell, override this.
  # In this example, each row is determined by its subviews that are embedded.
  #
  def tableView(table_view, heightForRowAtIndexPath: index_path)
    return index_path.row == 0 ? 50.0 : 22.0
  end

  # the table's selection has changed, show the alert or action sheet
  def tableView(table_view, didSelectRowAtIndexPath: index_path)

    # deselect the current row (don't keep the table selection persistent)
    table_view.deselectRowAtIndexPath(table_view.indexPathForSelectedRow, animated: true)

    if index_path.row == 0
      case index_path.section
      when UIACTION_SIMPLE_SECTION
        dialog_simple_action
      when UIACTION_OKCANCEL_SECTION
        dialog_ok_cancel_action
      when UIACTION_CUSTOM_SECTION
        dialog_other_action
      when UIALERT_SIMPLE_SECTION
        alert_simple_action
      when UIALERT_OKCANCEL_SECTION
        alert_ok_cancel_action
      when UIALERT_CUSTOM_SECTION
        alert_other_action
      when UIALERT_SECURETEXT_SECTION
        alert_secure_text_action
      end
    end
  end

  # to determine which UITableViewCell to be used on a given row.
  #
  def tableView(table_view, cellForRowAtIndexPath: index_path)
    cell = nil

    if index_path.row == 0
      cell = tableView.dequeueReusableCellWithIdentifier( ALERT_CELL_ID, forIndexPath: index_path )
      cell.textLabel.text = @data_source_array[index_path.section][:label]
    else
      cell = tableView.dequeueReusableCellWithIdentifier( SOURCE_CELL_ID, forIndexPath: index_path )
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