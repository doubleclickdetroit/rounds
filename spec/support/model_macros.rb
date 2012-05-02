module ModelMacros
  SlideOriginal = Slide

  def ___foo
    before(:each) do
      Slide.any_instance.stub(:check_for_round_id).and_return(true)
    end
  end
end
