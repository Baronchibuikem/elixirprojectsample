defmodule BlogApp.Posts.Post do
  @derive {Jason.Encoder, only: [:id, :title, :content, :author_id]}
  defstruct [:id, :title, :content, :author_id]

  def new(attrs) do
    %__MODULE__{
      id: generate_id(),  # Ensure id is generated
      title: Map.get(attrs, "title"),
      content: Map.get(attrs, "content"),
      author_id: Map.get(attrs, "author_id")
    }
  end

  defimpl String.Chars do
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

  defp generate_id do
    :crypto.strong_rand_bytes(16) |> Base.encode64()
  end
end
