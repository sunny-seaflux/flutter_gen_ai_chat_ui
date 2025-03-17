import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:provider/provider.dart';

import '../../models/app_state.dart';
import '../../services/ai_service.dart';

/// A basic example showing the minimal implementation of Flutter Gen AI Chat UI.
/// This example demonstrates essential features with clean, well-documented code.
class BasicChatScreen extends StatefulWidget {
  const BasicChatScreen({super.key});

  @override
  State<BasicChatScreen> createState() => _BasicChatScreenState();
}

class _BasicChatScreenState extends State<BasicChatScreen> {
  // Create a controller to manage chat messages
  final _chatController = ChatMessagesController();

  // Mock AI service
  final _aiService = AiService();

  // Define users for the chat
  final _currentUser = ChatUser(id: 'user123', firstName: 'You');
  final _aiUser = ChatUser(id: 'ai123', firstName: 'AI Assistant');

  // Track loading state
  bool _isLoading = false;

  // Example questions for the welcome message
  final _exampleQuestions = [
    ExampleQuestion(question: "What can you help me with?"),
    ExampleQuestion(question: "Tell me about Flutter"),
    ExampleQuestion(question: "How does this UI work?"),
    ExampleQuestion(question: "Show me some examples"),
  ];

  @override
  void initState() {
    super.initState();

    // Add a welcome message to the chat
    _chatController.addMessage(
      ChatMessage(
        text: "👋 Hello! I'm your AI assistant. How can I help you today?",
        user: _aiUser,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controller to avoid memory leaks
    _chatController.dispose();
    super.dispose();
  }

  /// Handle sending a user message and generating a response
  Future<void> _handleSendMessage(ChatMessage message) async {
    // Set loading state to show typing indicator
    setState(() => _isLoading = true);

    try {
      // Get app state for configuration
      final appState = Provider.of<AppState>(context, listen: false);

      // Simulate API call to generate response
      final response = await _aiService.generateResponse(message.text,
          includeCodeBlock: false);

      // Add the AI response to the chat
      _chatController.addMessage(
        ChatMessage(
          text: response.text,
          user: _aiUser,
          createdAt: DateTime.now(),
          isMarkdown: response.isMarkdown,
        ),
      );
    } finally {
      // Reset loading state
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get app state for theme and settings
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Chat Example'),
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(
              appState.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: appState.toggleTheme,
            tooltip: 'Toggle theme',
          ),
          // Reset conversation button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _chatController.clearMessages();
              // Re-add the welcome message
              _chatController.addMessage(
                ChatMessage(
                  text:
                      "👋 Hello! I'm your AI assistant. How can I help you today?",
                  user: _aiUser,
                  createdAt: DateTime.now(),
                ),
              );
            },
            tooltip: 'Reset conversation',
          ),
        ],
      ),
      body: AiChatWidget(
        // Required parameters
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _chatController,
        onSendMessage: _handleSendMessage,

        // Loading state
        loadingConfig: LoadingConfig(
          isLoading: _isLoading,
        ),

        // Welcome message configuration
        welcomeMessageConfig: const WelcomeMessageConfig(
          title: "Welcome to the Basic Example",
          questionsSectionTitle: "Try asking:",
        ),

        // Example questions to display in the welcome message
        exampleQuestions: _exampleQuestions,

        // Input configuration
        inputOptions: const InputOptions(
          unfocusOnTapOutside:
              false, // Prevents focus loss when tapping outside
          sendOnEnter: true, // Enter key sends the message
          decoration: InputDecoration(
            hintText: 'Type a message...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              borderSide: BorderSide.none,
            ),
            filled: true,
          ),
        ),

        // Message styling
        messageOptions: MessageOptions(
          showUserName: true,
          bubbleStyle: BubbleStyle(
            userBubbleColor: Theme.of(context).colorScheme.primaryContainer,
            aiBubbleColor: Theme.of(context).colorScheme.surfaceVariant,
          ),
        ),

        // Enable animations based on app state
        enableAnimation: appState.enableAnimation,
      ),
    );
  }
}
