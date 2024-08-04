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
      {:ok, result} ->
        IO.puts("Insert result: #{inspect(result)}")
        %{
          "acknowledged" => result.acknowledged,
          "inserted_id" => result.inserted_id
        }
      {:error, reason} ->
        %{"error" => reason}
    end

  end

  def get_post(id) do
    query = %{"_id" => id}
    MongoRepo.find_one(@collection, query)
  end
end
