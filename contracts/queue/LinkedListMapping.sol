pragma solidity >=0.5.7 <0.6.0;

//pragma solidity 0.5.12;

//Linkedlist implemented with mapping wrapped in a priority queue

contract LinkedListMapping {
    constructor() public {
        sellHead = 0;
        sellTail = 0;
        sellistCounter = 1;
        buyHead = 0;
        buyTail = 0;
        buyListCounter = 1;
    }

    /**
*   @dev 
    Orderstruct with its elements:
        Sender: The address of the trader submitting the order
        Price: The price of the order
        Volume: The volume of the order
        AuxPrice: The contcantenation of the order's price and the counter which helps to sort the heap when there are ties
        id: The id of the order 
        next: The id of the nex order in the list
        prev The id of the previous order in the list
    
    sellHead: The head (first) node of the sellList
    sellTail: The tail (last) node of the sellList
    sellistCounter: The counter of ask orders (later used to create order ids)

    buyHead: The head (first) node of the buyList
    buyTail: The tail (last) node of the buyList
    buyListCounter: The counter of bid orders (later used to create order ids)

    sellList: Mappping that maps order ids to OrderStruct for asks
    buyList: Mappping that maps order ids to OrderStruct for bids
*/

    struct OrderStruct {
        address Sender;
        uint256 Price;
        uint256 Volume;
        uint256 AuxPrice;
        uint256 id;
        uint256 next;
        uint256 prev;
    }

    uint256 public sellHead;
    uint256 public sellTail;
    uint256 public sellistCounter;

    uint256 public buyHead;
    uint256 public buyTail;
    uint256 public buyListCounter;

    mapping(uint256 => OrderStruct) public sellList;
    mapping(uint256 => OrderStruct) public buyList;

    //*****************************************************************//
    //**********************  buyList Functions  **********************//
    //*****************************************************************//

    //***********************************************************************//

    /**
     *   @dev Adds the incoming bid orders to its right position in the list
     */
    function insertBid(
        address sender,
        uint256 price,
        uint256 volume,
        uint256 auxprice
    ) external {
        OrderStruct memory current = buyList[buyHead];
        while (
            current.id != 0 && auxprice <= current.AuxPrice //The linkedlist is sorted in an desceding order (decreasing)
        ) {
            current = buyList[current.next];
            // we only exit this loop if we find the position to insert our data;
        }
        if (
            current.prev == 0
        ) //it means the current is equal to first and in that case we have to insert the node as a new head
        {
            buyListAddHead(sender, price, volume, auxprice);
        }
        //the node next to the previous is no longer the current but it's our new node
        else {
            buyListInsertAfter(current.prev, sender, price, volume, auxprice);
        }
    }

    //***********************************************************************//

    /**
     *   @dev Adds the bid orders after the prevId node
     */
    function buyListInsertAfter(
        uint256 prevId,
        address sender,
        uint256 price,
        uint256 volume,
        uint256 auxprice
    ) internal returns (bool) {
        if (prevId == buyTail) {
            buyListAddTail(sender, price, volume, auxprice);
        } else {
            OrderStruct memory prevOrder = buyList[prevId];
            OrderStruct memory nextOrder = buyList[prevOrder.next];
            uint256 newOrderId = buyListCreateObject(sender, price, volume, auxprice);
            buyListLink(newOrderId, nextOrder.id);
            buyListLink(prevOrder.id, newOrderId);
        }
        return true;
    }

    //***********************************************************************//

    /**
     *   @dev Adds the bid orders before the nextId node
     */
    function buyListInsertBefore(
        uint256 nextId,
        address sender,
        uint256 price,
        uint256 volume,
        uint256 auxprice
    ) internal returns (bool) {
        if (nextId == buyHead) {
            buyListAddHead(sender, price, volume, auxprice);
        } else {
            buyListInsertAfter(buyList[nextId].prev, sender, price, volume, auxprice);
        }
        return true;
    }

    //***********************************************************************//

    function buyListAddTail(
        address sender,
        uint256 price,
        uint256 volume,
        uint256 auxprice
    ) internal returns (bool) {
        if (buyHead == 0) {
            buyListAddHead(sender, price, volume, auxprice);
        } else {
            uint256 ordertId = buyListCreateObject(sender, price, volume, auxprice);
            buyListLink(buyTail, ordertId);
            buyListSetTail(ordertId);
        }

        return true;
    }

    //***********************************************************************//
    function buyListSetTail(uint256 id) internal returns (bool) {
        buyTail = id;
        return true;
    }

    //***********************************************************************//
    function buyListAddHead(
        address sender,
        uint256 price,
        uint256 volume,
        uint256 auxprice
    ) internal returns (uint256) {
        uint256 ordertId = buyListCreateObject(sender, price, volume, auxprice);
        buyListLink(ordertId, buyHead);
        buyListSetHead(ordertId);
        if (buyTail == 0) buyListSetTail(ordertId);
        return ordertId;
    }

    //***********************************************************************//
    function buyListSetHead(uint256 id) internal returns (bool) {
        buyHead = id;
        return true;
    }

    //***********************************************************************//
    function buyListCreateObject(
        address sender,
        uint256 price,
        uint256 volume,
        uint256 auxprice
    ) internal returns (uint256) {
        uint256 newId = buyListCounter;
        buyListCounter++;
        OrderStruct memory order = OrderStruct(sender, price, volume, auxprice, newId, 0, 0);
        buyList[order.id] = order;
        return order.id;
    }

    //***********************************************************************//
    function buyListLink(uint256 prevId, uint256 nextId) internal {
        buyList[prevId].next = nextId;
        buyList[nextId].prev = prevId;
    }

    //***********************************************************************//

    /**
    *   @dev Removes and returns the highest priority element of the buyList
        Only if the buyList is not empty
    */
    function buyListMaxDelete()
        external
        returns (
            uint256,
            address,
            uint256
        )
    {
        OrderStruct memory removeObject = buyList[buyHead];
        uint256 _price = removeObject.Price;
        address _sender = removeObject.Sender;
        uint256 _volume = removeObject.Volume;

        if (buyTail == buyHead) {
            buyHead = 0;
            buyTail = 0;
        } else {
            buyHead = removeObject.next;
            buyList[removeObject.next].prev = 0;
        }

        delete buyList[removeObject.id];
        return (_price, _sender, _volume);

        /* OrderStruct memory removeObject = buyList[buyHead];
        buyListSetHead(removeObject.next);
        buyList[removeObject.next].prev = 0;
        
        if (buyTail == buyHead)
        {
            buyListSetHead(0);
            buyListSetTail(0);
        }
        else
        {
            buyListSetHead(removeObject.next);
            buyList[removeObject.next].prev = 0;
            buyListLink(removeObject.prev, removeObject.next);
        }
        uint256 _price =  removeObject.Price;
        address _sender = removeObject.Sender;
        delete buyList[removeObject.id];
        return (_price,_sender); */
    }

    //***********************************************************************//
    /**
     *   @dev Returns the sender, price, and volume of the highest priority element (The highest bid)
     */
    function buyListMax()
        external
        view
        returns (
            uint256,
            address,
            uint256
        )
    {
        require(buyHead != 0, "buyList is empty!"); //throws exception if the buylist is empty
        return (buyList[buyHead].Price, buyList[buyHead].Sender, buyList[buyHead].Volume);
    }

    //***********************************************************************//
    /**
     *   @dev Checks if the buyList is empty or not
     */
    function buyListisEmpty() external view returns (bool) {
        if (buyHead == 0) {
            return true;
        } else {
            return false;
        }
    }

    //*****************************************************************//
    //**********************  SellList Functions  *********************//
    //*****************************************************************//

    //***********************************************************************//

    //***********************************************************************//

    /**
     *   @dev Adds the incoming ask orders to its right position in the list
     */
    function insertAsk(
        address sender,
        uint256 price,
        uint256 volume,
        uint256 auxprice
    ) external {
        OrderStruct memory current = sellList[sellHead];
        while (
            current.id != 0 && auxprice >= current.AuxPrice //The linkedlist is sorted in an ascending order (increasing)
        ) {
            current = sellList[current.next];
            // we only exit this loop if we find the position to insert our data;
        }
        if (
            current.prev == 0
        ) //it means the current is equal to first and in that case we have to insert the node as a new head
        {
            sellListAddHead(sender, price, volume, auxprice);
        }
        //the node next to the previous is no longer the current but it's our new node
        else {
            sellListInsertAfter(current.prev, sender, price, volume, auxprice);
        }
    }

    //***********************************************************************//

    /**
     *   @dev Adds the ask orders after the prevId node
     */
    function sellListInsertAfter(
        uint256 prevId,
        address sender,
        uint256 price,
        uint256 volume,
        uint256 auxprice
    ) internal returns (bool) {
        if (prevId == sellTail) {
            sellListAddTail(sender, price, volume, auxprice);
        } else {
            OrderStruct memory prevOrder = sellList[prevId];
            OrderStruct memory nextOrder = sellList[prevOrder.next];
            uint256 newOrderId = sellListCreateObject(sender, price, volume, auxprice);
            sellListLink(newOrderId, nextOrder.id);
            sellListLink(prevOrder.id, newOrderId);
        }
        return true;
    }

    //***********************************************************************//

    /**
     *   @dev Adds the ask orders before the nextId node
     */
    function sellListInsertBefore(
        uint256 nextId,
        address sender,
        uint256 price,
        uint256 volume,
        uint256 auxprice
    ) internal returns (bool) {
        if (nextId == sellHead) {
            sellListAddHead(sender, price, volume, auxprice);
        } else {
            sellListInsertAfter(sellList[nextId].prev, sender, price, volume, auxprice);
        }
        return true;
    }

    //***********************************************************************//
    function sellListAddTail(
        address sender,
        uint256 price,
        uint256 volume,
        uint256 auxprice
    ) internal returns (bool) {
        if (sellHead == 0) {
            sellListAddHead(sender, price, volume, auxprice);
        } else {
            uint256 ordertId = sellListCreateObject(sender, price, volume, auxprice);
            sellListLink(sellTail, ordertId);
            sellListSetTail(ordertId);
        }

        return true;
    }

    //***********************************************************************//
    function sellListSetTail(uint256 id) internal returns (bool) {
        sellTail = id;
        return true;
    }

    //***********************************************************************//
    function sellListAddHead(
        address sender,
        uint256 price,
        uint256 volume,
        uint256 auxprice
    ) internal returns (uint256) {
        uint256 ordertId = sellListCreateObject(sender, price, volume, auxprice);
        sellListLink(ordertId, sellHead);
        sellListSetHead(ordertId);
        if (sellTail == 0) sellListSetTail(ordertId);
        return ordertId;
    }

    //***********************************************************************//
    function sellListSetHead(uint256 id) internal returns (bool) {
        sellHead = id;
        return true;
    }

    //***********************************************************************//
    function sellListCreateObject(
        address sender,
        uint256 price,
        uint256 volume,
        uint256 auxprice
    ) internal returns (uint256) {
        uint256 newId = sellistCounter;
        sellistCounter++;
        OrderStruct memory order = OrderStruct(sender, price, volume, auxprice, newId, 0, 0);
        sellList[order.id] = order;
        return order.id;
    }

    //***********************************************************************//
    function sellListLink(uint256 prevId, uint256 nextId) internal returns (bool) {
        sellList[prevId].next = nextId;
        sellList[nextId].prev = prevId;
        return true;
    }

    //***********************************************************************//

    /**
    *   @dev Removes and returns the highest priority element of the sellList (the lowest ask order)
        Only if the sellList is not empty
    */
    function sellListMaxDelete()
        external
        returns (
            uint256,
            address,
            uint256
        )
    {
        OrderStruct memory removeObject = sellList[sellHead];
        uint256 _price = removeObject.Price;
        address _sender = removeObject.Sender;
        uint256 _volume = removeObject.Volume;

        if (sellTail == sellHead) {
            sellHead = 0;
            sellTail = 0;
        } else {
            sellHead = removeObject.next;
            sellList[removeObject.next].prev = 0;
        }

        delete sellList[removeObject.id];
        return (_price, _sender, _volume);

        /* OrderStruct memory removeObject = sellList[sellHead];
        if (sellTail == sellHead)
        {
            sellListSetHead(0);
            sellListSetTail(0);
        }
        else
        {
            sellListSetHead(removeObject.next);
            sellList[removeObject.next].prev = 0;
        }
        uint256 _price =  removeObject.Price;
        address _sender =  removeObject.Sender;
        delete sellList[removeObject.id];
        return (_price,_sender); */
    }

    //***********************************************************************//
    /**
     *   @dev Returns the sender, price, and volume of the highest priority element (The lowest ask)
     */
    function sellListMax()
        external
        view
        returns (
            uint256,
            address,
            uint256
        )
    {
        require(sellHead != 0, "sellList is empty!"); //throws exception if the sellList is empty
        return (sellList[sellHead].Price, sellList[sellHead].Sender, sellList[sellHead].Volume);
    }

    //***********************************************************************//
    /**
     *   @dev Checks if the sellList is empty or not
     */
    function sellListisEmpty() external view returns (bool) {
        if (sellHead == 0) {
            return true;
        } else {
            return false;
        }
    }

    //***********************************************************************//
    /**
    *   @dev deletes the entire priority queue and sends its funds (if any) back to the CallMarket
    /* function deletePQ (address payable callmarket) external {
        selfdestruct(callmarket);
    } */
}
