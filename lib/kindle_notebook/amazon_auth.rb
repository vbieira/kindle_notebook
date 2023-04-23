# frozen_string_literal: true

module KindleNotebook
  class AmazonAuth
    # TODO: this could be in the gem's configuration instead
    def initialize
      @auth_session = Capybara::Session.new(ENV["SELENIUM_DRIVER"].to_sym)
    end

    def sign_in
      auth_session.visit(KindleNotebook.configuration.url)
      return auth_session if valid_cookies?

      submit_sign_in_form
      auth_session.save_cookies
      auth_session
    end

    private

    attr_reader :auth_session

    def valid_cookies?
      auth_session.find_latest_cookie_file
      auth_session.restore_cookies
      auth_session.refresh
      auth_session.has_current_path?("/kindle-library")
    end

    def submit_otp_form
      print "Enter OTP: "
      mfa_code = gets.chomp
      auth_session.fill_in("auth-mfa-otpcode", with: mfa_code)
      auth_session.first("#auth-signin-button").click
    end

    def submit_sign_in_form
      auth_session.click_button("Sign in with your account", match: :first)
      auth_session.fill_in("ap_email", with: KindleNotebook.configuration.login)
      auth_session.fill_in("ap_password", with: KindleNotebook.configuration.password)
      auth_session.check("rememberMe")
      auth_session.first("#signInSubmit").click
      submit_otp_form if mfa?
    end

    def mfa?
      auth_session.current_path.match?(%r{ap/mfa})
    end
  end
end
