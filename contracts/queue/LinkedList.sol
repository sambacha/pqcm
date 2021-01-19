pragma solidity >=0.5.7 <0.6.0;
//pragma solidity 0.5.12;

//Linkedlist wrapped in a priority queue

contract LinkedList{


/**
*   @dev 
    sellFirst: The head node of the SellList (each node is a contract itself, so it's a contract from the type "SellList")
    buyFirst: The head node of the BuyList (each node is a contract itself, so it's a contract from the type "BuyList")
*/
    
    SellList public sellFirst;
    BuyList public buyFirst;
    SellList internal selltemp;
    BuyList internal buytemp;
    address payable callmarket;
    address internal owner;
    

    constructor (address _callmarket) public {
        callmarket = address(uint160(_callmarket)); 
        sellFirst = SellList(0);
        buyFirst = BuyList(0);
        owner = address(this);
    }
//*****************************************************************//
//**********************  buyList Functions  **********************//
//*****************************************************************//


//***********************************************************************//

    /**
    *   @dev Adds the incoming bid orders to its right position in the list
    */
    function insertBid(address sender, uint256 price, uint256 volume, uint256 auxprice) external 
    {
        BuyList newitem = new BuyList (sender, price , volume, auxprice);
        BuyList current = buyFirst; 
        BuyList previous = BuyList(0);
        
        //we iterate through our list with 2 conditions:
        while (current != BuyList(0) && auxprice <= current.auxPrice()) //The linkedlist is sorted in an descending order (descreasing)
        {
            previous = current;
            current = current.next();
            // we only exit this loop if we find the position to insert our data;
        } 
        //now if we have to check if we have to insert the node to the begining of the list:
        if (previous == BuyList(0)) //it means the current is equal to first and in that case we have to insert the node as a new head
        {
            buyFirst = newitem; 
        }
        else //the node next to the privious is no longer the current but it's our new node
        {
            previous.addNew(newitem);
        }
        
        //and in all cases regardless of if it's a first node or not, we must say we have to say the node next to our new node is current
        
        newitem.addNew(current);
        
    }

//***********************************************************************//

    /**
    *   @dev Removes and returns the highest bid of the list
        Only if the list is not empty
    */
    function buyListMaxDelete() external returns(uint256, address, uint256) 
    {
        require (buyFirst != BuyList(0), 'buyList is empty!'); //throws exception if the buyList is empty
        buytemp = buyFirst;
        buyFirst = buytemp.next();
        buytemp.deletenode(callmarket, owner);
        //buyFirst.deletenode(callmarket);
        //buyFirst = buytemp.next();
        return (buytemp.price(), buytemp.sender(), buytemp.volume());
    }
//***********************************************************************//
    /**
    *   @dev Returns the sender, price, and volume of the highest priority element (The highest bid)
    */ 
    function buyListMax() external view returns (uint256, address, uint256){
        
        require (buyFirst != BuyList(0), 'buyList is empty!'); //throws exception if the buyList is empty
        return (buyFirst.price(), buyFirst.sender(), buyFirst.volume());
        
    }
//***********************************************************************//
    /**
    *   @dev Checks if the buyList is empty or not
    */ 

    function buyListisEmpty() external view returns (bool){
        
        if (buyFirst == BuyList(0))
        {
            return true;

        }
        else
        {
            return false;
        }
        
    }
//*****************************************************************//
//**********************  SellList Functions  *********************//
//*****************************************************************//

//***********************************************************************//

    /**
    *   @dev Adds the incoming ask orders to its right position in the list
    */
    function insertAsk (address sender, uint256 price, uint256 volume, uint256 auxprice) external 
    {
        SellList newitem = new SellList (sender, price , volume, auxprice);
        SellList current = sellFirst; 
        SellList previous = SellList(0);
        
        //we iterate through our list with 2 conditions:
        while (current != SellList(0) && auxprice >= current.auxPrice()) //The linkedlist is sorted in an ascending order (increasing)
        {
            previous = current;
            current = current.next();
            // we only exit this loop if we find the position to insert our data;
        } 
        //now if we have to check if we have to insert the node to the begining of the list:
        if (previous == SellList(0)) //it means the current is equal to first and in that case we have to insert the node as a new head
        {
            sellFirst = newitem; 
        }
        else //the node next to the privious is no longer the current but it's our new node
        {
            previous.addNew(newitem);
        }
        
        //and in all cases regardless of if it's a first node or not, we must say we have to say the node next to our new node is current
        
        newitem.addNew(current);
    }  
//***********************************************************************//

    /**
    *   @dev Removes and returns the lowest ask of the list (highest priority element)
        Only if the list is not empty
    */
    function sellListMaxDelete() external returns (uint256, address, uint256)
    {
        require(sellFirst != SellList(0),'sellList is empty!'); //throws exception if the sellList is empty
        selltemp = sellFirst;
        sellFirst = selltemp.next();
        selltemp.deletenode(callmarket, owner);
        //sellFirst.deletenode(callmarket);
        //sellFirst = selltemp.next();
        return (selltemp.price(), selltemp.sender(), selltemp.volume());
    }  
//***********************************************************************//
    /**
    *   @dev Returns the sender, price, and volume of the highest priority element (The lowest ask)
    */ 
    function sellListMax() external view returns (uint256, address, uint256){
        
        require(sellFirst != SellList(0),'sellList is empty!'); //throws exception if the sellList is empty
        return (sellFirst.price(), sellFirst.sender(), sellFirst.volume());
        
    }

//***********************************************************************//
    /**
    *   @dev Checks if the sellList is empty or not
    */ 
    function sellListisEmpty() external view returns (bool){
        
        if (sellFirst == SellList(0))
        {
            return true;

        }
        else
        {
            return false;
        }
        
    }

}
//*****************************************************************//
//*******************  SellList Contract  ************************//
//*****************************************************************//

