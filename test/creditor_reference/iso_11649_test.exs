defmodule CreditorReference.ISO11649Test do
  use ExUnit.Case
  doctest CreditorReference.ISO11649

  alias CreditorReference.ISO11649

  test "valid ISO 11649 reference" do
    assert CreditorReference.valid?(ISO11649, "RF471234567890") == true
    assert CreditorReference.valid?(ISO11649, "RF18 5390 0754 7034") == true
    assert CreditorReference.valid?(ISO11649, "RF18000000000539007547034") == true
    assert CreditorReference.valid?(ISO11649, "RF712348231") == true
    assert CreditorReference.valid?(ISO11649, "RF71 2348 231") == true
  end

  test "invalid ISO 11649 reference" do
    assert CreditorReference.valid?(ISO11649, "123456789") == false
    assert CreditorReference.valid?(ISO11649, "RF123456789") == false
    assert CreditorReference.valid?(ISO11649, "RF00 0000 0000 0000 0000") == false
  end

  test "generates a valid reference" do
    {:ok, cr} = CreditorReference.ISO11649.generate("hallo")

    assert CreditorReference.valid?(ISO11649, cr) == true
  end

  test "print format" do
    formatted = CreditorReference.ISO11649.format_print("RF18000000000539007547034")

    assert "RF18 0000 0000 0539 0075 4703 4" == formatted
  end
end
