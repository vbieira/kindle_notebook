# frozen_string_literal: true

module KindleNotebook
  class AmazonAuth
    def initialize
      @url = ENV["KINDLE_READER_URL"]
      @login = ENV["EMAIL"]
      @password = ENV["PASSWORD"]
      @session = Capybara::Session.new(:chrome)
    end

    def sign_in
      session.visit(url)
      if session.find_latest_cookie_file
        session.restore_cookies
        session.refresh
      else
        submit_sign_in_form
      end
      session
    end

    private

    attr_accessor :session
    attr_reader :url, :login, :password

    def submit_otp_form
      print "Enter OTP: "
      mfa_code = gets.chomp
      session.fill_in("auth-mfa-otpcode", with: mfa_code)
      session.first("#auth-signin-button").click
    end

    def submit_sign_in_form
      session.click_button("Sign in with your account", match: :first)
      session.fill_in("ap_email", with: login)
      session.fill_in("ap_password", with: password)
      session.check("rememberMe")
      session.first("#signInSubmit").click
      submit_otp_form
      session.save_cookies
    end
  end
end
