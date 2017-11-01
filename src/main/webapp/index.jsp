<%--
  Created by IntelliJ IDEA.
  User: OnlyLoveForBelinda
  Date: 2017/10/31
  Time: 18:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String path = request.getContextPath();
  String basePath = request.getScheme() + "://"
  + request.getServerName() + ":" + request.getServerPort()
  + path + "/";
%>
<html>
  <head>
    <title>websocketDemo演示</title>
  </head>
  <body>
    <div class="content_main">
      <div class="chatBox">
        <div id="chatWin" style="border: 1px solid black;height:200px;overflow-y:auto">
        </div>
        <div class="sendBox">
          <div>
            <input id="userName" type="text" placeholder="你的名称">
            <input id="targetUser" type="text" placeholder="目标用户名称">
            <textarea id="msgArea"></textarea>
          </div>
          <input type="button" value="连接" onclick="connect()">
          <input type="button" value="发送" onclick="sendMsg()">
        </div>
      </div>
    </div>
  </body>
  <script>
      var ws = null
      var basePath = "<%= basePath%>"
      var wsPath = basePath.replace( "http://", "ws://" );
      var sendMsg = function () {
          var userName = document.getElementById("userName").value
          var targetUser = document.getElementById("targetUser").value
          var content = document.getElementById("msgArea").value
          var data = {
              targetUser:targetUser,
              content:content,
              userName:userName
          }
          setMsgInHtml(userName+ "：" + content)
          document.getElementById("msgArea").value = ''
          if(ws){
              ws.send(JSON.stringify(data))
          }
      }
      var setMsgInHtml = function (msg) {
          var pNode=document.createElement("p")
          var textnode=document.createTextNode(msg)
          pNode.appendChild(textnode)
          document.getElementById("chatWin").appendChild(pNode)
      }
      var connect = function () {
          if(window.WebSocket){
              ws = new WebSocket(wsPath+"myHandler?userName="+document.getElementById("userName").value)
          }
          if(ws){
              ws.onopen = function(evt) {
                  console.log("Connection open ...");
              };

              ws.onmessage = function(evt) {
                  setMsgInHtml(evt.data)
              };

              ws.onclose = function(evt) {
                  console.log("Connection closed.");
              };
          }else{
              alert("你的浏览器不支持websocket")
          }
      }
  </script>
</html>
