requires "./lemmas/verification.k"

module MSIG-SPEC-EXECUTE
  imports VERIFICATION

  claim
    <k> #execute => #halt </k>
    <exit-code> 1 </exit-code>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <ethereum>
      <evm>
        <output>
          _ =>
          #buf(32, keccak( #parseHexWord("0x19") : #parseHexWord("0x1")
                         : (  #buf(32, DOM_SEP)
                           ++ #buf(32, keccak(#encodeArgs( #bytes32(#exec_typehash)
                                                         , #address(CALL_SRC)
                                                         , #address(CALL_DST)
                                                         , #uint8(CALL_TYPE)
                                                         , #uint256(MSIG_NONCE)
                                                         , #uint256(CALL_GAS)
                                                         , #uint256(CALL_VAL)
                                                         , #bytes32(keccak(#buf(DATA_LEN, DATA))) ))) ) ))
        </output>
        <statusCode> _ => EVMC_SUCCESS </statusCode>
        <endPC> _ => ?_ </endPC>
        <callStack> _ </callStack>
        <interimStates> _ </interimStates>
        <touchedAccounts> _ </touchedAccounts>
        <callState>
          <program>
            #runtime
            ++ #buf(32, THRESH)
            ++ #buf(32, DOM_SEP)
          </program>
          <jumpDests> #computeValidJumpDests(#runtime) </jumpDests> // TODO: this should include jumpdests in the appended data
          /* <jumpDests> */
          /*   #computeValidJumpDests(  #runtime */
          /*                         ++ #buf(32, THRESH) */
          /*                         ++ #buf(32, DOM_SEP) ) */
          /* </jumpDests> */
          <id> VADDRESS </id>
          <caller> VCALLER </caller>
          <callData>
            #abiCallData( "execute"
                        , #address(CALL_SRC)
                        , #address(CALL_DST)
                        , #uint8(CALL_TYPE)
                        , #uint256(CALL_GAS)
                        , #uint256(CALL_VAL)
                        , #bytes(#buf(DATA_LEN, DATA))
                        , #bytes(#buf(SIGS_LEN, _SIGS)) )
          </callData>
          <callValue> VCALLVALUE </callValue>
          <wordStack> .WordStack => ?_ </wordStack>
          <localMem> .Memory => ?_ </localMem>
          <pc> 0 => ?_ </pc>
          <gas> #gas(VGAS) => ?_ </gas>
          <memoryUsed> 0 => ?_ </memoryUsed>
          <callGas> _ => ?_ </callGas>
          <static> false </static>
          <callDepth> _ </callDepth>
        </callState>
        <substate>
          <selfDestruct> _ </selfDestruct>
          <log> _ </log>
          <refund> _ => ?_ </refund> // TODO: make this tighter
        </substate>
        <gasPrice> _ </gasPrice>
        <origin> _ </origin>
        <blockhashes> _ </blockhashes>
        <block> _ </block>
      </evm>
      <network>
        <chainID> _ </chainID>
        <activeAccounts> SetItem(VADDRESS) ...</activeAccounts>
        <accounts>
          <account>
            <acctID> VADDRESS </acctID>
            <balance> _ </balance>
            <code>
              #runtime
              ++ #buf(32, THRESH)
              ++ #buf(32, DOM_SEP)
            </code>
            <storage> 0 |-> (MSIG_NONCE => MSIG_NONCE +Int 1) ...</storage>
            <origStorage> _ </origStorage>
            <nonce> _ </nonce>
          </account>
          ...
        </accounts>
        <txOrder> _ </txOrder>
        <txPending> _ </txPending>
        <messages> _ </messages>
      </network>
    </ethereum>
    requires
      VCALLVALUE ==Int 0
      andBool VGAS ==Int 500000
      // calldata
      andBool #rangeAddress(CALL_SRC)
      andBool #rangeAddress(CALL_DST)
      andBool #rangeUInt(8, CALL_TYPE)
      andBool #rangeUInt(256, CALL_GAS)
      andBool #rangeUInt(256, CALL_VAL)
      /* andBool #range(1 <= DATA_LEN < 2 ^Int 16) // TODO: causes K to run out of memory */
      andBool DATA_LEN ==Int 60
      andBool #range((THRESH *Int 65) <= SIGS_LEN < 2 ^Int 16)
      // contract state
      andBool #rangeUInt(8, THRESH)
      andBool #rangeUInt(256, DOM_SEP)
      andBool #range(0 <= MSIG_NONCE < (pow256 -Int 1))
      // requires
      andBool (VCALLER ==Int CALL_SRC orBool CALL_SRC ==Int 0)

      /* andBool #rangeUInt(8, SIGNERS_LEN) */
      /* andBool DATA_LEN ==Int 0 */

endmodule
