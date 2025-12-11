import 'dart:io';
import '../lib/parser.dart';

Future<void> main(List<String> arguments) async {
  String? className;
  String jsonString;

  // Check if input is being piped
  if (stdin.hasTerminal == false) {
    // Reading from pipe
    jsonString = await stdin.transform(systemEncoding.decoder).join();
    jsonString = jsonString.trim();

    // Optional: First argument can be the class name when piping
    if (arguments.length == 1) {
      className = arguments[0];
    } else if (arguments.isEmpty) {
      className = null;
    } else {
      print("Usage with pipe:");
      print("  cat file.json | jdart                  # Auto class name");
      print("  cat file.json | jdart <ClassName>      # Explicit class name");
      exit(1);
    }
  } else {
    // Reading from command-line arguments
    if (arguments.isEmpty || arguments.length > 2) {
      print("Usage:");
      print(
        "  jdart <json string>                    # Extract class name from JSON",
      );
      print(
        "  jdart <Class Name> <json string>       # Explicitly provide class name",
      );
      print("");
      print("Pipe usage:");
      print("  cat file.json | jdart                  # Auto class name");
      print("  cat file.json | jdart <ClassName>      # Explicit class name");
      exit(1);
    }

    if (arguments.length == 1) {
      className = null;
      jsonString = arguments[0];
      print("Mode: Command-line with auto class name");
    } else {
      className = arguments[0];
      jsonString = arguments[1];
      print("Mode: Command-line with explicit class name");
    }
  }

  print("");

  bool isValid = Parser.checkIfValidJsonString(jsonString);
  if (isValid) {
    String dclass = Parser.generateDartClass(
      jsonString,
      className,
      false,
      false,
      false,
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
