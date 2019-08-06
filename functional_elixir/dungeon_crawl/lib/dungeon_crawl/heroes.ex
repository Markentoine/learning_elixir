defmodule DungeonCrawl.Heroes do
    alias DungeonCrawl.Character


    def all do 
        [%Character{
            name: "Habi",
            description: "Soldat vétéran balafré",
            hit_points: 18,
            max_hit_points: 18,
            damage_range: 4..6,
            attack_description: "A massive hit on head"
        }]
    end
end