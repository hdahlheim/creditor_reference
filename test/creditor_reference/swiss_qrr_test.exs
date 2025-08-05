defmodule CreditorReference.SwissQRRTest do
  use ExUnit.Case
  doctest CreditorReference.SwissQRR

  alias CreditorReference.SwissQRR

  test "validates print formatted swiss QR-References" do
    assert CreditorReference.valid?(SwissQRR, "21 00000 00003 13947 14300 09017") == true
    assert CreditorReference.valid?(SwissQRR, "00 00082 07791 22585 74212 86694") == true
    assert CreditorReference.valid?(SwissQRR, "00 00063 17171 24556 59592 26487") == true
  end

  test "validates digital formatted swiss QR-References" do
    assert CreditorReference.valid?(SwissQRR, "210000000003139471430009017") == true
    assert CreditorReference.valid?(SwissQRR, "000008207791225857421286694") == true
    assert CreditorReference.valid?(SwissQRR, "000006317171245565959226487") == true
  end

  test "validate errors on wrong input length" do
    assert CreditorReference.SwissQRR.validate("2100000003139471430009017") ==
             {:error, :invalid_length}

    assert CreditorReference.SwissQRR.validate("21000000000000000003139471430009017") ==
             {:error, :invalid_length}
  end

  test "validate errors on all zero reference" do
    assert CreditorReference.SwissQRR.validate("00 00000 00000 00000 00000 00000") ==
             {:error, :invalid_input}
  end

  test "generates a valid reference" do
    {:ok, ref} = CreditorReference.SwissQRR.generate("123456789")

    assert CreditorReference.valid?(SwissQRR, ref) == true
  end

  test "generate errors on just 0 input and empty input" do
    assert {:error, _} = CreditorReference.SwissQRR.generate("0")
    assert {:error, _} = CreditorReference.SwissQRR.generate("")
  end
end
