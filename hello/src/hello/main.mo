import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Stack "mo:base/Stack";
import Iter "mo:base/Iter";
import Int "mo:base/Int";







// Debug.print("hello,world");
// func quicksort(array :[var Int]){
//     let n = array.size();
//     if( n >= 2){
//         Partition(array,0,n-1);
//     };

// };

// func Partition (array :[var Int],l:Int,h:Int){

//     var low:Int  = l;
//     var high:Int = h;
  
//     if(low < high){
        
//         var pivot:Int = array[Int.abs(low)];


//         while(low < high){
//         while( low < high and array[Int.abs(high)] >= pivot){
//               high -= 1;
//         };   
//         array[Int.abs(low)] := array[Int.abs(high)];
//         while(low < high and array[Int.abs(low)] <= pivot){
//              low += 1;
//         };
//         array[Int.abs(high)] :=  array[Int.abs(low)];
//         };
//         array[Int.abs(low)] := pivot;

//     };
//     if(l < low-1)
//     Partition(array,l,low-1);
//     if(low+1 < h)
//     Partition(array,low+1,h);
// };



// //测试

// let a:[Int] = [-1,3,666,2];

// let r = Array.thaw<Int>(a);
// quicksort(r);
// let n = Array.freeze(r);
// var i = 0;
// while(i < n.size())
// {
//     Debug.print(Int.toText(n[i]));
//     i :=i+1;
// };



actor{


    public func qsort(arr: [Int]): async [Int]{
        let r = Array.thaw<Int>(arr);
        quicksort(r);
        let array = Array.freeze(r);
        return array;
    };



    func quicksort(array :[var Int]){
        let n = array.size();
        if( n >= 2){
            Partition(array,0,n-1);
        };

    };

    func Partition (array :[var Int],l:Int,h:Int){

        var low:Int  = l;
        var high:Int = h;
  
        if(low < high){
        
        var pivot:Int = array[Int.abs(low)];


        while(low < high){
        while( low < high and array[Int.abs(high)] >= pivot){
              high -= 1;
        };   
        array[Int.abs(low)] := array[Int.abs(high)];
        while(low < high and array[Int.abs(low)] <= pivot){
             low += 1;
        };
        array[Int.abs(high)] :=  array[Int.abs(low)];
        };
        array[Int.abs(low)] := pivot;

        };
        if(l < low-1)
        Partition(array,l,low-1);
        if(low+1 < h)
        Partition(array,low+1,h);
    };


}

