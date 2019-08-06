defmodule ServyHandlerTest do
  use ExUnit.Case

  alias Servy.Handler

  test "frameworks path" do
    request = """
    GET /frameworks HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    assert Handler.handle(request) ==
             "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 21\r\n\nPhoenix, React, Rails\n"
  end

  test "DELETE" do
    request = """
    DELETE /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    assert Handler.handle(request) ==
             "HTTP/1.1 204 No Content\r\nContent-Type: text/html\r\nContent-Length: 0\r\n\n\n"
  end

  test "languages path" do
    request = """
    GET /languages HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    assert Handler.handle(request) ==
             "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 321\r\n\n<ul>\n<li>Language is Assembly and its type is Imperative<li>Language is Elixir and its type is Functional<li>Language is Haskell and its type is Functional<li>Language is JS and its type is OOP<li>Language is Java and its type is OOP<li>Language is Python and its type is OOP<li>Language is Ruby and its type is OOP\n</ul>\n"
  end

  test "subdirectories" do
    request = """
    GET /languages/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    assert Handler.handle(request) ==
             "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 26\r\n\n<p>Language: 1 is Ruby</p>\n"
  end

  test "rewrite path for /frame to match /frameworks path" do
    request = """
    GET /frame HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    assert Handler.handle(request) ==
             "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 21\r\n\nPhoenix, React, Rails\n"
  end

  test "rewrite prettier URLs" do
    request = """
    GET /languages?id=2 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    assert Handler.handle(request) ==
             "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 26\r\n\n<p>Language: 2 is Java</p>\n"
  end

  test "Serving a static file" do
    request = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    assert Handler.handle(request) ==
             "HTTP/1.1 209 File Served\r\nContent-Type: text/html\r\nContent-Length: 320\r\n\n<h1>Clark's Wildthings Refuge</h1>\n\n<blockquote>\nWhen we contemplate the whole globe as one great dewdrop, striped and dotted with continents and islands, flying through space with other stars all singing and shining together as one, the whole universe appears as an infinite storm of beauty. -- John Muir\n</blockquote>\n\n"
  end

  test "Serving form.html" do
    request = """
    GET /language/new HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    assert Handler.handle(request) ===
             "HTTP/1.1 209 File Served\r\nContent-Type: text/html\r\nContent-Length: 240\r\n\n<form action=\"/bears\" method=\"POST\">\n  <p>\n    Name:<br/>\n    <input type=\"text\" name=\"name\">    \n  </p>\n  <p>\n    Type:<br/>\n    <input type=\"text\" name=\"type\">    \n  </p>\n  <p>\n    <input type=\"submit\" value=\"Create Bear\">\n  </p>\n</form>\n\n"
  end

  test "serving from pages" do
    request = """
    GET /pages/faq HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    assert Handler.handle(request) ==
             "HTTP/1.1 209 File Served\r\nContent-Type: text/html\r\nContent-Length: 12\r\n\n<h1>FAQ</h1>\n"
  end

  test "POST" do
    request = """
    POST /language/new HTTP/1.1\r
    Host: example.com\r
    Content-Type: application/x-www-form-urlencoded\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    name=Rust&type=functional
    """

    assert Handler.handle(request) ===
             "HTTP/1.1 204 No Content\r\nContent-Type: text/html\r\nContent-Length: 42\r\n\nRust was created. Its type is: functional\n\n"
  end

  test "API" do
    request = """
    GET /api/languages HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    assert Handler.handle(request) ===
             "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: 399\r\n\n[{\"type\":\"OOP\",\"name\":\"Ruby\",\"id\":1,\"friendly\":true},{\"type\":\"OOP\",\"name\":\"Java\",\"id\":2,\"friendly\":false},{\"type\":\"Functional\",\"name\":\"Elixir\",\"id\":3,\"friendly\":true},{\"type\":\"OOP\",\"name\":\"JS\",\"id\":4,\"friendly\":false},{\"type\":\"Imperative\",\"name\":\"Assembly\",\"id\":5,\"friendly\":false},{\"type\":\"OOP\",\"name\":\"Python\",\"id\":6,\"friendly\":true},{\"type\":\"Functional\",\"name\":\"Haskell\",\"id\":7,\"friendly\":false}]\n"
  end

  test "POST /api/languages" do
    request = """
    POST /api/languages HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/json\r
    Content-Length: 21\r
    \r
    {"name": "Racket", "type": "Functional"}
    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 201 Created\r
           Content-Type: text/html\r
           Content-Length: 44\r
           \nCreated the Functional language named Racket
           """
  end
end
