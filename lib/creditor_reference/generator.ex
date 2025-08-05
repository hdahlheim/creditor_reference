defmodule CreditorReference.Generator do
  @moduledoc """
  Generator behavior
  """

  @callback generate(input :: String.t(), opts :: keyword()) ::
              {:ok, String.t()} | {:error, term()}
end
