defmodule Servy.ViewSensors do
  @template_path Path.expand("../../templates", __DIR__)

  def render({snaps, coords}) do
    @template_path
    |> Path.join("sensors.eex")
    |> EEx.eval_file(snaps: snaps, coords: coords)
  end
end
