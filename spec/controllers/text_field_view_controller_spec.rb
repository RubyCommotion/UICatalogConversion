describe 'RCTextFieldViewController' do
  tests RCTextFieldViewController

  def controller
    rotate_device to: :portrait, button: :bottom
    @text_field_view_controller = RCTextFieldViewController.alloc.initWithStyle(UITableViewStyleGrouped)
  end

  after do
    @text_field_view_controller = nil
  end

  it "should create view" do
    @text_field_view_controller.should.not.be.nil
  end

  # it 'sets the title' do
  #   @text_field_view_controller.title.should == 'TextFieldTitle'
  # end

  # it 'should have 4 rows' do
  #   @text_field_view_controller.instance_variable_get('@data_source_array').count.should == 7
  # end

  # it 'should alert' do
  #   view('Show Simple').should.not == nil
  # end

end