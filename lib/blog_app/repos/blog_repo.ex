defmodule BlogApp.Repos.BlogRepo do
  alias BlogApp.Repo
  alias BlogApp.Blog

  def all() do
    Repo.all(Blog)
  end

  def get_by_id(id) do
    Repo.get(Blog, id)
  end

  def create(attrs \\ %{}) do
    %Blog{}
    |> Blog.changeset(attrs)
    |> Repo.insert()
  end

  def update_blog(blog, attrs \\ %{}) do
    blog
    |> Blog.changeset(attrs)
    |> Repo.update()
  end

  def delete_blog(blog) do
    Repo.delete(blog)
  end
end
