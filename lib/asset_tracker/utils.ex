defmodule AssetTracker.Utils do
  @moduledoc false
  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  @spec assert(boolean(), binary()) :: no_return()
  def assert(bool, error_message) do
    if bool == false, do: raise(error_message)
  end
end
