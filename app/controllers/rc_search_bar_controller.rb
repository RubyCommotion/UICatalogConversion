class RcSearchBarController < UIViewController

  SEARCHBAR_X = 0.0
  SEARCHBAR_Y = 120.0
  SEARCHBAR_HEIGHT = 44.0
  SEGMENTED_BUTTONS_X = 34.0
  SEGMENTED_BUTTONS_Y = 65.0
  SEGMENTED_BUTTONS_WIDTH = 252.0
  SEGMENTED_BUTTONS_HEIGHT = 30.0

  def viewDidLoad
  	super
  	self.title = 'SearchBar'.localized

  	@my_search_bar = UISearchBar.alloc.initWithFrame(CGRectMake(SEARCHBAR_X,
                                                                    SEARCHBAR_Y,
                                                                    CGRectGetWidth(self.view.bounds),
                                                                    SEARCHBAR_HEIGHT))
  	@my_search_bar.delegate = self
  	@my_search_bar.showsCancelButton = true
    @my_search_bar.showsBookmarkButton = true
  	self.view.addSubview(@my_search_bar)
    @my_search_bar.autoresizingMask = UIViewAutoresizingFlexibleWidth

    # implement the Obj-C XIB as code
    my_frame = CGRectMake(SEGMENTED_BUTTONS_X,
                          SEGMENTED_BUTTONS_Y,
                          SEGMENTED_BUTTONS_WIDTH,
                          SEGMENTED_BUTTONS_HEIGHT)

    my_segments = ['Tint'.localized, 'Background Images'.localized]
    my_segmented_control = UISegmentedControl.alloc.initWithItems(my_segments)
    my_segmented_control.frame = my_frame
    my_segmented_control.setSelectedSegmentIndex(0)
    my_segmented_control.addTarget(self,
                                   action: 'content_choice:' ,
                                   forControlEvents:UIControlEventValueChanged)

    self.view.addSubview(my_segmented_control)
  end

  def content_choice(sender)
    @my_search_bar.tintColor = nil
    @my_search_bar.backgroundImage = nil
    @my_search_bar.setImage(nil,
                                forSearchBarIcon: UISearchBarIconBookmark,
                                state:UIControlStateNormal
                                )

    case sender.selectedSegmentIndex
      #tinted background
      when 0
        @my_search_bar.tintColor = UIColor.blueColor
      when 1
      # image background
        @my_search_bar.backgroundImage = UIImage.imageNamed('/images/searchBarBackground')
        @my_search_bar.setImage(UIImage.imageNamed('/images/bookmarkImage'),
                                    forSearchBarIcon: UISearchBarIconBookmark,
                                    state: UIControlStateNormal
                                   )
        @my_search_bar.setImage(UIImage.imageNamed('/images/bookmarkImageHighlighted'),
                                    forSearchBarIcon: UISearchBarIconBookmark,
                                    state: UIControlStateHighlighted
                                   )
    end
  end


  # UISearchBarDelegate methods

  # called when the bookmark button inside the search bar is tapped
  def searchBarBookmarkButtonClicked(searchBar)
  end

  # called when keyboard search button pressed
  def searchBarSearchButtonClicked(searchBar)
    @my_search_bar.resignFirstResponder
  end

  # called when cancel button pressed
  def searchBarCancelButtonClicked(searchBar)
  	@my_search_bar.resignFirstResponder
  end
end