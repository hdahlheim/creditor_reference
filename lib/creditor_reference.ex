defmodule CreditorReference do
  @moduledoc """
  Documentation for `CreditorReference`.
  """

  @doc """
  Validate a creditor reference.

  ## Examples

      iex> CreditorReference.validate(:iso_11649, "RF471234567890")
      {:ok, "RF471234567890"}

  """
  def validate(type \\ :iso_11649, input) when type in [:iso_11649] do
    CreditorReference.ISO11649.validate(input)
  end

  @doc """
  Generate a creditor reference.

  ## Examples

      iex> CreditorReference.generate(:iso_11649, "1234567890")
      {:ok, "RF471234567890"}

  """
  def generate(type \\ :iso_11649, input) when type in [:iso_11649] do
    CreditorReference.ISO11649.generate(input)
  end
end
