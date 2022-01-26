import { hello_micro } from "../../declarations/hello_micro";
//export const canisterId = process.env.MICROBLOG_CANISTER_ID;

//张贴post的功能
async function post(){
  let post_button = document.getElementById("post");
  let error =  document.getElementById("error");
  error.value = "";
  post_button.disabled = true;
  let textarea = document.getElementById("message");
  let otp = document.getElementById("otp").value;
  let text = textarea.value;
  try{ 
    await hello_micro.post(otp,text);
    textarea.value = "";
  }catch (err){
    console.log(err)
    error.innerText= "Post Failed";  

  }
  post_button.disabled = false;


}


var num_posts = 0;
async function load_posts(){

  //html
  let posts_section = document.getElementById("posts");
 
  //hello_micro的posts返回一个List
  let posts = await hello_micro.posts();
  //posts 没有添加新内容，返回
  if(num_posts == posts.length) return;
  //postssection设为空
  posts_section.replaceChildren([]);
  //更新num
  num_posts = posts.length;
  for(var i = 0;i < posts.length;i++){
    //把新的posts放入前端
    let post = document.createElement("p");
    post.innerText = posts[i].content.toString()+"     "+posts[i].time.toString();
    posts_section.appendChild(post);
  }


}
async function load_canisterid(){
  let canister = document.getElementById("canisterid");
  canister.replaceChildren([]);
  var canisterid = "";
  canisterid = await hello_micro.get_canisterid();
  console.log("hello,world");
  let p = document.createElement("a");
  p.innerText = canisterid;
  canister.appendChild(p);

}

async function load_authorname(){
  let author_name = document.getElementById("author_name");
  author_name.replaceChildren([]);
  var author = "";
  author = await hello_micro.get_name();
  console.log(author);
  let p = document.createElement("p");
  p.innerText = author;
  author_name.appendChild(p);


}
var num_follows = 0;
async function load_follows() {
  var follows = null;
  follows = await hello_micro.follows();
  if (follows == null || num_follows == follows.length) return; 
  num_follows = follows.length;
  //html
  let follows_section = document.getElementById("follows");
  follows_section.replaceChildren([]);
  for(var i = 0;i < follows.length;i++){
    //把新的posts放入前端
    let follow = document.createElement("p");
    follow.innerText = follows[i].toString();
    follows_section.appendChild(follow);
  }


}
var num_timelines = 0;
async function load_timelines() {
 
  let timelines = await hello_micro.timeline();
  if (timelines == null || num_timelines == timelines.length) return; 
  num_timelines = timelines.length;
  //html
  let timelines_section = document.getElementById("timelines");
  timelines_section.replaceChildren([]);
  for(var i = 0;i < timelines.length;i++){
    //把新的posts放入前端
   
    let timeline = document.createElement("p");
    timeline.innerText = timelines[i].content.toString()+"     "+ timelines[i].time.toString()+"    "+timelines[i].author.toString() ;
    timelines_section.appendChild(timeline);
  }


}

async function load_all(){
  load_posts();
  load_follows();
  load_timelines();
 


}

function load(){
  //post按钮
  let post_button = document.getElementById("post");
  //button按下调用post方法
  post_button.onclick = post;

  //调用一次load_posts方法
  load_authorname();
  load_canisterid();
  load_all();

  //每个三秒都重复刷新load_posts
  setInterval(load_all,3000)

}


window.onload = load 
