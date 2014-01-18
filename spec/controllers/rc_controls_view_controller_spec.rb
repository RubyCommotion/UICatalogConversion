describe 'RcControlsViewController' do
  tests RcControlsViewController

  def controller
    rotate_device to: :portrait, button: :bottom
    @controls_view_controller = RcControlsViewController.alloc.initWithStyle(UITableViewStyleGrouped)
  end

  after do
    @controls_view_controller = nil
  end

  it 'sets the title' do
    @controls_view_controller.title.should == 'Controls'
  end

  it 'should have 1 section' do
    @controls_view_controller.instance_variable_get('@data_source_array').count.should == 1
  end
end