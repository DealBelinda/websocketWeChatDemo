package service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.util.HashMap;
import java.util.Map;

public class MyHandler extends TextWebSocketHandler {
    //用户对应的websocket SESSION
    public static Map<String,WebSocketSession> userSocketSessionMap = new HashMap<>();

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        JSONObject messageJson = JSON.parseObject(message.getPayload());
        String rtnMsg = messageJson.getString("userName")+ "：" + messageJson.getString("content");
        WebSocketSession targetSession = userSocketSessionMap.get(messageJson.getString("targetUser"));
        if(targetSession!=null){
            targetSession.sendMessage(new TextMessage(rtnMsg));
        }else{
            session.sendMessage(new TextMessage("系统回复：用户"+messageJson.getString("targetUser")+"已断开连接！"));
        }
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        System.out.println("webSocket连接已建立");
        String userName = String.valueOf(session.getAttributes().get("userName"));
        if(userName!=null&&!userName.trim().equals("")){
            userSocketSessionMap.put(userName,session);
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        userSocketSessionMap.remove(session.getAttributes().get("userName"));
    }
}