#pragma mark -

class RcWebViewController < UIViewController

  LEFT_MARGIN       = 20.0
  TOP_MARGIN        = 20.0
  RIGHT_MARGIN      = 20.0
  TWEEN_MARGIN      = 6.0

  TEXT_FIELD_HEIGHT = 30.0

  attr_accessor :myWebView

  def viewDidLoad
    super
    
    self.title = "Web"
    self.navigationController.navigationBar.translucent = false

    # create the URL input field
    textFieldFrame = CGRectMake(LEFT_MARGIN, TWEEN_MARGIN, CGRectGetWidth(self.view.bounds) - (LEFT_MARGIN * 2.0), TEXT_FIELD_HEIGHT)
    urlField = UITextField.alloc.initWithFrame(textFieldFrame)
    urlField.borderStyle = UITextBorderStyleBezel
    urlField.textColor = UIColor.blackColor
    urlField.delegate = self
    urlField.placeholder = "<enter a full URL>"
    urlField.text = "http://www.apple.com"
    urlField.backgroundColor = UIColor.whiteColor
    urlField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin
    urlField.returnKeyType = UIReturnKeyGo
    urlField.keyboardType = UIKeyboardTypeURL   # this makes the keyboard more friendly for typing URLs
    urlField.autocapitalizationType = UITextAutocapitalizationTypeNone    # don't capitalize
    urlField.autocorrectionType = UITextAutocorrectionTypeNo    # we don't like autocompletion while typing
    urlField.clearButtonMode = UITextFieldViewModeAlways
    urlField.setAccessibilityLabel("URL entry")
    self.view.addSubview(urlField)
      
    # create the UIWebView
    webFrame = self.view.frame
    webFrame.origin.y += (TWEEN_MARGIN * 2.0) + TEXT_FIELD_HEIGHT  # leave room for the URL input field
    webFrame.size.height -= 40.0
    self.myWebView = UIWebView.alloc.initWithFrame(webFrame)
      
    self.myWebView.backgroundColor = UIColor.whiteColor
    self.myWebView.scalesPageToFit = true
    self.myWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin)
    self.myWebView.delegate = self
    self.view.addSubview(self.myWebView)
    
    self.myWebView.loadRequest(NSURLRequest.requestWithURL(NSURL.URLWithString("http://www.apple.com/")))
  end


  #pragma mark - UIViewController delegate methods

  def viewWillAppear(animated)
    super
     
    self.myWebView.delegate = self   # setup the delegate as the web view is shown
  end

  def viewWillDisappear(animated)
    super
      
    self.myWebView.stopLoading    # in case the web view is still loading its content
    self.myWebView.delegate = nil    # disconnect the delegate as the webview is hidden
    UIApplication.sharedApplication.networkActivityIndicatorVisible = false
  end

  # this helps dismiss the keyboard when the "Done" button is clicked
  def textFieldShouldReturn(textField)
    textField.resignFirstResponder
    self.myWebView.loadRequest(NSURLRequest.requestWithURL(NSURL.URLWithString(textField.text)))
    
    return true
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
    errorString = NSString.stringWithFormat("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\"><html><head><meta http-equiv='Content-Type' content='text/html;charset=utf-8'><title></title></head><body><div style='width: 100%%; text-align: center; font-size: 36pt; color: red;'>An error occurred:<br>%@</div></body></html>", error.localizedDescription)
    self.myWebView.loadHTMLString(errorString, baseURL:nil)
  end

end