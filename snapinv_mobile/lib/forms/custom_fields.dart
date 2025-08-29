import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

/// Custom Text Field Widget
class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final bool isLong;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hint,
    this.isLong = false,
    this.controller,
    this.onChanged,
    this.validator,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        // const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          enabled: enabled,
          maxLines: isLong ? 4 : 1,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom Number Field Widget
class CustomNumberField extends StatelessWidget {
  final String label;
  final String? hint;
  final bool isDecimal;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final double? min;
  final double? max;

  const CustomNumberField({
    Key? key,
    required this.label,
    this.hint,
    this.isDecimal = false,
    this.controller,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.min,
    this.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator ?? _defaultValidator,
          enabled: enabled,
          keyboardType: isDecimal
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
          inputFormatters: [
            if (!isDecimal) FilteringTextInputFormatter.digitsOnly,
            if (isDecimal)
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) return null;

    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (min != null && number < min!) {
      return 'Value must be at least $min';
    }

    if (max != null && number > max!) {
      return 'Value must be at most $max';
    }

    return null;
  }
}

/// Custom Dropdown Field Widget
class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final String? hint;

  const CustomDropdownField({
    Key? key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom Checkbox Field Widget
class CustomCheckboxField extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool?)? onChanged;
  final bool enabled;
  final String? subtitle;

  const CustomCheckboxField({
    Key? key,
    required this.label,
    required this.value,
    this.onChanged,
    this.enabled = true,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(label),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      onChanged: enabled ? onChanged : null,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
}

/// Custom Toggle Field Widget
class CustomToggleField extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool)? onChanged;
  final bool enabled;
  final String? subtitle;

  const CustomToggleField({
    Key? key,
    required this.label,
    required this.value,
    this.onChanged,
    this.enabled = true,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(label),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      onChanged: enabled ? onChanged : null,
      contentPadding: EdgeInsets.zero,
    );
  }
}

/// Custom Date Field Widget
class CustomDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final Function(DateTime)? onChanged;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? hint;

  const CustomDateField({
    Key? key,
    required this.label,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: enabled ? () => _selectDate(context) : null,
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: hint ?? 'Select date',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            child: Text(
              value != null
                  ? '${value!.day}/${value!.month}/${value!.year}'
                  : hint ?? 'Select date',
              style: TextStyle(
                color: value != null
                    ? Theme.of(context).textTheme.bodyLarge?.color
                    : Theme.of(context).hintColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
    );
    if (picked != null && onChanged != null) {
      onChanged!(picked);
    }
  }
}

/// Custom Time Field Widget
class CustomTimeField extends StatelessWidget {
  final String label;
  final TimeOfDay? value;
  final Function(TimeOfDay)? onChanged;
  final bool enabled;
  final String? hint;

  const CustomTimeField({
    Key? key,
    required this.label,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: enabled ? () => _selectTime(context) : null,
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: hint ?? 'Select time',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              suffixIcon: const Icon(Icons.access_time),
            ),
            child: Text(
              value != null ? value!.format(context) : hint ?? 'Select time',
              style: TextStyle(
                color: value != null
                    ? Theme.of(context).textTheme.bodyLarge?.color
                    : Theme.of(context).hintColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.now(),
    );
    if (picked != null && onChanged != null) {
      onChanged!(picked);
    }
  }
}

/// Custom File Upload Field Widget
class CustomFileUploadField extends StatelessWidget {
  final String label;
  final List<String>? allowedExtensions;
  final Function(List<PlatformFile>)? onFilesSelected;
  final bool multipleFiles;
  final bool enabled;
  final List<PlatformFile>? selectedFiles;

  const CustomFileUploadField({
    Key? key,
    required this.label,
    this.allowedExtensions,
    this.onFilesSelected,
    this.multipleFiles = false,
    this.enabled = true,
    this.selectedFiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: enabled ? _selectFiles : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Icon(Icons.cloud_upload, size: 48, color: Colors.grey),
                const SizedBox(height: 8),
                Text(
                  selectedFiles != null && selectedFiles!.isNotEmpty
                      ? '${selectedFiles!.length} file(s) selected'
                      : 'Click to select files',
                  style: const TextStyle(color: Colors.grey),
                ),
                if (selectedFiles != null && selectedFiles!.isNotEmpty)
                  ...selectedFiles!.map((file) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          file.name,
                          style: const TextStyle(fontSize: 12),
                        ),
                      )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: multipleFiles,
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && onFilesSelected != null) {
        onFilesSelected!(result.files);
      }
    } catch (e) {
      debugPrint('Error picking files: $e');
    }
  }
}

/// Custom URL/Link Field Widget
class CustomURLField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool showLaunchButton;

