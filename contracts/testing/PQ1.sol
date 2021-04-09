pragma solidity >=0.5.7 <0.6.0;

//pragma experimental ABIEncoderV2;

//Heap with dynamic array wrapped in a priority queue

contract PQ1 {
    //uint256[] MaxHeap;      //The array that contains integers in (descending (decremental)) order, we always want the highest nuber (maxheap)
    struct OrderStruct {
        uint256 Number;
    }
    OrderStruct[] MaxHeap;

    //******************* Enqueue() ***************************//
    //the new item will be added to the end of the array list
    //then heapified up with a call to heapifyUp method
    function Enqueue(uint256 _number) public returns (bool) {
        OrderStruct memory neworder = OrderStruct(_number);
        MaxHeap.push(neworder);
        maxheap_heapifyUp();
        return true;
    }

    //*******************  maxheap_heapifyUp () ***************************//
    //this function is called everytime we insert a new element to the end of the array
    //now the heap has to be sorted again
    function maxheap_heapifyUp() internal returns (bool) {
        uint256 k = MaxHeap.length - 1; //k is set to be the last entry of the array (also heap) which is the element that's just added and has to be moved up
        while (k > 0) {
            //while we havent reached to the top of the heap
            uint256 p = (k - 1) / 2; //we need to compute the parent of this last element which is p = (k-1)/2
            if (
                MaxHeap[k].Number > MaxHeap[p].Number
            ) //if the element is greater than its parent
            {
                OrderStruct memory temp = MaxHeap[k]; //"!SYNTAX!"//swap the element at index k with its parent
                MaxHeap[k] = MaxHeap[p];
                MaxHeap[p] = temp;
                k = p; //k moves up one level
            } else {
                break;
            } //if not the break statement exits the loop (it continues until no element index k is not greater than its parent)
        }
        return true;
    }

    //******************** RemoveMax() function ********************//
    //the highest priority item will be removed from the list and returned
    //then the heap is reordered uising the heapifyDown method
    function RemoveMax() public returns (uint256) {
        require(MaxHeap.length != 0, "List is empty!"); //the delete function throws exception if the heap is empty

        if (MaxHeap.length == 1) {
            //if the heap has only one items
            uint256 _number = MaxHeap[0].Number;
            MaxHeap.pop(); //the only element of the heap is removed and returned
            return (_number);
        }

        //if neither of these conditions are true, then there are at least 2 items in the heap and deletion proceeds
        uint256 _number = MaxHeap[0].Number;
        MaxHeap[0] = MaxHeap[MaxHeap.length - 1]; //the last elementof the heap is removed and written into the first position
        MaxHeap.pop();
        maxheap_heapifyDown(); //now the siftdown is called
        return (_number);
    }

    //******************** Dequeue() function ********************//
    //Emptying the list by iterating over it and deleting the highest priority number in each round (similar to match funtion in the call market)
    function Dequeue() public returns (uint256) {
        while (isEmpty() != true) {
            RemoveMax();
        }
    }

    //*******************  maxheap_heapifyDown () ***************************//
    //when we want to remove an element from the heap we remove the root of the heap and add the last item
    //to the root and reorder the heap again
    function maxheap_heapifyDown() internal returns (bool) {
        uint256 k = 0;
        uint256 leftchild = 2 * k + 1;
        while (leftchild < MaxHeap.length) {
            //as long as the left child is within the array that heap is stored in
            uint256 max = leftchild;
            uint256 rightchild = leftchild + 1; //rightchild = 2k+2

            if (rightchild < MaxHeap.length) //if there is a rightchild
            {
                if (
                    MaxHeap[rightchild].Number > MaxHeap[leftchild].Number
                ) //then the right child and left child are compared
                {
                    max++; //now max is set to rightchild, otherwise max remains to be the leftchild
                }
            }

            if (
                MaxHeap[k].Number < MaxHeap[max].Number
            ) //compares the k item with the max item and if k is smaller than its greatest children they are swapped
            {
                OrderStruct memory temp = MaxHeap[k];
                MaxHeap[k] = MaxHeap[max];
                MaxHeap[max] = temp;
                k = max; //k is set to max
                leftchild = 2 * k + 1; //l is recompuetd in preparation for the next iteration
            } else {
                //if the k item is not smaller than the max item, heapifyDown should stop
                break;
            }
        }
        return true;
    }

    //****************   Peek()  *********************//
    //Retrieves, but does not remove, the head of this queue
    function Peek() public returns (uint256) {
        require(MaxHeap.length != 0, "List is empty!"); //throws exception if the maxheap (BuyList) is empty
        return (MaxHeap[0].Number);
    }

    //****************   isEmpty()  *********************//
    //checks if the MaxHeap is empty or not
    function isEmpty() public returns (bool) {
        if (MaxHeap.length == 0) {
            return true;
        } else {
            return false;
        }
    }
}
