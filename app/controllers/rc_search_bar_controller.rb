class RcSearchBarController < UIViewController

  # TODO flesh our remaining UISearchBar delegate methods and implement Obj-C xib file rendition of Segmented Control
  attr_accessor :my_search_bar, :content_options, :my_segmented_control

  def viewDidLoad
  	super

  	self.title = 'SearchBar STUB'

  	self.my_search_bar = UISearchBar.alloc.initWithFrame(CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 44.0))
  	self.my_search_bar.delegate = self
  	self.my_search_bar.showsCancelButton = true
    self.my_search_bar.showsBookmarkButton = true
  	self.view.addSubview(self.my_search_bar)
    self.my_search_bar.autoresizingMask = UIViewAutoresizingFlexibleWidth
    self.view.backgroundColor = UIColor.whiteColor

    #frame for the segemented button
       my_frame = CGRectMake(10.0, 110.0, 300.0, 40.0)

       #Array of items to go inside the segment control
       #You can choose to add an UIImage as one of the items instead of NSString
       my_segments = ['Normal', 'Tinted', 'Background']

       self.my_segmented_control = UISegmentedControl.alloc.initWithItems(my_segments)
       self.my_segmented_control.frame = my_frame
       self.my_segmented_control.removeSegmentAtIndex(2, animated:true)
       self.my_segmented_control.insertSegmentWithTitle('Brown', atIndex:3, animated:true)
       self.my_segmented_control.setSelectedSegmentIndex(0)
       self.my_segmented_control.addTarget(self, action: 'which_colour:' , forControlEvents:UIControlEventValueChanged)

       #add the control to the view
       self.view.addSubview(self.my_segmented_control)

  end

  def content_choice(selected_segment_index)
    self.my_search_bar.tintColor = nil
    self.my_search_bar.backgroundImage = nil
    self.my_search_bar.setImage(nil, forSearchBarIcon: UISearchBarIconBookmark, state:UIControlStateNormal)

    case selected_segment_index
    when 1
      #tinted background
      self.my_search_bar.tintColor = UIColor.blueColor
    when 2
      # image background
      self.my_search_bar.backgroundImage = UIImage.imageNamed('searchBarBackground')
      self.my_search_bar.setImage(UIImage.imageNamed('bookmarkImage', forSearchBarIcon: UISearchBarIconBookmark, state: UIControlStateNormal))
      self.my_search_bar.setImage(UIImage.imageNamed('bookmarkImageHighlighted', forSearchBarIcon: UISearchBarIconBookmark, state: UIControlStateHighlighted))
    end
   end


  def which_colour(paramSender)
      #check if its the same control that triggered the change event
      if paramSender.isEqual(self.my_segmented_control)

          #get index position for the selected control
          selected_index = paramSender.selectedSegmentIndex

          #get the Text for the segmented control that was selected
          my_choice = paramSender.titleForSegmentAtIndex(selected_index)
          #let log this info to the console
          puts("Segment at position #{selected_index} with #{my_choice} text is selected")
      end
  end

  #pragma mark - UISearchBarDelegate

  # called when the bookmark button inside the search bar is tapped
  def searchBarBookmarkButtonClicked(searchBar)
  end

  # called when keyboard search button pressed
  def searchBarSearchButtonClicked(searchBar)
  	self.my_search_bar.resignFirstResponder
  end

  # called when cancel button pressed
  def searchBarCancelButtonClicked(searchBar)
  	self.my_search_bar.resignFirstResponder
  end
end