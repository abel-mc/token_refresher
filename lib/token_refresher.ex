defmodule TokenRefresher do
  @moduledoc """
  TokenRefresher is responsible for continuously refreshing tokens
  for multiple providers based on their `expires_in` configuration.
  """

  use Supervisor

  @doc """
  Starts the TokenRefresher supervisor.

  ## Example

      TokenRefresher.start_link()

  """
  def start_link(_) do
    providers = Application.get_env(:token_refresher, :providers, [])
    Supervisor.start_link(__MODULE__, providers, name: __MODULE__)
  end

  @impl true
  def init(providers) do
    children = Enum.map(providers, fn {provider, expires_in} ->
      %{
        id: provider,
        start: {TokenRefresher.Refresher, :start_link, [{provider, expires_in}]}
      }
    end)

    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc """
  Gets the current token for a given provider.

  ## Parameters

    - provider: The provider module.

  ## Returns

    - `{:ok, token}` if the token is found.
    - `{:error, :not_found}` if the provider is not found.
  """
  def get_token(provider) do
    case Supervisor.which_children(__MODULE__) do
      children ->
        case Enum.find(children, fn {id, _pid, _type, _modules} -> id == provider end) do
          {_, pid, _, _} ->
            GenServer.call(pid, :get_token)
          nil ->
            {:error, :not_found}
        end
    end
  end
end
