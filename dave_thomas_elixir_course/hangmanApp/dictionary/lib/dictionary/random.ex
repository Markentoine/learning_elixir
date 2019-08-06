defmodule Dictionary.Random do

    def get_random_word, do: Agent.get(Dictionary.Fetchwords, &Enum.random/1)

end