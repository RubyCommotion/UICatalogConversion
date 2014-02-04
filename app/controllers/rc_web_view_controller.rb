#pragma mark -

class RcWebViewController < UIViewController

  LEFT_MARGIN       = 20.0
  TOP_MARGIN        = 20.0
  RIGHT_MARGIN      = 20.0
  TWEEN_MARGIN      = 6.0

  TEXT_FIELD_HEIGHT = 30.0

  attr_accessor :my_web_view

  def viewDidLoad
    super
    
    self.title = 'Web'
    self.navigationController.navigationBar.translucent = false

    # create the URL input field
    text_field_frame = CGRectMake(LEFT_MARGIN, TWEEN_MARGIN, CGRectGetWidth(self.view.bounds) - (LEFT_MARGIN * 2.0), TEXT_FIELD_HEIGHT)
    url_field = UITextField.alloc.initWithFrame(text_field_frame)
    url_field.borderStyle = UITextBorderStyleBezel
    url_field.textColor = UIColor.blackColor
    url_field.delegate = self
    url_field.placeholder = '<enter a full URL>'
    url_field.text = 'http://www.apple.com'
    url_field.backgroundColor = UIColor.whiteColor
    url_field.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin
    url_field.returnKeyType = UIReturnKeyGo
    url_field.keyboardType = UIKeyboardTypeURL   # this makes the keyboard more friendly for typing URLs
    url_field.autocapitalizationType = UITextAutocapitalizationTypeNone    # don't capitalize
    url_field.autocorrectionType = UITextAutocorrectionTypeNo    # we don't like autocompletion while typing
    url_field.clearButtonMode = UITextFieldViewModeAlways
    url_field.setAccessibilityLabel('URL entry')
    self.view.addSubview(url_field)
      
    # create the UIWebView
    web_frame = self.view.frame
    web_frame.origin.y += (TWEEN_MARGIN * 2.0) + TEXT_FIELD_HEIGHT  # leave room for the URL input field
    web_frame.size.height -= 40.0
    self.my_web_view = UIWebView.alloc.initWithFrame(web_frame)
      
    self.my_web_view.backgroundColor = UIColor.whiteColor
    self.my_web_view.scalesPageToFit = true
    self.my_web_view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin)
    self.my_web_view.delegate = self
    self.view.addSubview(self.my_web_view)
    
    self.my_web_view.loadRequest(NSURLRequest.requestWithURL(NSURL.URLWithString('http://www.apple.com/')))
  end


  #pragma mark - UIViewController delegate methods

  def viewWillAppear(animated)
    super
     
    self.my_web_view.delegate = self   # setup the delegate as the web view is shown
  end

  def viewWillDisappear(animated)
    super
      
    self.my_web_view.stopLoading    # in case the web view is still loading its content
    self.my_web_view.delegate = nil    # disconnect the delegate as the webview is hidden
    UIApplication.sharedApplication.networkActivityIndicatorVisible = false
  end

  # this helps dismiss the keyboard when the 'Done' button is clicked
  def textFieldShouldReturn(text_field)
    text_field.resignFirstResponder
    self.my_web_view.loadRequest(NSURLRequest.requestWithURL(NSURL.URLWithString(text_field.text)))
    
    true
  end


  #pragma mark - UIWebViewDelegate

  def webViewDidStartLoad(webView)
    # starting the load, show the activity indicator in the status bar
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true
  end

  def webViewDidFinishLoad(webView)
    # finished loading, hide the activity indicator in the status bar
    UIApplication.sharedApplication.networkActivityIndicatorVisible = false;
  end

  def webView(webView, didFailLoadWithError:error)
    # load error, hide the activity indicator in the status bar
    UIApplication.sharedApplication.networkActivityIndicatorVisible = false

    # report the error inside the webview
    error_string = NSString.stringWithFormat("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\"><html><head><meta http-equiv='Content-Type' content='text/html;charset=utf-8'><title></title></head><body><div style='width: 100%%; text-align: center; font-size: 36pt; color: red;'>An error occurred:<br>%@</div></body></html>", error.localizedDescription)
    self.my_web_view.loadHTMLString(error_string, baseURL:nil)
  end

end