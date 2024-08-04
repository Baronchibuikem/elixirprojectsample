defmodule BlogApp.Models.Blog do
   @moduledoc """
  Defines the schema for a blog post and provides functions
  for data validation and transformation.
  """

  alias __MODULE__
  alias Mongo.ObjectId

  @enforce_keys [:title, :body]
  defstruct [
    :_id,         # MongoDB ObjectId
    :title,       # Title of the blog post
    :body,        # Body content of the post
    :author,      # Author's name
    :inserted_at, # Timestamp of creation
    :updated_at   # Timestamp of the last update
  ]

  @type t :: %__MODULE__{
          _id: ObjectId.t() | nil,
          title: String.t(),
          body: String.t(),
          author: String.t() | nil,
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  @doc """
  Creates a new blog post struct with the given attributes.
  """
  @spec new(map()) :: Blog.t()
  def new(attrs \\ %{}) do
    %Blog{
      _id: attrs["_id"] || nil,
      title: Map.fetch!(attrs, "title"),
      body: Map.fetch!(attrs, "body"),
      author: attrs["author"] || "Anonymous",
      inserted_at: attrs["inserted_at"] || NaiveDateTime.utc_now(),
      updated_at: attrs["updated_at"] || NaiveDateTime.utc_now()
    }
  end

  @doc """
  Validates the blog post data.
  """
  @spec validate(map()) :: :ok | {:error, String.t()}
  def validate(attrs) do
    cond do
      is_nil(attrs["title"]) or attrs["title"] == "" ->
        {:error, "Title is required"}

      is_nil(attrs["body"]) or attrs["body"] == "" ->
        {:error, "Body is required"}

      true ->
        :ok
    end
  end

end
