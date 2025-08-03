defmodule CreditorReference.Generator do
  @callback generate(input :: binary(), opts :: keyword()) ::
              {:ok, binary} | {:error, term()}
end
