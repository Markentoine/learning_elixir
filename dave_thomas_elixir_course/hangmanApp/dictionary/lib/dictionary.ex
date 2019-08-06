defmodule Dictionary do
  alias Dictionary.{Fetchwords, Random, Length}

  defdelegate random_word, to: Random, as: :get_random_word

  defdelegate n_length_words(n), to: Length, as: :get_words_length

end
