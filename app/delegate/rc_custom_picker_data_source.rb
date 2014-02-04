class RcCustomPickerDataSource < NSObject
  attr_accessor :custom_picker_array
  
  def init
    # use predetermined frame size
    super
    # create the data source for this custom picker
    #@custom_picker_array = []
    #
    #@custom_picker_array << RcCustomView.alloc.initWithTitle('Early Morning', image: UIImage.imageNamed('/images/12-6AM.png'))
    #@custom_picker_array << RcCustomView.alloc.initWithTitle('Late Morning', image: UIImage.imageNamed('/images/6-12AM.png'))
    #@custom_picker_array << RcCustomView.alloc.initWithTitle('Afternoon', image: UIImage.imageNamed('/images/12-6PM.png'))
    #@custom_picker_array << RcCustomView.alloc.initWithTitle('Evening', image: UIImage.imageNamed('/images/6-12PM.png'))
    
    # two assignment lines of code added below are to fix a custom picker mis-alignment issue using the original UICatalog code for iOS 6
    @time_of_day_titles =  %w(Early\ Morning Late\ Morning Afternoon Evening)
    @image_named = [ UIImage.imageNamed('/images/12-6AM.png'), UIImage.imageNamed('/images/6-12AM.png'),
                    UIImage.imageNamed('/images/12-6PM.png'), UIImage.imageNamed('/images/6-12PM.png') ]
    self
  end
  
  
  #pragma mark - UIPickerViewDataSource
  
  def pickerView(picker_view, widthForComponent: component)
    RcCustomView.view_width
  end
  
  def pickerView(picker_view, rowHeightForComponent: component)
    RcCustomView.view_height
  end
  
  def pickerView(picker_view, numberOfRowsInComponent: component)
    #@custom_picker_array.count
    @time_of_day_titles.count
  end
  
  def numberOfComponentsInPickerView(picker_view)
    1
  end
  
  #pragma mark - UIPickerViewDelegate
  
  # tell the picker which view to use for a given component and row, we have an array of views to show
  def pickerView(picker_view, viewForRow: row, forComponent: component, reusingView: view)
    # The call directly below causes mis-alignment issues with the pickers wheel window and its rows - IOS 7
    #@custom_picker_array[row]
    RcCustomView.alloc.initWithTitle(@time_of_day_titles[row], image: @image_named[row])
  end
end