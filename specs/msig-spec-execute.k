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
          .ByteArray
        =>
          #buf(32, keccak(#encodeArgs( #bytes32(#exec_typehash)
                                     , #address(CALL_SRC)
                                     , #address(CALL_DST)
                                     , #uint8(CALL_TYPE)
                                     , #uint256(MSIG_NONCE)
                                     , #uint256(CALL_GAS)
                                     , #uint256(CALL_VAL)
                                     , #bytes32(keccak(#buf(DATA_LEN, DATA))) )))
        </output>
        <statusCode> _ => EVMC_SUCCESS </statusCode>
        <endPC> _ => ?_ </endPC>
        <callStack> _ </callStack>
        <interimStates> _ </interimStates>
        <touchedAccounts> _ </touchedAccounts>
        <callState>
          <program> #runtime </program>
          <jumpDests> #computeValidJumpDests(#runtime) </jumpDests>
          <id> VADDRESS </id>
          <caller> _ </caller>
          <callData>
            #abiCallData( "execute"
                        , #address(CALL_SRC)
                        , #address(CALL_DST)
                        , #uint8(CALL_TYPE)
                        , #uint256(CALL_GAS)
                        , #uint256(CALL_VAL)
                        , #bytes(#buf(DATA_LEN, DATA))
                        , #bytes(.ByteArray) )
          </callData>
          <callValue> VCALLVALUE </callValue>
          <wordStack> .WordStack => ?_ </wordStack>
          <localMem> .Memory => ?_ </localMem>
          <pc> 0 => ?_ </pc>
          <gas> #gas(VGAS) => ?_ </gas>
          <memoryUsed> 0 => ?_ </memoryUsed>
          <callGas> _ => ?_ </callGas>
          <static> _ </static>
          <callDepth> _ </callDepth>
        </callState>
        <substate> _ </substate>
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
            <code> #runtime </code>
            <storage> 0 |-> MSIG_NONCE ...</storage>
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
      #rangeUInt(256, MSIG_NONCE)
      andBool VCALLVALUE ==Int 0
      andBool VGAS ==Int 500000
      andBool #rangeAddress(CALL_SRC)
      andBool #rangeAddress(CALL_DST)
      andBool #rangeUInt(8, CALL_TYPE)
      andBool #rangeUInt(256, CALL_GAS)
      andBool #rangeUInt(256, CALL_VAL)
      andBool #range (1 <= DATA_LEN < 2 ^Int 16)
      /* andBool DATA_LEN ==Int 0 */

endmodule
