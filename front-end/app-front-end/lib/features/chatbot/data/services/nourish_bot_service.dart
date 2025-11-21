import '../../domain/entities/chat_message.dart';
import '../../domain/entities/bot_settings.dart';

class NourishBotService {
  static BotSettings _settings = const BotSettings();

  // Get current settings
  static BotSettings getSettings() => _settings;

  // Update settings
  static void updateSettings(BotSettings newSettings) {
    _settings = newSettings;
  }

  // Quick action templates
  static List<QuickAction> getQuickActions() {
    return const [
      QuickAction(
        id: 'waste_tips',
        label: 'Waste Tips',
        icon: 'delete',
        prompt: 'Give me tips to reduce food waste',
      ),
      QuickAction(
        id: 'meal_plan',
        label: 'Meal Plan',
        icon: 'restaurant_menu',
        prompt: 'Help me plan my meals for this week',
      ),
      QuickAction(
        id: 'leftover_ideas',
        label: 'Leftover Ideas',
        icon: 'lightbulb',
        prompt: 'What can I make with my leftovers?',
      ),
      QuickAction(
        id: 'nutrition',
        label: 'Nutrition',
        icon: 'favorite',
        prompt: 'How can I improve my nutrition?',
      ),
      QuickAction(
        id: 'recipe',
        label: 'Recipe',
        icon: 'book',
        prompt: 'Suggest a healthy recipe',
      ),
      QuickAction(
        id: 'budget',
        label: 'Save Money',
        icon: 'savings',
        prompt: 'How can I save money on groceries?',
      ),
    ];
  }

  // Generate welcome message
  static ChatMessage getWelcomeMessage() {
    return ChatMessage(
      id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
      message: 'Hi! I\'m NourishBot 🌱\n\nI\'m here to help you reduce food waste, plan nutritious meals, and make the most of your ingredients. How can I assist you today?',
      isBot: true,
      timestamp: DateTime.now(),
      type: MessageType.text,
      quickActions: getQuickActions().take(3).toList(),
    );
  }

  // Generate AI response based on user message
  static Future<ChatMessage> generateResponse(String userMessage) async {
    // Simulate AI processing delay
    await Future.delayed(const Duration(milliseconds: 800));

    final message = userMessage.toLowerCase();
    String response;
    MessageType type = MessageType.text;
    List<QuickAction>? actions;

    if (message.contains('waste') || message.contains('reduce')) {
      response = _getWasteTipsResponse();
      type = MessageType.tips;
    } else if (message.contains('meal') || message.contains('plan')) {
      response = _getMealPlanResponse();
      type = MessageType.suggestion;
      actions = [
        const QuickAction(
          id: 'generate_plan',
          label: 'Generate Plan',
          icon: 'auto_awesome',
          prompt: 'Generate a meal plan for me',
        ),
      ];
    } else if (message.contains('leftover') || message.contains('use')) {
      response = _getLeftoverIdeasResponse();
      type = MessageType.recipe;
    } else if (message.contains('nutrition') || message.contains('healthy')) {
      response = _getNutritionResponse();
    } else if (message.contains('budget') || message.contains('save') || message.contains('money')) {
      response = _getBudgetResponse();
    } else if (message.contains('recipe')) {
      response = _getRecipeResponse();
      type = MessageType.recipe;
    } else if (message.contains('hello') || message.contains('hi')) {
      response = 'Hello! 👋 How can I help you today?';
      actions = getQuickActions().take(3).toList();
    } else {
      response = _getGeneralResponse();
      actions = getQuickActions().take(3).toList();
    }

    return ChatMessage(
      id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
      message: response,
      isBot: true,
      timestamp: DateTime.now(),
      type: type,
      quickActions: actions,
    );
  }

  static String _getWasteTipsResponse() {
    return '''Here are some effective ways to reduce food waste:

🥗 **Storage Tips**
• Store fruits & veggies properly
• Use airtight containers
• Label & date your food

📅 **Planning**
• Plan meals before shopping
• Check inventory first
• Buy only what you need

♻️ **Smart Usage**
• First In, First Out (FIFO)
• Use wilting veggies in soups
• Freeze excess portions

These tips can reduce waste by up to 50%!''';
  }

  static String _getMealPlanResponse() {
    return '''I can help you create a perfect meal plan! 🍽️

Based on your inventory and preferences, I suggest:

**This Week's Plan:**
• Use ingredients expiring soon
• Balance nutrition across meals
• Minimize grocery trips

Would you like me to:
1. Generate a 7-day plan
2. Suggest recipes for specific items
3. Create a shopping list

Just let me know!''';
  }

  static String _getLeftoverIdeasResponse() {
    return '''Great question! Here are creative leftover ideas:

🍚 **Rice Leftovers:**
• Fried rice with veggies
• Rice pudding
• Stuffed peppers

🍗 **Chicken Leftovers:**
• Chicken salad sandwich
• Pasta with chicken
• Chicken soup

🥔 **Veggie Leftovers:**
• Vegetable frittata
• Stir-fry mix
• Veggie soup

What ingredients do you have?''';
  }

  static String _getNutritionResponse() {
    return '''Let me help you improve your nutrition! 🥗

**Key Focus Areas:**
• Increase vegetable intake (5+ servings/day)
• Include lean proteins
• Choose whole grains
• Stay hydrated

**Quick Wins:**
✓ Add greens to smoothies
✓ Snack on nuts/seeds
✓ Prep veggies in advance
✓ Use smaller plates

Your current diet mode: ${_settings.dietMode.displayName}

Need personalized recommendations?''';
  }

  static String _getBudgetResponse() {
    return '''Here's how to save money on groceries: 💰

**Smart Shopping:**
• Buy seasonal produce (30% cheaper!)
• Use store brands
• Shop with a list
• Avoid shopping when hungry

**Meal Prep Savings:**
• Cook in batches
• Use cheaper protein sources
• Plan around sales
• Minimize takeout

**Average Savings:**
These tips can save \$200-400/month!

Want a budget-friendly meal plan?''';
  }

  static String _getRecipeResponse() {
    return '''Here's a healthy recipe suggestion! 👨‍🍳

**Quinoa Buddha Bowl**
⏱️ 25 minutes | 🍽️ 2 servings

**Ingredients:**
• 1 cup quinoa
• Mixed greens
• Roasted chickpeas
• Avocado
• Tahini dressing

**Steps:**
1. Cook quinoa
2. Roast chickpeas with spices
3. Arrange bowl with greens
4. Top with avocado & dressing

**Nutrition:** 420 cal, 15g protein

Want more recipes?''';
  }

  static String _getGeneralResponse() {
    return '''I can help you with:

🗑️ **Waste Reduction**
• Storage tips
• Preservation methods
• Creative usage ideas

🍽️ **Meal Planning**
• Weekly plans
• Recipe suggestions
• Shopping lists

🥗 **Nutrition**
• Balanced meals
• Dietary guidance
• Healthy swaps

💰 **Budget Tips**
• Cost-saving strategies
• Affordable recipes
• Smart shopping

What would you like to explore?''';
  }

  // Get conversation starters
  static List<String> getConversationStarters() {
    return [
      'What can I make with eggs and vegetables?',
      'Help me plan meals for the week',
      'How to store fresh herbs?',
      'Give me a budget-friendly recipe',
      'What to do with overripe bananas?',
      'Suggest high-protein meals',
    ];
  }

  // Create typing indicator message
  static ChatMessage createTypingMessage() {
    return ChatMessage(
      id: 'typing',
      message: '',
      isBot: true,
      timestamp: DateTime.now(),
      isTyping: true,
    );
  }
}
