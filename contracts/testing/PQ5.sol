pragma solidity >=0.5.7 <0.6.0;

//Linkedlist implemented with mapping wrapped in a priority queue

contract PQ5 {
    constructor() public {
        Head = 0;
        Tail = 0;
        Counter = 1;
    }

    struct Struct {
        uint256 Number;
        uint256 id;
        uint256 next;
        uint256 prev;
    }

    uint256 public Head;
    uint256 public Tail;
    uint256 public Counter;

    mapping(uint256 => Struct) public List;

    //******************** Enqueue() function ********************//
    //A new integer will be added in its right position in the list
    function Enqueue(uint256 _number) public returns (bool) {
        Struct memory current = List[Head];
        while (
            current.id != 0 && _number <= current.Number //The linkedlist is sorted in an desceding order (decreasing)
        ) {
            current = List[current.next];
            // we only exit this loop if we find the position to insert our data;
        }
        if (
            current.prev == 0
        ) //it means the current is equal to first and in that case we have to insert the node as a new head
        {
            List_AddHead(_number);
        }
        //the node next to the privious is no longer the current but it's our new node
        else {
            List_InsertAfter(current.prev, _number);
        }
        return true;
    }

    //******************** List_InsertAfter() function ********************//
    function List_InsertAfter(uint256 _prevId, uint256 _number)
        internal
        returns (bool)
    {
        if (_prevId == Tail) {
            List_AddTail(_number);
        } else {
            Struct memory prevOrder = List[_prevId];
            Struct memory nextOrder = List[prevOrder.next];
            uint256 newOrderId = List_CreateObject(_number);
            List_Link(newOrderId, nextOrder.id);
            List_Link(prevOrder.id, newOrderId);
        }
        return true;
    }

    //******************** List_AddTail() function ********************//
    function List_AddTail(uint256 _number) internal returns (bool) {
        if (Head == 0) {
            List_AddHead(_number);
        } else {
            uint256 orderId = List_CreateObject(_number);
            List_Link(Tail, orderId);
            List_SetTail(orderId);
        }

        return true;
    }

    //******************** List_SetTail() function ********************//
    function List_SetTail(uint256 _id) internal returns (bool) {
        Tail = _id;
        return true;
    }

    //******************** List_AddHead() function ********************//
    function List_AddHead(uint256 _number) internal returns (uint256) {
        uint256 orderId = List_CreateObject(_number);
        List_Link(orderId, Head);
        List_SetHead(orderId);
        if (Tail == 0) List_SetTail(orderId);
        return orderId;
    }

    //******************** List_SetHead() function ********************//
    function List_SetHead(uint256 _id) internal returns (bool) {
        Head = _id;
        return true;
    }

    //******************** List_CreateObject() function ********************//
    function List_CreateObject(uint256 _number) internal returns (uint256) {
        uint256 newId = Counter;
        Counter++;
        Struct memory order = Struct(_number, newId, 0, 0);
        List[order.id] = order;
        return order.id;
    }

    //******************** List_CreateObject() function ********************//
    function List_Link(uint256 _prevId, uint256 _nextId) internal {
        List[_prevId].next = _nextId;
        List[_nextId].prev = _prevId;
    }

    //****************   Peek()  *********************//
    //Retrieves, but does not remove, the head of this queue
    function Peek() public returns (uint256) {
        require(Head != 0, "List is empty!"); //throws exception if the List is empty
        return (List[Head].Number);
    }

    //******************** RemoveMax() function ********************//
    //the highest priority item will be removed from the list and is returned by the function
    function RemoveMax() public returns (uint256) {
        Struct memory removeObject = List[Head];
        uint256 _number = removeObject.Number;

        if (Tail == Head) {
            Head = 0;
            Tail = 0;
        } else {
            Head = removeObject.next;
            List[removeObject.next].prev = 0;
        }

        delete List[removeObject.id];
        return (_number);

        /* OrderStruct memory removeObject = BuyList[BuyHead];
        BuyList_SetHead(removeObject.next);
        BuyList[removeObject.next].prev = 0;
        
        if (BuyTail == BuyHead)
        {
            BuyList_SetHead(0);
            BuyList_SetTail(0);
        }
        else
        {
            BuyList_SetHead(removeObject.next);
            BuyList[removeObject.next].prev = 0;
            BuyList_Link(removeObject.prev, removeObject.next);
        }
        uint256 _price =  removeObject.Price;
        address _sender = removeObject.Sender;
        delete BuyList[removeObject.id];
        return (_price,_sender); */
    }

    //******************** Dequeue() function ********************//
    //Emptying the list by iterating over it and deleting the highest priority number in each round (similar to match funtion in the call market)
    function Dequeue() public returns (uint256) {
        while (isEmpty() != true) {
            RemoveMax();
        }
    }

    //****************   isEmpty()  *********************//
    //checks if the List is empty
    function isEmpty() public returns (bool) {
        if (Head == 0) {
            return true;
        } else {
            return false;
        }
    }
}
