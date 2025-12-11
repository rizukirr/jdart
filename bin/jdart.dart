import 'dart:io';
import '../lib/parser.dart';

Future<void> main(List<String> arguments) async {
  String? className;
  String jsonString;

  // Parse flags
  bool enableFromJson = true;
  bool enableToJson = true;
  bool enableParseList = true;

  // Separate flags from positional arguments
  final List<String> positionalArgs = [];
  for (final arg in arguments) {
    if (arg == '--disable-fromJson') {
      enableFromJson = false;
    } else if (arg == '--disable-toJson') {
      enableToJson = false;
    } else if (arg == '--disable-parseList') {
      enableParseList = false;
    } else if (arg == '--help' || arg == '-h') {
      _printUsage();
      exit(0);
    } else if (arg.startsWith('--')) {
      print("Unknown flag: $arg");
      print("");
      _printUsage();
      exit(1);
    } else {
      positionalArgs.add(arg);
    }
  }

  // Check if input is being piped
  if (stdin.hasTerminal == false) {
    // Reading from pipe
    jsonString = await stdin.transform(systemEncoding.decoder).join();
    jsonString = jsonString.trim();

    // Optional: First argument can be the class name when piping
    if (positionalArgs.length == 1) {
      className = positionalArgs[0];
    } else if (positionalArgs.isEmpty) {
      className = null;
    } else {
      print("Usage with pipe:");
      print("  cat file.json | jdart [options]                    # Auto class name");
      print("  cat file.json | jdart [options] <ClassName>        # Explicit class name");
      print("");
      print("Run 'jdart --help' for more information");
      exit(1);
    }
  } else {
    // Reading from command-line arguments
    if (positionalArgs.isEmpty || positionalArgs.length > 2) {
      _printUsage();
      exit(1);
    }

    if (positionalArgs.length == 1) {
      className = null;
      jsonString = positionalArgs[0];
      print("Mode: Command-line with auto class name");
    } else {
      className = positionalArgs[0];
      jsonString = positionalArgs[1];
      print("Mode: Command-line with explicit class name");
    }
  }

  print("");

  bool isValid = Parser.checkIfValidJsonString(jsonString);
  if (isValid) {
    String dclass = Parser.generateDartClass(
      jsonString,
      className,
      enableFromJson,
      enableToJson,
      enableParseList,
    );

    if (dclass.isEmpty) {
      print(
        "Error: Could not generate class. Ensure JSON is properly formatted.",
      );
    } else {
      print(dclass);
    }
  } else {
    print("Invalid Json");
  }
}

void _printUsage() {
  print("Usage:");
  print("  jdart [options] <json string>");
  print("  jdart [options] <ClassName> <json string>");
  print("");
  print("Options:");
  print("  --disable-fromJson     Disable fromJson factory constructor generation");
  print("  --disable-toJson       Disable toJson method generation");
  print("  --disable-parseList    Disable parseList static method generation");
  print("  --help, -h             Show this help message");
  print("");
  print("Pipe usage:");
  print("  cat file.json | jdart [options]                    # Auto class name");
  print("  cat file.json | jdart [options] <ClassName>        # Explicit class name");
  print("");
  print("Examples:");
  print("  jdart '{\"name\": \"John\", \"age\": 30}'");
  print("  jdart Person '{\"name\": \"John\", \"age\": 30}'");
  print("  jdart --disable-toJson '{\"name\": \"John\"}'");
  print("  cat data.json | jdart --disable-fromJson --disable-parseList User");
}
