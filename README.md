# jdart

A fast command-line tool that converts JSON into type-safe Dart class definitions.

## Demo

![Demo](demo-jdart.gif)

## Features

- Automatically generates Dart classes from JSON
- Smart type inference (String, int, double, bool, nested objects, lists)
- Handles nested objects and arrays
- Auto-extracts class names from JSON structure
- Converts snake_case and kebab-case to camelCase
- Performance optimized with memoization caching
- Supports both command-line arguments and piped input

## Installation

Requirements: Dart SDK 3.10.3 or higher

```bash
# Clone the repository
git clone https://github.com/rizukirr/jdart.git
cd jdart

# Install dependencies
dart pub get

# Build the executable
./build.sh          # On Linux/macOS
build.bat           # On Windows

# Install globally (Linux/macOS)
sudo cp build/release/jdart /usr/local/bin/

# Or add to PATH
export PATH="$PATH:$(pwd)/build/release"

# Or Quick install globally (Linux/macOS)
# ./install.sh
```

### Optional : Run with Dart SDK

```bash
dart pub global activate --source path .
```

## Usage

### Command-line Arguments

```bash
# Auto-generate class name from JSON structure
jdart '{"user": {"name": "John", "age": 30}}'

# Provide explicit class name
jdart Person '{"name": "John", "age": 30}'

# Array
jdart '[{"id": 1, "name": "Item 1"}, {"id": 2, "name": "Item 2"}]'
```

### Piped Input

```bash
# From file with auto class name
cat data.json | jdart

# From file with explicit class name
cat data.json | jdart Person

# From curl/API response
curl https://api.example.com/user | jdart User
```

## Options

By default, jdart generates three methods for each class: `fromJson`, `toJson`, and `parseList`. You can disable any of these using command-line flags:

```bash
# Disable fromJson factory constructor
jdart --disable-fromJson '{"name": "John", "age": 30}'

# Disable toJson method
jdart --disable-toJson Person '{"name": "John"}'

# Disable parseList static method
jdart --disable-parseList '{"id": 1, "name": "Item"}'

# Combine multiple flags
jdart --disable-fromJson --disable-toJson User '{"name": "John"}'

# Works with piped input too
cat data.json | jdart --disable-parseList Person
```

Available flags:
- `--disable-fromJson`: Disables generation of the `fromJson` factory constructor
- `--disable-toJson`: Disables generation of the `toJson` method
- `--disable-parseList`: Disables generation of the static `parseList` method
- `--help`, `-h`: Displays usage information

## How It Works

1. **Auto Class Name Extraction**: If no class name is provided and JSON has a single root key, that key becomes the class name
2. **Smart Type Inference**: Analyzes JSON values to determine appropriate Dart types
3. **Nested Object Detection**: Recursively processes nested objects and creates separate classes
4. **Name Sanitization**: Converts various naming conventions to Dart-idiomatic camelCase/PascalCase
5. **Performance Optimized**: Uses memoization caching for repeated name conversions

## Development

```bash
# Run tests
dart test

# Run specific test
dart test test/parser_test.dart

# Lint code
dart analyze

# Format code
dart format .
```

## License

See [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
