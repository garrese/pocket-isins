import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/portfolio_form_data.dart';
import '../../../../core/network/market_data_service.dart';
import '../../../../core/services/log/talker_provider.dart';
import 'markets_step_screen.dart';
import 'wizard_bottom_actions.dart';
import 'isin_step_screen.dart';

class RegisteredNameStepScreen extends ConsumerStatefulWidget {
  final IsinFormData formData;
  final bool isEditing;

  const RegisteredNameStepScreen(
      {super.key, required this.formData, this.isEditing = false});

  @override
  ConsumerState<RegisteredNameStepScreen> createState() =>
      _RegisteredNameStepScreenState();
}

class _RegisteredNameStepScreenState
    extends ConsumerState<RegisteredNameStepScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isLoading = false;
  bool _isManualEditEnabled = false;
  List<dynamic> _searchResults = [];
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.formData.registeredName,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchRegisteredName();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleBackNavigation(bool didPop) async {
    if (didPop) return;

    if (!widget.isEditing) {
      // In creation flow, just go back to the previous step without warning.
      Navigator.of(context).pop();
      return;
    }

    // In edit flow, going back means cancelling the edit operation.
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
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    }
  }

  Future<void> _searchRegisteredName() async {
    setState(() {
      _isLoading = true;
      _searchResults = [];
      _selectedIndex = null;
    });

    try {
      final marketService = ref.read(marketDataServiceProvider);
      final quotes = await marketService.searchSymbol(widget.formData.isinCode);
      if (mounted) {
        setState(() {
          _searchResults = quotes;
        });

        if (quotes.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No registered names found. You can enter it manually.',
              ),
            ),
          );
          _isManualEditEnabled = true;
        }
      }
    } catch (e, stack) {
      if (mounted) {
        ref
            .read(talkerProvider)
            .handle(e, stack, 'Error searching registered name');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error searching: $e')));
        setState(() {
          _isManualEditEnabled = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      widget.formData.registeredName = _nameController.text.trim();
      final route = MaterialPageRoute(
        builder: (context) => MarketsStepScreen(
          formData: widget.formData,
          isEditing: widget.isEditing,
        ),
      );
      if (widget.isEditing) {
        Navigator.pushReplacement(context, route);
      } else {
        Navigator.push(context, route);
      }
    }
  }

  void _onPrevious() {
    if (widget.isEditing) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => IsinStepScreen(
            formData: widget.formData,
            isEditing: true,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _showManualEditWarning() {
    if (_isManualEditEnabled) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manual Entry'),
        content: const Text(
          'It is recommended to use the automatic search to fill the Registered Name. Are you sure you want to enter it manually?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isManualEditEnabled = true;
              });
            },
            child: const Text('Proceed Manually'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _handleBackNavigation(didPop),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registered Name'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Select Registered Name:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_searchResults.isEmpty)
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
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final q = _searchResults[index];
                      final name = q['longname'] ?? q['shortname'] ?? 'Unknown';

                      return RadioListTile<int>(
                        title: Text(name),
                        subtitle: Text('${q['exchange']} - ${q['symbol']}'),
                        value: index,
                        groupValue: _selectedIndex,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedIndex = value;
                            _nameController.text = name;
                          });
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: GestureDetector(
                  onTap: _showManualEditWarning,
                  child: AbsorbPointer(
                    absorbing: !_isManualEditEnabled,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Registered Name',
                        border: const OutlineInputBorder(),
                        filled: !_isManualEditEnabled,
                        fillColor: !_isManualEditEnabled
                            ? Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.5)
                            : null,
                      ),
                      style: TextStyle(
                        color: !_isManualEditEnabled
                            ? Theme.of(context).disabledColor
                            : null,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please select or enter a registered name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              WizardBottomActions(
                onCancel: _cancelWizard,
                onPrevious: _onPrevious,
                onContinue: _onContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
