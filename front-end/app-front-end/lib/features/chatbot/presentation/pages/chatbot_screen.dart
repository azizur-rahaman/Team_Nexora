import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/chat_message.dart';
import '../../data/services/nourish_bot_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(NourishBotService.getWelcomeMessage());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      message: text.trim(),
      isBot: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
      _messageController.clear();
    });

    _scrollToBottom();

    // Get AI response
    final botResponse = await NourishBotService.generateResponse(text);

    setState(() {
      _isTyping = false;
      _messages.add(botResponse);
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralLightGray.withOpacity(0.3),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.neutralWhite),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.neutralWhite.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: AppColors.neutralWhite,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NourishBot',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.neutralWhite,
                    fontWeight: AppTypography.bold,
                  ),
                ),
                Text(
                  'Online',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.neutralWhite.withOpacity(0.8),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.neutralWhite),
            onPressed: () {
              context.push('/chatbot/settings');
            },
            tooltip: 'Bot Settings',
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Input Area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isBot = message.isBot;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isBot) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryGreen,
                        AppColors.primaryGreenDark,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    color: AppColors.neutralWhite,
                    size: 16,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: isBot
                        ? const LinearGradient(
                            colors: [
                              AppColors.primaryGreen,
                              AppColors.primaryGreenLight,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isBot ? null : AppColors.neutralWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isBot ? 4 : AppSpacing.radiusMD),
                      topRight: Radius.circular(isBot ? AppSpacing.radiusMD : 4),
                      bottomLeft: const Radius.circular(AppSpacing.radiusMD),
                      bottomRight: const Radius.circular(AppSpacing.radiusMD),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neutralBlack.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.message,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isBot ? AppColors.neutralWhite : AppColors.neutralBlack,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(left: isBot ? 40 : 0, right: isBot ? 0 : 8),
            child: Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: AppTypography.caption.copyWith(
                color: AppColors.neutralGray,
                fontSize: 10,
              ),
            ),
          ),

          // Quick Actions
          if (message.quickActions != null && message.quickActions!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: message.quickActions!.map((action) {
                  return _buildQuickActionChip(action);
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActionChip(QuickAction action) {
    return ActionChip(
      label: Text(action.label),
      avatar: Icon(
        _getIconData(action.icon),
        size: 16,
        color: AppColors.primaryGreen,
      ),
      onPressed: () {
        _sendMessage(action.prompt);
      },
      backgroundColor: AppColors.neutralWhite,
      side: const BorderSide(color: AppColors.primaryGreen),
      labelStyle: AppTypography.bodySmall.copyWith(
        color: AppColors.primaryGreen,
        fontWeight: AppTypography.semiBold,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 0,
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryGreen,
                  AppColors.primaryGreenDark,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: AppColors.neutralWhite,
              size: 16,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryGreen,
                  AppColors.primaryGreenLight,
                ],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.neutralWhite,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      onEnd: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.neutralBlack.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Quick action chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: NourishBotService.getQuickActions().map<Widget>((QuickAction action) {
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: ActionChip(
                      label: Text(action.label),
                      avatar: Icon(
                        _getIconData(action.icon),
                        size: 16,
                        color: AppColors.primaryGreen,
                      ),
                      onPressed: () {
                        _sendMessage(action.prompt);
                      },
                      backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                      side: BorderSide(color: AppColors.primaryGreen.withOpacity(0.3)),
                      labelStyle: AppTypography.bodySmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: AppTypography.semiBold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Input field
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.neutralLightGray.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          color: AppColors.neutralGray,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primaryGreen,
                        AppColors.primaryGreenDark,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: AppColors.neutralWhite),
                    onPressed: () {
                      _sendMessage(_messageController.text);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'delete':
        return Icons.delete_outline;
      case 'restaurant_menu':
        return Icons.restaurant_menu;
      case 'lightbulb':
        return Icons.lightbulb_outline;
      case 'favorite':
        return Icons.favorite_outline;
      case 'book':
        return Icons.menu_book;
      case 'savings':
        return Icons.savings_outlined;
      default:
        return Icons.chat;
    }
  }
}
