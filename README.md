UICatalogConversion App
=======================

The UICatalogConversion app is a conversion of Apple's iOS UICatalog source code into RubyMotion source code. This first iteration does not include any spec tests - testing will be added in iteration two.
This is contrary to normal TDD sequence but was done aon an exception basis for this first Ruby Commotion community's app.

RubyMotion Web Site: http://www.rubymotion.com

Apple's UICatalog About:https://developer.apple.com/library/ios/samplecode/uicatalog/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007710-Intro-DontLinkElementID_2

Apple's UICatalog Readme:  https://developer.apple.com/library/ios/samplecode/uicatalog/Listings/ReadMe_txt.html#//apple_ref/doc/uid/DTS40007710-ReadMe_txt-DontLinkElementID_10

Purpose of UICatalogConversion App
==================================

This conversion of UICatalog's Objective-C code into RubyMotion source code is meant to serve two purposes:

  1. to provide template code for all iOS 7 UI elements (copy for re-use purposes)

  2. to demonstrate how Objective-C code is converted to RubyMotion syntax.


The Code Conversion is Not Completely 1:1
=========================================

As demonstration code for converting Objective-C to RubyMotion source code, an attempt was made to align, as much as possible, each of the code bases, however,
there are several ways in which the alignment is not 1:1.

  1. The current Apple UICatalog example is iOS 6 compliant and the RubyMotion code is iOS 7 compliant.

  2. To demonstrate how concise Ruby syntax is, things like Objective-C's return statement were removed.
     The last value referenced in a Ruby method is returned by default. This is just one example.

  3. The custom UIPicker code in the Objective-C code did not render correctly and, as such, a fair amount of code was re-written to correct the problem.

  4. RubyMotion eliminates the need for Objective-C header files.

  5. Under Ruby, an object's methods and properties types are determined by "Duck Typing" which makes the code that much more concise. http://en.wikipedia.org/wiki/Duck_typing

  6. The Objective-C UICatalog app uses Interface Builder to create many of the UI views - the RubyMotion conversion created the UI views using code.
     RubyMotion is capable of using IB files but it was decided to show how IB views can be converted into code.



UICatalogConversion App
=======================
 
This UICatalogConversion app is a demo of many of the views and controls in the UIKit framework, along with their various properties and styles.
If you need RubyMotion code to create specific UI controls or views, refer to this sample and it should give you a good head start in building your UI.
In most cases, you can simply copy and paste the code snippets you need. When images or custom views are used, accessibility code has been added.
Using the iOS Accessibility API enhances the user experience of VoiceOver users.

 
Using the Sample
================

Please see the RubyMotion web site for runtime requirements - http://www.rubymotion.com/developer-center/guides/getting-started/

In most areas of this example, as you see various UI elements, you will see a corresponding explanation as to where you can find the code.
So for example the Alerts page - there will be a label that identifies the source file for the Alert code e.g. rc_alerts_view_controller.rb".
This means refer to the rc_alerts_view_controller.rb
 
Buttons - This UIViewController or page contains various kinds of UIButton controls complete with background images.
 
Controls - This page contains other miscellaneous UIControl classes helpful in building your user interface including switch, slider page, and progress indicator.
 
TextFields - This page hosts different kinds of UITextField controls.  It also demonstrates how to handle the keyboard, particularly where text fields are placed.
 
SearchBar - This pages exhibits the UISearchBar control.
 
TextView - This page exhibits the use of UITextView.
 
Pickers - This page shows the varying picker style view including UIPickerView and UIDatePicker.  UIDatePicker variants include date, time, date and time, as well as a counter.  A custom picker is also included in this page.
 
Images - Shows how you can create a UIImageView containing a group of images used for animations or slide show.
 
Web - Shows how to properly use a UIWebView and target websites using NSURL class.
 
Segment - This page adds several types of UISegmentedControl views.
 
Toolbar - This page shows how to use UIToolbar and adds several kinds of UIBarButtonItems.
 
Alerts - This page shows how to use UIActionSheet and UIAlertView to display varying kinds of alerts that require user actions.  This includes simple alerts, OK/Cancel alerts, and alerts with custom titled buttons.
 
Transitions - This page shows how to implement view "flipping" and "curl" animations between two different views using a category of UIView called UIViewAnimation.
 
Localization - A work around was used to support localization under RubyMotion - see the Helper and Resources folder for applicable files.

Delegate Folder -a delegate folder was added to the usual RubyMotion folder build the happens with the RM command motion create MyApp


Contributors
============

Salman Ansari, Yaakov Gamliel, Forrest Grant, René Köcher, Dennis Major, Matthew Nguyen, Yvan Ross and Jack Watson-Hamblin
