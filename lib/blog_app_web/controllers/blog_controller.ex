defmodule BlogAppWeb.BlogController do
  use BlogAppWeb, :controller

  alias BlogApp.Repos.BlogRepo

  def index(conn, _params) do
    posts = BlogRepo.list_posts()
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    case BlogRepo.create_post(post_params) do
      {:ok, _post} ->
        send_resp(conn, :created, "")
      {:error, _reason} ->
        send_resp(conn, :unprocessable_entity, "")
    end
  end

  def show(conn, %{"id" => id}) do
    case BlogRepo.get_post(id) do
      {:error, :not_found} ->
        send_resp(conn, :not_found, "")
      {:ok, post} ->
        render(conn, "show.json", post: post)
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    case BlogRepo.update_post(id, post_params) do
      {:ok, _post} ->
        send_resp(conn, :no_content, "")
      {:error, _reason} ->
        send_resp(conn, :unprocessable_entity, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    case BlogRepo.delete_post(id) do
      {:ok, _post} ->
        send_resp(conn, :no_content, "")
      {:error, _reason} ->
        send_resp(conn, :unprocessable_entity, "")
    end
  end
end
