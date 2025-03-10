import { router } from "expo-router";
import { View } from "react-native";
import { Appbar, Button, useTheme } from "react-native-paper";

export default function Index() {
  const theme = useTheme();
  return (
    <View style={{ flex: 1, backgroundColor: theme.colors.surface }}>
      <Appbar.Header>
        <Appbar.Content title="Home" />
      </Appbar.Header>
      <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
        <Button
          mode="contained"
          onPress={() => router.push("/chat")}
          style={{ marginHorizontal: 16 }}
        >
          Start Chat
        </Button>
      </View>
    </View>
  );
}
