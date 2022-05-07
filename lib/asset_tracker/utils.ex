defmodule AssetTracker.Utils do
  @moduledoc false
  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end
end
