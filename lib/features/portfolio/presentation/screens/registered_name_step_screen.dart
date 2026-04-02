import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/portfolio_form_data.dart';
import '../../../../core/network/market_data_service.dart';
import '../../../../core/services/log/talker_provider.dart';
import 'isin_step_screen.dart';
import 'markets_step_screen.dart';
import 'wizard_bottom_actions.dart';

class RegisteredNameStepScreen extends ConsumerStatefulWidget {
  final IsinFormData formData;
  final bool isEditing;
  final bool isEntryPoint;

  const RegisteredNameStepScreen({
    super.key,
    required this.formData,
    this.isEditing = false,
    this.isEntryPoint = false,
  });

  @override
  ConsumerState<RegisteredNameStepScreen> createState() =>
      _RegisteredNameStepScreenState();
}

class _RegisteredNameStepScreenState
    extends ConsumerState<RegisteredNameStepScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<String> _uniqueNames = [];
  final Set<String> _selectedNames = {};

  // Custom manual entry
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _selectedNames.addAll(widget.formData.registeredNames);
    _nameController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchRegisteredNames();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleBackNavigation(bool didPop) async {
    if (didPop) return;
    await _cancelWizard();
  }

  Future<void> _cancelWizard() async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Operation?'),
        content: const Text(
          'Are you sure you want to cancel? All progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (shouldCancel == true) {
      if (context.mounted) {
        if (widget.isEditing) {
          Navigator.of(context).pop('CANCEL');
        } else {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    }
  }

  Future<void> _searchRegisteredNames() async {
    setState(() {
      _isLoading = true;
      _uniqueNames = [];
    });

    try {
      final marketService = ref.read(marketDataServiceProvider);

      List<dynamic> isinQuotes = [];
      List<dynamic> altNameQuotes = [];

      if (widget.formData.isinCode.isNotEmpty) {
        isinQuotes = await marketService.searchSymbol(widget.formData.isinCode);
      }

      if (widget.formData.altName.isNotEmpty) {
        altNameQuotes =
            await marketService.searchSymbol(widget.formData.altName);
      }

      final Set<String> foundNames = {};

      for (final q in [...isinQuotes, ...altNameQuotes]) {
        final name = q['longname'] ?? q['shortname'];
        if (name != null && name.toString().trim().isNotEmpty) {
          foundNames.add(name.toString().trim());
        }
      }

      if (mounted) {
        setState(() {
          _uniqueNames = foundNames.toList();
          // Also add previously saved names that might not be in the search results anymore
          for (final n in widget.formData.registeredNames) {
            if (!_uniqueNames.contains(n)) {
              _uniqueNames.add(n);
            }
          }
        });

        if (_uniqueNames.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No registered names found. You can enter them manually.',
              ),
            ),
          );
        }
      }
    } catch (e, stack) {
      if (mounted) {
        ref
            .read(talkerProvider)
            .handle(e, stack, 'Error searching registered names');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error searching: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onContinue() async {
    if (_formKey.currentState!.validate()) {
      widget.formData.registeredNames = _selectedNames.toList();

      final route = MaterialPageRoute(
        builder: (context) => MarketsStepScreen(
          formData: widget.formData,
          isEditing: widget.isEditing,
          isEntryPoint: false,
        ),
      );
      final result = await Navigator.push(context, route);
      if (result == 'CANCEL' || result == 'SAVED') {
        if (mounted) {
          Navigator.pop(context, result);
        }
      }
    }
  }

  void _onPrevious() {
    if (widget.isEntryPoint) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => IsinStepScreen(
            formData: widget.formData,
            isEditing: widget.isEditing,
            isEntryPoint: true,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _addManualName() async {
    _nameController.clear();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Manually'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, _nameController.text),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (result != null && result.trim().isNotEmpty) {
      final newName = result.trim();
      setState(() {
        if (!_uniqueNames.contains(newName)) {
          _uniqueNames.add(newName);
        }
        _selectedNames.add(newName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _handleBackNavigation(didPop),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Registered Names'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Select Registered Names:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: _addManualName,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Manually'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_uniqueNames.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'No results found.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _uniqueNames.length,
                    itemBuilder: (context, index) {
                      final name = _uniqueNames[index];
                      final isSelected = _selectedNames.contains(name);

                      return CheckboxListTile(
                        title: Text(name),
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedNames.add(name);
                            } else {
                              _selectedNames.remove(name);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: FormField<bool>(
                  validator: (_) {
                    if (_selectedNames.isEmpty) {
                      return 'Please select at least one registered name, or skip if you really want to.';
                    }
                    return null;
                  },
                  builder: (state) {
                    if (state.hasError) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          state.errorText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              const SizedBox(height: 24),
              WizardBottomActions(
                onCancel: _cancelWizard,
                onPrevious: _onPrevious,
                onContinue: () {
                  if (_selectedNames.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('No Names Selected'),
                        content: const Text(
                          'You have not selected any registered names. Do you want to proceed anyway?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Bypass validation
                              widget.formData.registeredNames = [];
                              final route = MaterialPageRoute(
                                builder: (context) => MarketsStepScreen(
                                  formData: widget.formData,
                                  isEditing: widget.isEditing,
                                  isEntryPoint: false,
                                ),
                              );
                              Navigator.push(context, route).then((result) {
                                if (result == 'CANCEL' || result == 'SAVED') {
                                  if (mounted) {
                                    Navigator.pop(context, result);
                                  }
                                }
                              });
                            },
                            child: const Text('Proceed'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    _onContinue();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
