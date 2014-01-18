class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    main_view_controller = RcMainViewController.alloc.init
    UINavigationBar.appearance.setBarTintColor(UIColor.darkGrayColor)
    # add the navigation controller's view to the window as the root view controller
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(main_view_controller)
    @window.makeKeyAndVisible
    true
  end
end
