defmodule BlogAppWeb.BlogController do
  use BlogAppWeb, :controller
  alias BlogApp.Posts

  @doc """
  Creates a new blog post.

  This action expects a `post_params` map in the request body, which contains the
  details of the post to be created. It returns a JSON response indicating the
  success or failure of the operation.

  ## Parameters

    - conn: The connection struct.
    - post_params: A map containing the post details (`"title"`, `"content"`, `"author_id"`).

  ## Examples

      POST /api/posts
      {
        "post": {
          "title": "My First Post",
          "content": "This is the content of my first post.",
          "author_id": "12345"
        }
      }

      Response:
      {
        "status": "success",
        "result": {...}
      }

  If an error occurs, a JSON response with the error message and code will be returned.
  """
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

  @doc """
  Retrieves a blog post by its ID.

  This action expects an ID as a parameter in the request URL. It returns a JSON response
  containing the post data if found, or an error message if the post is not found or if
  an error occurs.

  ## Parameters

    - conn: The connection struct.
    - id: The ID of the post to retrieve.

  ## Examples

      GET /api/posts/4ZzzuX69wSic5CRPOplx2A==

      Response:
      {
        "status": "success",
        "result": {
          "id": "4ZzzuX69wSic5CRPOplx2A==",
          "title": "My Second Blog Post",
          "content": "This is the content of my second post.",
          "author_id": "12345"
        }
      }

  If the post is not found, a JSON response with an error message will be returned.
  """
  def show(conn, %{"id" => id}) do
    case Posts.get_post(id) do
      {:ok, result} ->
        json(conn, %{status: "success", result: result})
      {:error, %Mongo.Error{} = error} ->
        json(conn, %{status: "error", message: error.message, code: error.code})
      _ ->
        json(conn, %{status: "error", message: "Post not found"})
    end
  end
end
