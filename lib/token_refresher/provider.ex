defmodule TokenRefresher.Provider do
  @moduledoc """
  A behaviour module for implementing token providers.
  """

  @callback fetch_token() :: {:ok, any} | {:error, term}
end
