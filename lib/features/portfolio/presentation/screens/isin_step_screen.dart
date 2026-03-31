import 'package:flutter/material.dart';
import '../../domain/portfolio_form_data.dart';
import 'registered_name_step_screen.dart';
import 'wizard_bottom_actions.dart';

class IsinStepScreen extends StatefulWidget {
  final IsinFormData formData;
  final bool isEditing;

  const IsinStepScreen(
      {super.key, required this.formData, this.isEditing = false});

  @override
  State<IsinStepScreen> createState() => _IsinStepScreenState();
}

class _IsinStepScreenState extends State<IsinStepScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _isinController;

  @override
  void initState() {
    super.initState();
    _isinController = TextEditingController(text: widget.formData.isinCode);
  }

  @override
  void dispose() {
    _isinController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      widget.formData.isinCode = _isinController.text.trim();
      final route = MaterialPageRoute(
        builder: (context) => RegisteredNameStepScreen(
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

  Future<void> _handleBackNavigation(bool didPop) async {
    if (didPop) return;

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _handleBackNavigation(didPop),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add ISIN'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter the ISIN code',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _isinController,
                  decoration: const InputDecoration(
                    labelText: 'ISIN Code',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an ISIN code';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                WizardBottomActions(
                  isFirstStep: true,
                  onCancel: () async {
                    await _handleBackNavigation(false);
                  },
                  onContinue: _onContinue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
