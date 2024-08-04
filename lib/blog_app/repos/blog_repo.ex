defmodule BlogApp.Repos.BlogRepo do
  @moduledoc """
  The Blog repository.
  """

  alias BlogApp.Mongo
  alias BlogApp.Models.Blog
  import BSON.ObjectId, only: [new: 0] # Corrected import for generating ObjectId

  @collection "posts"

  @doc """
  Lists all posts.
  """
  def list_posts do
    Mongo.find(:mongo, @collection, %{})
    |> Enum.map(&convert_to_post/1)
  end

  @doc """
  Gets a single post by ID.
  """
  def get_post(id) do
    case Mongo.find_one(:mongo, @collection, %{"_id" => id}) do
      nil -> {:error, :not_found}
      post -> {:ok, convert_to_post(post)}
    end
  end

  @doc """
  Creates a post.
  """
  def create_post(attrs \\ %{}) do
    post = %{
      "_id" => BSON.ObjectId.generate(), # Use BSON.ObjectId.generate/0 for ObjectId
      "title" => attrs["title"],
      "content" => attrs["content"],
      "author" => attrs["author"]
    }

    case Mongo.insert_one(:mongo, @collection, post) do
      {:ok, %{inserted_id: id}} -> {:ok, Map.put(post, "_id", id) |> convert_to_post()}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Updates a post.
  """
  def update_post(id, attrs) do
    update = %{
      "$set" => Map.drop(attrs, ["_id"])
    }

    case Mongo.update_one(:mongo, @collection, %{"_id" => id}, update) do
      {:ok, _result} -> {:ok, get_post(id)}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Deletes a post.
  """
  def delete_post(id) do
    case Mongo.delete_one(:mongo, @collection, %{"_id" => id}) do
      {:ok, _result} -> {:ok, :deleted}
      {:error, reason} -> {:error, reason}
    end
  end

  defp convert_to_post(%{"_id" => id, "title" => title, "content" => content, "author" => author}) do
    %Blog{_id: id, title: title, body: content, author: author}
  end

  defp convert_to_post(nil), do: nil
end
