require 'test_helper'

class TestVersion < Minitest::Test
  def test_version
    assert_equal '0.0.0', Fronton.version
  end
end
