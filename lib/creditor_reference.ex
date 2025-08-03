defmodule CreditorReference do
  @moduledoc """
  Documentation for `CreditorReference`.
  """

  @cr_alias %{
    :iso_11649 => CreditorReference.ISO11649,
    :swiss_qrr => CreditorReference.SwissQRR
  }

  def valid?(type, input) do
    case validate(type, input) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end

  @doc """
  Validate a creditor reference.

  ## Examples

      iex> CreditorReference.validate(:iso_11649, "RF471234567890")
      {:ok, "RF471234567890"}

  """
  def validate(type \\ get_default_type(), input) when is_atom(type) do
    module = Map.get(@cr_alias, type, type)
    apply(module, :validate, [input])
  end

  @doc """
  Generate a creditor reference.

  ## Examples

      iex> CreditorReference.generate(:iso_11649, "1234567890")
      {:ok, "RF471234567890"}

  """
  def generate(type \\ :iso_11649, input) when is_atom(type) do
    module = Map.get(@cr_alias, type, type)
    apply(module, :generate, [input])
  end

  defp get_default_type do
    :iso_11649
  end
end
