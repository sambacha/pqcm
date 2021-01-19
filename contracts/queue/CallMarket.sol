
//pragma solidity 0.5.12;

pragma solidity >=0.5.7 <0.6.0;
//import "node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "./HeapDynamicArray.sol";
import "./HeapStaticArray.sol";
import "./HeapMapping.sol";
import "./LinkedList.sol";
import "./LinkedListMapping.sol";

contract CallMarket{

    //HeapDynamicArray public priorityQueue = new HeapDynamicArray();
    //HeapStaticArray public priorityQueue = new HeapStaticArray(84);
    //HeapMapping public priorityQueue = new HeapMapping();
    //we pass the address of the callmarket to the LinkedList so that the selfdestruct could send Ethers back to the callmarket
    //LinkedList public priorityQueue = new LinkedList(address(this));
    LinkedListMapping public priorityQueue = new LinkedListMapping();
    //Mapping public MP = new Mapping(address(this));
    address payable public callmarket = address(uint160(address(this)));
    
//***********************************************************************//

    /**
    *   @dev Converts string to uint and returns the uint
    */

    function strTouint (string memory s) internal pure returns (uint) {
        bytes memory b = bytes(s);
        uint i;
        uint result = 0;
        uint j = b.length;
        for (i = 0; i < j; i++) {
            uint c = uint(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }

        return result;
    }
//***********************************************************************//

    /**
    *   @dev Converts uint to string and returns the string
    */

    function uintTostr (uint intVar) internal pure returns (string memory _uintAsString) {
        if (intVar == 0) {
            return "0";
        }
        uint j = intVar;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (intVar != 0) {
            bstr[k--] = byte(uint8(48 + intVar % 10));
            intVar /= 10;
        }
        return string(bstr);
    }
//***********************************************************************//
    
    /**
    *   @dev Contcatenates two string and returns the result
    */

    function contcat(string memory a, string memory b) internal pure returns (string memory) {

        return string (abi.encodePacked( a , b));
    }

//****************************************************//
//****************************************************//
//****************************************************//

    /**
    *   @dev
        States.Open: The market is open
        States.Closed: The market is closed but the orders have not yet been processed
        States.Settled: The market is closed and settled (orders have been processed)
        creationTime: The openning time of the market
        biddingPeriod: The window of time during which the market is open
        numOrders: Total orders in the market (both bids and asks)
        buylistCounter: A bid orders counter that is decremented every time a bid is submitted (used for handling ties)
        sellistCounter: An ask orders counter that is incremented every time an ask is submitted (used for handling ties)
        refunds: Maintains the refund counters to be transferred to the block.coinbase (current block miner)

        totalTokenBalance: Maintains the total token balance of each trader 
        unavailableTokenBalance: Maintains the number of tokens a trader has depositted
        unavailableTokenArray: Maintains a list of unavailableTokenBalance addresses, this list will be used to delete the unavailableTokenBalance mapping

        totalEtherBalance: Maintains the total ETH balance of each trader 
        unavailableEtherBalance: Maintains the number of ETH a trader has depositted
        unavailableEtherArray: Maintains a list of unavailableEtherBalance addresses, this list will be used to delete the unavailableEtherBalance mapping
    */

    //uint256 public countervariable;
    enum States {Open, Closed, Settled} 
    States internal state;
    uint256 public creationTime;
    uint256 public biddingPeriod;
    uint256 public numOrders;        
    uint256 public buylistCounter;   
    uint256 public sellistCounter;  
    mapping(address => uint256) internal refunds;

    mapping(address => uint256) public totalTokenBalance;
    mapping(address => uint256) public unavailableTokenBalance;
    address[] public unavailableTokenArray;

    mapping(address => uint256) public totalEtherBalance;
    mapping(address => uint256) public unavailableEtherBalance;
    address[] public unavailableEtherArray;
    


//**********************************************//
//***************Function Modifiers*************//
//**********************************************//

    /* modifier CheckAuctionStage () {
        if (now >= creationTime + biddingPeriod || numOrders == 1000) 
        {
            CloseMarket();
        }
        _;
    } */

    
//**********************************************// 
    /**
    *   @dev Checks whether the market is at state_1 or not 
    */

    modifier auctionAtStage (States state_1 ) { 
        require (state == state_1); 
        _;
    }
//***********************************************************************//
    /**
    *   @dev Allows the traders to deposit ERC20 tokens
        Traders must firs call the approve() from the ERC20 token contract to allow the call market contract to spend those tokens
    */

    function depositToken(address token, uint256 numofTokens) external returns (bool) {
        
        totalTokenBalance[msg.sender] += numofTokens;
        IERC20(token).transferFrom(msg.sender, address(this), numofTokens);        
        return true;
    
    }
//***********************************************************************//
    /**
    *   @dev Allows the traders to deposit ETH
    */ 

    function depositEther() external payable returns (bool) {
        totalEtherBalance[msg.sender] += msg.value;
        
        return true;
    }



//***********************************************************************//
    /**
    *   @dev Opens the market
    */ 

    function openMarket() external returns (bool) {

        creationTime = block.timestamp; 
        biddingPeriod = 10 minutes;
        state = States.Open;
        numOrders = 0;
        sellistCounter = 100;
        buylistCounter = 999;
        return true;

    }
//***********************************************************************//
    /**
    *   @dev 
        Allows traders to submit bid orders if the market is at the open state
        Traders must have enough ETH already depositted
        To handle ties: Converts the bid price to string, contactenate it with the buylistCounter and converts the constactenated string to uint
        Calls the PQ InsertBid function
        Increment the market's total number of orders 
        Decrements the buylistCounter
        Increase the unavailableEtherBalance of the trader by _volume * _price;
    */ 
  
    function submitBid (uint256 price, uint256 volume) external auctionAtStage (States.Open) returns (bool)
    {
        require ((totalEtherBalance[msg.sender] - unavailableEtherBalance[msg.sender]) >= volume * price, 'Ether balance is not enough!' );
        
        uint256 _finalpriceUint;
        string memory _finalpriceString;
        _finalpriceString = contcat ( uintTostr(price), uintTostr (buylistCounter));
        _finalpriceUint = strTouint (_finalpriceString);
        
        numOrders++;
        buylistCounter--;
        unavailableEtherBalance[msg.sender] += volume * price;
        unavailableEtherArray.push(msg.sender);
        priorityQueue.insertBid(msg.sender, price, volume, _finalpriceUint);
        return true;
    }

//***********************************************************************//
    /**
    *   @dev 
        Allows traders to submit ask orders if the market is at the open state
        Traders must have enough tokens already depositted
        To handle ties: Converts the ask price to string, contactenate it with the sellistCounter and converts the constactenated string to uint
        Calls the PQ InsertAsk function
        Increments the market's total number of orders 
        Increments the sellistCounter
        Increase the unavailableTokenBalance of the trader by _volume
    */ 

    function submitAsk (uint256 price, uint256 volume) external auctionAtStage (States.Open) returns (bool)
    {
        require((totalTokenBalance[msg.sender] - unavailableTokenBalance[msg.sender]) >= volume, 'Token balance is not enough!');
        uint256 _finalpriceUint;
        string memory _finalpriceString;
        _finalpriceString = contcat ( uintTostr(price), uintTostr (sellistCounter));
        _finalpriceUint = strTouint (_finalpriceString);
        
        numOrders++;
        sellistCounter++;
        unavailableTokenBalance[msg.sender] += volume;
        unavailableTokenArray.push(msg.sender);
        priorityQueue.insertAsk(msg.sender, price, volume, _finalpriceUint);
        return true;

    }
//***********************************************************************//
    /**
    *   @dev Closes the market
    */ 

    function closeMarket() external returns (bool)
    {
        state = States.Closed;
        return true;
    }

//***********************************************************************//
    /**
    *   @dev 
        Processes the orders only if the market is at the closed state

    */



    //*********************************************************//
    /**
    *   @dev 
        matchorders() version 1: Volumes are all 1

    */
    /* function matchOrders() external auctionAtStage(States.Closed) returns (bool){

        
        state = States.Settled;

        (uint256 BBPrice, address BBSender, uint256 BBVolume) = priorityQueue.buyListMaxDelete();
        (uint256 BAPrice, address BASender, uint256 BAVolume) = priorityQueue.sellListMaxDelete();
    
        while (BBPrice >= BAPrice)
        
        {  
    
            //Alice bids 110$, Bob asks for 90$ -> Alice pays 110$ but Bob only gets what he's asked for (90$). 20$ price improvements go to the miner
            totalTokenBalance[BBSender] += 1;
            totalEtherBalance[BBSender] -= BBPrice;

            totalEtherBalance[BASender] += BAPrice;
            totalTokenBalance[BASender] -= 1;
            //refunds[block.coinbase] += BBPrice - BAPrice;
         
            if (priorityQueue.buyListisEmpty() || priorityQueue.sellListisEmpty()) 
            {
                break;
            }

            (BBPrice,BBSender,BBVolume) = priorityQueue.buyListMaxDelete();
            (BAPrice,BASender,BAVolume) = priorityQueue.sellListMaxDelete();
        }
        
        //uint refund = refunds[block.coinbase]; 
        //refunds[block.coinbase] = 0; 
        //block.coinbase.transfer(refund);
        
        // for (uint i = 0 ; i< unavailableTokenArray.length; i++) 
        // {   
        //     delete unavailableTokenBalance[unavailableTokenArray[i]];
        // }
        
        // for (uint j= 0 ; j< unavailableEtherArray.length; j++) 
        // {   
        //     delete unavailableEtherBalance[unavailableEtherArray[j]];
        // }
             
        
        
        return true;

        
    } */
    //*********************************************************//
    /**
    *   @dev 
        matchorders() version 2: Partial fillings

    */
 

    function matchOrders() external auctionAtStage(States.Closed) returns (bool){

        state = States.Settled;
        
        (uint256 BBPrice, address BBSender, uint256 BBVolume) = priorityQueue.buyListMax();
        (uint256 BAPrice, address BASender, uint256 BAVolume) = priorityQueue.sellListMax();
    
        
        
        
         while (BBPrice >= BAPrice)
        {  
            
            if (BBVolume > BAVolume ) 
            {
                totalTokenBalance[BBSender] += BAVolume ;
                totalEtherBalance[BBSender] -= BBPrice;

                totalEtherBalance[BASender] += BAPrice;
                totalTokenBalance[BASender] -= BAVolume;
                
                BBVolume = BBVolume - BAVolume;
                priorityQueue.sellListMaxDelete();
                

                if (priorityQueue.buyListisEmpty() || priorityQueue.sellListisEmpty()) 
                {
                    break;
                }
                (BAPrice, BASender, BAVolume) = priorityQueue.sellListMax();
            }
            
            if (BBVolume < BAVolume) 
            {   
                
                totalTokenBalance[BBSender] += BBVolume ;
                totalEtherBalance[BBSender] -= BBPrice;

                totalEtherBalance[BASender] += BAPrice;
                totalTokenBalance[BASender] -= BBVolume;

                BAVolume = BAVolume - BBVolume;
                priorityQueue.buyListMaxDelete();
                

                if (priorityQueue.buyListisEmpty() || priorityQueue.sellListisEmpty()) 
                {
                    break;
                }
                (BBPrice,BBSender,BBVolume) = priorityQueue.buyListMax();
                


            }

            if (BBVolume == BAVolume) 
            {
                
                totalTokenBalance[BBSender] += BBVolume ;
                totalEtherBalance[BBSender] -= BBPrice;

                totalEtherBalance[BASender] += BAPrice;
                totalTokenBalance[BASender] -= BBVolume;

                priorityQueue.buyListMaxDelete();
                priorityQueue.sellListMaxDelete();
                

                if (priorityQueue.buyListisEmpty() || priorityQueue.sellListisEmpty()) 
                {
                    break;
                }
                (BBPrice,BBSender,BBVolume) = priorityQueue.buyListMax();
                (BAPrice,BASender,BAVolume) = priorityQueue.sellListMax();

            }
    
            

          
        
        
        ////uint refund = refunds[block.coinbase]; 
        ////refunds[block.coinbase] = 0; 
        ////block.coinbase.transfer(refund);
        
        //for (uint i = 0 ; i< unavailableTokenArray.length; i++) 
        //{   
           // delete unavailableTokenBalance[unavailableTokenArray[i]];
        //}
        
        //for (uint j= 0 ; j< unavailableEtherArray.length; j++) 
        //{   
           // delete unavailableEtherBalance[unavailableEtherArray[j]];
        //}
             
        
        
        
        } 
        return true;
        
    }
//***********************************************************************//
    /**
    *   @dev Allows the tarders to claim their available tokens back
    */    
    function claimTokens (address token, uint256 numofTokens ) external returns (bool)
    {
        require ((totalTokenBalance[msg.sender] - unavailableTokenBalance[msg.sender]) >= numofTokens, 'Not enough Tokens');
        uint256 tokensToBeClaimed = numofTokens ;
        totalTokenBalance[msg.sender] -= tokensToBeClaimed;
        IERC20(token).transfer(msg.sender, tokensToBeClaimed);
        return true;
    }
//***********************************************************************//
    /**
    *   @dev Allows the tarders to claim their available ETH back
    */     
    function claimEther (uint256 numofEthers) external returns (bool)
    {
        require ((totalEtherBalance[msg.sender] - unavailableEtherBalance[msg.sender]) >= numofEthers, 'Not enough Ethers');
        uint256 EthersToBeClaimed = numofEthers ;
        totalEtherBalance[msg.sender] -= EthersToBeClaimed;
        msg.sender.transfer(EthersToBeClaimed);
        return true;
    }    
//***********************************************************************//
    /**
    *   @dev Getter function to get the Ether balanace of the contract 
    */     
    /* function getBalance() public view returns (uint256) {
        return address(this).balance;
    } */
                                                                                                                                                                                   
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
