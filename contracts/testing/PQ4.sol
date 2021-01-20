pragma solidity >=0.5.7 <0.6.0;

//pragma experimental ABIEncoderV2;

//Linkedlist wrapped in a priority queue

contract PQ4 {
    List public First;
    List temp;

    constructor() public {
        First = List(0);
    }

    //******************** Enqueue() function ********************//
    //A new integer will be added in its right position in the list
    function Enqueue(uint256 _number) public returns (bool) {
        List newitem = new List(_number);
        List current = First;
        List previous = List(0);

        //we iterate through our list with 2 conditions:
        while (
            current != List(0) && _number <= current.Number() //The linkedlist is sorted in an descending order (descreasing)
        ) {
            previous = current;
            current = current.next();
            // we only exit this loop if we find the position to insert our data;
        }
        //now if we have to check if we have to insert the node to the begining of the list:
        if (
            previous == List(0)
        ) //it means the current is equal to first and in that case we have to insert the node as a new head
        {
            First = newitem;
        }
        //the node next to the privious is no longer the current but it's our new node
        else {
            previous.addNew(newitem);
        }

        //and in all cases regardless of if it's a first node or not, we must say we have to say the node next to our new node is current

        newitem.addNew(current);
        return true;
    }

    //******************** RemoveMax() function ********************//
    //the highest priority item will be removed from the list and is returned by the function
    function RemoveMax() public returns (uint256) {
        require(First != List(0), "List is empty!"); //throws exception if the maxheap (BuyList) is empty
        temp = First;
        First.deletenode();
        First = temp.next();
        return (temp.Number());
    }

    //******************** Dequeue() function ********************//
    //Emptying the list by iterating over it and deleting the highest priority number in each round (similar to match funtion in the call market)
    function Dequeue() public returns (uint256) {
        while (isEmpty() != true) {
            RemoveMax();
        }
    }

    //****************   Peek()  *********************//
    //Retrieves, but does not remove, the head of this queue
    function Peek() public returns (uint256) {
        require(First != List(0), "List is empty!"); //throws exception if the List is empty
        return (First.Number());
    }

    //****************   isEmpty()  *********************//
    //checks if the List is empty
    function isEmpty() public returns (bool) {
        if (First == List(0)) {
            return true;
        } else {
            return false;
        }
    }
}

//*****************************************************************//
//*******************  List Contract  ************************//
//*****************************************************************//

contract List {
    List public next;
    uint256 public Number;

    constructor(uint256 _number) public {
        Number = _number;
        next = List(0);
    }

    function addNew(List _number) public {
        next = _number;
    }

    function deletenode() public {
        selfdestruct(block.coinbase);
    }
}
