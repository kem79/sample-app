require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "", email: "user@invalid", password: "foo", password_confirmation: "bar" }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div#error_explanation ul li'
  end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {name: "name", email: "name@valid.com", password: "foobar", password_confirmation: "foobar"}
    end
    assert_template 'users/show'
    assert_not flash.empty?
    assert_select 'div.alert-success'
    assert is_logged_in?, "user should be automatically logged in upon registration"
  end
  
end
