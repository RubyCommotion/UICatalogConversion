# Since the macro NSLocalizedString isn't available in RubyMotion
# code from https://github.com/rubymotion/sugarcube/blob/master/lib/sugarcube-localized/nsstring.rb

class NSString

  # This can be called as `'Hello'.localized` or `'Hello'._`.  The `str._`
  # syntax is meant to be reminiscent of gettext-style `_(str)`.
  def localized(value=nil, table=nil)
    @localized = NSBundle.mainBundle.localizedStringForKey(self, value:value, table:table)
  end
  alias _ localized

end