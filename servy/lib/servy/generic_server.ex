defmodule Servy.GenericServer do
  def start(callback_module, initial_state \\ %{}, name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, name)
    pid
  end

  def listen_loop(state, callback_module) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call(message, state)
        send(sender, {:response, response})
        listen_loop(new_state, callback_module)

      {:cast, message} ->
        new_state = callback_module.handle_cast(message, state)
        listen_loop(new_state, callback_module)

      unexpected_message ->
        callback_module.handle_info(unexpected_message, state)
        listen_loop(state, callback_module)
    end
  end

  def call(pid, msg) do
    send(pid, {:call, self(), msg})

    receive do
      {:response, response} -> response
    end
  end

  def cast(pid, msg) do
    send(pid, {:cast, msg})
  end
end
