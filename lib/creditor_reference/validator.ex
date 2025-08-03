defmodule CreditorReference.Validator do
  @callback valid?(input :: binary()) :: true | false
  @callback validate(input :: binary(), opts :: keyword()) ::
              {:ok, binary()} | {:error, term()}
end