  const CustomURLField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.showLaunchButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator ?? _defaultValidator,
          enabled: enabled,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            hintText: hint ?? 'https://example.com',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            suffixIcon: showLaunchButton
                ? IconButton(
                    icon: const Icon(Icons.launch),
                    onPressed: _launchURL,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) return null;

    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  Future<void> _launchURL() async {
    final url = controller?.text;
    if (url != null && url.isNotEmpty) {
      final uri = Uri.tryParse(url);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }
}

// Barcode Scanner Page
class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Code'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
                return const Icon(Icons.flash_off, color: Colors.grey) ;
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                return const Icon(Icons.camera_front);
              },
            ),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (!isScanned) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final barcode = barcodes.first;
                  if (barcode.rawValue != null) {
                    setState(() => isScanned = true);
                    Navigator.pop(context, barcode.rawValue);
                  }
                }
              }
            },
          ),
          // Scanner overlay
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: Colors.green,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Position the QR code or barcode within the frame to scan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top + borderRadius)
        ..quadraticBezierTo(rect.left, rect.top, rect.left + borderRadius, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.top);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderHeightSize = height / 2;
    final cutOutWidth = cutOutSize < width ? cutOutSize : width - borderWidth;
    final cutOutHeight = cutOutSize < height ? cutOutSize : height - borderWidth;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final cutOutRect = Rect.fromLTWH(
      borderWidthSize - cutOutWidth / 2,
      borderHeightSize - cutOutHeight / 2,
      cutOutWidth,
      cutOutHeight,
    );

    canvas
      ..saveLayer(rect, backgroundPaint)
      ..drawRect(rect, backgroundPaint)
      ..drawRRect(
        RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
        boxPaint..blendMode = BlendMode.clear,
      )
      ..restore();

    // Draw corner brackets
    final bracketPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = Path();

    // Top left corner
    path.moveTo(cutOutRect.left - borderWidth / 2, cutOutRect.top + borderLength);
    path.lineTo(cutOutRect.left - borderWidth / 2, cutOutRect.top + borderRadius);
    path.quadraticBezierTo(cutOutRect.left - borderWidth / 2, cutOutRect.top - borderWidth / 2,
        cutOutRect.left + borderRadius, cutOutRect.top - borderWidth / 2);
    path.lineTo(cutOutRect.left + borderLength, cutOutRect.top - borderWidth / 2);

    // Top right corner
    path.moveTo(cutOutRect.right - borderLength, cutOutRect.top - borderWidth / 2);
    path.lineTo(cutOutRect.right - borderRadius, cutOutRect.top - borderWidth / 2);
    path.quadraticBezierTo(cutOutRect.right + borderWidth / 2, cutOutRect.top - borderWidth / 2,
        cutOutRect.right + borderWidth / 2, cutOutRect.top + borderRadius);
    path.lineTo(cutOutRect.right + borderWidth / 2, cutOutRect.top + borderLength);

    // Bottom right corner
    path.moveTo(cutOutRect.right + borderWidth / 2, cutOutRect.bottom - borderLength);
    path.lineTo(cutOutRect.right + borderWidth / 2, cutOutRect.bottom - borderRadius);
    path.quadraticBezierTo(cutOutRect.right + borderWidth / 2, cutOutRect.bottom + borderWidth / 2,
        cutOutRect.right - borderRadius, cutOutRect.bottom + borderWidth / 2);
    path.lineTo(cutOutRect.right - borderLength, cutOutRect.bottom + borderWidth / 2);

    // Bottom left corner
    path.moveTo(cutOutRect.left + borderLength, cutOutRect.bottom + borderWidth / 2);
    path.lineTo(cutOutRect.left + borderRadius, cutOutRect.bottom + borderWidth / 2);
    path.quadraticBezierTo(cutOutRect.left - borderWidth / 2, cutOutRect.bottom + borderWidth / 2,
        cutOutRect.left - borderWidth / 2, cutOutRect.bottom - borderRadius);
    path.lineTo(cutOutRect.left - borderWidth / 2, cutOutRect.bottom - borderLength);

    canvas.drawPath(path, bracketPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}


