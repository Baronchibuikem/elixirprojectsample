defmodule BlogApp.MongoRepo do
  @moduledoc """
  A GenServer-based MongoDB repository module for performing basic operations
  like inserting and finding documents.

  This module provides an abstraction over MongoDB operations, allowing
  synchronous interaction with a MongoDB database through GenServer calls.
  """

  use GenServer
  alias Mongo

  @doc """
  Starts the `BlogApp.MongoRepo` GenServer.

  ## Options

    - `:name` - The name to register the GenServer under.

  ## Examples

      iex> BlogApp.MongoRepo.start_link(database: "blog_db")
      {:ok, pid}

  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Initializes the GenServer with a MongoDB connection.

  ## Options

    - `opts` - A keyword list of options for the MongoDB connection.

  ## Returns

    - `{:ok, state}` - The initial state containing the MongoDB connection PID.

  """
  def init(opts) do
    {:ok, pid} = Mongo.start_link(opts)
    {:ok, %{pid: pid}}
  end

  @doc """
  Inserts a document into the specified collection.

  ## Parameters

    - `collection` - The name of the collection to insert the document into.
    - `document` - The document to insert, which can be a struct or a map.

  ## Returns

    - `{:ok, %Mongo.InsertOneResult{}}` on success.
    - `{:error, %Mongo.Error{}}` on failure.

  ## Examples

      iex> BlogApp.MongoRepo.insert_one("posts", %{title: "New Post", content: "Content"})
      %{status: "success", message: "Document inserted successfully", inserted_id: id}

  """
  def insert_one(collection, document) do
    document_map = struct_to_map(document)
    GenServer.call(__MODULE__, {:insert_one, collection, document_map})
  end

  @doc """
  Finds a single document in the specified collection by the given query.

  ## Parameters

    - `collection` - The name of the collection to search.
    - `query` - A map representing the query to find the document.

  ## Returns

    - `{:ok, document}` if a document is found.
    - `{:error, message}` if no document is found or if an error occurs.

  ## Examples

      iex> BlogApp.MongoRepo.find_one("posts", %{"_id" => "12345"})
      %{status: "success", document: document}

  """
  def find_one(collection, query) do
    GenServer.call(__MODULE__, {:find_one, collection, query})
  end

  @doc false
  def handle_call({operation, collection, data}, _from, %{pid: pid} = state) do
    result = perform_operation(pid, operation, collection, data)
    {:reply, result, state}
  end

  @doc false
  defp perform_operation(pid, :insert_one, collection, document) do
    case Mongo.insert_one(pid, collection, document) do
      {:ok, %Mongo.InsertOneResult{acknowledged: true, inserted_id: id}} ->
        %{status: "success", message: "Document inserted successfully", inserted_id: id}

      {:ok, %Mongo.InsertOneResult{acknowledged: false}} ->
        %{status: "error", message: "Document insertion failed"}

      {:error, reason} ->
        format_mongo_error(reason)
    end
  end

  @doc false
  defp perform_operation(pid, :find_one, collection, query) do
    formatted_message = """
    PID: #{inspect(pid)}
    Collection: #{inspect(collection)}
    Query: #{inspect(query)}
    """
    IO.puts(formatted_message)

    result = try do
      Mongo.find_one(pid, collection, query)
    rescue
      e in Mongo.Error -> format_mongo_error(e)
    end

    IO.puts("Result: #{inspect(result)}")

    case result do
      %{} -> %{status: "success", document: result}
      nil -> %{status: "error", message: "No document found"}
      _ -> %{status: "error", message: "Unexpected result format"}
    end
  end

  @doc false
  defp struct_to_map(%_{} = struct) do
    struct
    |> Map.from_struct()
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      case v do
        %DateTime{} -> Map.put(acc, k, DateTime.to_iso8601(v))
        _ -> Map.put(acc, k, v)
      end
    end)
  end

  @doc false
  defp struct_to_map(map) when is_map(map), do: map

  @doc false
  defp format_mongo_error(%Mongo.Error{message: message, code: code}) do
    %{status: "error", error: message, code: code}
  end
end
