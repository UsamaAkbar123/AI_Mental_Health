import 'package:flutter/material.dart';

class SetGoalsValues extends StatefulWidget {
  const SetGoalsValues({super.key});

  @override
  SetGoalsValuesState createState() => SetGoalsValuesState();
}

class SetGoalsValuesState extends State<SetGoalsValues> {
  String selectedValue = ''; /// Variable to store the selected value

  List<String> predefinedValues = ['Option 1', 'Option 2', 'Option 3'];

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          // Your icon
          // SvgPicture.asset("assets/steps/$icon", color: AppTheme.cT!.appColorLight),
          const Icon(Icons.arrow_drop_down, color: Colors.black), // Replace with your arrow icon
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedValue,
              items: [
                ...predefinedValues.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }),
                const DropdownMenuItem<String>(
                  value: 'custom',
                  child: Text('Add Custom'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedValue = value!;
                  if (value == 'custom') {
                    // Handle adding custom value
                    _showCustomInputDialog();
                  }
                });
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to show custom input dialog
  void _showCustomInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Custom Value'),
          content: TextField(
            onChanged: (value) {
              // Handle the entered custom value
              // You can save it or use it as needed
            },
            decoration: const InputDecoration(hintText: 'Enter custom value'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle saving the custom value
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
