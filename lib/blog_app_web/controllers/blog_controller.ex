defmodule BlogAppWeb.BlogController do
  use BlogAppWeb, :controller

  alias BlogApp.Repos.BlogRepo

  def index(conn, _params) do
    blogs = BlogRepo.all()
    render(conn, "index.json", blogs: blogs)
  end

  def create(conn, %{"blog" => blog_params}) do
    case BlogRepo.create(blog_params) do
      {:ok, blog} -> render(conn, "show.json", blog: blog)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{"errors" => changeset.errors})
    end
  end

  # Define other actions if needed
end
