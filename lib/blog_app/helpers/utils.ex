defmodule BlogApp.Helpers do
  @moduledoc """
  Helper functions for BlogApp.
  """

  @doc """
  Converts a Base64-encoded string to a format that MongoDB can use for querying.
  """
  def base64_to_string(base64_id) do
    base64_id
    |> Base.decode64!()
    |> Base.encode16()
  end
end
