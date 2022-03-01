require 'test_helper'
require "validator/email_validator"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = active_user
  end
  test "name_validation" do
    # 名前未入力
    user = User.new(email: "test@email.com", password: "password")
    user.save
    required_msg = ["名前を入力してください"]
    assert_equal(required_msg, user.errors.full_messages)
    # 文字数制限
    max = 30
    name = "a" * (max + 1)
    user.name = name
    user.save
    maxlength_msg = ["名前は30文字以内で入力してください"]
    assert_equal(maxlength_msg, user.errors.full_messages)
    # 30文字以内は保存されているか
    name = "ア" * max
    user.name = name
    assert_difference("User.count", 1) do
      user.save
    end
  end
  test "email_validation" do
    # 入力必須
    user = User.new(name: "test", password: "password")
    user.save
    require_msg = ["メールアドレスを入力してください"]
    assert_equal(require_msg, user.errors.full_messages)
    # 文字数制限
    max = 300
    domain = "@example.com"
    email = "a" * ((max + 1) - domain.length) + domain
    assert max < email.length
    user.email = email
    user.save
    maxlength_msg = ["メールアドレスは255文字以内で入力してください"]
    assert_equal(maxlength_msg, user.errors.full_messages)
    # 書式チェック
    ok_emails = %w(
      A@EX.COM
      a@ex.com
      a_a@ex.com
      a@e.co.js
      1.1@ex.com
      a.aa@ex.com
    )
    ok_emails.each do |email|
      user.email = email
      assert user.save
    end
    ng_emails = %w(
      aaa
      a.ex.com
      a@|.com
      a@ex.
      a@ex@co.jp
    )
    ng_emails.each do |email|
      user.email = email
      user.save
      format_msg = ["メールアドレスは有効ではありません"]
      assert_equal(format_msg, user.errors.full_messages)
    end
  end
  test "email_downcase" do
    email = "USER@EXAMPLE.COM"
    user = User.new(email: email)
    user.save
    assert user.email === email.downcase
  end
  test "password_validation" do
    # 入力必須
    user = User.new(name: "test", email: "test@example.com")
    user.save
    required_msg = ["パスワードを入力してください"]
    assert_equal(required_msg, user.errors.full_messages)

    # min文字以上
    min = 8
    user.password = "a" * (min - 1)
    user.save
    minlength_msg = ["パスワードは8文字以上で入力してください"]
    assert_equal(minlength_msg, user.errors.full_messages)

    # max文字以下
    max = 72
    user.password = "a" * (max + 1)
    user.save
    maxlength_msg = ["パスワードは72文字以内で入力してください"]
    assert_equal(maxlength_msg, user.errors.full_messages)

    # 書式チェック VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
    ok_passwords = %w(
      pass---word
      ________
      12341234
      ____pass
      pass----
      PASSWORD
    )
    ok_passwords.each do |pass|
      user.password = pass
      assert user.save
    end

    ng_passwords = %w(
      pass/word
      pass.word
      |~=?+"a"
      １２３４５６７８
      ＡＢＣＤＥＦＧＨ
      password@
    )
    format_msg = ["パスワードは半角英数字・ﾊｲﾌﾝ・ｱﾝﾀﾞｰﾊﾞｰが使えます"]
    ng_passwords.each do |pass|
      user.password = pass
      user.save
      assert_equal(format_msg, user.errors.full_messages)
    end
  end
end