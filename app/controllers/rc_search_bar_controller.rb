class RcSearchBarController < UIViewController

  # TODO flesh our remaining UISearchBar delegate methods and implement Obj-C xib file rendition of Segmented Control
  attr_accessor :my_search_bar, :content_options

  def viewDidLoad
  	super

  	self.title = 'SearchBar STUB'

  	self.my_search_bar = UISearchBar.alloc.initWithFrame(CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 44.0))
  	self.my_search_bar.delegate = self
  	self.my_search_bar.showsCancelButton = true
    self.my_search_bar.showsBookmarkButton = true
  	self.view.addSubview(self.my_search_bar)
    self.my_search_bar.autoresizingMask = UIViewAutoresizingFlexibleWidth
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