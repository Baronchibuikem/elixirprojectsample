defmodule BlogAppWeb.FallbackController do
  use BlogAppWeb, :controller

  def call(conn, {:error, _reason}) do
    conn
    |> put_status(:internal_server_error)
    |> json(%{error: "Internal Server Error"})
  end
end
