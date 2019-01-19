defprotocol Caeser do
  def encrypt(string, shift)
  def rot13(string)
end

defimpl Caeser, for: [BitString,List] do
  def encrypt(string, shift) when is_bitstring(string) do
    string |> to_char_list |> Enum.map(&Char.rot(&1, shift)) |> to_string
  end

  def encrypt(string, shift) do
    string |> Enum.map(&Char.rot(&1, shift))
  end

  def rot13(string) do
    encrypt(string, 13)
  end
end

defmodule Char do
  # Handle backward rotation
  def rot(char, pos) when pos < 0, do: rot(char, 26 - rem(abs(pos),26))

  # Handle alpha chars
  def rot(char, pos) when char >= ?A and char <= ?Z, do: rem(char-?A + pos, ?Z-?A+1) + ?A
  def rot(char, pos) when char >= ?a and char <= ?z, do: rem(char-?a + pos, ?z-?a+1) + ?a

  # Return other chars, ie spacing, punctuation, numbers
  def rot(char, _), do: char
end
