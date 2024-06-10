defmodule TokenRefresher.Refresher do
  use GenServer
  require Logger

  @doc """
  Starts the Refresher GenServer.
  """
  def start_link({provider, expires_in}) do
    GenServer.start_link(__MODULE__, {provider, expires_in})
  end

  @impl true
  def init({provider, expires_in}) do
    case provider.fetch_token() do
      {:ok, token} ->
        Logger.info("#{inspect(provider)} token fetched during initialization.")
        schedule_refresh(expires_in)
        {:ok, {provider, expires_in, token}}
      {:error, reason} ->
        Logger.error("Failed to fetch token for #{inspect(provider)}: #{reason}")
        {:stop, reason}
    end
  end

  @impl true
  def handle_info(:refresh, {provider, expires_in, _old_token}) do
    case provider.fetch_token() do
      {:ok, token} ->
        Logger.info("#{inspect(provider)} token refreshed.")
        schedule_refresh(expires_in)
        {:noreply, {provider, expires_in, token}}
      {:error, reason} ->
        Logger.error("Failed to refresh token for #{inspect(provider)}: #{reason}")
        schedule_refresh(expires_in)
        {:noreply, {provider, expires_in, nil}}
    end
  end

  @impl true
  def handle_call(:get_token, _from, {provider, expires_in, token}) do
    {:reply, {:ok, token}, {provider, expires_in, token}}
  end

  defp schedule_refresh(expires_in) do
    Process.send_after(self(), :refresh, expires_in * 1000)
  end
end
