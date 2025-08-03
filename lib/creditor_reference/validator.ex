defmodule CreditorReference.Validator do
  @callback validate(input :: binary(), opts :: keyword()) ::
              {:ok, binary()} | {:error, term()}
end
