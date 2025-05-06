class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url = "http://localhost:3000/login"
    mail(to: @user.email, subject: "Welcome to stock app!", body: "Hi Welcome to Stock App! We're glad you're here.")
  end
end
