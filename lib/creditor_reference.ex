defmodule CreditorReference do
  @moduledoc """
  Documentation for `CreditorReference`.
  """

  @type_mapping %{
    :iso_11649 => CreditorReference.ISO11649,
    :swiss_qrr => CreditorReference.SwissQRR
  }

  @doc """
  Validate a creditor reference.

  ## Examples

      iex> CreditorReference.validate(:iso_11649, "RF471234567890")
      {:ok, "RF471234567890"}

  """
  def validate(type \\ :iso_11649, input) when is_atom(type) do
    module = Map.get(@type_mapping, type, type)
    apply(module, :validate, [input])
  end

  @doc """
  Generate a creditor reference.

  ## Examples

      iex> CreditorReference.generate(:iso_11649, "1234567890")
      {:ok, "RF471234567890"}

  """
  def generate(type \\ :iso_11649, input) when is_atom(type) do
    module = Map.get(@type_mapping, type, type)
    apply(module, :generate, [input])
  end
end
