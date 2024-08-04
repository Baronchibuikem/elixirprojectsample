defmodule BlogApp.Mongo do
  use GenServer
  alias Mongo

  @db_name "blog_app_db"

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_) do
    {:ok, conn} = Mongo.start_link(url: "mongodb://localhost:27017/#{@db_name}", name: :mongo)
    {:ok, conn}
  end

  def get_conn, do: GenServer.call(__MODULE__, :get_conn)

  def handle_call(:get_conn, _from, state) do
    {:reply, state, state}
  end

  # Wrapper function for find
  def find(collection, query, opts \\ []) do
    Mongo.find(:mongo, collection, query, opts)
  end

  # Wrapper function for find_one
  def find_one(collection, query, opts \\ []) do
    Mongo.find_one(:mongo, collection, query, opts)
  end

  # Wrapper function for insert_one
  def insert_one(collection, doc, opts \\ []) do
    Mongo.insert_one(:mongo, collection, doc, opts)
  end

  # Wrapper function for update_one
  def update_one(collection, filter, update, opts \\ []) do
    Mongo.update_one(:mongo, collection, filter, update, opts)
  end

  # Wrapper function for delete_one
  def delete_one(collection, filter, opts \\ []) do
    Mongo.delete_one(:mongo, collection, filter, opts)
  end

  # Add other wrappers as needed...
end
