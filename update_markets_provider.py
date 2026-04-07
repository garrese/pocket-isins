import re

with open('lib/features/markets/data/markets_provider.dart', 'r') as f:
    content = f.read()

# 1. Add Timer import
if "import 'dart:async';" not in content:
    content = content.replace("import 'package:flutter/foundation.dart';", "import 'package:flutter/foundation.dart';\nimport 'dart:async';")

# 2. Change ref.read to ref.watch for portfolioProvider
content = content.replace("final isins = await ref.read(portfolioProvider.future);", "final isins = await ref.watch(portfolioProvider.future);")

# 3. Add Timer logic in build
build_method_pattern = r"(Future<List<Isin>> build\(\) async \{)(.*?\n    return isins;\n  \})"

replacement = r"""\1
    // 1. Fetch initial state from DB without waiting for network updates
    final isins = await _loadFromDb();

    // 2. Setup periodic timer for checking 5-minute threshold
    final timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (state.hasValue && state.value != null) {
        _triggerBackgroundUpdates(state.value!);
      }
    });

    ref.onDispose(() {
      timer.cancel();
    });

    // 3. Trigger async refresh for outdated tickers right away
    _triggerBackgroundUpdates(isins);

    return isins;
  }"""

content = re.sub(build_method_pattern, replacement, content, flags=re.DOTALL)

with open('lib/features/markets/data/markets_provider.dart', 'w') as f:
    f.write(content)
