import Iter "mo:base/Iter";
import List "mo:base/List";
import Pricinpal "mo:base/Bool";
import Principal "mo:base/Principal";

import Debug "mo:base/Debug";
import Int "mo:base/Int";

import Time "mo:base/Time";


actor Microblog{

    // public func greet(name : Text) : async Text {
    //     return "Hello, " # name # "!";
    // };
    type Message = {
        content:Text;
        time :Time.Time;
        author:?Text;
    };

    stable var authorName : ?Text = ?"Huiwating";

    var messages : List.List<Message> = List.nil();
    var followed : List.List<Principal> = List.nil();
    //public type Message = Text;
    public type Microblog = actor{
        follow : shared(Principal) ->async(); //关注对象
        follows : shared query () ->async [Principal]; //返回关注列表
        post :shared (Text) ->async();
        posts :shared query() ->async [Message];  
        timeline :shared() -> async [Message]; //返回所有关注对象发布的消息
        get_name:shared ()->async Text;
        set_name:shared (Text) ->async();



    };
    public shared  func  get_name() :async ?Text{
        authorName ;
           
    };
    public shared  func  get_canisterid() :async ?Text{
        ?Principal.toText(Principal.fromActor(Microblog)); 
           
    };
 
 

    public shared(msg) func set_name(author :?Text):async(){
        authorName := author;

    };
    
    public shared func follow(id :Principal) : async() {
        followed := List.push(id,followed);
    };

    public shared func  follows() :async [Principal]{
        List.toArray(followed);

    };
    public shared (msg) func post(otp:Text,text :Text):async(){
 //       assert(Principal.toText(msg.caller) == "74kkb-bmzhh-s6c3c-regcw-lhwil-ztkou-7isyp-rjnrk-3uxqe-lo7tk-rqe" );
        
        assert(Principal.toText(msg.caller) == Principal.fromActor(Microblog) );
        assert(otp == "23456");

        let m : Message = do{
            {
            content = text;
            time = Time.now();
            author = authorName;
            
            }
        };
        messages := List.push(m,messages);
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


