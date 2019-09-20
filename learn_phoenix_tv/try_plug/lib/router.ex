defmodule TryPlug.Router do
    use Plug.Router

    plug :match
    plug :dispatch

    get "/hi" do
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, "Hi World")
    end

    match _ do
        send_resp(conn, 404, "Not found")
    end


    # run a server with in iex session
    # Plug.Adapters.Cowboy.http TryPlug.Router, []
end