pragma solidity ^0.8.0;

/**
 * If a self-call, override sender with the overpacked address from
 * NativeMetaTransaction.
 *
 * Ref: https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/ContextMixin.sol
 */
abstract contract ContextMixin {
    /**
     * Returns msg.sender address or signer address if meta-transaction
     *
     * @return sender
     */
    function msgSender()
        internal
        view
        returns (address payable sender)
    {
        if (msg.sender == address(this)) {
            bytes memory array = msg.data;
            uint256 index = msg.data.length;
            assembly {
                // Load the 32 bytes word from memory with the address on the
                // lower 20 bytes, and mask those.
                sender := and(
                    mload(add(array, index)),
                    0xffffffffffffffffffffffffffffffffffffffff
                )
            }
        } else {
            sender = payable(msg.sender);
        }
    }
}
