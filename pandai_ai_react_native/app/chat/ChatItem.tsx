import { FaRobot } from "rn-icons/fa";

import { View } from "react-native";
import { FaUser } from "rn-icons/fa";
import { Text } from "react-native-paper";
import React from "react";

type ChatItemProps = {
  message: ChatMessageItem;
};

export default function ChatItem({ message }: ChatItemProps) {
  return (
    <View style={{ marginVertical: 10 }}>
      <View
        style={{
          flexDirection: "row",
          flex: 1,
          justifyContent: message.isMe ? "flex-end" : "flex-start",
        }}
      >
        <View
          style={{
            padding: 8,
            backgroundColor: message.isMe ? "#BBDEFB" : "#EEEEEE",
            borderRadius: 8,
            flexDirection: "row",
          }}
        >
          {message.isMe ? <FaUser /> : <FaRobot />}
          <View style={{ width: 10 }} />
          {message.type === "message" ? (
            <>
              <Text>{message.message}</Text>
            </>
          ) : message.type === "typing" ? (
            <Text>...</Text>
          ) : (
            <Text>Unknown message type</Text>
          )}
        </View>
      </View>
    </View>
  );
}
