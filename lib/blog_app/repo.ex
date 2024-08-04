defmodule BlogApp.Repo do
  use Ecto.Repo, otp_app: :blog_app, adapter: Mongo.Ecto
end
