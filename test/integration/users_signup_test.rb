require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    password = "a" * 6
    @user_form = {
      name:                  "username",
      email:                 "user@example.com",
      password:              password,
      password_confirmation: password
    }
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count' do
      post users_path, params: { user: @user_form }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select 'div.alert-success'
  end

  test "invalid signup information name blank" do
    get signup_path
    @user_form[:name] = ''
    assert_no_difference 'User.count' do
      post signup_path, params: { user: @user_form }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger', 'The form contains 1 error.'
    assert_select 'li', "Name can't be blank"
    assert_select 'form', :action => signup_path
  end

  test "invalid signup information name long" do
    get signup_path
    @user_form[:name] = 'a' * 51
    assert_no_difference 'User.count' do
      post signup_path, params: { user: @user_form }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger', 'The form contains 1 error.'
    assert_select 'li', /Name is too long/
    assert_select 'form', :action => signup_path
  end

  test "invalid signup information email blank" do
    get signup_path
    @user_form[:email] = ''
    assert_no_difference 'User.count' do
      post signup_path, params: { user: @user_form }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger', 'The form contains 2 errors.'
    assert_select 'li', "Email can't be blank"
    assert_select 'li', "Email is invalid"
    assert_select 'form', :action => signup_path
  end

  test "invalid signup information email long" do
    get signup_path
    email_head = 'a' * (257 - "@example.com".length)
    @user_form[:email] = "#{email_head}@example.com"
    assert_no_difference 'User.count' do
      post signup_path, params: { user: @user_form }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger', 'The form contains 1 error.'
    assert_select 'li', /Email is too long/
    assert_select 'form', :action => signup_path
  end

  test "invalid signup information email invalid" do
    get signup_path
    @user_form[:email] = 'user@invalid'
    assert_no_difference 'User.count' do
      post signup_path, params: { user: @user_form }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger', 'The form contains 1 error.'
    assert_select 'li', "Email is invalid"
    assert_select 'form', :action => signup_path
  end

  test "invalid signup information password short" do
    get signup_path
    @user_form[:password] = @user_form[:password_confirmation] = 'a' * 5
    assert_no_difference 'User.count' do
      post signup_path, params: { user: @user_form }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger', 'The form contains 1 error.'
    assert_select 'li', /Password is too short/
    assert_select 'form', :action => signup_path
  end

  test "invalid signup information confirmation doesn't match" do
    get signup_path
    @user_form[:password_confirmation] = 'b' * 6
    assert_no_difference 'User.count' do
      post signup_path, params: { user: @user_form }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger', 'The form contains 1 error.'
    assert_select 'li', "Password confirmation doesn't match Password"
    assert_select 'form', :action => signup_path
  end
end
