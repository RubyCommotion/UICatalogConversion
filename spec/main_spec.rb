describe "Application 'UICatalogConversion'" do
  before do
    @app = UIApplication.sharedApplication
  end

  it "has one window" do
    @app.windows.size.should == 2
  end
end
