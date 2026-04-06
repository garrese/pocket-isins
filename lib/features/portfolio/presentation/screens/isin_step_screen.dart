import 'package:flutter/material.dart';
import '../../domain/portfolio_form_data.dart';
import 'registered_name_step_screen.dart';
import 'wizard_bottom_actions.dart';

class IsinStepScreen extends StatefulWidget {
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
  State<IsinStepScreen> createState() => _IsinStepScreenState();
}

class _IsinStepScreenState extends State<IsinStepScreen> {
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
      widget.formData.isinCode = _isinController.text.trim();
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _handleBackNavigation(didPop),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add ISIN / Name'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Enter ISIN and/or Name',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'At least one of them must be provided to continue.',
                        style: TextStyle(color: Colors.grey),
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
                    ],
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
