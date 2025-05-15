module RequestSpecHelper
  def auth_headers_for(user)
    post "/users/tokens/sign_in", params: {
                               email: user.email,
                               password: user.password,
                             }

    json = JSON.parse(response.body)
    token = json["token"]
    { "Authorization": "Bearer #{token}", "Content-Type": "application/json" }
  end
end
