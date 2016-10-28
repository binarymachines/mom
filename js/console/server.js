var express = require("express");
var app = express();
var router = express.Router();
var path = __dirname + '/views/';
var css_path = __dirname + '/css/';
var dist_css_path = __dirname + '/dist/css/';
var dist_js_path = __dirname + '/dist/js/';

router.use(function (req,res,next) {
  console.log("/" + req.method);
  next();
});

router.get("/css/dashboard.css",function(req,res){
  res.sendFile(css_path + "dashboard.css");
});

router.get("/dist/css/bootstrap.min.css",function(req,res){
  res.sendFile(dist_css_path + "bootstrap.min.css");
});

router.get("/dist/js/bootstrap.min.js",function(req,res){
  res.sendFile(dist_js_path + "bootstrap.min.js");
});

router.get("/",function(req,res){
  res.sendFile(path + "index.html");
});

router.get("/about",function(req,res){
  res.sendFile(path + "about.html");
});

router.get("/dashboard",function(req,res){
  res.sendFile(path + "dashboard.html");
});

app.use("/",router);

app.use("*",function(req,res){
  res.sendFile(path + "404.html");
});

app.listen(3000,function(){
  console.log("Live at Port 3000");
});
