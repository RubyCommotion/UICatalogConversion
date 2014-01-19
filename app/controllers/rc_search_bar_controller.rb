class RcSearchBarController < UIViewController

  # TODO flesh our remaining UISearchBar delegate methods and implement Obj-C xib file rendition of Segmented Control
  attr_accessor :mySearchBar, :contentOptions

  def viewDidLoad
  	super

  	self.title = 'SearchBar STUB'

  	self.mySearchBar = UISearchBar.alloc.initWithFrame(CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 44.0))
  	self.mySearchBar.delegate = self
  	self.mySearchBar.showsCancelButton = true
    self.mySearchBar.showsBookmarkButton = true
  	self.view.addSubview(self.mySearchBar)
    self.mySearchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth
  end

  def contentChoice(selectedSegmentIndex)
    self.mySearchBar.tintColor = nil
    self.mySearchBar.backgroundImage = nil
    self.mySearchBar.setImage(nil, forSearchBarIcon: UISearchBarIconBookmark, state:UIControlStateNormal)

    case selectedSegmentIndex
    when 1
      #tinted background
      self.mySearchBar.tintColor = UIColor.blueColor
    when 2
      # image background
      self.mySearchBar.backgroundImage = UIImage.imageNamed('searchBarBackground')
      self.mySearchBar.setImage(UIImage.imageNamed('bookmarkImage', forSearchBarIcon: UISearchBarIconBookmark, state: UIControlStateNormal))
      self.mySearchBar.setImage(UIImage.imageNamed('bookmarkImageHighlighted', forSearchBarIcon: UISearchBarIconBookmark, state: UIControlStateHighlighted))
    end
   end

  #pragma mark - UISearchBarDelegate

  # called when the bookmark button inside the search bar is tapped
  def searchBarBookmarkButtonClicked(searchBar)
  end

  # called when keyboard search button pressed
  def searchBarSearchButtonClicked(searchBar)
  	self.mySearchBar.resignFirstResponder
  end

  # called when cancel button pressed
  def searchBarCancelButtonClicked(searchBar)
  	self.mySearchBar.resignFirstResponder
  end
end