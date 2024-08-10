defmodule BlogApp.Posts.Post do
  @moduledoc """
  Defines the `BlogApp.Posts.Post` struct and associated functions.

  This module represents a blog post with the following fields:
  - `:id` - A unique identifier for the post, generated using `:crypto.strong_rand_bytes/1` and `Base.encode64/1`.
  - `:title` - The title of the blog post.
  - `:content` - The content of the blog post.
  - `:author_id` - The identifier for the author of the post.

  JSON encoding is derived using `Jason.Encoder`, and the `String.Chars` protocol is implemented to provide a custom string representation of the post.
  """

  @derive {Jason.Encoder, only: [:id, :title, :content, :author_id]}
  defstruct [:id, :title, :content, :author_id]

  @doc """
  Creates a new `%BlogApp.Posts.Post{}` struct from the given attributes.

  ## Parameters

    - `attrs`: A map with string keys representing the post attributes.

  ## Returns

    - A `%BlogApp.Posts.Post{}` struct with the fields populated from the map and a generated unique `:id`.

  ## Examples

      iex> BlogApp.Posts.Post.new(%{"title" => "My Title", "content" => "My Content", "author_id" => "123"})
      %BlogApp.Posts.Post{
        id: "generated_id",
        title: "My Title",
        content: "My Content",
        author_id: "123"
      }
  """
  def new(attrs) do
    %__MODULE__{
      id: generate_id(),  # Ensure id is generated
      title: Map.get(attrs, "title"),
      content: Map.get(attrs, "content"),
      author_id: Map.get(attrs, "author_id")
    }
  end

  defimpl String.Chars do
    @doc """
    Provides a custom string representation for the `BlogApp.Posts.Post` struct.

    ## Examples

        iex> to_string(%BlogApp.Posts.Post{id: "1", title: "Title", content: "Content", author_id: "123"})
        "Post {\n  id: \"1\",\n  title: \"Title\",\n  content: \"Content\",\n  author_id: \"123\"\n}"
    """
    def to_string(%BlogApp.Posts.Post{id: id, title: title, content: content, author_id: author_id}) do
      """
      Post {
        id: #{inspect(id)},
        title: #{inspect(title)},
        content: #{inspect(content)},
        author_id: #{inspect(author_id)}
      }
      """
    end
  end

  @doc """
  Generates a unique identifier for a post.

  ## Returns

    - A base64-encoded string of 16 random bytes.

  ## Examples

      iex> BlogApp.Posts.Post.generate_id()
      "generated_unique_id"
  """
  defp generate_id do
    :crypto.strong_rand_bytes(16) |> Base.encode64()
  end
end
