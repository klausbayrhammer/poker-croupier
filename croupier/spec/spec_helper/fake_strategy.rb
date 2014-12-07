class SpecHelper::FakeStrategy < SpecHelper::DummyClass
  attr_reader :name

  def initialize(name = 'FakePlayer')
    @name = name
  end
end
