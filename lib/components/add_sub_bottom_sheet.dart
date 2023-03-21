import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subscript/services/subscription.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:subscript/main.dart';

import '../services/listenerEnums.dart';

class AddSubBottomSheet extends StatefulWidget {
  const AddSubBottomSheet({super.key});

  @override
  State<AddSubBottomSheet> createState() => _AddSubBottomSheetState();
}

class _AddSubBottomSheetState extends State<AddSubBottomSheet> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final moneyController = TextEditingController();
  var currencyDropdownValue = "None selected";
  var freqDropdownValue = "None selected";
  late String currency;
  DateTime? dueDate;
  var isLoading = false;

  Future<void> pickDate() async {
    final newDueDate = await DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      onChanged: (date) => date,
      onConfirm: (date) {},
    );
    if (newDueDate != null) {
      dueDate = newDueDate;
      setState(() {});
    }
  }

  void firstDropdownCallback(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        currencyDropdownValue = selectedValue;
      });
    }
  }

  void secondDropdownCallback(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        freqDropdownValue = selectedValue;
      });
    }
  }

  Future<void> addSub() async {
    if (isLoading) return;
    if (titleController.text == "") {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text("Title is required"),
            content:
                const Text("Please fill in a title to add the subscription."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text("Continue"),
              ),
            ],
          );
        },
      );
      return;
    }
    final String text = moneyController.text;
    final bool containsMultipleDots =
        text.split('').where((char) => char == '.').length > 1;
    if (moneyController.text == "") {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text("Subscription price is required"),
            content:
                const Text("Please fill in a price to add the subscription."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text("Continue"),
              ),
            ],
          );
        },
      );
      return;
    }
    bool containsText = RegExp(r'[a-zA-Z]').hasMatch(text);
    if (containsText) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text("Subscription price invalid"),
            content: const Text("Text is given in price, no integers found."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text("Continue"),
              ),
            ],
          );
        },
      );
      return;
    }
    if (containsMultipleDots) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text("Subscription price format invalid"),
            content: const Text("Price contains more than one decimal point"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text("Continue"),
              ),
            ],
          );
        },
      );
      return;
    }
    if (dueDate == null) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text("A subscription payment dateline is required"),
            content: const Text(
                "Please fill in a dateline to add the subscription."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text("Continue"),
              ),
            ],
          );
        },
      );
      return;
    }
    if (currencyDropdownValue == "None selected") {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text("Subscription payment currency empty"),
            content: const Text(
                "Please provide a payment currency to add a subscription"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text("Continue"),
              ),
            ],
          );
        },
      );
      return;
    }
    if (freqDropdownValue == "None selected") {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text("Subscription payment frequency empty"),
            content: const Text(
                "Please provide a payment freqency to add a subscription"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text("Continue"),
              ),
            ],
          );
        },
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    final navigator = Navigator.of(context);
    final newSub = Subscription(
        id: const Uuid().v4(),
        title: titleController.text,
        description: descriptionController.text == ""
            ? null
            : descriptionController.text,
        dueDate: dueDate!,
        price: double.parse(moneyController.text),
        currency: currencyDropdownValue,
        frequency: freqDropdownValue);
    Subscripts.add(newSub);
    subStreamController.add(SubscriptStream.refreshSubs);
    newSub.storeSub();
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final formattedDate =
        dueDate != null ? DateFormat("dd/MM/yyyy").format(dueDate!) : "";
    return Container(
      height: 320,
      margin: EdgeInsets.only(
          bottom: mediaQuery.viewInsets.bottom > 0
              ? mediaQuery.viewInsets.bottom
              : mediaQuery.viewPadding.bottom),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: const InputDecoration(
                hintText: "Enter title", icon: Icon(Icons.title)),
            controller: titleController,
          ),
          TextField(
              decoration: const InputDecoration(
                  hintText: "Enter description (optional)",
                  icon: Icon(Icons.feed)),
              controller: descriptionController),
          TextField(
            decoration: const InputDecoration(
                hintText: "Enter price", icon: Icon(Icons.attach_money)),
            controller: moneyController,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              dueDate == null
                  ? IconButton(
                      onPressed: pickDate,
                      iconSize: 26,
                      icon: const Icon(Icons.event_available_outlined),
                    )
                  : ActionChip(
                      label: Text(formattedDate),
                      onPressed: pickDate,
                      backgroundColor: isDark
                          ? Colors.grey[800]
                          : const Color.fromRGBO(246, 242, 249, 1),
                      elevation: 0,
                    ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 127,
                child: DropdownButton(
                  items: const [
                    DropdownMenuItem(
                        value: "None selected", child: Text("Select currency")),
                    DropdownMenuItem(value: "SGD", child: Text("SGD")),
                    DropdownMenuItem(value: "USD", child: Text("USD")),
                    DropdownMenuItem(value: "EUR", child: Text("EUR")),
                    DropdownMenuItem(value: "JPY", child: Text("JPY")),
                    DropdownMenuItem(value: "GBP", child: Text("GBP")),
                    DropdownMenuItem(value: "CAD", child: Text("CAD")),
                    DropdownMenuItem(value: "AUD", child: Text("AUD")),
                    DropdownMenuItem(value: "CHF", child: Text("CHF")),
                    DropdownMenuItem(value: "CNY", child: Text("CNY")),
                    DropdownMenuItem(value: "HKD", child: Text("HKD")),
                    DropdownMenuItem(value: "NZD", child: Text("NZD")),
                  ],
                  value: currencyDropdownValue,
                  onChanged: firstDropdownCallback,
                  isExpanded: true,
                  icon: const Icon(Icons.payments),
                  iconSize: 25,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 127,
                child: DropdownButton(
                  items: const [
                    DropdownMenuItem(
                        value: "None selected",
                        child: Text("Select frequency")),
                    DropdownMenuItem(value: "per day", child: Text("Daily")),
                    DropdownMenuItem(value: "per week", child: Text("Weekly")),
                    DropdownMenuItem(
                        value: "per month", child: Text("Monthly")),
                    DropdownMenuItem(value: "per year", child: Text("Yearly")),
                  ],
                  value: freqDropdownValue,
                  onChanged: secondDropdownCallback,
                  isExpanded: true,
                  icon: const Icon(Icons.schedule),
                  iconSize: 25,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: addSub,
                style: filledButtonStyle,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Add subscription"),
              )
            ],
          )
        ],
      ),
    );
  }
}
