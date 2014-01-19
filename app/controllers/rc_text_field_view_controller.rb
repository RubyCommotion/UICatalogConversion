class RcTextFieldViewController < UITableViewController

  TEXT_FIELD_WIDTH = 260.0
  TEXT_FIELD_CELL_ID = "TextFieldCellID"
  SOURCE_CELL_ID = "SourceCellID"
  VIEW_TAG = 1

  def viewDidLoad
    super
    self.title = "TextFieldTitle"

    @data_source_array = [
      {  title: "UITextField",            source: "RCTextFieldController.rb: textFieldNormal",   view: textFieldNormal},
      {  title: "UITextField Rounded",    source: "RCTextFieldController.rb: textFieldRounded",  view: textFieldRounded},
      {  title: "UITextField Secure",     source: "RCTextFieldController.rb: textFieldSecure",   view: textFieldSecure},
      {  title: "UITextField Left View",  source: "RCTextFieldController.rb: textFieldLeftView", view: textFieldLeftView}
    ]

    # we aren't editing any fields yet, it will be in edit when the user touches an edit field
    @editing = false

    # register our cell IDs for later when we are asked for UITableViewCells
    # [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TEXT_FIELD_CELL_ID]
    # ableViewCell class] forCellReuseIdentifierSOURCE_CELL_ID
  end



  def numberOfSectionsInTableView
    @data_source_array.count
  end

  def tableView(tableView, titleForHeaderInSection:section)
    @data_source_array[section][:title]
  end

  def tableView(tableView, numberOfRowsInSection:section)
    2
  end

  def tableView(tableView, heightForRowAtIndexPath:index_path)
    height = index_path.row == 0 ? 50.0 : 22.0
    p "Height: #{height}"
    return height
  end

  def tableView(tableView, cellForRowAtIndexPath:index_path)

    cell = nil

    if index_path.row == 0
      cell = tableView.dequeueReusableCellWithIdentifier(TEXT_FIELD_CELL_ID,forIndexPath:index_path)
      cell.selectionStyle = UITableViewCellSelectionStyleNone

      viewToCheck = nil
      cell.contentView(viewWithTag:VIEW_TAG)

      if viewToCheck
        viewToCheck.removeFromSuperview

        textField = @data_source_array[index_path.section][:view]
        
        CGRect newFrame = textField.frame # make sure this textfield's width matches the width of the cell
        newFrame.size.width = CGRectGetWidth(cell.contentView.frame) - kLeftMargin*2
        textField.frame = newFrame
        textField.autoresizingMask = UIViewAutoresizingFlexibleWidth # if the cell is ever resized, keep the textfield's width to match the cell's width

        cell.contentView.addSubview(textField)
      else
        cell = tableView.dequeueReusableCellWithIdentifier(SOURCE_CELL_ID, index_path) || begin
          UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:SOURCE_CELL_ID)
        end

        cell.selectionStyle = UITableViewCellSelectionStyleNone
        cell.textLabel.textAlignment = NSTextAlignmentCenter
        cell.textLabel.textColor = UIColor.grayColor
        cell.textLabel.highlightedTextColor = UIColor.blackColor
        cell.textLabel.font = UIFont.systemFontOfSize(12.0)

        cell.textLabel.text = @data_source_array[index_path.section][:source]
      end

      return cell
    end
  end


  def textFieldShouldReturn(textField)
    textField.resignFirstResponder # the user pressed the "Done" button, so dismiss the keyboard
    true
  end

  def textFieldNormal
    if @text_field_normal.nil?     
      frame = CGRectMake(kLeftMargin, 8.0, TEXT_FIELD_WIDTH, kTextFieldHeight)
      @text_field_normal = UITextField.alloc.initWithFrame(frame)

      @text_field_normal.borderStyle = UITextBorderStyleBezel
      @text_field_normal.textColor = UIColor.blackColor
      @text_field_normal.font = UIFont.systemFontOfSize(17.0)
      @text_field_normal.placeholder = "<enter text>"
      @text_field_normal.backgroundColor = UIColor.whiteColor
      @text_field_normal.autocorrectionType = UITextAutocorrectionTypeNo    # no auto correction support

      @text_field_normal.keyboardType = UIKeyboardTypeDefault               # use the default type input method (entire keyboard)
      @text_field_normal.returnKeyType = UIReturnKeyDone

      @text_field_normal.clearButtonMode = UITextFieldViewModeWhileEditing  # has a clear 'x' button to the right

      @text_field_normal.tag = VIEW_TAG                                     # tag this control so we can remove it later for recycled cell
      @text_field_normal.delegate = self                                    # let us be the delegate so we know when the keyboard's "Done" button is pressed

      @text_field_normal.setAccessibilityLabel = "NormalTextField"
    end 
    return @text_field_normal
  end

  def textFieldRounded
    if @text_field_rounded.nil?
      frame = CGRectMake(kLeftMargin, 8.0, TEXT_FIELD_WIDTH, kTextFieldHeight)
      @text_field_rounded = UITextField.alloc.initWithFrame(frame)

      @text_field_rounded.borderStyle = UITextBorderStyleRoundedRect
      @text_field_rounded.textColor = UIColor.blackColor
      @text_field_rounded.font = UIFont.systemFontOfSize(17.0)
      @text_field_rounded.placeholder = "<enter text>"
      @text_field_rounded.backgroundColor = UIColor.whiteColor

      @text_field_rounded.autocorrectionType = UITextAutocorrectionTypeNo  # no auto correction support

      @text_field_rounded.keyboardType = UIKeyboardTypeDefault
      @text_field_rounded.returnKeyType = UIReturnKeyDone

      @text_field_rounded.clearButtonMode = UITextFieldViewModeWhileEditing    # has a clear 'x' button to the right

      @text_field_rounded.tag = VIEW_TAG       # tag this control so we can remove it later for recycled cell

      @text_field_rounded.delegate = self  # let us be the delegate so we know when the keyboard's "Done" button is pressed

      @text_field_rounded.setAccessibilityLabel("RoundedTextField")
    end
    return @text_field_rounded
  end

  def textFieldSecure
    if (@text_field_secure == nil)
      frame = CGRectMake(kLeftMargin, 8.0, TEXT_FIELD_WIDTH, kTextFieldHeight)
      @text_field_secure = UITextField.alloc.initWithFrame(frame)

      @text_field_secure.borderStyle = UITextBorderStyleBezel
      @text_field_secure.textColor = UIColor.blackColor
      @text_field_secure.font = UIFont.systemFontOfSize(17.0)
      @text_field_secure.placeholder = "<enter password>"
      @text_field_secure.backgroundColor = UIColor.whiteColor

      @text_field_secure.keyboardType = UIKeyboardTypeDefault
      @text_field_secure.returnKeyType = UIReturnKeyDone   

      @text_field_secure.secureTextEntry = true # make the text entry secure (bullets)

      @text_field_secure.clearButtonMode = UITextFieldViewModeWhileEditing # has a clear 'x' button to the right

      @text_field_secure.tag = VIEW_TAG        # tag this control so we can remove it later for recycled cell

      @text_field_secure.delegate = self   # let us be the delegate so we know when the keyboard's "Done" button is pressed

      @text_field_secure.setAccessibilityLabel("SecureTextField")
    end
    return @text_field_secure
  end

  def textFieldLeftView
    if @text_field_left_view.nil?
      frame = CGRectMake(kLeftMargin, 8.0, TEXT_FIELD_WIDTH, kTextFieldHeight)
      @text_field_left_view = UITextField.alloc.initWithFrame(frame)
      @text_field_left_view.borderStyle = UITextBorderStyleBezel
      @text_field_left_view.textColor = UIColor.blackColor
      @text_field_left_view.font = UIFont.systemFontOfSize(17.0)
      @text_field_left_view.placeholder = "<enter text>"
      @text_field_left_view.backgroundColor = UIColor.whiteColor

      @text_field_left_view.keyboardType = UIKeyboardTypeDefault
      @text_field_left_view.returnKeyType = UIReturnKeyDone 

      @text_field_left_view.clearButtonMode = UITextFieldViewModeWhileEditing   # has a clear 'x' button to the right

      @text_field_left_view.tag = VIEW_TAG      # tag this control so we can remove it later for recycled cell

      # Add an accessibility label that describes the text field.
      @text_field_left_view.setAccessibilityLabel("CheckMarkIcon")

      UIImageView *image = UIImageView.alloc.initWithImage(imageNamed:"segment_check.png")
      @text_field_left_view.leftView = image
      @text_field_left_view.leftViewMode = UITextFieldViewModeAlways

      @text_field_left_view.delegate = self # let us be the delegate so we know when the keyboard's "Done" button is pressed
    end
    return @text_field_left_view
  end
end









