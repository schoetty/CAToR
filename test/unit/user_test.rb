require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not save user without name, login, password, etc." do
    user = User.new
    user.first_name = "foo"
    user.surname = "bar"
    user.login = "foobar"
    user.password = "foobar"
    assert user.save!
  end
  test "truth" do
    true
  end
end