contract SellList {
    /**
*   @dev 
    each node of the sellList is a contract from type "SellList" that has the following attributes:
    next: The address of the next node (contract) in the sellList
    sender: The sender of the ask order
    price: The price of the ask order
    volume: The volume of the ask order
    auxPrice: The contcantenation of the order's price and the counter which helps to sort the heap when there are ties
*/
    SellList public next;
    address public sender;
    uint256 public price;
    uint256 public volume;
    uint256 public auxPrice;
    
    constructor(address orderSender, uint256 orderPrice, uint256 orderVolume, uint256 auxprice)  public {
        
        sender = sender;
        price = price;
        volume = volume;
        auxPrice = auxprice;
        next = SellList(0);
    }

    function addNew(SellList askorder) external {
        
        next = askorder;
       
    }
   
    function deletenode (address payable callmarket,address ownerContract) external {
        require (msg.sender == ownerContract,"Should be the Owner");
        selfdestruct(callmarket);
        
    }
    
    
}   

//*****************************************************************//
//*******************  BuyList Contract  ************************//
//*****************************************************************//    
    
contract BuyList {
    /**
*   @dev 
    each node of the BuyList is a contract from type "BuyList" that has the following attributes:
    next: The address of the next node (contract) in the buyList
    sender: The sender of the bid order
    price: The price of the bid order
    volume: The volume of the bid order
    auxPrice: The contcantenation of the order's price and the counter which helps to sort the heap when there are ties
*/
    BuyList public next;
    address public sender;
    uint256 public price;
    uint256 public volume;
    
    uint256 public auxPrice;
    
    constructor(address orderSender, uint256 orderPrice, uint256 orderVolume, uint256 auxprice) public {
        
        sender = orderSender;
        price = orderPrice;
        volume = orderVolume;
        auxPrice = auxprice;
        next = BuyList(0);
    }

    function addNew(BuyList bidorder) external {
        
        next = bidorder;
       
    }

    function deletenode (address payable callmarket, address ownerContract) external {
        require (msg.sender == ownerContract,"Should be the Owner");
        selfdestruct(callmarket);
    }
} 