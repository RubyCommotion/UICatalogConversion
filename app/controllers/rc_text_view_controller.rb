class RcTextViewController < UIViewController

  def setup_text_view
    @text_view = UITextView.alloc.initWithFrame(self.view.frame).tap { |tv|
      tv.textColor = UIColor.blackColor
      tv.font = UIFont.fontWithName('Arial', size: 18.0)
      tv.delegate = self
      tv.backgroundColor = UIColor.whiteColor
      tv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
    }
    text_to_add = "Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.\r\rThis text view can also use attributed strings."

    attr_string = NSMutableAttributedString.alloc.initWithString(text_to_add)

    # make red text
    attr_string.addAttribute(NSForegroundColorAttributeName,
                             value: UIColor.redColor,
                             range: NSMakeRange(attr_string.length - 19, 19))

    # make blue text
    attr_string.addAttribute(NSForegroundColorAttributeName,
                             value: UIColor.blueColor,
                             range: NSMakeRange(attr_string.length - 23, 3))
    attr_string.addAttribute(NSUnderlineStyleAttributeName,
                             value: NSNumber.numberWithInteger(1),
                             range: NSMakeRange(attr_string.length - 23, 3))

    @text_view.setAttributedText(attr_string)

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
    self.setup_text_view
  end

  def viewWillAppear(animated)
    super
    # listen for keyboard hide/show notifications so we can properly adjust the table's height
    default_notification_center.addObserver(self,
                                            selector: 'keyboardWillShow:',
                                            name: UIKeyboardWillShowNotification,
                                            object: nil)
    default_notification_center.addObserver(self,
                                            selector: 'keyboardWillHide:',
                                            name: UIKeyboardWillHideNotification,
                                            object: nil)
  end


#pragma mark - Notifications

  def adjustViewForKeyboardReveal(show_keyboard, notificationInfo: notification_info)

    # the keyboard is showing so resize the table 's height
    keyboardRect = notification_info.objectForKey(UIKeyboardFrameEndUserInfoKey).CGRectValue
    animationDuration =notification_info.objectForKey(UIKeyboardAnimationDurationUserInfoKey).doubleValue
    frame = @text_view.frame
    # the keyboard rect' s width and height are reversed in landscape
    adjustDelta = (UIDevice.currentDevice.orientation == UIDeviceOrientationPortrait) ? CGRectGetHeight(keyboardRect) : CGRectGetWidth(keyboardRect)
    if show_keyboard
      frame.size.height -= adjustDelta
    else
      frame.size.height += adjustDelta
      do_with_animations(animationDuration) { @text_view.frame = frame }
    end
  end

  def keyboardWillShow(a_notification)
    adjustViewForKeyboardReveal(true, notificationInfo: a_notification.userInfo)
  end

  def keyboardWillHide(a_notification)
    adjustViewForKeyboardReveal(false, notificationInfo: a_notification.userInfo)
  end

  def viewDidDisappear(animated)
    super

    default_notification_center.removeObserver(self,
                                               name: UIKeyboardWillShowNotification,
                                               object: nil)
    default_notification_center.removeObserver(self,
                                               name: UIKeyboardWillHideNotification,
                                               object: nil)
  end

#pragma mark - UITextViewDelegate

  def save_action(sender)
    # finish typing text/dismiss the keyboard by removing it as the first responder
    #
    @text_view.resignFirstResponder
    self.navigationItem.rightBarButtonItem = nil # this will remove the 'save' button
  end

  def textViewDidBeginEditing(textView)
    # provide my own Save button to dismiss the keyboard
    save_item = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemDone,
                                                                  target: self,
                                                                  action: 'save_action:')
    self.navigationItem.rightBarButtonItem = save_item
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