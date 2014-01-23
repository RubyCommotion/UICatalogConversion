class RcMainViewController < UITableViewController
  attr_accessor :menu_list

  CELL_IDENTIFIER = "MyIdentifier"

  def viewDidLoad
    super
    # set our view controller as delegate and data source for the table view
    tableView.delegate = self
    tableView.dataSource = self
    
    # construct the array of page descriptions we will use (each description is a hash) 
    self.menu_list = []

    # instantiate VCs for the menu
    buttons_view_controller = RcButtonsViewController.alloc.initWithStyle(UITableViewStyleGrouped)
    controls_view_controller = RcControlsViewController.alloc.initWithStyle(UITableViewStylePlain)
    text_field_view_controller = RcTextFieldViewController.alloc.initWithStyle(UITableViewStylePlain)
    search_bar_view_controller = RcSearchBarController.alloc.init
    text_view_controller = RcTextViewController.alloc.init
    picker_view_controller = RcPickerViewController.alloc.init
    images_view_controller = RcImagesViewController.alloc.init
    web_view_controller = RcWebViewController.alloc.init
    segment_view_controller = RcSegmentViewController.alloc.init
#   toolbar_view_controller = RcToolbarViewController.alloc.init
    alerts_view_controller = RcAlertsViewController.alloc.initWithStyle(UITableViewStylePlain)
    transition_view_controller = RcTransitionViewController.alloc.init

    # add the info needed for each VC
    self.menu_list << {:title => "ButtonsTitle"._, :explain => "ButtonsExplain"._, :view_controller => buttons_view_controller}
    self.menu_list << {:title => "Controls", :explain => "Various uses of UIControl", :view_controller => controls_view_controller}
    self.menu_list << {:title => "TextFields", :explain => "Various uses of UITextField", :view_controller => text_field_view_controller}
    self.menu_list << {:title => 'SearchBar'.localized, :explain => 'SearchBarExplain'.localized, :view_controller => search_bar_view_controller}
    self.menu_list << {:title => "Text View", :explain => "An example of a TextView", :view_controller => text_view_controller}
    self.menu_list << {:title => "PickerTitle".localized, :explain => "PickerExplain".localized, :view_controller => picker_view_controller}
    self.menu_list << {:title => "ImagesTitle".localized, :explain => "ImagesExplain".localized, :view_controller => images_view_controller}
    self.menu_list << {:title => "Web", :explain => "Use of UIWebView", :view_controller => web_view_controller}
    self.menu_list << {:title => "Segments", :explain => "Various uses of UISegmentedControl", :view_controller =>  segment_view_controller}
#    self.menu_list << {:title => "Toolbar", :title => "Uses of UIToolbar", :view_controller => toolbar_view_controller}
    self.menu_list << {:title => "Alerts", :explain => "Various uses of UIAlertView, UIActionSheet", :view_controller => alerts_view_controller}
    self.menu_list << {:title => "Transitions", :explain => "Shows UIViewAnimationTrasitions", :view_controller => transition_view_controller}

    # register our cell ID for later when we are asked for UITableViewCells (iOS 6.0 a later)
    tableView.registerClass(RcMyTableViewCell, forCellReuseIdentifier: CELL_IDENTIFIER)
  end

  def viewWillAppear(animated)
    super
    # this UIViewController is about to re-appear, make sure we remove the current selection in our table view
    table_selection = tableView.indexPathForSelectedRow
    tableView.deselectRowAtIndexPath(table_selection, animated:false)

    # some over view controller could have changed our nav bar tint color, so reset it here 
    UINavigationBar.appearance.setBarTintColor(UIColor.lightGrayColor)
  end

  # UITableViewDelegate 
  # the table's selection has changed, switch to that item's UIViewController

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    #target_viewcontroller = self.menu_list.objectAtIndex(indexPath.row).objectForKey(:view_controller)
    target_viewcontroller = self.menu_list[indexPath.row][:view_controller]
    self.navigationController.pushViewController(target_viewcontroller, animated:true)
  end

  # UITableViewDataSource
  # tell our table how many rows it will have, in our case the size of our menuList

  def tableView(tableView, numberOfRowsInSection:section)
    self.menu_list.count
  end
  
  # tell our table what kind of cell to use and its title for the given row

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER)
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell.textLabel.text = self.menu_list.objectAtIndex(indexPath.row).objectForKey(:title)
    cell.detailTextLabel.text = self.menu_list.objectAtIndex(indexPath.row).objectForKey(:explain)
    cell
  end

end

