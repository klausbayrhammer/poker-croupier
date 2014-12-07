class SpecHelper::DummyClass
  def method_missing(method, *args)

  end

  def respond_to?(method, include_private = false)
    true
  end
end