defmodule TokenRefresher.RefresherTest do
  use ExUnit.Case
  import ExUnit.CaptureLog

  test "fetches token during initialization and stores it in state" do
    assert capture_log(fn ->
             {:ok, pid} = TokenRefresher.Refresher.start_link({DummyProvider, 1})
             assert {DummyProvider, 1, "dummy_token"} == :sys.get_state(pid)
           end) =~ "DummyProvider token fetched during initialization."
  end

  test "refreshes token based on expires_in and updates state" do
    assert capture_log(fn ->
             {:ok, pid} = TokenRefresher.Refresher.start_link({DummyProvider, 1})
             Process.sleep(1100)
             assert {DummyProvider, 1, "dummy_token"} == :sys.get_state(pid)
           end) =~ "DummyProvider token refreshed."
  end

  test "responds with the current token for a given provider" do
    {:ok, pid} = TokenRefresher.Refresher.start_link({DummyProvider, 1})
    assert {:ok, "dummy_token"} = GenServer.call(pid, :get_token)
  end
end
