defmodule Servy.Languages do
  alias Servy.Language

  def list_languages do
    [
      %Servy.Language{id: 1, name: "Ruby", type: "OOP", friendly: true},
      %Servy.Language{id: 2, name: "Java", type: "OOP", friendly: false},
      %Servy.Language{id: 3, name: "Elixir", type: "Functional", friendly: true},
      %Servy.Language{id: 4, name: "JS", type: "OOP", friendly: false},
      %Servy.Language{id: 5, name: "Assembly", type: "Imperative", friendly: false},
      %Servy.Language{id: 6, name: "Python", type: "OOP", friendly: true},
      %Servy.Language{id: 7, name: "Haskell", type: "Functional", friendly: false}
    ]
  end

  def get_language(id) do
    Enum.find(list_languages(), fn l ->
      String.to_integer(id) == l.id
    end)
  end
end
