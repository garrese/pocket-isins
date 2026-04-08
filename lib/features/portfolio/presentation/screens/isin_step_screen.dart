import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/portfolio_form_data.dart';
import '../../data/portfolio_provider.dart';
import 'package:pocket_isins/core/utils/toast_utils.dart';
import 'registered_name_step_screen.dart';
import 'wizard_bottom_actions.dart';
import '../../../../core/widgets/constrained_width.dart';

class IsinStepScreen extends ConsumerStatefulWidget {
  final IsinFormData formData;
  final bool isEditing;
  final bool isEntryPoint;

  const IsinStepScreen({
    super.key,
    required this.formData,
    this.isEditing = false,
    this.isEntryPoint = true,
  });

  @override
  ConsumerState<IsinStepScreen> createState() => _IsinStepScreenState();
}

class _IsinStepScreenState extends ConsumerState<IsinStepScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _isinController;
  late TextEditingController _altNameController;

  late IsinFormData _originalFormData;

  @override
  void initState() {
    super.initState();
    _originalFormData = widget.formData.clone();
    _isinController = TextEditingController(text: widget.formData.isinCode);
    _altNameController = TextEditingController(text: widget.formData.altName);
  }

  @override
  void dispose() {
    _isinController.dispose();
    _altNameController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (_formKey.currentState!.validate()) {
      final newIsinCode = _isinController.text.trim();

      // Check if ISIN code already exists (only if we're not editing or if we changed the code)
      if (newIsinCode.isNotEmpty &&
          (!widget.isEditing || newIsinCode != _originalFormData.isinCode)) {

        try {
          final existingIsins = await ref.read(portfolioProvider.future);
          final isinExists = existingIsins.any((isin) => isin.isinCode == newIsinCode);

          if (isinExists) {
            if (mounted) {
              ToastUtils.show(context, 'An ISIN with code $newIsinCode already exists.');
            }
            return;
          }
        } catch (e) {
          // If we fail to load portfolio, ignore validation and let it be handled later.
        }
      }

      widget.formData.isinCode = newIsinCode;
      widget.formData.altName = _altNameController.text.trim();

      final route = MaterialPageRoute(
        builder: (context) => RegisteredNameStepScreen(
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

  Future<void> _handleBackNavigation(bool didPop) async {
    if (didPop) return;
    await _cancelWizard();
  }

  bool _hasChanges() {
    final currentFormData = widget.formData.clone();
    currentFormData.isinCode = _isinController.text.trim();
    currentFormData.altName = _altNameController.text.trim();
    return currentFormData != _originalFormData;
  }

  Future<void> _cancelWizard() async {
    if (!_hasChanges()) {
      _performCancel();
      return;
    }

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
      _performCancel();
    }
  }

  void _performCancel() {
    if (context.mounted) {
      if (widget.isEditing) {
        Navigator.of(context).pop('CANCEL');
      } else {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  Widget _buildGuideCard() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How it works',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildStep(
                  icon: Icons.search,
                  title: 'Search',
                  description: 'Enter the asset ISIN and/or Name.',
                  isLast: false,
                ),
                _buildStep(
                  icon: Icons.checklist,
                  title: 'Filter',
                  description: 'Select the valid Registered Names.',
                  isLast: false,
                ),
                _buildStep(
                  icon: Icons.show_chart,
                  title: 'Save',
                  description: 'Choose the definitive Market Tickers.',
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required String description,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0, top: 6.0),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: '$title: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: description),
                  ],
                ),
              ),
            ),
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
        appBar: AppBar(title: const Text('Add ISIN / Name')),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: ConstrainedWidth.narrow(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Enter ISIN and/or Name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _isinController,
                          decoration: const InputDecoration(
                            labelText: 'ISIN Code',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if ((value == null || value.trim().isEmpty) &&
                                _altNameController.text.trim().isEmpty) {
                              return 'Please enter either an ISIN or a Name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _altNameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if ((value == null || value.trim().isEmpty) &&
                                _isinController.text.trim().isEmpty) {
                              return 'Please enter either an ISIN or a Name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildGuideCard(),
                      ],
                    ),
                  ),
                ),
              ),
              WizardBottomActions(
                isFirstStep: true,
                onCancel: _cancelWizard,
                onContinue: _onContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
