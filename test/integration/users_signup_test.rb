require 'test_helper'
require 'sidekiq/testing'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    Sidekiq::Testing.inline!
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?

    log_in_as(user)
    assert_not is_logged_in?

    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?

    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?

    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'home/index'
    assert is_logged_in?
  end
end