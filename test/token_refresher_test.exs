defmodule TokenRefresherTest do
  use ExUnit.Case
  doctest TokenRefresher

  setup do
    Application.put_env(:token_refresher, :providers, [{DummyProvider, 1}])
    :ok
  end

  test "supervisor starts refresher for each provider and sets the token in the worker state" do
    assert {:ok, _pid} = TokenRefresher.start_link([])

    # Ensure the supervisor has started the worker
    children = Supervisor.which_children(TokenRefresher)
    assert length(children) == 1

    # Extract the PID of the worker
    [{_id, worker_pid, _type, _modules}] = children

    # Check the state of the worker
    assert {DummyProvider, 1, "dummy_token"} == :sys.get_state(worker_pid)
  end

  test "get_token returns the current token for a given provider" do
    assert {:ok, _pid} = TokenRefresher.start_link([])

    assert {:ok, "dummy_token"} = TokenRefresher.get_token(DummyProvider)
  end

  test "get_token returns an error if the provider is not found" do
    assert {:ok, _pid} = TokenRefresher.start_link([])

    assert {:error, :not_found} = TokenRefresher.get_token(NonExistentProvider)
  end
end
