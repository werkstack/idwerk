defmodule IdWerkWeb.OAuthApiView do
  use IdWerkWeb, :view

  def render("auth_jwt.json", %{token: token}) do
    token
  end
end
