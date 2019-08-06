defmodule Servy.Api.LanguagesController do
  def index(conv) do
    languages = Servy.Languages.list_languages()
    json = Poison.encode!(languages)

    %{conv | status: 200, header_content_type: "application/json", resp_body: json}
  end

  def create_language(conv) do
    new_language = conv.params

    %{
      conv
      | status: 201,
        resp_body: "Created the #{new_language["type"]} language named #{new_language["name"]}"
    }
  end
end
