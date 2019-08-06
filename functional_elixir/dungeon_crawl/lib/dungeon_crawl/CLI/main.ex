defmodule DungeonCrawl.CLI.Main do
    alias Mix.Shell.IO, as: Shell

    def start_game, do: welcome_message()
    defp welcome_message do
        Shell.info("# # #        # # #")
        Shell.info("#####        #####")
        Shell.info("#####        #####")
        Shell.info("##################")
        Shell.info("### LE CHATEAU ###")
        Shell.info("##################")
        Shell.info("#  ############  #")
        Shell.info("#  ############  #")
        Shell.info("##################")
        Shell.info("#######     ######")
        Shell.info("######       #####")
        Shell.info("######       #####")
        Shell.info("Vous vous réveillez dans une salle aux murs sales.")
        Shell.info("Vous voilà dans un chateau peuplé de monstres.")
        Shell.info("Tentez de survivre pour trouver la sortie...")
    end
end