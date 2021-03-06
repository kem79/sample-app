require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:marc)
  end
  
  test "unsuccessfull edit" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: {name: "",
                                    email: "foo@invalid",
                                    password: "foo",
                                    password_confirmation: "baz" }
    assert_template 'users/edit'
  end
  
  test "successful edit with user forwarding" do
    get edit_user_path(@user)
    log_in_as @user
    assert_redirected_to edit_user_path(@user), "User should be redirected to user edit page"
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password: "foobar",
                                    password_confirmation: "foobar"}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
end
