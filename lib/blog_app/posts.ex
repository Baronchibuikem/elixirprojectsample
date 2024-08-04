# lib/blog_app/posts.ex
defmodule BlogApp.Posts do
  alias BlogApp.{MongoRepo, Posts.Post}

  @collection "posts"

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

  def get_post(id) do
    query = %{"_id" => id}
    MongoRepo.find_one(@collection, query)
  end
end
