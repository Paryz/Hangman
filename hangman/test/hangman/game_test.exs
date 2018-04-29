defmodule Hangman.GameTest do
  use ExUnit.Case
  doctest Hangman.Game

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "make_move does not change state if game is won" do
    for state <- [ :won, :lost ] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert { ^game, _ } = Game.make_move(game, "x")
    end
  end

  test "first occurence of letter is not already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "a")
    assert game.game_state != :already_used
  end

  test "second occurence of letter is not already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "a")
    assert game.game_state != :already_used
    { game, _tally } = Game.make_move(game, "a")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    { game, _tally } = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a good word is a win" do
    moves = [
      { "w", :good_guess },
      { "i", :good_guess },
      { "b", :good_guess },
      { "l", :good_guess },
      { "e", :won },
    ]
    game = Game.new_game("wibble")

    Enum.reduce(moves, game, fn({guess, status}, new_game) ->
      { new_game, _tally } = Game.make_move(new_game, guess)
      assert new_game.game_state == status
      assert new_game.turns_left == 7
      new_game
    end)
  end

  test "a bad guess is recognized" do
    game = Game.new_game("wibble")
    { game, _tally } = Game.make_move(game, "a")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "a wrong guesses results in losing the game" do
    moves = [
      { "a", :bad_guess },
      { "b", :bad_guess },
      { "c", :bad_guess },
      { "d", :bad_guess },
      { "e", :bad_guess },
      { "f", :bad_guess },
      { "g", :lost },
    ]

    game = Game.new_game("w")

    Enum.reduce(moves, game, fn({ guess, status }, new_game) ->
      { new_game, _tally } = Game.make_move(new_game, guess)
      assert new_game.game_state == status
      new_game
    end)
  end
end
