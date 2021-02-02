requires "./lemmas/verification.k"

module MSIG-SPEC-NONCE
  imports VERIFICATION

  claim
    <k> #execute => #halt </k>
    <exit-code> 1 </exit-code>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>
    <ethereum>
      <evm>
        <output> .ByteArray => #padToWidth(32, #asByteStack(MSIG_NONCE)) </output>
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
          <callData> #abiCallData("nonce", .TypedArgs) </callData>
          <callValue> VCALLVALUE </callValue>
          <wordStack> .WordStack => ?_ </wordStack>
          <localMem> .Memory => ?_ </localMem>
          <pc> 0 => ?_ </pc>
          <gas> VGAS => ?_ </gas>
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
      andBool VGAS >Int 5000

endmodule
