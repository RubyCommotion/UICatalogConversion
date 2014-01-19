describe 'RcTextFieldViewController' do
  tests RcTextFieldViewController

  def controller
    rotate_device to: :portrait, button: :bottom
    @text_field_view_controller = RcTextFieldViewController.alloc.initWithStyle(UITableViewStyleGrouped)
  end

  after do
    @text_field_view_controller = nil
  end

  it "should create view" do
    @text_field_view_controller.should.not.be.nil
  end

  it 'sets the title' do
    @text_field_view_controller.title.should == 'TextFieldTitle'
  end

  it 'should have 4 rows' do
    @text_field_view_controller.instance_variable_get('@data_source_array').count.should == 4
  end

  it 'should enter text in normal textedit' do
    view('NormalTextField').text = "allo mon coco"
    view('NormalTextField').text.should == "allo mon coco"
  end

  it 'should have 4 UITextField' do
    views(UITextField).count.should == 4
  end

end