require 'test_helper'

class TestVersion < Minitest::Test
  def test_version
    assert_equal '0.1.0.alpha', Fronton.version
  end
end
