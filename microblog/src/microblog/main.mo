import Iter "mo:base/Iter";
import List "mo:base/List";
import Pricinpal "mo:base/Bool";
import Principal "mo:base/Principal";
import Prim "mo:⛔";
import Debug "mo:base/Debug";
import Int "mo:base/Int";

import Time "mo:base/Time";

/*** 第一版
actor {
    // public func greet(name : Text) : async Text {
    //     return "Hello, " # name # "!";
    // };
    public type Message = Text;
    public type Microblog = actor{
        follow : shared(Principal) ->async();
        follows : shared query () ->async [Principal];
        post :shared (Text) ->async();
        posts :shared query() ->async [Message];
        timeline :shared() -> async [Message];

    };

    stable var messages :List.List<Message> = List.nil();
    stable var followed : List.List<Principal> = List.nil();
    public shared func follow(id :Principal) : async() {
        followed := List.push(id,followed);
    };

    public shared func  follows() :async [Principal]{
        List.toArray(followed);

    };
    public shared (msg) func post(text :Text):async(){
        assert(Principal.toText(msg.caller) == "74kkb-bmzhh-s6c3c-regcw-lhwil-ztkou-7isyp-rjnrk-3uxqe-lo7tk-rqe" );
        messages := List.push(text,messages);
    };
    public shared func posts() :async[Message]{
        List.toArray(messages);

    };
    public shared func timeline() : async [Message]{

        var all : List.List<Message> = List.nil();
        for (id in Iter.fromList(followed)){
            let canister : Microblog = actor(Principal.toText(id));
            let msgs = await canister.posts();
            for(msg in Iter.fromArray(msgs)){
                all := List.push(msg,all);

            };

        };
        List.toArray(all)

    };
};


***/


/***
1. 把message类型改为一个记录结构，并且time字段，记录发消息的时间
2. 修改posts 和 timeline 方法，仅仅返回指定时间之后的内容
public shared func posts(since : Time.Time) :async[Message]{}
public shared func timeline(since : Time.Time) :async[Message]{}
***/


actor Microblog {
   
    
    //public type Message = Text;
    type Message = {
        message:Text;
        time :Time.Time;
    };
    public type Microblog = actor{
        follow : shared(Principal) ->async();
        follows : shared query () ->async [Principal];
        post :shared (Text) ->async();
        posts :shared query(Time.Time) ->async [Message];
        timeline :shared(Time.Time) -> async [Message];

    };

    stable var messages :List.List<Message> = List.nil();
    stable var followed : List.List<Principal> = List.nil();
    


    public shared func follow(id :Principal) : async() {
        followed := List.push(id,followed);
    };

    public shared func  follows() :async [Principal]{
        List.toArray(followed);

    };
    public shared (msg) func post(text :Text):async(){
  //      assert(Principal.toText(msg.caller) == "74kkb-bmzhh-s6c3c-regcw-lhwil-ztkou-7isyp-rjnrk-3uxqe-lo7tk-rqe" );
         assert(Principal.toText(msg.caller) == Principal.fromActor(Microblog) );
      

        let m : Message = do{
            {
            message = text;
            time = Time.now();
            }
        };
        messages := List.push(m,messages);


    };
    public shared  query func posts(since :Time.Time) :async[Message]{
        var query_messages :List.List<Message> = List.nil();
        
        for (m in Iter.fromList(messages)){
            //如果比之前大，说明在它之后，否则，在他之前
            let elapsedSeconds = (m.time - since) / 1000_000_000;
            if(elapsedSeconds > 0){
                query_messages :=List.push(m,query_messages); //这里要修改post方法             
            }

        };
        List.toArray(query_messages);

    }; 
    public shared func timeline(since:Time.Time) : async [Message]{

        var all : List.List<Message> = List.nil();
        for (id in Iter.fromList(followed)){
            let canister : Microblog = actor(Principal.toText(id));
            let msgs = await canister.posts(since);
            for(msg in Iter.fromArray(msgs)){
                all := List.push(msg,all);

            };

        };
        List.toArray(all)

    };
};

   




// actor {
//      var lastTime = Time.now();
//      public func greet(name : Text) : async Text {
//       let now = Time.now();
//        let elapsedSeconds = (now - lastTime) / 1000_000_000;
//        lastTime := now;
//        return "Hello, " # name # "!" #
//          " I was last called " # Int.toText(elapsedSeconds) # " seconds ago";
//       };
//    };
 
 