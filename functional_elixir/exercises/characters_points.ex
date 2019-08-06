defmodule CountPoints do
    def total_characters_points carac do
        %{strength: strength, dexterity: dexterity, intelligence: intelligence} = carac
        strength * 2 + (dexterity + intelligence) * 3
    end
    
end