# lib/blog_app_web/controllers/blog_controller.ex
defmodule BlogAppWeb.BlogController do
  use BlogAppWeb, :controller
  alias BlogApp.Posts

  def create(conn, %{"post" => post_params}) do
    case Posts.create_post(post_params) do
      {:ok, result} ->
        json(conn, %{status: "success", result: result})
      {:error, %Mongo.Error{} = error} ->
        json(conn, %{status: "error", message: error.message, code: error.code})
      _ ->
        json(conn, %{status: "error", message: "Unknown error"})
    end
  end

  def show(conn, %{"id" => id}) do
    case Posts.get_post(id) do
      {:ok, post} ->
        json(conn, post)
      {:error, %Mongo.Error{} = error} ->
        json(conn, %{status: "error", message: error.message, code: error.code})
      _ ->
        json(conn, %{status: "error", message: "Post not found"})
    end
  end
end
