# 🍔 SecretMenu

**Your personal food order manager for restaurants and cafes**

SecretMenu is an iOS app that helps you save, organize, and quickly access your favorite custom orders from your favorite restaurants and cafes. Never forget your perfect order combination again!

## ✨ Features

### 🏪 **Places Management**
- Add and manage your favorite restaurants and cafes
- Support for popular chains including:
  - Starbucks, Chipotle, McDonald's, Subway
  - Taco Bell, Dunkin', Chick-fil-A, Burger King
  - Wendy's, Panera, Tim Hortons, and more
- Custom brand icons and place details
- Grid layout for easy browsing

### 🏷️ **Smart Tagging System**
- Create custom tags to organize your orders
- Tag orders across different places (e.g., "Vegetarian", "Quick Lunch", "Date Night")
- Filter and find orders by tags
- Visual tag management with order counts

### 📝 **Order Tracking**
- Save detailed custom orders for each place
- Add notes, modifications, and special instructions
- Track order history and preferences
- Quick access to your go-to orders

### 🎨 **Beautiful UI/UX**
- Modern SwiftUI interface with smooth animations
- Dark/Light mode support
- Intuitive onboarding tutorial
- Responsive design for all iPhone sizes
- Beautiful gradients and visual effects

### 🔒 **Privacy & Data**
- All data stored locally on your device
- No cloud sync required
- Complete privacy control
- Core Data for reliable storage

### ⚡ **Premium Features**
- Ad-free experience
- Advanced customization options
- Enhanced organization features

## 🚀 Getting Started

### Prerequisites
- iOS 16.0 or later

### Installation

#### For Users
1. Download from the App Store
2. Open the app and follow the onboarding tutorial
3. Start adding your favorite places and orders!

## 🛠️ Architecture

### Tech Stack
- **Framework**: SwiftUI
- **Data Persistence**: Core Data
- **Architecture**: MVVM with ObservableObject
- **Minimum iOS Version**: 16.0

### Project Structure
```
SecretMenu/
├── SecretMenuApp.swift          # App entry point
├── Views/                       # SwiftUI views
│   ├── MainTabView.swift        # Main tab navigation
│   ├── Places/                  # Places management
│   ├── Tags/                    # Tag management
│   ├── Orders/                  # Order management
│   ├── Settings/                # App settings
│   └── Onboarding/              # Onboarding flow
├── Models/                      # Data models
├── Services/                    # Business logic
├── ViewModels/                  # View models
└── Assets.xcassets/            # App assets
```

### Key Components

#### Data Management
- `DataStore.swift` - Core Data management
- `Place` entity - Restaurant/cafe information
- `Order` entity - Custom order details
- `Tag` entity - Organization tags

#### Services
- `ThemeManager.swift` - Dark/Light mode
- `OnboardingManager.swift` - Tutorial flow
- `PremiumManager.swift` - Premium features
- `AdManager.swift` - Advertisement handling

## 🎯 Usage Guide

### Adding Your First Place
1. Tap the "+" button in the Places tab
2. Search for a popular restaurant or add a custom place
3. Add a custom icon or select from brand options
4. Save your place

### Creating Custom Orders
1. Select a place from your list
2. Tap "Add Order"
3. Enter your order details, modifications, and notes
4. Add relevant tags for easy organization
5. Save your order

### Organizing with Tags
1. Go to the Tags tab
2. Create tags like "Vegetarian", "Quick Lunch", "Date Night"
3. Apply tags to your orders
4. Use tags to filter and find orders quickly

### Managing Your Data
- Edit places and orders anytime
- Delete items with confirmation dialogs
- All changes are saved automatically
- Data is stored locally on your device


## 🙏 Acknowledgments

- SwiftUI community for inspiration and best practices
- Core Data framework for reliable data persistence
- All the beta testers who provided valuable feedback

## 📞 Support
- **Email**: secretmenu.contact@gmail.com

## 🔮 Roadmap

### Upcoming Features
- [ ] Cloud sync support
- [ ] Order sharing with friends
- [ ] Nutritional information tracking
- [ ] Restaurant menu integration
- [ ] Order history analytics
- [ ] Widget support
- [ ] Apple Watch companion app

### Version History
- **v1.0.0** - Initial release with core features

---

**Made with ❤️ by Hassan Waraych**

*Never forget your perfect order again! 🍔✨* 