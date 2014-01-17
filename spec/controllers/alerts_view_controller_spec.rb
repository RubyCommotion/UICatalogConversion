describe 'RCAlertsViewController' do
  tests RCAlertsViewController

  def controller
    rotate_device to: :portrait, button: :bottom
    @alerts_view_controller = RCAlertsViewController.alloc.initWithStyle(UITableViewStyleGrouped)
  end

  after do
    @alerts_view_controller = nil
  end

  it 'sets the title' do
    @alerts_view_controller.title.should == 'AlertTitle'
  end

  it 'should have 7 rows' do
    @alerts_view_controller.instance_variable_get('@data_source_array').count.should == 7
  end

  it 'should alert' do
    view('Show Simple').should.not == nil
  end

end