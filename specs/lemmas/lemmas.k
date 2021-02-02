requires "evm.md"
requires "edsl.md"

module LEMMAS
  imports EVM
  imports EDSL

  rule #range(_M:Map [ IDX1 := #padToWidth(LEN1, BUF) ], IDX2, LEN2) => #padToWidth(LEN1, BUF)
    requires IDX1 ==Int IDX2 andBool LEN1 ==Int LEN2    [simplification]

endmodule
