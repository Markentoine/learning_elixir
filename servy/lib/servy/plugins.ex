defmodule Servy.Plugins do
  require Logger

  def rewrite_path(%{path: "/frame"} = conv) do
    %{conv | path: "/frameworks"}
  end

  def rewrite_path(conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, conv.path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %{conv | path: "/#{thing}/#{id}"}
  end

  def rewrite_path_captures(conv, nil), do: conv

  def emojify(conv = %{status: 200}) do
    success_body = "🎉" <> conv.resp_body <> "🎉"
    %{conv | resp_body: success_body}
  end

  def emojify(conv), do: conv

  def track(%{status: 404, path: path} = conv) do
    Logger.warn("This path: #{path} had been requested. ")
    conv
  end

  def track(conv), do: conv
end
