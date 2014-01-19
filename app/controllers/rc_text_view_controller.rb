class RcTextViewController < UIViewController
#textView

  def setupTextView
    @text_view = UITextView.alloc.initWithFrame(self.view.frame).tap { |tv|
      tv.textColor = UIColor.blackColor
      tv.font = UIFont.fontWithName('Arial', size: 18.0)
      tv.delegate = self
      tv.backgroundColor = UIColor.whiteColor
      tv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    }
    textToAdd = "Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.\r\rThis text view can also use attributed strings."

    attrString = NSMutableAttributedString.alloc.initWithString(textToAdd)

    # make red text
    attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor, range: NSMakeRange(attrString.length - 19, 19))

    # make blue text
    attrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor, range: NSMakeRange(attrString.length - 23, 3))
    attrString.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber.numberWithInteger(1), range: NSMakeRange(attrString.length - 23, 3))

    @text_view.setAttributedText(attrString)

    @text_view.returnKeyType = UIReturnKeyDefault
    @text_view.keyboardType = UIKeyboardTypeDefault # use the default type input method (entire keyboard)
    @text_view.scrollEnabled = true

    # note : for UITextView, if you don't like auto correction while typing use:
    # myTextView.autocorrectionType = UITextAutocorrectionTypeNo

    self.view.addSubview(@text_view)
  end

  def viewDidLoad
    super
    self.title = 'TextViewTitle'
    self.setupTextView
  end

  def viewWillAppear(animated)
    super
    # listen for keyboard hide/show notifications so we can properly adjust the table's height
    default_notification_center.addObserver(self, selector: 'keyboardWillShow:', name: UIKeyboardWillShowNotification, object: nil)
    default_notification_center.addObserver(self, selector: 'keyboardWillHide:', name: UIKeyboardWillHideNotification, object: nil)
  end


#pragma mark - Notifications

  def adjustViewForKeyboardReveal(showKeyboard, notificationInfo: notificationInfo)

    # the keyboard is showing so resize the table 's height
    keyboardRect = notificationInfo.objectForKey(UIKeyboardFrameEndUserInfoKey).CGRectValue
    animationDuration =notificationInfo.objectForKey(UIKeyboardAnimationDurationUserInfoKey).doubleValue
    frame = @text_view.frame
    # the keyboard rect' s width and height are reversed in landscape
    adjustDelta = (UIDevice.currentDevice.orientation == UIDeviceOrientationPortrait) ? CGRectGetHeight(keyboardRect) : CGRectGetWidth(keyboardRect)
    if showKeyboard
      frame.size.height -= adjustDelta
    else
      frame.size.height += adjustDelta
      do_with_animations(animationDuration) { @text_view.frame = frame }
    end
  end

  def keyboardWillShow(aNotification)
    adjustViewForKeyboardReveal(true, notificationInfo: aNotification.userInfo)
  end

  def keyboardWillHide(aNotification)
    adjustViewForKeyboardReveal(false, notificationInfo: aNotification.userInfo)
  end

  def viewDidDisappear(animated)
    super

    default_notification_center.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    default_notification_center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  end

#pragma mark - UITextViewDelegate

  def saveAction(sender)
    # finish typing text/dismiss the keyboard by removing it as the first responder
    #
    @text_view.resignFirstResponder
    self.navigationItem.rightBarButtonItem = nil # this will remove the "save" button
  end

  def textViewDidBeginEditing(textView)
    # provide my own Save button to dismiss the keyboard
    saveItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemDone, target: self, action: 'saveAction:')
    self.navigationItem.rightBarButtonItem = saveItem
  end

  private

  def do_with_animations(animationDuration)
    UIView.beginAnimations('ResizeForKeyboard', context: nil)
    UIView.setAnimationDuration(animationDuration)
    yield
    UIView.commitAnimations
  end

  def default_notification_center
    NSNotificationCenter.defaultCenter
  end
end