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
        :source => "rc_buttons_view_controller.rb:\rdef gray_button",
        :view  => self.gray_button
      },
      {
        :title => 'UIButton',
        :label => 'Button with Image'.localized,
        :source => "rc_buttons_view_controller.rb:\rdef image_button",
        :view => self.image_button
      },
      {
        :title => 'UIButtonTypeRoundedRect',
        :label => 'Rounded Button'.localized,
        :source => "rc_buttons_view_controller.rb:\rdef rounded_button_type",
        :view => self.rounded_button_type
      },
      {
        :title => 'UIButtonTypeRoundedRect',
        :label => 'Attributed Text'.localized,
        :source => "rc_buttons_view_controller.rb:\rdef attr_text_button",
        :view => self.attr_text_button
      },
      {
        :title => 'UIButtonTypeDetailDisclosure',
        :label => 'Detail Disclosure'.localized,
        :source => "rc_buttons_view_controller.rb:\rdef detail_disclosure_button",
        :view => self.detail_disclosure_button
      },
      {
        :title => 'UIButtonTypeInfoLight',
        :label => 'Info Light'.localized,
        :source => "rc_buttons_view_controller.rb:\rdef info_light_button_type",
        :view => self.info_light_button_type
      },
      {
        :title => 'UIButtonTypeInfoDark',
        :label => 'Info Dark'.localized,
        :source => "rc_buttons_view_controller.rb:\rdef info_dark_button_type",
        :view => self.info_dark_button_type
      },
      {
        :title => 'UIButtonTypeContactAdd',
        :label => 'Contact Add',
        :source => "rc_buttons_view_controller.rb:\rdef contact_add_button_type",
        :view => self.contact_add_button_type
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
    #puts 'UIButton was clicked'
  end

  #pragma mark - Lazy creation of buttons

  def gray_button
    # create a UIButton with various background images
    gray_button ||= begin
      button_background = UIImage.imageNamed( '/images/whiteButton.png' )
      button_background_pressed = UIImage.imageNamed( '/images/blueButton.png' )
      frame = [ [ 0.0, 5.0 ], [ STD_BUTTON_WIDTH, STD_BUTTON_HEIGHT ] ]

      gray_button = RcButtonsViewController.newButtonWithTitle( 'Gray',
                                                  target: self, 
                                                  selector: 'action:',
                                                  frame: frame, 
                                                  image: button_background, 
                                                  imagePressed: button_background_pressed, 
                                                  darkTextColor: true )
      gray_button.tag = VIEW_TAG # tag to be able to remove it from recycled tabel cells
      gray_button
    end
  end

  def image_button
    # create a UIButton with just an image instead of a title
    image_button ||= begin
      button_background = UIImage.imageNamed( '/images/whiteButton.png' )
      button_background_pressed = UIImage.imageNamed( '/images/blueButton.png' )
      frame = [ [ 0.0, 5.0 ], [ STD_BUTTON_WIDTH, STD_BUTTON_HEIGHT ] ]

      image_button = RcButtonsViewController.newButtonWithTitle( '',
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
      image_button
    end
  end

  def rounded_button_type
    # create a UIButton (UIButtonTypeRoundedRect)
    rounded_button_type ||= UIButton.buttonWithType( UIButtonTypeRoundedRect ).tap do |button|
      button.frame = [ [ 0.0, 5.0 ], [ STD_BUTTON_WIDTH, STD_BUTTON_HEIGHT ] ]
      button.setTitle( 'Rounded', forState: UIControlStateNormal )
      button.addTarget( self, action: 'action:', forControlEvents: UIControlEventTouchUpInside )

      button.tag = VIEW_TAG # tag to be able to remove it from recycled tabel cells
    end
    rounded_button_type
  end

  def attr_text_button
    # create a UIButton with attributed text for its title
    attr_text_button ||= UIButton.buttonWithType( UIButtonTypeRoundedRect ).tap do |button|
      button.frame = [ [ 0.0, 5.0 ], [ STD_BUTTON_WIDTH, STD_BUTTON_HEIGHT ] ]
      button.setTitle( 'Rounded', forState: UIControlStateNormal )
      button.addTarget( self, action: 'action:', forControlEvents: UIControlEventTouchUpInside )

      # add an accessibility label
      button.setAccessibilityLabel( 'attr_text_button'.localized )

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
    attr_text_button
  end

  def detail_disclosure_button
    # create a UIButton (UIButtonTypeDetailDisclosure)
    detail_disclosure_buttonType ||= UIButton.buttonWithType( UIButtonTypeDetailDisclosure ).tap do |button|
      button.frame = [ [ 0.0, 8.0 ], [ 25.0, 25.0 ] ]
      button.setTitle( 'Detail Disclosure', forState: UIControlStateNormal )
      button.backgroundColor = UIColor.clearColor
      button.addTarget( self, action: 'action:', forControlEvents: UIControlEventTouchUpInside )

      # Add a custom accessibility label to the button because it has  no associated text.
      button.setAccessibilityLabel( 'MoreInfoButton'.localized )

      button.tag = VIEW_TAG # tag to be able to remove it from recycled tabel cells
    end
    detail_disclosure_buttonType
  end

  def info_light_button_type
    # create a UIButton (UIButtonTypeInfoLight)
    info_light_button_type ||= UIButton.buttonWithType( UIButtonTypeInfoLight ).tap do |button|
      button.frame = [ [ 0.0, 8.0 ], [ 25.0, 25.0 ] ]
      button.setTitle( 'Detail Disclosure', forState: UIControlStateNormal )
      button.backgroundColor = UIColor.grayColor
      button.addTarget( self, action: 'action:', forControlEvents: UIControlEventTouchUpInside )

      # Add a custom accessibility label to the button because it has  no associated text.
      button.setAccessibilityLabel( 'MoreInfoButton'.localized )

      button.tag = VIEW_TAG # tag to be able to remove it from recycled tabel cells
    end
    info_light_button_type
  end

  def info_dark_button_type
    # create a UIButton (UIButtonTypeInfoDark)
    info_dark_button_type ||= UIButton.buttonWithType( UIButtonTypeInfoDark ).tap do |button|
      button.frame = [ [ 0.0, 8.0 ], [ 25.0, 25.0 ] ]
      button.setTitle( 'Detail Disclosure', forState: UIControlStateNormal )
      button.backgroundColor = UIColor.clearColor
      button.addTarget( self, action: 'action:', forControlEvents: UIControlEventTouchUpInside )

      # Add a custom accessibility label to the button because it has  no associated text.
      button.setAccessibilityLabel( 'MoreInfoButton'.localized )

      button.tag = VIEW_TAG # tag to be able to remove it from recycled tabel cells
    end
    info_dark_button_type
  end

  def contact_add_button_type
    # create a UIButton (UIButtonTypeContactAdd)
    contact_add_button_type ||= UIButton.buttonWithType( UIButtonTypeContactAdd ).tap do |button|
      button.frame = [ [ 0.0, 8.0 ], [ 25.0, 25.0 ] ]
      button.setTitle( 'Detail Disclosure', forState: UIControlStateNormal )
      button.backgroundColor = UIColor.clearColor
      button.addTarget( self, action: 'action:', forControlEvents: UIControlEventTouchUpInside )

      # Add a custom accessibility label to the button because it has  no associated text.
      button.setAccessibilityLabel( 'AddContactButton'.localized )

      button.tag = VIEW_TAG # tag to be able to remove it from recycled tabel cells
    end
    contact_add_button_type
  end
end
