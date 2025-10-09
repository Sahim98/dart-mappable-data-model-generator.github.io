# 🚀 Quick Parse

[![Flutter](https://img.shields.io/badge/Flutter-3.24.0-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8.1-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![GitHub Pages](https://img.shields.io/badge/demo-live-success)](https://sahim98.github.io/quick_parse/)

A powerful Flutter-based code generator that converts JSON to Dart Mappable models and transforms Mappable models into clean Entity/Model patterns following best practices.

## ✨ Features

### 📋 JSON to Model Conversion
- **Automatic Type Detection**: Intelligently infers Dart types from JSON values
- **Nested Object Support**: Handles complex nested structures with ease
- **List & Array Handling**: Properly detects and types array elements
- **Null-Safe**: Generates null-safe Dart code with proper nullable annotations
- **Dynamic Types**: Uses `dynamic` type for null values in JSON
- **Customizable Annotations**: Configure `@MappableClass` options:
  - Ignore null values
  - Custom case styles (camelCase, snake_case, etc.)
  - Generate helper methods

### 🏗️ Model to Entity Pattern
- **Clean Architecture**: Separates concerns by creating Entity base classes
- **Smart Field Distribution**:
  - **Entity**: Contains ALL fields (primary and non-primary types)
  - **Model**: Only declares non-primary type fields
- **Primary Type Detection**: Automatically identifies `String`, `int`, `double`, `num`, and `bool`
- **Super Parameters**: Uses `super.fieldName` for primary types (cleaner syntax)
- **Preserves Mixins**: Maintains `dart_mappable` mixin in generated models
- **Production-Ready**: Generates formatted, linter-compliant code

### 🎨 User Interface
- **Split View**: Side-by-side input and output panels
- **Live Preview**: Real-time code generation as you type
- **Syntax Highlighting**: Beautiful code display with proper Dart syntax highlighting
- **Mode Toggle**: Easy switching between conversion modes
- **Responsive**: Works on desktop, tablet, and mobile

## 🌐 Live Demo

Try it now: **[https://sahim98.github.io/quick_parse/](https://sahim98.github.io/quick_parse/)**

## 📸 Screenshots

### JSON to Model
Convert any JSON into type-safe Dart Mappable classes:

**Input:**
```json
{
  "name": "John Doe",
  "age": 30,
  "email": "john@example.com",
  "message": null
}
```

**Output:**
```dart
@MappableClass()
class User with UserMappable {
  final String name;
  final int age;
  final String email;
  final dynamic message;

  const User({
    required this.name,
    required this.age,
    required this.email,
    this.message,
  });
}
```

### Model to Entity Pattern
Transform your models into clean entity/model architecture:

**Input:**
```dart
@MappableClass()
class Data with DataMappable {
  final String name;
  final int age;
  final List<String> items;

  const Data({
    required this.name,
    required this.age,
    required this.items,
  });
}
```

**Output:**
```dart
// ENTITY
class DataEntity {
  final String name;
  final int age;
  final List<String> items;

  const DataEntity({
    required this.name,
    required this.age,
    required this.items,
  });
}

// MODEL
@MappableClass()
class Data extends DataEntity with DataMappable {
  final List<String> items;

  const Data({
    super.name,      // Primary types use super
    super.age,       // No 'required' needed
    required this.items,  // Non-primary types use this
  });
}
```

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev) - Google's UI toolkit for building beautiful, natively compiled applications
- **State Management**: [Riverpod](https://riverpod.dev) - A reactive caching and data-binding framework
- **Code Formatting**: [dart_style](https://pub.dev/packages/dart_style) - Formats generated code to follow Dart style guidelines
- **Syntax Highlighting**: [flutter_highlight](https://pub.dev/packages/flutter_highlight) - Beautiful code display
- **String Utilities**: [recase](https://pub.dev/packages/recase) - For case conversion (camelCase, PascalCase, etc.)

## 🚀 Getting Started

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) 3.24.0 or higher
- [Dart](https://dart.dev/get-dart) 3.8.1 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Sahim98/dart-mappable-data-model-generator.git
   cd quick_parse
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # Web
   flutter run -d chrome
   
   # Desktop (macOS)
   flutter run -d macos
   
   # Desktop (Windows)
   flutter run -d windows
   
   # Desktop (Linux)
   flutter run -d linux
   ```

### Build for Production

```bash
# Web
flutter build web --release

# Desktop
flutter build macos --release  # macOS
flutter build windows --release  # Windows
flutter build linux --release  # Linux
```

## 📖 Usage Guide

### Mode 1: JSON to Model

1. Select **"JSON to Model"** mode from the top panel
2. Paste your JSON in the left panel
3. (Optional) Configure Mappable options:
   - Toggle "Ignore Null"
   - Select case style
   - Choose generate methods
4. The generated Dart model appears in the right panel
5. Copy and use in your project!

### Mode 2: Model to Entity

1. Select **"Model to Entity"** mode from the top panel
2. Paste your `@MappableClass` annotated model in the left panel
3. View the generated Entity and Model classes side-by-side
4. Entity contains all fields
5. Model extends Entity with smart super parameters

## 🎯 Key Concepts

### Primary vs Non-Primary Types

**Primary Types** (use `super.` parameter):
- `String`
- `int`
- `double`
- `num`
- `bool`

**Non-Primary Types** (use `this.` parameter):
- `List<T>`
- `Map<K, V>`
- Custom classes
- Complex types

### Why Entity/Model Pattern?

This pattern provides:
- **Separation of Concerns**: Business logic separate from data serialization
- **Reduced Boilerplate**: Primary types inherited from entity
- **Better Testing**: Test entities without serialization concerns
- **Clean Architecture**: Follows domain-driven design principles

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Sahim98**
- GitHub: [@Sahim98](https://github.com/Sahim98)
- Repository: [dart-mappable-data-model-generator](https://github.com/Sahim98/dart-mappable-data-model-generator)

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev)
- Inspired by the need for cleaner code generation
- Thanks to the [dart_mappable](https://pub.dev/packages/dart_mappable) package

## 📚 Related Resources

- [dart_mappable Documentation](https://pub.dev/packages/dart_mappable)
- [Flutter Documentation](https://docs.flutter.dev)
- [Riverpod Documentation](https://riverpod.dev)

---

<div align="center">

**⭐ Star this repository if you found it helpful!**

Made with ❤️ using Flutter

</div>
