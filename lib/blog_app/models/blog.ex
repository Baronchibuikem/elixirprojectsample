defmodule BlogApp.Blog do
  use Ecto.Schema

  import Ecto.Changeset

  schema "blogs" do
    field :title, :string
    field :content, :string
    field :author_id, :string
    timestamps()
  end

  @doc false
  def changeset(blog, params) do
    blog
    |> cast(params, [:title, :content, :author_id])
    |> validate_required([:title, :content, :author_id])
  end

end
