defmodule GallowsWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "hangman:*", GallowsWeb.HangmanChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  j
  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
