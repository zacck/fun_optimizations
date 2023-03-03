defmodule GenApi.Randomizer do
  use GenServer

  # opportunity to pass in persistent state
  # e.g like the last timestamp in case the app restarted
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: :randomizer)
  end

  # Initialize Genserver with the specified state
  def init(_) do
    IO.puts("initialized")
    number = :rand.uniform(100)

    # consider a struct if implementation gets complex
    state = %{min_number: number, timestamp: nil}

    #schedule the first update
    schedule_update()

    {:ok, state}
  end

  def handle_info(:update, state) do
    #schedule the next update
    schedule_update()

    #update random number in state
    new_state = %{state | min_number: :rand.uniform(100)}
    IO.inspect(new_state)

    {:noreply, new_state}
  end

  # schedule the next update every minute
  defp schedule_update() do
    Process.send_after(self(), :update, :timer.minutes(1))
  end
end
