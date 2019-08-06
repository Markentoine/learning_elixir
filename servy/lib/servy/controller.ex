defmodule Servy.Controller do
  require Logger
  alias Servy.{Languages, ViewLanguage}

  @template_path Path.expand('../../templates', __DIR__)

  def index(conv) do
    languages =
      Languages.list_languages()
      |> Enum.sort(&ViewLanguage.sort_ascendent/2)

    content = ViewLanguage.render(@template_path, "index.eex", languages: languages)

    %{conv | status: 200, resp_body: content}
  end

  def show(conv, %{"id" => id}) do
    language = Languages.get_language(id)

    content = ViewLanguage.render(@template_path, "show.eex", id: id, name: language.name)

    %{conv | status: 200, resp_body: content}
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    %{
      conv
      | status: 204,
        resp_body: "#{name} was created. Its type is: #{type}"
    }
  end

  def delete(conv) do
    Logger.info("language had been deleted!")
    %{conv | status: 204}
  end
end
