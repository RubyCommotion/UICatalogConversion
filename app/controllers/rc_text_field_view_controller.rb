class RcTextFieldViewController < UITableViewController

  LEFT_MARGING = 20
  TEXT_FIELD_HEIGHT = 15
  TEXT_FIELD_WIDTH = 260.0
  TEXT_FIELD_CELL_ID = 'TextFieldCellID'
  SOURCE_CELL_ID = 'SourceCellID'
  VIEW_TAG = 1

  def viewDidLoad
    super
    self.title = 'TextFieldTitle'


    @data_source_array = [
      {  title: 'UITextField Normal',     source: 'rc_text_field_view_controller.rb: text_field_normal',   view: text_field_normal},
      {  title: 'UITextField Rounded',    source: 'rc_text_field_view_controller.rb: text_field_rounded',  view: text_field_rounded},
      {  title: 'UITextField Secure',     source: 'rc_text_field_view_controller.rb: text_field_secure',   view: text_field_secure},
      {  title: 'UITextField Left View',  source: 'rc_text_field_view_controller.rb: text_field_left_view', view: text_field_left_view}
    ]
  end

  
  def text_field_normal
    if @text_field_normal_view.nil?     
      frame = CGRectMake(LEFT_MARGING, 8.0, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)
      @text_field_normal_view = UITextField.alloc.initWithFrame(frame)

      @text_field_normal_view.borderStyle = UITextBorderStyleBezel
      @text_field_normal_view.textColor = UIColor.blackColor
      @text_field_normal_view.font = UIFont.systemFontOfSize(14.0)
      @text_field_normal_view.placeholder = '<enter text for normal textfield>'
      @text_field_normal_view.backgroundColor = UIColor.whiteColor
      @text_field_normal_view.autocorrectionType = UITextAutocorrectionTypeNo    # no auto correction support

      @text_field_normal_view.keyboardType = UIKeyboardTypeDefault              # http://www.rubymotion.com/developer-center/api/UIKeyboardType.html
      @text_field_normal_view.returnKeyType = UIReturnKeyDone

      @text_field_normal_view.clearButtonMode = UITextFieldViewModeWhileEditing  # has a clear 'x' button to the right

      @text_field_normal_view.tag = VIEW_TAG                                     # tag this control so we can remove it later for recycled cell
      @text_field_normal_view.delegate = self                                    # let us be the delegate so we know when the keyboard's 'Done' button is pressed

      @text_field_normal_view.setAccessibilityLabel('NormalTextField')
    end 
    @text_field_normal_view
  end

  def text_field_rounded
    if @text_field_rounded_view.nil?
      frame = CGRectMake(LEFT_MARGING, 8.0, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)
      @text_field_rounded_view = UITextField.alloc.initWithFrame(frame)

      @text_field_rounded_view.borderStyle = UITextBorderStyleRoundedRect
      @text_field_rounded_view.textColor = UIColor.blackColor
      @text_field_rounded_view.font = UIFont.systemFontOfSize(14.0)
      @text_field_rounded_view.placeholder = '<enter text for rounded textfield>'
      @text_field_rounded_view.backgroundColor = UIColor.whiteColor

      @text_field_rounded_view.autocorrectionType = UITextAutocorrectionTypeNo  # no auto correction support

      @text_field_rounded_view.keyboardType = UIKeyboardTypeDefault
      @text_field_rounded_view.returnKeyType = UIReturnKeyDone

      @text_field_rounded_view.clearButtonMode = UITextFieldViewModeWhileEditing    # has a clear 'x' button to the right

      @text_field_rounded_view.tag = VIEW_TAG       # tag this control so we can remove it later for recycled cell

      @text_field_rounded_view.delegate = self  # let us be the delegate so we know when the keyboard's 'Done' button is pressed

      @text_field_rounded_view.setAccessibilityLabel('RoundedTextField')
    end
    @text_field_rounded_view
  end

  def text_field_secure
    if @text_field_secure_view == nil
      frame = CGRectMake(LEFT_MARGING, 8.0, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)
      @text_field_secure_view = UITextField.alloc.initWithFrame(frame)

      @text_field_secure_view.borderStyle = UITextBorderStyleBezel
      @text_field_secure_view.textColor = UIColor.blackColor
      @text_field_secure_view.font = UIFont.systemFontOfSize(14.0)
      @text_field_secure_view.placeholder = '<enter password>'
      @text_field_secure_view.backgroundColor = UIColor.whiteColor

      @text_field_secure_view.keyboardType = UIKeyboardTypeDefault
      @text_field_secure_view.returnKeyType = UIReturnKeyDone   

      @text_field_secure_view.secureTextEntry = true # make the text entry secure (bullets)

      @text_field_secure_view.clearButtonMode = UITextFieldViewModeWhileEditing # has a clear 'x' button to the right

      @text_field_secure_view.tag = VIEW_TAG        # tag this control so we can remove it later for recycled cell

      @text_field_secure_view.delegate = self   # let us be the delegate so we know when the keyboard's 'Done' button is pressed

      @text_field_secure_view.setAccessibilityLabel('SecureTextField')
    end
    @text_field_secure_view
  end

  def text_field_left_view
    if @text_field_left_view.nil?
      frame = CGRectMake(LEFT_MARGING, 8.0, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)
      @text_field_left_view = UITextField.alloc.initWithFrame(frame)
      
      @text_field_left_view.borderStyle = UITextBorderStyleBezel
      @text_field_left_view.textColor = UIColor.blackColor
      @text_field_left_view.font = UIFont.systemFontOfSize(14.0)
      @text_field_left_view.placeholder = '<enter text for left textfield>'
      @text_field_left_view.backgroundColor = UIColor.whiteColor

      @text_field_left_view.keyboardType = UIKeyboardTypeDefault
      @text_field_left_view.returnKeyType = UIReturnKeyDone 

      @text_field_left_view.clearButtonMode = UITextFieldViewModeWhileEditing   # has a clear 'x' button to the right

      @text_field_left_view.tag = VIEW_TAG      # tag this control so we can remove it later for recycled cell

      # Add an accessibility label that describes the text field.
      @text_field_left_view.setAccessibilityLabel('CheckMarkIcon')


      # converted to Ruby syntax
      #image = UIImageView.alloc.initWithImage(UIImage.imageNamed:'/images/right_round-26.png')
      # changed image to match image used by Obj-C source code for text field left view
      image = UIImageView.alloc.initWithImage(UIImage.imageNamed('/images/segment_check-24.png'))
      @text_field_left_view.leftView = image
      @text_field_left_view.leftViewMode = UITextFieldViewModeAlways

      @text_field_left_view.delegate = self # let us be the delegate so we know when the keyboard's 'Done' button is pressed
    end
    @text_field_left_view
  end

  def numberOfSectionsInTableView(tableview)
    @data_source_array.count
  end

  def tableView(table_view, titleForHeaderInSection:section)
    @data_source_array[section][:title]
  end

  def tableView(table_view, numberOfRowsInSection:section)
    2
  end

  def tableView(table_view, heightForRowAtIndexPath:index_path)
    height = index_path.row == 0 ? 50.0 : 22.0
    height
  end

  def tableView(table_view, cellForRowAtIndexPath:index_path)

    cell = nil

    if index_path.row == 0
      cell = table_view.dequeueReusableCellWithIdentifier(TEXT_FIELD_CELL_ID) || begin
       UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:TEXT_FIELD_CELL_ID)
     end

     cell.selectionStyle = UITableViewCellSelectionStyleNone

     if view_to_remove = cell.contentView.viewWithTag(VIEW_TAG)
      view_to_remove.removeFromSuperview
    end

    text_field = @data_source_array[index_path.section][:view]

      new_frame = text_field.frame # make sure this textfield's width matches the width of the cell
      new_frame.size.width = CGRectGetWidth(cell.contentView.frame) - LEFT_MARGING*2
      text_field.frame = new_frame
      text_field.autoresizingMask = UIViewAutoresizingFlexibleWidth # if the cell is ever resized, keep the textfield's width to match the cell's width
      cell.contentView.addSubview(text_field)

    else
      cell = tableView.dequeueReusableCellWithIdentifier(SOURCE_CELL_ID)  || begin
       UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:SOURCE_CELL_ID)
     end

     cell.selectionStyle = UITableViewCellSelectionStyleNone
     cell.textLabel.textAlignment = NSTextAlignmentCenter
     cell.textLabel.textColor = UIColor.grayColor
     cell.textLabel.highlightedTextColor = UIColor.blackColor
     cell.textLabel.font = UIFont.systemFontOfSize(12.0)
     cell.textLabel.text = @data_source_array[index_path.section][:source]

   end
   cell
 end


 def textFieldShouldReturn(text_field)
    text_field.resignFirstResponder # the user pressed the 'Done' button, so dismiss the keyboard
    true
  end

end