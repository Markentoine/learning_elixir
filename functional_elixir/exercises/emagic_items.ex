defmodule MagicItems do
    def test_data do
        [
            %{title: "this", magic: true},
            %{title: "that", magic: false}
        ]
    end

    def filter_items([], magic: magic), do: []
    def filter_items([item = %{magic: item_magic} | rest], magic: magic)
        when item_magic == magic do
        [item | filter_items(rest, magic: magic)]
    end
    def filter_items([item = %{magic: item_magic} | rest], magic: magic) do
        filter_items(rest, magic: magic)
    end

end