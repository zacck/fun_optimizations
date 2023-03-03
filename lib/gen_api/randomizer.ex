defmodule GenApi.Randomizer do
  use GenServer
  alias GenApi.User

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

  # implement sychronous callback to query the database
  def handle_call(:query, _, state) do

    #update the state of the server with a new timestamp
    now =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)
      |> NaiveDateTime.to_string()

    new_state = %{state | timestamp: now }

    # query db and return results
    results = []

    {:reply, results, new_state}
  end

  def handle_info(:update, state) do
    #schedule the next update
    schedule_update()

    # spawn off an asnyc process to update user points
    spawn(fn -> GenApi.User.update_user_points() end)

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
