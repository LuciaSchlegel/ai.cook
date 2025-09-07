# 🍳 ai.cook - AI-Powered Recipe Management App

**ai.cook** is a comprehensive Flutter-based recipe management application that combines intelligent recipe discovery, personalized AI recommendations, and seamless ingredient management. The app features a multi-tier architecture with Flutter frontend, Node.js/TypeScript backend, and Python-based AI microservices.

## 🌟 Key Features

### 🔍 Smart Recipe Discovery
- **Intelligent Recipe Search**: Advanced filtering by ingredients, cooking time, difficulty, and dietary preferences
- **AI-Powered Recommendations**: Personalized recipe suggestions based on available ingredients and user preferences
- **Recipe Categorization**: Organized by cuisine type, meal category, cooking method, and dietary restrictions

### 🥘 Ingredient Management
- **Digital Cupboard**: Track your available ingredients with quantities and expiration dates
- **Smart Suggestions**: Get recommendations for recipes you can make with current ingredients
- **Shopping Lists**: Automatic generation based on missing ingredients for desired recipes
- **Ingredient Categorization**: Organized by food groups (Grains, Dairy, Vegetables, Meat, etc.)

### 🤖 AI Integration
- **Conversational AI Assistant**: Chat with an AI cooking assistant for tips, substitutions, and guidance
- **Recipe Generation**: Create new recipes from keywords using OpenAI integration
- **Personalized Recommendations**: AI analyzes your preferences and suggests tailored recipes
- **Smart Ingredient Substitutions**: Get AI-powered alternatives for missing ingredients

### 📅 Meal Planning
- **Calendar Integration**: Plan meals for the week with drag-and-drop functionality
- **Nutritional Tracking**: Monitor dietary goals and nutritional information
- **Batch Cooking Support**: Plan and organize meal prep sessions

### 👤 User Management
- **Multi-Authentication**: Support for email/password, Google Sign-In, and Apple Sign-In
- **User Profiles**: Personalized preferences, dietary restrictions, and cooking skill levels
- **Social Features**: Share recipes and cooking experiences (planned)

### 📱 Cross-Platform Support
- **iOS & Android**: Native performance with Flutter
- **Responsive Design**: Optimized for phones and tablets
- **Offline Capability**: Core features available without internet connection

## 🏗️ Architecture

### Frontend (Flutter)
```
lib/
├── screens/           # Main app screens
│   ├── auth/         # Authentication screens
│   ├── home/         # Dashboard and home screen
│   ├── cupboard/     # Ingredient management
│   ├── recipes/      # Recipe browsing and details
│   ├── calendar/     # Meal planning
│   └── settings/     # App configuration
├── providers/        # State management (Provider pattern)
├── widgets/          # Reusable UI components
├── models/           # Data models
├── dialogs/          # Modal dialogs and overlays
└── utils/            # Helper functions and utilities
```

### Backend (Node.js/TypeScript)
```
server/
├── src/
│   ├── controllers/  # API route handlers
│   ├── services/     # Business logic
│   ├── models/       # Database entities (TypeORM)
│   ├── routes/       # API routing
│   ├── dtos/         # Data transfer objects
│   └── scripts/      # Database seeding and utilities
├── tests/            # Unit and integration tests
└── docs/             # API documentation
```

### AI Microservice (Python/FastAPI)
```
llm_microservice/
├── app.py           # FastAPI application
├── routes/          # API endpoints
├── services/        # AI service logic
└── models/          # Data models
```

### Database Architecture
- **PostgreSQL**: Primary database for recipes, ingredients, and user data
- **Firebase Auth**: User authentication and session management
- **TypeORM**: Database ORM with migrations and seeding

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** (3.7.2+)
- **Node.js** (16+)
- **Python** (3.8+)
- **PostgreSQL** (13+)
- **Firebase Project** (for authentication)

### Environment Setup

#### 1. Clone the Repository
```bash
git clone <repository-url>
cd ai.cook
```

#### 2. Flutter App Setup
```bash
# Install Flutter dependencies
flutter pub get

# Create environment file
cp .env.example .env
# Edit .env with your configuration

# Run the app
flutter run
```

#### 3. Backend Server Setup
```bash
cd server

# Install dependencies
npm install

# Setup environment variables
cp .env.example .env
# Edit .env with database and service URLs

# Run database migrations
npm run migrate

# Seed basic data (categories, units, tags)
npm run seed:basic

# Seed sample recipes (optional)
npm run seed:recipes:test

# Start development server
npm run dev
```

