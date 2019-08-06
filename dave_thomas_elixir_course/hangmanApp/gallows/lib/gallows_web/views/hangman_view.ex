defmodule GallowsWeb.HangmanView do
  use GallowsWeb, :view

  def reveal_letters(letters) do
    Enum.join(letters, " ")
  end
end
