defmodule BlogApp.Posts do
  @moduledoc """
  The `BlogApp.Posts` module provides functions to create and retrieve blog posts in the `blog_app` application.

  This module interacts with the MongoDB database using the `BlogApp.MongoRepo` module.
  """

  alias BlogApp.{MongoRepo, Posts.Post}

  @collection "posts"

  @doc """
  Creates a new blog post with the given attributes and inserts it into the MongoDB collection.

  ## Parameters

    - `attrs`: A map containing the attributes for the new post. Expected keys are:
      - `"title"`: The title of the post.
      - `"content"`: The content of the post.
      - `"author_id"`: The ID of the author.

  ## Returns

    - `{:ok, id}`: On successful insertion, returns the `id` of the newly inserted post.
    - `{:error, message}`: If insertion fails, returns an error message.

  ## Examples

      iex> BlogApp.Posts.create_post(%{"title" => "New Post", "content" => "This is the content", "author_id" => "12345"})
      {:ok, "generated_post_id"}

      iex> BlogApp.Posts.create_post(%{"title" => "", "content" => "", "author_id" => ""})
      {:error, "Document insertion failed"}
  """
  def create_post(attrs) do
    post = Post.new(attrs)
    post_map =  %{
      "_id" => post.id,
      "title" => post.title,
      "content" => post.content,
      "author_id" => post.author_id
    }
    IO.puts(post)
    case MongoRepo.insert_one(@collection, post_map) do
      %{status: "success", inserted_id: id} ->
        {:ok, id}

      %{status: "error", message: message} ->
        {:error, message}
    end
  end

  @doc """
  Retrieves a blog post by its ID from the MongoDB collection.

  ## Parameters

    - `id`: The ID of the post to retrieve. This should be a Base64 encoded string that represents the `_id` in the MongoDB collection.

  ## Returns

    - `{:ok, document}`: On successful retrieval, returns the post document as a map.
    - `{:error, message}`: If the post is not found or an error occurs, returns an error message.

  ## Examples

      iex> BlogApp.Posts.get_post("4ZzzuX69wSic5CRPOplx2A==")
      {:ok, %{"_id" => "4ZzzuX69wSic5CRPOplx2A==", "title" => "My Post", "content" => "This is my post", "author_id" => "12345"}}

      iex> BlogApp.Posts.get_post("nonexistent_id")
      {:error, %{status: "error", message: "Post not found"}}
  """
  def get_post(id) do
    query = %{"_id" => id}
    case MongoRepo.find_one(@collection, query) do
      %{status: "success", document: document} -> {:ok, document}
      %{status: "error", message: _} = error -> {:error, error}
    end
  end
end
