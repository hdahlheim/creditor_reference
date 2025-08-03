defmodule CreditorReference.SwissQRR do
  @moduledoc """
  Module for generating and validating Swiss ESR-Numbers used in the legacy
  Orange Payment Slip and the QR-Bill QR-Reference in combination with QR-IBAN.
  """

  @behaviour CreditorReference.Validator
  @behaviour CreditorReference.Generator

  @impl CreditorReference.Validator
  def valid?(input) do
    case validate(input) do
      {:ok, _} -> true
      _ -> false
    end
  end

  @doc """
  Validates a given reference number against the check digit at the end of the
  string. The input can be in print format (whitespace spepareted) or digital
  format (continues number string).

    iex> {:ok, "21 00000 00003 13947 14300 09017"} =
    iex> CreditorReference.SwissQRR.validate("21 00000 00003 13947 14300 09017")
  """
  @impl CreditorReference.Validator
  def validate(str, _opts \\ []) when is_binary(str) do
    with normalized <- String.replace(str, " ", ""),
         :ok <- is_valid_esr_format(normalized),
         true <- 0 == calculate_modulo10_recursive(normalized) do
      {:ok, str}
    end
  end

  @impl CreditorReference.Generator
  def generate(input, _opts \\ []) when is_binary(input) do
    with normalized <- String.replace(input, " ", ""),
         :ok <- validate_input(input),
         :ok <- validate_input_length(input),
         cecksum_digit <- calculate_modulo10_recursive(normalized),
         cecksum_digit_str <- Integer.to_string(cecksum_digit) do
      esr = String.pad_leading(normalized <> cecksum_digit_str, 27, "0")
      {:ok, esr}
    end
  end

  @start_carry 0
  # Modulo 10 recursive Check digit matrix
  @lookup_table %{
    0 => 0,
    1 => 9,
    2 => 4,
    3 => 6,
    4 => 8,
    5 => 2,
    6 => 7,
    7 => 1,
    8 => 3,
    9 => 5
  }

  @doc """
  Caluteates the checksum number using the modulo 10 recursive method.

  For valid QR-References e.g Numbers with the length 27 the result is expected
  to be 0. If any other number is returned for a 27 character long input than
  the result is a invalid QR-Reference.

  For any input with a length of less then 27 this function can be used to
  calutate the checksum digit. If the input concatiated with the result `input <>
  checksum_digit` are less then 27 characters long the concatenated result needs
  to be left padded with `0` until it reaches the length of 27
  charectarts to be considered a valid QR-Reference.

  ## Examples

    iex> 0 = CreditorReference.SwissQRR.calculate_modulo10_recursive("210000000003139471430009017")
    iex> 7 = CreditorReference.SwissQRR.calculate_modulo10_recursive("21000000000313947143000901")
    iex> 0 = CreditorReference.SwissQRR.calculate_modulo10_recursive("000000000003139471430009018")
  """
  def calculate_modulo10_recursive(str) do
    str
    |> String.graphemes()
    |> Enum.reduce(
      @start_carry,
      fn char, carry ->
        @lookup_table[rem(carry + String.to_integer(char), 10)]
      end
    )
    |> then(fn carry -> rem(10 - carry, 10) end)
  end

  defp is_valid_esr_format(str) do
    cond do
      str == "000000000000000000000000000" -> {:error, :all_zero_not_allowed}
      String.length(str) != 27 -> {:error, :invalid_length}
      :otherwise -> :ok
    end
  end

  defp validate_input(str) do
    case Integer.parse(str) do
      :error -> {:error, :invalid_input}
      {0, ""} -> {:error, :zero_input_not_allowed}
      {_, str} when str != "" -> {:error, :only_numbers_allowed}
      {_i, ""} -> :ok
    end
  end

  defp validate_input_length(str) do
    if String.length(str) < 27, do: :ok, else: {:error, :max_input_length_exceeded}
  end
end
