defmodule Servy.FileHandler do
  require Logger

  def handle_file({:ok, content}, conv) do
    %{conv | status: 209, resp_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    Logger.warn("No File Found")
    conv
  end
end
