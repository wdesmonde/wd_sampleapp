class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
      params[:session][:password])
      if user.nil?
        # create an error message and re-render the sign-in form
        flash.now[:error] = "Invalid email/password combination."
        @title = "Sign in"
        render 'new'
      else
        # sign-in the user and redirect to the user's show page
        sign_in user
        redirect_to user
      end
  end

  def destroy
  end

end