#### 4. AI Microservice Setup
```bash
cd llm_microservice

# Install Python dependencies
pip install -r requirements.txt

# Setup environment variables
cp .env.example .env
# Add your OpenAI API key

# Start the service
python app.py
```

### Environment Variables

#### Flutter (.env)
```env
API_URL=http://localhost:3000
```

#### Backend Server (.env)
```env
# Database
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=ai_cook
DATABASE_USER=your_db_user
DATABASE_PASSWORD=your_db_password

# Services
LLM_SERVICE_URL=http://localhost:8000

# Firebase (optional, for admin features)
FIREBASE_SERVICE_ACCOUNT_KEY=path/to/service-account.json
```

#### AI Microservice (.env)
```env
# OpenAI Configuration
OPENAI_API_KEY=your_openai_api_key_here

# Service Configuration
PORT=8000
HOST=0.0.0.0
```

## 🎯 Core Features Deep Dive

### AI-Powered Recipe Recommendations

The app features a sophisticated AI recommendation system that:

1. **Filters Recipes**: Analyzes user's available ingredients and preferences
2. **Sends to AI**: Forwards top 10 matching recipes to the LLM microservice
3. **Generates Personalized Suggestions**: AI creates customized recommendations with explanations
4. **Provides Actionable Insights**: Suggests shopping lists, substitutions, and cooking tips

**API Endpoint**: `POST /ai-recommendations/recommendations`

### Smart Ingredient Management

- **Automatic Categorization**: Ingredients are intelligently categorized into food groups
- **Dietary Flag Detection**: Automatic tagging for vegan, vegetarian, gluten-free, and lactose-free items
- **Quantity Tracking**: Support for various units (grams, cups, pieces, etc.)
- **Expiration Monitoring**: Track freshness and get usage suggestions

### Recipe Database

- **25,000+ Recipes**: Comprehensive database with diverse cuisines and dietary options
- **Smart Filtering**: Filter by ingredients, cooking time, difficulty, dietary restrictions
- **Detailed Instructions**: Step-by-step cooking instructions with timing
- **Nutritional Information**: Calculated nutritional data based on ingredients

## 📊 Database Schema

### Core Entities
- **Users**: User profiles and preferences
- **Ingredients**: Food items with categories and dietary flags
- **Recipes**: Complete recipes with instructions and metadata
- **UserIngredients**: User's available ingredients with quantities
- **Categories**: Food categories (Grains, Dairy, Vegetables, etc.)
- **Units**: Measurement units (grams, cups, tablespoons, etc.)
- **RecipeTags**: Recipe categorization tags

### Relationships
- Users have many UserIngredients
- Recipes have many RecipeIngredients
- Ingredients belong to Categories
- RecipeIngredients have Units for measurements

## 🧪 Testing

### Backend Testing
```bash
cd server

# Run all tests
npm test

# Run specific test suites
npm test -- --testNamePattern="AI Recommendation"

# Run with coverage
npm test -- --coverage
```

### Flutter Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

## 📦 Deployment

### Backend Deployment
The backend can be deployed to various platforms:

- **Heroku**: Use provided `Procfile`
- **AWS/GCP**: Docker containerization supported
- **Traditional VPS**: PM2 process management

### Flutter Deployment
```bash
# Build for iOS
flutter build ios

# Build for Android
flutter build apk --release

# Build for Web
flutter build web
```

## 🔧 Development

### Adding New Recipes
1. Use the seeding scripts in `server/src/scripts/`
2. Format data according to the recipe schema
3. Run seeding commands to populate the database

### Extending AI Features
1. Modify prompts in `server/src/services/ai_recommendation.service.ts`
2. Add new endpoints in the Python microservice
3. Update Flutter providers to consume new AI features

### Database Migrations
```bash
cd server
npm run migrate
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:
- Check the [documentation](docs/)
- Review [API documentation](server/docs/)
- Open an issue for bugs or feature requests

## 🙏 Acknowledgments

- OpenAI for AI capabilities
- Firebase for authentication services
- Flutter team for the excellent framework
- TypeORM for database management
- All open-source contributors

---

**Built with ❤️ using Flutter, Node.js, Python, and AI**