/// Example usage class
class FormFieldsExample extends StatefulWidget {
  const FormFieldsExample({Key? key}) : super(key: key);

  @override
  State<FormFieldsExample> createState() => _FormFieldsExampleState();
}

class _FormFieldsExampleState extends State<FormFieldsExample> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _textController = TextEditingController();
  final _longTextController = TextEditingController();
  final _integerController = TextEditingController();
  final _decimalController = TextEditingController();
  final _urlController = TextEditingController();

  // State variables
  String? _selectedDropdown;
  bool _checkboxValue = false;
  bool _toggleValue = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<PlatformFile>? _selectedFiles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Form Fields')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextField(
                label: 'Short Text',
                hint: 'Enter short text',
                controller: _textController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Long Text',
                hint: 'Enter long text',
                isLong: true,
                controller: _longTextController,
              ),
              const SizedBox(height: 16),
              CustomNumberField(
                label: 'Integer Number',
                hint: 'Enter integer',
                controller: _integerController,
              ),
              const SizedBox(height: 16),
              CustomNumberField(
                label: 'Decimal Number',
                hint: 'Enter decimal',
                isDecimal: true,
                controller: _decimalController,
              ),
              const SizedBox(height: 16),
              CustomDropdownField<String>(
                label: 'Dropdown Selection',
                value: _selectedDropdown,
                hint: 'Choose option',
                items: const [
                  DropdownMenuItem(value: 'option1', child: Text('Option 1')),
                  DropdownMenuItem(value: 'option2', child: Text('Option 2')),
                  DropdownMenuItem(value: 'option3', child: Text('Option 3')),
                ],
                onChanged: (value) => setState(() => _selectedDropdown = value),
              ),
              const SizedBox(height: 16),
              CustomCheckboxField(
                label: 'Checkbox Option',
                value: _checkboxValue,
                onChanged: (value) =>
                    setState(() => _checkboxValue = value ?? false),
              ),
              CustomToggleField(
                label: 'Toggle Option',
                value: _toggleValue,
                onChanged: (value) => setState(() => _toggleValue = value),
              ),
              const SizedBox(height: 16),
              CustomDateField(
                label: 'Select Date',
                value: _selectedDate,
                onChanged: (date) => setState(() => _selectedDate = date),
              ),
              const SizedBox(height: 16),
              CustomTimeField(
                label: 'Select Time',
                value: _selectedTime,
                onChanged: (time) => setState(() => _selectedTime = time),
              ),
              const SizedBox(height: 16),
              CustomFileUploadField(
                label: 'Upload Files',
                multipleFiles: true,
                selectedFiles: _selectedFiles,
                onFilesSelected: (files) =>
                    setState(() => _selectedFiles = files),
              ),
              const SizedBox(height: 16),
              CustomURLField(
                label: 'Website URL',
                hint: 'https://example.com',
                controller: _urlController,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Process form data
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form is valid!')),
                    );
                  }
                },
                child: const Text('Submit Form'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _longTextController.dispose();
    _integerController.dispose();
    _decimalController.dispose();
    _urlController.dispose();
    super.dispose();
  }
}
