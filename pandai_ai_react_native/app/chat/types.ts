type ChatMessageItem = UserChatMessageItem | TypingChatMessageItem;

interface UserChatMessageItem {
  isMe: boolean;
  message: string;
  type: "message";
}

interface TypingChatMessageItem {
  isMe: false;
  type: "typing";
}
