defmodule DummyProvider do
  @behaviour TokenRefresher.Provider

  def fetch_token do
    {:ok, "dummy_token"}
  end
end
