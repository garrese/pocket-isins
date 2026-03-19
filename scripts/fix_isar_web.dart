import 'dart:io';

void main() {
  final dir = Directory('lib');
  if (!dir.existsSync()) {
    print('lib directory not found');
    return;
  }

  int count = 0;
  final files = dir.listSync(recursive: true);
  for (final file in files) {
    if (file is File && file.path.endsWith('.g.dart')) {
      final content = file.readAsStringSync();

      // Match `id: <large_integer>`
      final pattern = RegExp(r'id:\s*(-?\d+)');

      bool changed = false;
      final newContent = content.replaceAllMapped(pattern, (match) {
        final originalIdStr = match.group(1)!;
        final originalId = int.tryParse(originalIdStr);

        if (originalId != null) {
          // JS max safe integer
          const maxSafeInt = 9007199254740991;

          if (originalId > maxSafeInt || originalId < -maxSafeInt) {
            changed = true;
            // We use modulo to keep the ID unique and deterministic.
            final newId = originalId % maxSafeInt;
            return 'id: $newId';
          }
        }
        return match.group(0)!;
      });

      if (changed) {
        file.writeAsStringSync(newContent);
        print('Patched: ${file.path}');
        count++;
      }
    }
  }

  print('Patching complete. Modified $count files.');
}
