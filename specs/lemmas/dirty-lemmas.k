requires "lemmas.k"

module DIRTY-LEMMAS
  imports LEMMAS

  // Extracting the function signature
  //TODO: need more preconditions on this I think
  // We are missing this #noOverflowAux(WS) condition which checks that each
  // element of the byte array is indeed a single byte
  /* rule #asWord(WS) >>Int 224 => #asWord(#take(#sizeByteArray(WS) -Int 28, WS)) */
  /*   requires #sizeByteArray(WS) >=Int 28 */
  /*     /1* andBool #noOverflow(WS) *1/ */
  /*     andBool #sizeByteArray(WS) <=Int 32 */
  /*   [simplification] */
  rule #asWord(WS) >>Int SHIFT => #asWord(#take(#sizeByteArray(WS) -Int (SHIFT /Int 8), WS))
    requires SHIFT >=Int 0 andBool SHIFT %Int 8 ==Int 0
      andBool #sizeByteArray(WS) >=Int (SHIFT /Int 8)
      andBool #sizeByteArray(WS) <=Int 32
    [simplification]

  rule #sizeByteArray(#take(N, _)) => N [simplification]

  // for the case when DATA_LEN ==Int 0
  rule #buf(LEN, _) => .ByteArray requires LEN ==Int 0 [simplification]

endmodule
