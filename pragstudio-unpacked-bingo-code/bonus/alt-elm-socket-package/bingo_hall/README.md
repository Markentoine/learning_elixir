# BingoHall

## Installation

1. Install Elixir dependencies:

    ```sh
    mix deps.get
    ```

2. Install Node.js dependencies: 

    ```sh
    cd assets && npm install
    ```

    You may see some warnings, but they can be safely ignored.


3. Install Elm dependencies:

    ```sh
    cd assets/elm && elm-package install -y
    ```

4. Make sure the assets build:

    ```sh
    cd assets && node node_modules/.bin/brunch build
    ```

5. Make sure all the tests pass:

    ```sh
    mix test
    ```

6. Fire up the Phoenix endpoint:

    ```sh
    mix phx.server
    ```

7. Visit [`localhost:4000`](http://localhost:4000) to play the game!

## Alternative Installation

The code in the `bingo_hall` directory uses the [elm-phoenix](https://github.com/saschatimme/elm-phoenix) Elm package rather than the [elm-phoenix-socket](https://github.com/fbonetti/elm-phoenix-socket) package we used in the videos.

Unfortunately, since the [elm-phoenix](https://github.com/saschatimme/elm-phoenix) package is an Elm effect manager it is not available in the Elm package repository. However, there are a couple ways to install it.

First, you can clone the GitHub repo and copy the package's modules into the `assets/elm/vendor` directory. That's what we've done to keep installation simple. If you look in the existing `assets/elm/vendor` directory you'll see a handful of modules in the `Phoenix` namespace. The downside to this approach is dependency management is a manual process.

The second way is to use [elm-github-install](https://github.com/gdotdesign/elm-github-install) which installs Elm packages from Git repositories rather than from [http://package.elm-lang.org/](http://package.elm-lang.org/). Here's how to do that:

1. First, remove the `assets/elm/vendor` directory.

2. Then install `elm-github-install`:

    ```sh
    npm install elm-github-install@1.6.1 -g
    ```

3. And add the `saschatimme/elm-phoenix` package dependency to the `assets/elm/elm-package.json` file:

    ```js
    "saschatimme/elm-phoenix": "0.3.0 <= v < 1.0.0"
    ```

4. Then change into the `assets/elm` directory and install the Elm package dependencies using `elm-github-install`:

    ```sh
    cd assets/elm

    elm-github-install
    ```

5. Finally, you need to remove the example Phoenix app that ships with the `elm-phoenix` package. Otherwise the nesting causes conflicts with the `bingo_hall` Phoenix app. The `example` directory is buried under the `elm-stuff` directory. Delete it like so:

    ```sh
    rm -rf elm-stuff/packages/saschatimme/elm-phoenix/0.3.1/example
    ```
