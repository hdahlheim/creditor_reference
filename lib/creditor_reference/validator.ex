defmodule CreditorReference.Validator do
  @moduledoc """
  Validator behavior
  """

  @callback validate(input :: String.t(), opts :: keyword()) ::
              {:ok, String.t()} | {:error, term()}
end
