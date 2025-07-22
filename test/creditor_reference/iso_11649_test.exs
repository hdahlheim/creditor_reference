defmodule CreditorReference.ISO11649Test do
  use ExUnit.Case
  doctest CreditorReference.ISO11649

  test "valid ISO 11649 reference" do
    assert CreditorReference.ISO11649.valid?("RF471234567890") == true
    assert CreditorReference.ISO11649.valid?("RF18 5390 0754 7034") == true
    assert CreditorReference.ISO11649.valid?("RF18000000000539007547034") == true
    assert CreditorReference.ISO11649.valid?("RF18000000000539007547034") == true
    assert CreditorReference.ISO11649.valid?("RF712348231") == true
    assert CreditorReference.ISO11649.valid?("RF71 2348 231") == true
  end

  test "invalid ISO 11649 reference" do
    assert CreditorReference.ISO11649.valid?("123456789") == false
    assert CreditorReference.ISO11649.valid?("RF123456789") == false
    assert CreditorReference.ISO11649.valid?("RF00 0000 0000 0000 0000") == false
  end

  test "generates a valid reference" do
    {:ok, cr} = CreditorReference.ISO11649.generate("hallo")

    assert CreditorReference.ISO11649.valid?(cr) == true
  end

  test "print format" do
    formatted = CreditorReference.ISO11649.format_print("RF18000000000539007547034")

    assert "RF18 0000 0000 0539 0075 4703 4" == formatted
  end
end
