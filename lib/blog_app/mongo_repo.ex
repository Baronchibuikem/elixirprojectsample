defmodule BlogApp.MongoRepo do
  use GenServer
  alias Mongo

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    {:ok, pid} = Mongo.start_link(opts)
    {:ok, %{pid: pid}}
  end

  def insert_one(collection, document) do
    document_map = struct_to_map(document)
    GenServer.call(__MODULE__, {:insert_one, collection, document_map})
  end

  def find_one(collection, query) do
    GenServer.call(__MODULE__, {:find_one, collection, query})
  end

  def handle_call({:insert_one, collection, document}, _from, %{pid: pid}) do
    try do
      case Mongo.insert_one(pid, collection, document) do
        {:ok, %Mongo.InsertOneResult{acknowledged: true, inserted_id: id}} ->
          {:reply, %{status: "success", message: "Document inserted successfully", inserted_id: id}, %{pid: pid}}

        {:ok, %Mongo.InsertOneResult{acknowledged: false}} ->
          {:reply, %{status: "error", message: "Document insertion failed"}, %{pid: pid}}

        {:error, reason} ->
          {:reply, %{status: "error", message: "Insertion failed: #{inspect(reason)}"}, %{pid: pid}}
      end
    rescue
      e in Mongo.Error ->
        {:reply, format_mongo_error(e), %{pid: pid}}
    end
  end

  def handle_call({:find_one, collection, query}, _from, %{pid: pid}) do
    try do
      result = Mongo.find_one(pid, collection, query)
      {:reply, result, %{pid: pid}}
    rescue
      e in Mongo.Error ->
        {:reply, format_mongo_error(e), %{pid: pid}}
    end
  end

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

  defp struct_to_map(map) when is_map(map), do: map

  defp format_mongo_error(%Mongo.Error{message: message, code: code}) do
    %{
      error: message,
      code: code
    }
  end
end
