defmodule CreditorReference.ISO11649 do
  @behaviour CreditorReference.Validator
  @behaviour CreditorReference.Generator

  @prefix "RF"
  @generator_postfix "RF00"

  @impl CreditorReference.Validator
  def valid?(ref) do
    case validate(ref) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end

  @impl CreditorReference.Validator
  def validate(ref, opts \\ []) do
    normalize = Keyword.get(opts, :normalize, true)

    with {@prefix, checksum, cr} <- validate_format(ref),
         # remove all whitespace bevor length check
         cr <- String.replace(cr, " ", ""),
         :ok <- validate_length(cr, 21),
         :ok <- valid_checksum(cr <> @prefix <> checksum) do
      if normalize do
        {:ok, @prefix <> checksum <> cr}
      else
        {:ok, ref}
      end
    end
  end

  @impl CreditorReference.Generator
  def generate(input, opts \\ []) do
    with :ok <- validate_length(input, 21) do
      checksum =
        (input <> @generator_postfix)
        |> generate_checksum()
        |> to_string()
        |> String.pad_leading(2, "0")

      if opts[:padding] do
        {:ok, @prefix <> checksum <> String.pad_leading(input, 21, "0")}
      else
        {:ok, @prefix <> checksum <> input}
      end
    end
  end

  def format_print(rfcr) when is_binary(rfcr) do
    rfcr
    |> String.graphemes()
    |> Enum.chunk_every(4)
    |> Enum.join(" ")
  end

  defp validate_format(<<@prefix, checksum::binary-size(2), cr::binary>>) do
    {@prefix, checksum, cr}
  end

  defp validate_format(_) do
    {:error, :invalid_reference}
  end

  defp letter_to_digits(<<char>>, acc) when char in ?a..?z, do: acc <> "#{char - (?a - 10)}"
  defp letter_to_digits(<<char>>, acc) when char in ?A..?Z, do: acc <> "#{char - (?A - 10)}"
  defp letter_to_digits(<<char>> = n, acc) when char in ?0..?9, do: acc <> n
  defp letter_to_digits(<<>>, acc), do: acc
  defp letter_to_digits(c, _), do: raise(ArgumentError, "Invalid character #{c}")

  defp valid_checksum(input) do
    input
    |> String.graphemes()
    |> Enum.reduce(<<>>, &letter_to_digits/2)
    |> String.to_integer()
    |> rem(97)
    |> then(&if 1 == &1, do: :ok, else: {:error, :invalid_checksum})
  end

  defp generate_checksum(input) do
    input
    |> String.graphemes()
    |> Enum.reduce(<<>>, &letter_to_digits/2)
    |> String.to_integer()
    |> then(&(98 - rem(&1, 97)))
  end

  defp validate_length(string, max_length) do
    if String.length(string) <= max_length, do: :ok, else: {:error, :invalid_length}
  end
end
