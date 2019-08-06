# defmodule Servy.PledgeServer do
#   @name :pledge_server
#   def start(intial_state \\ [{"piroska", 200}, {"sacha", 300}, {"jerome", 100}]) do
#     pid = spawn(__MODULE__, :listen_loop, [intial_state])
#     Process.register(pid, @name)
#     pid
#   end
# 
#   def listen_loop(state) do
#     receive do
#       {sender, :create_pledge, name, amount} ->
#         {:ok, id} = send_pledge_to_external_service(name, amount)
#         most_recent_pledges = Enum.take(state, 2)
#         new_state = [{name, amount} | most_recent_pledges]
#         send(sender, {:response, id})
#         listen_loop(new_state)
# 
#       {sender, :recent_pledges} ->
#         send(sender, {:response, state})
#         listen_loop(state)
# 
#       {sender, :total_pledges} ->
#         total = Enum.map(state, &elem(&1, 1)) |> Enum.sum()
#         send(sender, {:response, total})
#         listen_loop(state)
# 
#       unexpected ->
#         IO.puts("Unexpected message: #{unexpected}")
#         listen_loop(state)
#     end
#   end
# 
#   def create_pledge(name, amount) do
#     send(@name, {self(), :create_pledge, name, amount})
# 
#     receive do
#       {:response, status} -> status
#     end
#   end
# 
#   def recent_pledges() do
#     send(@name, {self(), :recent_pledges})
# 
#     receive do
#       {:response, pledges} -> pledges
#     end
#   end
# 
#   def total_pledges() do
#     send(@name, {self(), :total_pledges})
# 
#     receive do
#       {:response, total} -> total
#     end
#   end
# 
#   defp send_pledge_to_external_service(name, amount) do
#     {:ok, "pledge-#{:rand.uniform(10000)}"}
#   end
# end
# 
