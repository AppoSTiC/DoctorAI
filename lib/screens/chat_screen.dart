import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/chat_controller.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatController>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice AI Health Assistant'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.amber[100],
            width: double.infinity,
            child: const Text(
              "Disclaimer: This is not a medical diagnosis. Consult a doctor for serious conditions.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Consumer<ChatController>(
              builder: (context, controller, child) {
                if (controller.messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tap the microphone and describe your symptoms.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(message: controller.messages[index]);
                  },
                );
              },
            ),
          ),
          Consumer<ChatController>(
            builder: (context, controller, child) {
              if (controller.isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 80), // Space for FAB
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<ChatController>(
        builder: (context, controller, child) {
          return FloatingActionButton(
            onPressed: () => controller.toggleListening(),
            backgroundColor: controller.isListening ? Colors.red : Colors.blue,
            child: Icon(controller.isListening ? Icons.stop : Icons.mic),
          );
        },
      ),
    );
  }
}
