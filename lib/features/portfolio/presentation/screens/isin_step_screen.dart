import 'package:flutter/material.dart';
import '../../domain/portfolio_form_data.dart';
import 'registered_name_step_screen.dart';

class IsinStepScreen extends StatefulWidget {
  final IsinFormData formData;

  const IsinStepScreen({super.key, required this.formData});

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RegisteredNameStepScreen(formData: widget.formData),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
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
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
    return false; // Let the popUntil handle it
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add ISIN - Step 1'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              // If we are at step 1 and pressing back, ask to cancel
              await _onWillPop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                await _onWillPop();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
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
                ElevatedButton(
                  onPressed: _onContinue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
