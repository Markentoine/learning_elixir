defmodule Servy.ViewLanguage do
  def list_language(lang) do
    "<li>name: #{lang.name} / type: #{lang.type}</li>"
  end

  def sort_ascendent(l1, l2) do
    l1.name <= l2.name
  end

  def render(templates_path, template_file, bindings) do
    templates_path
    |> Path.join(template_file)
    |> EEx.eval_file(bindings)
  end
end
