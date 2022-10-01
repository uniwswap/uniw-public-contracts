// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Get a link to NFT contract
interface NFT {

  function mint(address to, uint256 id) external;

  function setCategory(uint id, uint category) external;
}

// Get a link to payment token contract
interface IPaymentToken {
  
  function balanceOf(address account) external view returns (uint256);

  function transfer(address recipient, uint256 amount) external returns (bool);

  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  function burnFrom(address account, uint256 amount) external;

}


// Get a link to random feed contract
interface IRandomFeed {

  function getRandomFeed(uint256 salt) external returns(uint256 id, uint256 category);

}

/**
   * @title UniwBox Version 1.0
   *
   * @author UniWswap
   */
contract UniWBox {

  //---sell parameters---//  
  uint256 public itemsSold;
  uint256 public items;
  uint256 public price;

  //---Set of addresses---// 
  address public admin;
  address public treasury;
  address public dev;
  address public nftContract;
  address public mintToken;
  address public daoToken;

  address private randomFeed;

  //---Box Control Variable---//
  uint8 public percentageBCV;
  uint8 public valueBCV; // 0 = negative value, 1 = positive value 

  //-----Features-----//
  // 0 = mint is disabled, 1 = mint with mint token is enabled,
  // 2 = mint with DAO token is enabled, 3 = mint with both token is enabled 
  uint8 public feature;

  // Max Token Mint Cap
  uint256 public maxMintCap;

  // Token Mint Count
  mapping(address => uint256) public tokenMintCount;   
  
  /**
	   * @dev Fired in initializeSell()
	   *
     * @param _by an address of owner who executes the function
	   * @param _mintPrice minting price in terms of mint token per UniWbox
     * @param _items number of UniWbox to be sold
     * @param _maxMintCap max Mint cap that particular user can mint.
     */
  event Initialize(
    address indexed _by,
    uint256 _mintPrice,
    uint256 _items,
    uint256 _maxMintCap 
  );

  /**
	   * @dev Fired in setBCV()
	   *
     * @param _by an address of owner who executes the function
	   * @param _percentage BCV percentage
     * @param _value BCV value (0 = negative value, 1 = positive value)
     */
  event BCVUpdated(
    address indexed _by,
    uint8 _percentage,
    uint8 _value
  );

  /**
	   * @dev Fired in setFeature()
	   *
     * @param _by an address of owner who executes the function
	   * @param _feature defines feature code
     */
  event FeatureUpdated(
    address indexed _by,
    uint8 _feature
  );

  /**
	   * @dev Fired in setMaxMintCap()
	   *
     * @param _by an address of owner who executes the function
	   * @param maxMintCap_ max token Mint Cap for Particular user
     */
    event TokenMintCapUpdated(
      address indexed _by,
      uint256 maxMintCap_
    );

  /**
	   * @dev Creates/deploys UniWbox Version 1.0
	   *
	   * @param admin_ address of admin
     * @param treasury_ address of treasury
     * @param dev_ address of dev
     * @param nftContract_ address of BoosterNFT smart contract
     * @param mintToken_ address of mint token
     * @param daoToken_ address of DAO token
     * @param randomFeed_ address of randomFeed contract
	   */
  constructor(
      address admin_,
      address treasury_,
      address dev_,
      address nftContract_,
      address mintToken_,
      address daoToken_,
      address randomFeed_
    )
  {
    //---Setup smart contract internal state---//
    admin = admin_;
    treasury = treasury_;
    dev = dev_;
    nftContract = nftContract_;
    mintToken = mintToken_;
    daoToken = daoToken_;
    randomFeed = randomFeed_;
  }

  /**
	   * @dev Initialize sell parameters
	   *
     * @notice same function can be used to reinitialize parameters,
     *         arguments should be placed carefully for reinitialization/ 
     *         modification of sell parameter 
     *
	   * @param mintPrice_ minting price in terms of mint token per UniWbox
     * @param items_ total number of UniWbox to be sold
     * @param maxMintCap_ max Mint cap that particular user can mint.
	   */
  function initializeSell(uint256 mintPrice_, uint256 items_, uint256 maxMintCap_)
    external
  {
    require(msg.sender == admin, "Only admin can initialize sell");
    
    // Set up sell parameters
    price = mintPrice_;
    items = items_;
    maxMintCap = maxMintCap_;    

    // Emits an event
    emit Initialize(msg.sender, mintPrice_, items_, maxMintCap_);  
  }

  /**
	   * @dev Sets Box Control Variable
	   * 
	   * @param percentage_ BCV percentage
     * @param value_ BCV value (0 = negative value, 1 = positive value)
     */
  function setBCV(uint8 percentage_, uint8 value_)
    external
  {
    require(msg.sender == admin, "Only admin can set BCV");
    
    require(percentage_ <= 100 && value_ <= 1, "Invalid input");
    
    //--- Set up BCV parameters ---//
    percentageBCV = percentage_;
    
    valueBCV = value_;

    //Emits an event
    emit BCVUpdated(msg.sender, percentage_, value_);
  }


  /**
	   * @dev Sets Token Mint Cap
	   * 
	   * @param maxMintCap_ max token Mint Cap for Particular user
     */
  function setMaxMintCap(uint256 maxMintCap_) 
    external
  {
      require(msg.sender == admin, "Only admin can set maxMintCap");

      maxMintCap = maxMintCap_;

      emit TokenMintCapUpdated(msg.sender, maxMintCap_);
  }


  /**
	   * @dev Sets feature
	   * 
	   * @param feature_ defines feature code
     */
  function setFeature(uint8 feature_)
    external
  {
    require(msg.sender == admin, "Only admin can set feature");
    
    require(feature_ <= 3, "Invalid input");
    
    // Set feature
    feature = feature_;

    // Emits an event
    emit FeatureUpdated(msg.sender, feature_);
  }
  
  /**
	   * @dev Sets mint token contract address
	   * 
	   * @param token_ mint token contract address
     */
  function setTokenAddress(address token_)
    external
  {
    require(msg.sender == admin, "Only admin can set randomFeed");
    
    // Set mintToken address
    mintToken = token_;
  }

  /**
	   * @dev Sets DAO token contract address
	   * 
	   * @param dao_ DAO token contract address
     */
  function setDAOTokenAddress(address dao_)
    external
  {
    require(msg.sender == admin, "Only admin can set randomFeed");
    
    // Set daoToken address
    daoToken = dao_;
  }

  
  /**
	   * @dev Sets random feed contract address
	   * 
	   * @param randomFeed_ random feed contract address
     */
  function setRandomFeedAddress(address randomFeed_)
    external
  {
    require(msg.sender == admin, "Only admin can set randomFeed");
    
    // Set randomFeed address
    randomFeed = randomFeed_;
  }

  /**
	   * @dev Mints Booster NFTs by paying price in mint token 
	   * 
	   * @param amount_ number NFTs to buy
     */
  function mintWithToken(uint amount_) external {    
    
    require(feature == 1 || feature == 3, "Feature disabled");
    require(tokenMintCount[msg.sender]+amount_ <= maxMintCap, "Max Mint Cap Hit!!!");

    // update token mint count
    tokenMintCount[msg.sender] += amount_;

    // Calculate mint price in mint token
    uint256 _mintPrice =  price * amount_;

    // Transfer proceedings to dev and treasury address
    IPaymentToken(mintToken).transferFrom(msg.sender, dev, _mintPrice / 10);

    IPaymentToken(mintToken).transferFrom(msg.sender, treasury, (_mintPrice - _mintPrice / 10));

    require(itemsSold + amount_ <= items, "Not enough NFTs left");
    
    for(uint i=0; i < amount_; i++) {
      // Get id and category to be assigned to minted NFT
      (uint256 id, uint256 category) = IRandomFeed(randomFeed).getRandomFeed(itemsSold * _mintPrice * i);
      // Mint an NFT
      NFT(nftContract).mint(msg.sender, id);
      // Set the category of minted NFT
      NFT(nftContract).setCategory(id, category);
      // Increment sold counter
      itemsSold++;
    }

  }

  /**
	   * @dev Mints Booster NFTs by paying price in DAO token 
	   * 
	   * @param amount_ number NFTs to buy
     */
  function mintWithDAOToken(uint amount_) external {    
    
    require(feature == 2 || feature == 3, "Feature disabled");
    require(tokenMintCount[msg.sender]+amount_ <= maxMintCap, "Max Mint Cap Hit!!!");

    // update token mint count
    tokenMintCount[msg.sender] += amount_;

    // Calculate mint price in DAO token
    uint256 _mintPrice = price * amount_;

    // Burn DAO tokens
    IPaymentToken(daoToken).burnFrom(msg.sender, (_mintPrice - _mintPrice / 10));
    IPaymentToken(daoToken).transferFrom(msg.sender, treasury, _mintPrice / 10);


    require(itemsSold + amount_ <= items, "Not enough NFTs left");

    for(uint i=0; i < amount_; i++) {
      // Get id and category to be assigned to minted NFT  
      (uint256 id, uint256 category) = IRandomFeed(randomFeed).getRandomFeed(itemsSold * _mintPrice * i);
      // Mint an NFT
      NFT(nftContract).mint(msg.sender, id);
      // Set the category of minted NFT
      NFT(nftContract).setCategory(id, category);
      // Increment sold counter
      itemsSold++;
    }

  }


  /**
     * @dev Withdraw tokens 
     * 
     * @param token_ address of token
     */
  function withdrawTokens(address token_) external {
    
    require(msg.sender == admin, "Only admin can withdraw tokens");

    // Fetch balance of the contract  
    uint _balance = IPaymentToken(token_).balanceOf(address(this));
    
    require(_balance > 0, "Zero balance");
    
    // transfer tokens to owner if balance is non-zero
    IPaymentToken(token_).transfer(msg.sender, _balance);
      
  }

}
