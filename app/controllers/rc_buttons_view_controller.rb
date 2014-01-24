class RcButtonsViewController < UITableViewController
  # constants for button sizing
  STD_BUTTON_WIDTH  = 106.0
  STD_BUTTON_HEIGHT = 40.0
  VIEW_TAG          = 1

  # table view cell id constants
  DISPLAY_CELL_ID   = 'DisplayCellID'
  SOURCE_CELL_ID    = 'SourceCellID'

  #pramga mark - button setup helper (class method)

  class << self
    def newButtonWithTitle( title, target: target, selector: selector, frame: frame, image: image, imagePressed: image_pressed, darkTextColor: dark_text_color )
      UIButton.alloc.initWithFrame( frame ).tap do |button|
        # use tap to setup and return the new button
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter
        button.setTitle( title, forState: UIControlStateNormal )
        button.setTitleColor( ( dark_text_color ) ? UIColor.blackColor : UIColor.whiteColor, forState: UIControlStateNormal )

        new_image = image.stretchableImageWithLeftCapWidth( 12.0, topCapHeight: 0.0 )
        new_image_pressed = image_pressed.stretchableImageWithLeftCapWidth( 12.0, topCapHeight: 0.0 )

        button.setBackgroundImage( new_image, forState: UIControlStateNormal )
        button.setBackgroundImage( new_image_pressed, forState: UIControlStateHighlighted )
        button.addTarget( target, action: selector, forControlEvents: UIControlEventTouchUpInside )

        # in case the parent view draws with a custom color or gradient, use a transparent color
        button.backgroundColor = UIColor.clearColor
      end
    end
  end

  #pramga mark - instance implementation

  def viewDidLoad
    super

    self.title = 'ButtonsTitle'.localized

    @data_source_array = [
      {
        :title => 'UIButton',
        :label => 'Background Image'.localized,
        :source => 'rc_buttons_view_controller.rb:\rdef grayButton',
        :view  => self.grayButton
      },
      {
        :title => 'UIButton',
        :label => 'Button with Image'.localized,
        :source => 'rc_buttons_view_controller.rb:\rdef imageButton',
        :view => self.imageButton
      },
      {
        :title => 'UIButtonTypeRoundedRect',
        :label => 'Rounded Button'.localized,
        :source => 'rc_buttons_view_controller.rb:\rdef roundedButtonType',
        :view => self.roundedButtonType
      },
      {
        :title => 'UIButtonTypeRoundedRect',
        :label => 'Attributed Text'.localized,
        :source => 'rc_buttons_view_controller.rb:\rdef attrTextButton',
        :view => self.attrTextButton
      },
      {
        :title => 'UIButtonTypeDetailDisclosure',
        :label => 'Detail Disclosure'.localized,
        :source => 'rc_buttons_view_controller.rb:\rdef detailDisclosureButton',
        :view => self.detailDisclosureButton
      },
      {
        :title => 'UIButtonTypeInfoLight',
        :label => 'Info Light'.localized,
        :source => 'rc_buttons_view_controller.rb:\rdef infoLightButtonType',
        :view => self.infoLightButtonType
      },
      {
        :title => 'UIButtonTypeInfoDark',
        :label => 'Info Dark'.localized,
        :source => 'rc_buttons_view_controller.rb:\rdef infoDarkButtonType',
        :view => self.infoDarkButtonType
      },
      {
        :title => 'UIButtonTypeContactAdd',
        :label => 'Contact Add',
        :source => 'rc_buttons_view_controller.rb:\rdef contactAddButtonType',
        :view => self.contactAddButtonType
      }
    ]

    self.tableView.registerClass( UITableViewCell, forCellReuseIdentifier: DISPLAY_CELL_ID )
    self.tableView.registerClass( UITableViewCell, forCellReuseIdentifier: SOURCE_CELL_ID )
  end

  #pragma mark - UITableViewDataSource
  
  def numberOfSectionsInTableView( table_view )
    @data_source_array.length
  end

  def tableView( table_view, titleForHeaderInSection: section )
    @data_source_array[ section ][ :title ]
  end

  def tableView( table_view, numberOfRowsInSection: section )
    2
  end

  # To determine specific row height for each cell, override this.
  # In this example, each row is determined by its subviews that are embedded.
  def tableView( table_view, heightForRowAtIndexPath: index_path )
    ( index_path.row == 0 ) ? 50.0 : 38.0
  end

  # To determine which UITableViewCell to be used on a given row.
  def tableView( table_view, cellForRowAtIndexPath: index_path )
    cell = nil

    if index_path.row == 0
      cell = tableView.dequeueReusableCellWithIdentifier( DISPLAY_CELL_ID, forIndexPath: index_path )
      cell.selectionStyle = UITableViewCellSelectionStyleNone

      # remove old embedded control
      view_to_remove = cell.contentView.viewWithTag( VIEW_TAG )
      view_to_remove.removeFromSuperview unless view_to_remove.nil?
      
      cell.textLabel.text = @data_source_array[ index_path.section ][ :label ]
      button = @data_source_array[ index_path.section ][ :view ]

      # make sure this button is right-justified to the right side of the cell
      new_frame = button.frame
      new_frame.origin.x = CGRectGetWidth( cell.contentView.frame ) - CGRectGetWidth( new_frame ) - 10.0

      # if the cell is ever resized, keep the button over to the right
      button.frame = new_frame
      button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin

      cell.contentView.addSubview( button )
    else
      cell = tableView.dequeueReusableCellWithIdentifier( SOURCE_CELL_ID , forIndexPath: index_path ).tap do |c|
        c.selectionStyle = UITableViewCellSelectionStyleNone
        c.textLabel.opaque = false
        c.textLabel.textAlignment = NSTextAlignmentCenter
        c.textLabel.textColor = UIColor.grayColor
        c.textLabel.numberOfLines = 2
        c.textLabel.highlightedTextColor = UIColor.blackColor
        c.textLabel.font = UIFont.systemFontOfSize( 12.0 )
        c.textLabel.text = @data_source_array[ index_path.section ][ :source ]
      end
    end

    cell
  end

  def action( sender )
    puts 'UIButton was clicked'
  end

  #pragma mark - Lazy creation of buttons

  def grayButton
    # create a UIButton with various background images
    @grayButton ||= begin
      button_background = UIImage.imageNamed( '/images/whiteButton.png' )
      button_background_pressed = UIImage.imageNamed( '/images/blueButton.png' )
      frame = [ [ 0.0, 5.0 ], [ STD_BUTTON_WIDTH, STD_BUTTON_HEIGHT ] ]

      @grayButton = RcButtonsViewController.newButtonWithTitle( 'Gray',
                                                  target: self, 
                                                  selector: 'action:',
                                                  frame: frame, 
                                                  image: button_background, 
                                                  imagePressed: button_background_pressed, 
                                                  darkTextColor: true )
      @grayButton.tag = VIEW_TAG # tag to be able to remove it from recycled tabel cells
      @grayButton
    end
  end

  def imageButton
    # create a UIButton with just an image instead of a title
    @imageButton ||= begin
      button_background = UIImage.imageNamed( '/images/whiteButton.png' )
      button_background_pressed = UIImage.imageNamed( '/images/blueButton.png' )
      frame = [ [ 0.0, 5.0 ], [ STD_BUTTON_WIDTH, STD_BUTTON_HEIGHT ] ]

      @imageButton = RcButtonsViewController.newButtonWithTitle( '',
                                                  target: self, 
                                                  selector: 'action:',
                                                  frame: frame, 
                                                  image: button_background, 
                                                  imagePressed: button_background_pressed, 
                                                  darkTextColor: true ).tap do |button| 

        button.setImage( UIImage.imageNamed( '/images/UIButton_custom.png' ), forState: UIControlStateNormal )
        button.setAccessibilityLabel( 'ArrowButton'.localized )

        button.tag = VIEW_TAG # tag to be able to remove it from recycled tabel cells
      end
      @imageButton
    end
  end

  def roundedButtonType
    # create a UIButton (UIButtonTypeRoundedRect)
    @roundedButtonType ||= UIButton.buttonWithType( UIButtonTypeRoundedRect ).tap do |button|
      button.frame = [ [ 0.0, 5.0 ], [ STD_BUTTON_WIDTH, STD_BUTTON_HEIGHT ] ]
      button.setTitle( 'Rounded', forState: UIControlStateNormal )
      button.addTarget( self, action: 'action:', forControlEvents: UIControlEventTouchUpInside )

      button.tag = VIEW_TAG # tag to be able to remove it from recycled tabel cells
    end
  end

  def attrTextButton
    # create a UIButton with attributed text for its title
    @attrTextButton ||= UIButton.buttonWithType( UIButtonTypeRoundedRect ).tap do |button|
      button.frame = [ [ 0.0, 5.0 ], [ STD_BUTTON_WIDTH, STD_BUTTON_HEIGHT ] ]
      button.setTitle( 'Rounded', forState: UIControlStateNormal )
      button.addTarget( self, action: 'action:', forControlEvents: UIControlEventTouchUpInside )

      # add an accessibility label
      button.setAccessibilityLabel( 'AttrTextButton'.localized )

      # apply red text for normal state
      normal_attr_string = NSMutableAttributedString.alloc.initWithString( 'Rounded' ).tap do |attr_string|
        attr_string.addAttribute( NSForegroundColorAttributeName, value: UIColor.redColor, range: [0, attr_string.length ] )
      end
      button.setAttributedTitle( normal_attr_string, forState: UIControlStateNormal )

      # apply green text for pressed state
      highlighted_attr_string = NSMutableAttributedString.alloc.initWithString( 'Rounded' ).tap do |attr_string|
        attr_string.addAttribute( NSForegroundColorAttributeName, value: UIColor.greenColor, range: [0, attr_string.length ] )
      end
      button.setAttributedTitle( highlighted_attr_string, forState: UIControlStateHighlighted )

      button.tag = VIEW_TAG # tag to be able to remove it from recycled tabel cells
    end
  end

  def detailDisclosureButton
    # create a UIButton (UIButtonTypeDetailDisclosure)
    @detailDisclosureButtonType ||= UIButton.buttonWithType( UIButtonTypeDetailDisclosure ).tap do |button|
      button.frame = [ [ 0.0, 8.0 ], [ 25.0, 25.0 ] ]
      button.setTitle( 'Detail Disclosure', forState: UIControlStateNormal )
      button.backgroundColor = UIColor.clearColor
      button.addTarget( self, action: 'action:', forControlEvents: UIControlEventTouchUpInside )

      # Add a custom accessibility label to the button because it has  no associated text.
      button.setAccessibilityLabel( 'MoreInfoButton'.localized )

      button.tag = VIEW_TAG # tag to be able to remove it from recycled tabel cells
    end
  end

  def infoLightButtonType
    # create a UIButton (UIButtonTypeInfoLight)
    @infoLightButtonType ||= UIButton.buttonWithType( UIButtonTypeInfoLight ).tap do |button|
      button.frame = [ [ 0.0, 8.0 ], [ 25.0, 25.0 ] ]
      button.setTitle( 'Detail Disclosure', forState: UIControlStateNormal )
      button.backgroundColor = UIColor.grayColor
      button.addTarget( self, action: 'action:', forControlEvents: UIControlEventTouchUpInside )

      # Add a custom accessibility label to the button because it has  no associated text.
      button.setAccessibilityLabel( 'MoreInfoButton'.localized )

      button.tag = VIEW_TAG # tag to be able to remove it from recycled tabel cells
    end
  end

  def infoDarkButtonType
    # create a UIButton (UIButtonTypeInfoDark)
    @infoDarkButtonType ||= UIButton.buttonWithType( UIButtonTypeInfoDark ).tap do |button|
      button.frame = [ [ 0.0, 8.0 ], [ 25.0, 25.0 ] ]
      button.setTitle( 'Detail Disclosure', forState: UIControlStateNormal )
      button.backgroundColor = UIColor.clearColor
      button.addTarget( self, action: 'action:', forControlEvents: UIControlEventTouchUpInside )

      # Add a custom accessibility label to the button because it has  no associated text.
      button.setAccessibilityLabel( 'MoreInfoButton'.localized )

      button.tag = VIEW_TAG # tag to be able to remove it from recycled tabel cells
    end
  end

  def contactAddButtonType
    # create a UIButton (UIButtonTypeContactAdd)
    @cantactAddButtonType ||= UIButton.buttonWithType( UIButtonTypeContactAdd ).tap do |button|
      button.frame = [ [ 0.0, 8.0 ], [ 25.0, 25.0 ] ]
      button.setTitle( 'Detail Disclosure', forState: UIControlStateNormal )
      button.backgroundColor = UIColor.clearColor
      button.addTarget( self, action: 'action:', forControlEvents: UIControlEventTouchUpInside )

      # Add a custom accessibility label to the button because it has  no associated text.
      button.setAccessibilityLabel( 'AddContactButton'.localized )

      button.tag = VIEW_TAG # tag to be able to remove it from recycled tabel cells
    end
  end
end
