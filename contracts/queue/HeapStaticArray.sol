/// SPDX-License-Identifier: SSPL-1.0
/// @tittle HeapStaticArray
/// @version 0.3.0

pragma solidity >=0.5.7 <0.6.0;

// @note Heap with static array wrapped in a priority queue
contract HeapStaticArray {
    constructor(uint256 _MAXORDERS) public {
        maxOrders = _MAXORDERS;
    }

    /**
*   @dev 
    Order structs with its element:
        Sender: The address of the trader submitting the order
        Price: The price of the order
        Volume: The volume of the order, it is considered 1 by now
        AuxPrice: The contcantenation of the order's price and the counter which helps to sort the heap when there are ties
    buyList: The array that contains bid OrderStructs, it is a maxheap (decrementally ordered)
    sellList: The array that contains ask OrderStructs, it is a minheap (incrementally ordered)
*/

    /**
*   @dev 
    Orderstruct with its elements:
        Sender: The address of the trader submitting the order
        Price: The price of the order
        Volume: The volume of the order
        Exists: Is set to true when the incoming order is stored in the mapping
        AuxPrice: The contcantenation of the order's price and the counter which helps to sort the heap when there are ties
    
    maxOrders: sets the maximum number of orders that could be submitted to the market (buyList and sellList arrays' sizes are set to this number)
    buyList: The array that contains bid OrderStructs, it is a maxheap (decrementally sorted)
    sellList: sellList: The array that contains ask OrderStructs, it is a minheap (incrementally sorted)
    sellIndex: The index used to access asks in the sellList static array
    buyIndex: The index used to access bids in the buyList static array
*/

    struct OrderStruct {
        address Sender;
        uint256 Price;
        uint256 Volume;
        bool Exists;
        uint256 AuxPrice;
    }
    uint256 public maxOrders;
    OrderStruct[42] internal buyList;
    OrderStruct[42] internal sellList;
    uint256 public sellIndex;
    uint256 public buyIndex;

    //**********************  buyList Functions  **********************//

    /**
     *   @dev Adds the incoming bid orders to the buyList array which will be then heapified
     */
    function insertBid(
        address sender,
        uint256 price,
        uint256 volume,
        uint256 auxprice
    ) external {
        OrderStruct memory neworder = OrderStruct(sender, price, volume, true, auxprice);

        if (!buyList[0].Exists) {
            buyList[0] = neworder;
        } else {
            buyIndex++;
            buyList[buyIndex] = neworder;
            maxheapHeapifyUp();
        }
    }

    //***********************************************************************//
    /**
     *   @dev Sorts the heap
     */
    function maxheapHeapifyUp() internal returns (bool) {
        uint256 k = buyIndex; //k is set to be the last entry of the array (also heap) which is the element that's just added and has to be moved up
        while (k > 0) {
            //while we havent reached to the top of the heap
            uint256 p = (k - 1) / 2; //we need to compute the parent of this last element which is p = (k-1)/2
            if (buyList[k].AuxPrice > buyList[p].AuxPrice) //if the element is greater than its parent
            {
                OrderStruct memory temp = buyList[k]; //swap the element at index k with its parent
                buyList[k] = buyList[p];
                buyList[p] = temp;
                k = p; //k moves up one level
            } else {
                break;
            } //if not the break statement exits the loop (it continues until no element index k is not greater than its parent)
        }

        return true;
    }

    //***********************************************************************//

    /**
    *   @dev Removes and returns the highest priority element of the buyList
        Only if the buyList is not empty
        then the heap is reordered using the heapifyDown method
    */
    function buyListMaxDelete()
        external
        returns (
            uint256,
            address,
            uint256
        )
    {
        require(!buyList[0].Exists, "buyList is empty!"); //the delete function throws exception if the list is empty

        if (buyIndex == 0) {
            uint256 _price = buyList[0].Price;
            address _sender = buyList[0].Sender;
            uint256 _volume = buyList[0].Volume;
            delete buyList[0];
            return (_price, _sender, _volume);
        }
        if (buyIndex == 1) //if the heap has two items
        {
            uint256 _price = buyList[0].Price;
            address _sender = buyList[0].Sender;
            uint256 _volume = buyList[0].Volume;
            buyList[0] = buyList[1]; //the first element of the heap is removed
            delete buyList[1];
            buyIndex--;
            return (_price, _sender, _volume);
        }
        //if neither of these conditions are true, then there are at least 2 items in the heap and deletion proceeds
        uint256 _price = buyList[0].Price;
        address _sender = buyList[0].Sender;
        uint256 _volume = buyList[0].Volume;
        buyList[0] = buyList[buyIndex]; //the last elementof the heap is removed and written into the first position
        delete buyList[buyIndex];
        buyIndex--;
        maxheapHeapifyDown(); //now the heapifydown is called
        return (_price, _sender, _volume);
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
        require(!buyList[0].Exists, "buyList is empty!"); //the delete function throws exception if the list is empty
        return (buyList[0].Price, buyList[0].Sender, buyList[0].Volume);
    }

    //***********************************************************************//

    /**
    *   @dev Heapifydown the buyList when a bid order is removed 
        (1)the heap root is removed and is replaced by the last element in the list,(2) the heap gets resorted
    */

    function maxheapHeapifyDown() internal returns (bool) {
        uint256 k = 0;
        uint256 leftchild = 2 * k + 1;
        while (leftchild <= buyIndex) {
            //as long as the left child is within the array that heap is stored in
            uint256 max = leftchild;
            uint256 rightchild = leftchild + 1; //rightchild = 2k+2

            if (rightchild < buyIndex) //if there is a rightchild
            {
                if (
                    buyList[rightchild].AuxPrice > buyList[leftchild].AuxPrice
                ) //then the right child and left child are compared
                {
                    max++; //now max is set to rightchild, otherwise max remains to be the leftchild
                }
            }

            if (
                buyList[k].AuxPrice < buyList[max].AuxPrice
            ) //compares the k item with the max item and if k is smaller than its greatest children they are swapped
            {
                OrderStruct memory temp = buyList[k]; //swap the element at index k with its parent
                buyList[k] = buyList[max];
                buyList[max] = temp;
                k = max; //k is set to max
                leftchild = 2 * k + 1; //l is recompuetd in preparation for the next iteration
            } else {
                //if the k item is not smaller than the max item, heapifyDown should stop
                break;
            }
        }
        return true;
    }

    /**
     *   @dev Checks if the buyList is empty or not
     */
    function buyListisEmpty() external view returns (bool) {
        if (!buyList[0].Exists) {
            return true;
        } else {
            return false;
        }
    }


    //**********************  sellList Functions  *********************//

    /**
     *   @dev Adds the incoming bid orders to the buyList array which will be then heapified
     */

    function insertAsk(
        address sender,
        uint256 price,
        uint256 volume,
        uint256 auxprice
    ) external {
        OrderStruct memory neworder = OrderStruct(sender, price, volume, true, auxprice);

        if (!sellList[0].Exists) {
            sellList[0] = neworder;
        } else {
            sellIndex++;
            sellList[sellIndex] = neworder;
            minheapHeapifyUp();
        }
    }

    //***********************************************************************//
    /**
     *   @dev Sorts the heap
     */
    function minheapHeapifyUp() internal returns (bool) {
        uint256 k = sellIndex; //k is set to be the last entry of the array(also heap) which is the element that's just added and has to be moved up
        while (k > 0) {
            //while we havent reached to the top of the heap
            uint256 p = (k - 1) / 2; //we need to compute the parent of this last element which is p = (k-1)/2
            if (sellList[k].AuxPrice < sellList[p].AuxPrice) //if the element is greater than its parent
            {
                OrderStruct memory temp = sellList[k]; //swap the element at index k with its parent
                sellList[k] = sellList[p];
                sellList[p] = temp;

                k = p; //k moves up one level
            } else {
                break;
            } //if not the break statement exits the loop (it continues until no element index k is not greater than its parent)
        }

        return true;
    }

    //***********************************************************************//
    /**
    *   @dev Removes and returns the highest priority element of the sellList
        Only if the sellList is not empty
        then the heap is reordered using the heapifyDown method
    */

    function sellListMaxDelete()
        external
        returns (
            uint256,
            address,
            uint256
        )
    {
        require(sellList[0].Exists, "sellList is empty!"); //the delete function throws exception if the list is empty

        if (sellIndex == 0) {
            uint256 _price = sellList[0].Price;
            address _sender = sellList[0].Sender;
            uint256 _volume = sellList[0].Volume;
            delete sellList[0];
            return (_price, _sender, _volume);
        }

        if (sellIndex == 1) {
            // if the heap has only one item

            uint256 _price = sellList[0].Price;
            address _sender = sellList[0].Sender;
            uint256 _volume = sellList[0].Volume;
            sellList[0] = sellList[1];
            delete sellList[1]; //the only element of the heap is removed and returned
            sellIndex--;
            return (_price, _sender, _volume);
        }

        //if neither of these conditions are true, then there are at least 2 items in the heap and deletion proceeds

        uint256 _price = sellList[0].Price;
        address _sender = sellList[0].Sender;
        uint256 _volume = sellList[0].Volume;
        sellList[0] = sellList[sellIndex]; //the last elementof the heap is removed and written into the first position
        delete sellList[sellIndex];
        sellIndex--;
        minheapHeapifyDown(); //now the heapifyDown is called to restore the ordering of the heap
        return (_price, _sender, _volume);
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
        require(sellList[0].Exists, "sellList is empty!"); //throws exception if the sellist is empty
        return (sellList[0].Price, sellList[0].Sender, sellList[0].Volume);
    }

    //***********************************************************************//

    /**
    *   @dev Heapifydown the sellList when an ask order is removed 
        (1)the heap root is removed and is replaced by the last element in the list,(2) the heap gets resorted
    */

    function minheapHeapifyDown() internal returns (bool) {
        uint256 k = 0;
        uint256 leftchild = 2 * k + 1;
        while (leftchild <= sellIndex) {
            //as long as the left child is within the array that heap is stored in
            uint256 min = leftchild;
            uint256 rightchild = leftchild + 1; //rightchild = 2k+2

            if (rightchild < sellIndex) //if there is a rightchild, then the right child and left child are compared
            {
                if (sellList[rightchild].AuxPrice < sellList[leftchild].AuxPrice) {
                    min++;
                } //now min is set to rightchild, otherwise min remains to be the leftchild
            }

            if (
                sellList[min].AuxPrice < sellList[k].AuxPrice
            ) //compares the k item with the max item and if its less they are swapped
            {
                OrderStruct memory temp = sellList[k]; //swap the element at index k with its parent
                sellList[k] = sellList[min];
                sellList[min] = temp;

                k = min; //k is set to min
                leftchild = 2 * k + 1; //l is recompuetd in preparation for the next iteration
            } else {
                //if k item's smaller childer is not smaller than k item itself, heapifyDown should stop
                break;
            }
        }
        return true;
    }

    //***********************************************************************//
    /**
     *   @dev Checks if the sellList is empty or not
     */

    function sellListisEmpty() external view returns (bool) {
        if (!sellList[0].Exists) {
            return true;
        } else {
            return false;
        }
    }
}
