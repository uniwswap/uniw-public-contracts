// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.16;

interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view returns (address);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address _owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: weiValue}(
            data
        );
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @title SafeBEP20
 * @dev Wrappers around BEP20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeBEP20 for IBEP20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeBEP20 {
    using Address for address;

    function safeTransfer(
        IBEP20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IBEP20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IBEP20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeBEP20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IBEP20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) - value;
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IBEP20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(
            data,
            "SafeBEP20: low-level call failed"
        );
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeBEP20: BEP20 operation did not succeed"
            );
        }
    }
}

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

/* is ERC165 */
interface ERC721 {
    function balanceOf(address _owner) external view returns (uint256);

    function ownerOf(uint256 _tokenId) external view returns (address);

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable;

    function totalSupply() external view returns (uint256);
}

interface IBoosterNFT {
    function getNftType(uint256 tokenId) external view returns (uint8 index);
}

// Launchpad with boostable participation amount by NFT staking
contract UniWpad is ReentrancyGuard {
    using SafeBEP20 for IBEP20;

    // Info of each user.
    struct UserInfo {
        uint256 amount; // How many tokens the user has provided.
        bool claimed; // default false
    }

    //   NFT User Details
    struct NFTUserDetails {
        address nftAddress;
        uint256 tokenId;
    }

    // USER Info
    mapping(address => UserInfo) public userInfo; // address => amount

    // Max Participated Amount
    mapping(address => uint256) public _maxParticipateAmount;

    // Booster NFT link details
    mapping(address => NFTUserDetails) private _depositedNFT; // user => nft Details

    // NFTs power based depending on each NFT category
    mapping(uint8 => uint256) public nftBoostRate; // nftType => Boostrate

    // participators
    address[] public addressList;

    // Booster NFT contract address
    IBoosterNFT public boosterNFT;

    // admin address
    address public adminAddress;
    // The raising token
    IBEP20 public lpToken;
    // The offering token
    IBEP20 public offeringToken;
    // The block number when IFO starts
    uint256 public startBlock;
    // The block number when IFO ends
    uint256 public endBlock;
    // The amount of Blocks to delay the harvest, to give team time for Liq adding after Presale ends
    uint256 public harvestDelayBlocks;
    // total amount of raising tokens need to be raised
    uint256 public raisingAmount;
    // total amount of offeringToken that will offer
    uint256 public offeringAmount;
    // total amount of raising tokens that have already raised
    uint256 public totalAmount;

    // minimum amount to participate
    uint256 public minParticipationAmount;

    // maximum amount to participate without NFT Boost!
    uint256 public maxParticipationAmount;

    event Deposit(address indexed user, uint256 amount);
    event Harvest(
        address indexed user,
        uint256 offeringAmount,
        uint256 excessAmount
    );
    event StakeNFT(
        address indexed user,
        address stakedNFT,
        uint256 stakedNftID
    );
    event UnstakeNFT(
        address indexed user,
        address unstakedNFT,
        uint256 unstakedNftID
    );

    constructor(
        IBEP20 _lpToken,
        IBEP20 _offeringToken,
        IBoosterNFT _boosterNFT,
        uint256 _startBlock,
        uint256 _endBlock,
        uint256 _harvestDelayBlocks,
        uint256 _offeringAmount,
        uint256 _raisingAmount,
        address _adminAddress,
        uint256 _minParticipationAmount,
        uint256 _maxParticipationAmount
    ) {
        lpToken = _lpToken;
        offeringToken = _offeringToken;
        boosterNFT = _boosterNFT;
        startBlock = _startBlock;
        endBlock = _endBlock;
        harvestDelayBlocks = _harvestDelayBlocks;
        offeringAmount = _offeringAmount;
        raisingAmount = _raisingAmount;
        totalAmount = 0;
        adminAddress = _adminAddress;
        minParticipationAmount = _minParticipationAmount;
        maxParticipationAmount = _maxParticipationAmount;

        nftBoostRate[0] = 110; // => 110/100 = +10%
        nftBoostRate[1] = 120; // => 120/100 = +20%
        nftBoostRate[2] = 130; // => 130/100 = +30%
        nftBoostRate[3] = 140; // => 140/100 = +40%
        nftBoostRate[4] = 150; // => 150/100 = +50%
        nftBoostRate[5] = 200; // => 200/100 = +100%
    }

    modifier onlyAdmin() {
        require(msg.sender == adminAddress, "admin: wut?");
        _;
    }

    function isAllowedNFT(address _address) public view returns (bool) {
        return address(boosterNFT) == _address;
    }

    function setStakableNft(IBoosterNFT _newNftAddress) external onlyAdmin {
        boosterNFT = _newNftAddress;
    }

    function setStartEndDelayBlocks(
        uint256 _startBlock,
        uint256 _endBlock,
        uint256 _harvestDelayBlocks
    ) external onlyAdmin {
        startBlock = _startBlock;
        endBlock = _endBlock;
        harvestDelayBlocks = _harvestDelayBlocks;
    }

    function setMinAndMaxParticipationAmount(
        uint256 _minAmount,
        uint256 _maxAmount
    ) external onlyAdmin {
        minParticipationAmount = _minAmount;
        maxParticipationAmount = _maxAmount;
    }

    function setOfferingAmount(uint256 _offerAmount) external onlyAdmin {
        require(block.timestamp < startBlock, "no");
        offeringAmount = _offerAmount;
    }

    function setNftBoostRate(uint8 _nftType, uint256 _power) external onlyAdmin {
        nftBoostRate[_nftType] = _power;
    }

    function setRaisingAmount(uint256 _raisingAmount) external onlyAdmin {
        require(block.timestamp < startBlock, "no");
        raisingAmount = _raisingAmount;
    }

    /* ========== NFT View Functions ========== */

    // get user boost factor and ID of staked NFT
    function getBoost(address _account) public view returns (uint256, uint256) {
        // 1. boostFactor  2. tokenID
        NFTUserDetails memory nftUserDetail = _depositedNFT[_account];
        if (nftUserDetail.nftAddress == address(0x0)) {
            return (100, 0); // returns 100 for no staked NFT = Boostfactor of 1 (no boost!)
        }
        uint8 _nftType = boosterNFT.getNftType(nftUserDetail.tokenId); // NFT type is uint between 0 and 5

        return (nftBoostRate[_nftType], nftUserDetail.tokenId);
    }

    // get users max participation amount
    function getMaxParticipationAmountOfUser(address _account)
        public
        view
        returns (uint256)
    {
        (uint256 boostFactor, ) = getBoost(_account);
        return (maxParticipationAmount * boostFactor) / 100;
    }

    // update remainAmountOfUser
    function getRemainAmountOfUser(address _account)
        public
        view
        returns (uint256)
    {
        return _maxParticipateAmount[_account];
    }

    // get users Remaining Participation Amount
    function getUsersRemainingParticipationAmount(address _account)
        public
        view
        returns (uint256)
    {
        uint256 alreadyDeposited = userInfo[_account].amount;
        if (alreadyDeposited == 0 || getRemainAmountOfUser(_account) == 0) {
            return getMaxParticipationAmountOfUser(_account);
        }
        return getRemainAmountOfUser(_account) - alreadyDeposited;
    }

    /* ========== NFT External Functions ========== */

    // Staking of NFTs
    function stakeNFT(address _nft, uint256 _tokenId) external nonReentrant {
        require(isAllowedNFT(_nft), "only allowed NFTs");
        require(
            ERC721(_nft).ownerOf(_tokenId) == msg.sender,
            "user does not have specified NFT"
        );
        require(block.timestamp < endBlock, "Ido has already finished!");

        NFTUserDetails memory nftUserDetail = _depositedNFT[msg.sender];
        require(
            nftUserDetail.nftAddress == address(0x0),
            "user has already staked a NFT to Boost"
        );

        ERC721(_nft).transferFrom(msg.sender, address(this), _tokenId);
        uint8 _nftType = boosterNFT.getNftType(_tokenId);
        uint256 _boostrate = nftBoostRate[_nftType];
        nftUserDetail.nftAddress = _nft;
        nftUserDetail.tokenId = _tokenId;
        _maxParticipateAmount[msg.sender] =
            (maxParticipationAmount * _boostrate) /
            100;
        _depositedNFT[msg.sender] = nftUserDetail;
        emit StakeNFT(msg.sender, _nft, _tokenId);
    }

    // Unstaking of NFTs
    function unstakeNFT() external nonReentrant {
        NFTUserDetails memory nftUserDetail = _depositedNFT[msg.sender];
        require(
            nftUserDetail.nftAddress != address(0x0),
            "user has not staked any NFT!"
        );
        require(
            block.timestamp > endBlock + harvestDelayBlocks,
            "presale has not ended now!"
        );

        address _nft = nftUserDetail.nftAddress;
        uint256 _tokenId = nftUserDetail.tokenId;

        nftUserDetail.nftAddress = address(0x0);
        nftUserDetail.tokenId = 0;

        _depositedNFT[msg.sender] = nftUserDetail;

        ERC721(_nft).transferFrom(address(this), msg.sender, _tokenId);
        emit UnstakeNFT(msg.sender, _nft, _tokenId);
    }

    function deposit(uint256 _amount) external {
        require(
            block.timestamp > startBlock && block.timestamp < endBlock,
            "not ifo time"
        );
        // get user amount
        uint256 alreadyDeposited = userInfo[msg.sender].amount;

        if (alreadyDeposited == 0) {
            require(
                _amount >= minParticipationAmount &&
                    _amount <= getMaxParticipationAmountOfUser(msg.sender) &&
                    _amount + totalAmount <= raisingAmount,
                "need _amount > minParticipationAmount && < maxParticipationAmount && not exceeds raising amount cap"
            );
        }

        // get users allowed reaminung participation amount
        uint256 allowedReaminingDepositAmount = getMaxParticipationAmountOfUser(
            msg.sender
        ) - alreadyDeposited;

        require(
            _amount <= allowedReaminingDepositAmount && _amount + totalAmount <= raisingAmount,
            "need _amount < users maxParticipationAmount or _amount > HARDCAP MAX"
        );

        lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);

        if (alreadyDeposited == 0) {
            addressList.push(address(msg.sender));
        }

        // set user amout
        userInfo[msg.sender].amount = userInfo[msg.sender].amount + _amount;
        totalAmount = totalAmount + _amount;
        emit Deposit(msg.sender, _amount);
    }

    function harvest() external nonReentrant {
        require(
            block.timestamp > endBlock + harvestDelayBlocks,
            "not harvest time"
        );
        require(userInfo[msg.sender].amount > 0, "have you participated?");
        require(!userInfo[msg.sender].claimed, "nothing to harvest");

        uint256 offeringTokenAmount = getOfferingAmount(msg.sender);
        uint256 refundingTokenAmount = getRefundingAmount(msg.sender);

        offeringToken.safeTransfer(address(msg.sender), offeringTokenAmount);

        if (refundingTokenAmount > 0) {
            lpToken.safeTransfer(address(msg.sender), refundingTokenAmount);
        }
        userInfo[msg.sender].claimed = true;
        emit Harvest(msg.sender, offeringTokenAmount, refundingTokenAmount);
    }

    function hasHarvest(address _user) external view returns (bool) {
        return userInfo[_user].claimed;
    }

    // allocation 100000 means 0.1(10%), 1 means 0.000001(0.0001%), 1000000 means 1(100%)
    function getUserAllocation(address _user) public view returns (uint256) {
        if (totalAmount == 0) {
            return 0;
        } else {
            return (userInfo[_user].amount * 1e12) / totalAmount / 1e6;
        }
    }

    // get the amount of IFO token you will get
    function getOfferingAmount(address _user) public view returns (uint256) {
        if (totalAmount > raisingAmount) {
            uint256 allocation = getUserAllocation(_user);
            return (offeringAmount * allocation) / 1e6;
        } else {
            // userInfo[_user] / (raisingAmount / offeringAmount)
            return (userInfo[_user].amount * offeringAmount) / raisingAmount;
        }
    }

    // get the amount of lp token you will be refunded
    function getRefundingAmount(address _user) public view returns (uint256) {
        if (totalAmount <= raisingAmount) {
            return 0;
        }
        uint256 allocation = getUserAllocation(_user);
        uint256 payAmount = (raisingAmount * allocation) / 1e6;
        return userInfo[_user].amount - payAmount;
    }

    // get amount of users participated
    function getAddressListLength() external view returns (uint256) {
        return addressList.length;
    }

    // for admin to receive all remaining lpToken and offeringToken
    function finalWithdraw(uint256 _lpAmount, uint256 _offerAmount)
        external
        onlyAdmin
    {
        require(
            _lpAmount <= lpToken.balanceOf(address(this)),
            "not enough token 0"
        );
        require(
            _offerAmount <= offeringToken.balanceOf(address(this)),
            "not enough token 1"
        );
        lpToken.safeTransfer(address(msg.sender), _lpAmount);
        offeringToken.safeTransfer(address(msg.sender), _offerAmount);
    }
}
