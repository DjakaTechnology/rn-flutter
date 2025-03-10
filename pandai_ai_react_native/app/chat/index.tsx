import {
  NativeScrollEvent,
  NativeSyntheticEvent,
  FlatList,
  View,
} from "react-native";
import {
  Appbar,
  Button,
  TextInput,
  useTheme,
  ActivityIndicator,
} from "react-native-paper";
import { router } from "expo-router";
import React, { useCallback, useState, useRef } from "react";
import ChatItem from "./ChatItem";
import { delay } from "../util";

function createUserChatMessage(
  message: string,
  isUser: boolean
): UserChatMessageItem {
  return {
    message,
    isMe: isUser,
    type: "message",
  };
}

function createTypingChatMessage(): TypingChatMessageItem {
  return {
    isMe: false,
    type: "typing",
  };
}

function useChatService() {
  const [messages, setMessages] = useState<ChatMessageItem[]>([]);
  const [isLoading, setIsLoading] = useState(false);

  const sendMessage = useCallback(
    async (message: string) => {
      const newMessages = [...messages, createUserChatMessage(message, true)];
      setMessages(newMessages);
      setIsLoading(true);
      setMessages([...newMessages, createTypingChatMessage()]);

      await delay(1000);

      setIsLoading(false);
      setMessages([
        ...newMessages,
        createUserChatMessage("Hello, how are you?", false),
      ]);
    },
    [messages]
  );

  return { messages, isLoading, sendMessage };
}

function useScrollToBottomHandling() {
  const flatListRef = useRef<FlatList>(null);
  const [isAtBottom, setIsAtBottom] = useState(true);

  const handleScroll = useCallback(
    (event: NativeSyntheticEvent<NativeScrollEvent>) => {
      const { layoutMeasurement, contentOffset, contentSize } =
        event.nativeEvent;
      const paddingToBottom = 0;
      const isCloseToBottom =
        layoutMeasurement.height + contentOffset.y >=
        contentSize.height - paddingToBottom;
      setIsAtBottom(isCloseToBottom);
    },
    []
  );

  return { flatListRef, isAtBottom, handleScroll };
}

export default function Index() {
  const theme = useTheme();
  const [message, setMessage] = useState("");

  const { flatListRef, isAtBottom, handleScroll } = useScrollToBottomHandling();
  const { messages, isLoading, sendMessage } = useChatService();

  const handleSendMessage = useCallback(async () => {
    if (isLoading) return;
    await sendMessage(message);
    if (!isAtBottom) {
      flatListRef.current?.scrollToEnd({ animated: true });
    }
    setMessage("");
  }, [message, sendMessage, isLoading, isAtBottom]);

  return (
    <View
      style={{
        flex: 1,
        flexDirection: "column",
        backgroundColor: theme.colors.surface,
      }}
    >
      <Appbar.Header>
        <Appbar.BackAction onPress={() => router.back()} />
        <Appbar.Content title="Chat" />
      </Appbar.Header>
      <View style={{ flex: 1, position: "relative" }}>
        <FlatList
          ref={flatListRef}
          data={messages}
          renderItem={({ item }) => <ChatItem message={item} />}
          keyExtractor={(_, index) => index.toString()}
          onScroll={handleScroll}
          scrollEventThrottle={400}
          contentContainerStyle={{ paddingHorizontal: 12 }}
        />
        {isLoading && (
          <View
            style={{
              position: "absolute",
              bottom: 0,
              left: 0,
              right: 0,
              padding: 10,
              alignItems: "center",
            }}
          >
            <ActivityIndicator size="large" />
          </View>
        )}
      </View>
      <View style={{ flexDirection: "row", padding: 10, alignItems: "center" }}>
        <TextInput
          placeholder="Message"
          value={message}
          onChangeText={setMessage}
          style={{ flex: 1 }}
          mode="outlined"
        />
        <Button mode="contained" onPress={handleSendMessage}>
          Send
        </Button>
      </View>
    </View>
  );
}
