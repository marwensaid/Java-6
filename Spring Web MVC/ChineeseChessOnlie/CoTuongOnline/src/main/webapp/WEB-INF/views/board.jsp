<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="zh-CN" ng-app="myApp">
    <head>
        <title>Chinese Chess</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <link rel="stylesheet" type="text/css" href="resources/extra/Style.css">
        <link rel="stylesheet" type="text/css" href="resources/extra/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="resources/extra/bootstrap-theme.min.css">
    </head>
  <body ng-controller="MyAppController">
        <div id="main">
            <div id="debug" style="float:left;display:none">
            </div>

            <div style="float:left">
                <canvas id="board" width="460" height="510" ></canvas>
            </div>
            <div style="float: right">
                <div id="newGame" class="button" >New Game</div>
                <div id="restore" class="button" >Turn back</div>
                <div id="listUser" class="button" ng-click="showListUser()">List User</div>
                <div class="info" >Time：<span id="TimeCost">0</span></div>
                <div class="info" >Depth：<span id="depth">0</span></div>

                <br/>
                <div class="conversation">
                    <div class="title">
                        <div align="center" style="font-weight: bold;">
                            Chat Conversation
                        </div>
                    </div>
                    <div id="talks">
                        <div ng-repeat="message in messages track by $index" class="bubble" ng-bind="message"
                                ng-class="{'bubble--alt':($index%2)==0}">
                        </div>
                    </div>
                    <div class="send-message">
                        <input type="text" class="write-message" placeholder="Write Message ..." ng-model="yourMessage"
                               ng-keypress="sendMessage()">
                    </div>
                </div>
            </div>

        </div>

         <div class="modal fade" id="modalListUser" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content" style="height: 100vh; width: 150%; margin-left: -22%; overflow-y: scroll;" >
                    <div class="modal-header" style="background-color: #5bc0de;">
                        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                        <h4 class="modal-title" id="myModalLabel">List User Online</h4>
                    </div>
                    <div class="modal-body">
                        <div ng-repeat="user in userOnline" class="col-md-2 userInListUsers" ng-click="clickUser()" >
                            <br/>
                            <img src="{{user.img_url}}" height="80px" style="border-radius: 30px; margin-left: 10%;"/>
                            <span ng-bind-template="{{user.name}}"></span>
                            <span ng-bind-template="Score: {{user.point}}"></span>
                            <button class="btn btn-success" style="width: 100%; border-radius: 10px;" ng-click="addFriend()">
                                Add Friend
                            </button>
                            <button class="btn btn-primary" style="width: 100%; margin-top: 5%; border-radius: 10px;" ng-click="challengeUser()">
                                Chalenge
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
  		<script src="resources/extra/angular.min.js"></script>
        <script src="resources/extra/jquery-1.11.0.min.js"></script>
        <script src="resources/extra/bootstrap.min.js"></script>
        <script src="resources/extra/soundmanager2.js"></script>
        <script src="resources/extra/Chess.js"></script>
        <script src="resources/extra/Board.js"></script>
        <script src="resources/extra/control.js"></script>

        <div id="debug" style="position:absolut;top:0px;left:0px;width:200px;"></div>
        <script type='text/javascript'>
            var chessGame=new ChessGame("board");
            chessGame.init();
            document.getElementById("newGame").onclick=function(){chessGame.init()};
            document.getElementById("restore").onclick=function(){chessGame.restore()};
        </script>
        <script>
		
	  /**
		*	The code below is basic function to receive data from game's server
		*	@onOpen
		*	@onMessage
		*	@onClose
		*	0: OK ----- 1: ERROR
	    **/
		var ws=new WebSocket("ws://localhost:8080/cotuong/game");
		ws.onopen=function(message){
			var id_player=1;
			ws.send("REG-"+id_player);
		};
		ws.onmessage=function(message){
			var data=message.data.split("-|-");
			switch(data[0]){
				case "HANDSHAKE":
					var id_requestHandShake=data[1];
					break;
				case "ACCEPT_HANDSHAKE":
					break;
				case "PAUSE":
					var id_requestPause=1;
					
					break;
				case "ACCEPT_PAUSE":
					var accept=data[1];
					if(accept=="1"){
						console.log("continue");
					}
					break;
				case "CHAT":
					console.log(data[1]);
					break;
				case "LOGIN":
					break;
				case "LOGOUT":
					break;
			}
		}
		ws.onclose=function(message){
			ws.close();
		}
		/**
		 *
		 *
		 *
		 **/
		function postMessage(){
			var to_client_id=2;
			var text=$("#msg").val();
			ws.send("CHAT-"+to_client_id+"-"+text);
			$("#msg").val("");
		}
		function acceptHandShake(){
			var id_requestHandshake=1;
			ws.send("HANDSHAKE-0-"+id_requestHandshake);
		}
		function declineHandShake(){
			var id_requestHandshake=1;
			ws.send("HANDSHAKE-1-"+id_requestHandshake);
		}
		function requestPause(){
			var id_requestPause=1;
			ws.send("PAUSE-1-"+id_requestHandshake);
		}
		function acceptLose(){
			
		}
		function requestDrawGame(){
			
		}
	</script>
    </body>
</html>