import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:subscript/services/listenerEnums.dart';
import 'package:subscript/services/subscription.dart';
import 'package:subscript/main.dart';
import '../services/notificationservice.dart';
/* 
things to include:
  late String _title;               #
  late DateTime _dueDate;           #
  late double _price;               #
  late final String _freq;          #
*/

class SubItem extends StatefulWidget {
  final Subscription subscribe;
  const SubItem({super.key, required this.subscribe});

  @override
  State<SubItem> createState() => _SubItemState();
}

class _SubItemState extends State<SubItem> {
  bool isEdit = false;
  var isLoading2 = false;
  var isLoading = false;
  String? currencyValue = "None selected";
  String? freqValue = "None selected";
  Future<void> pickDate() async {
    final newDueDate = await DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      onChanged: (date) => date,
      onConfirm: (date) {},
    );
    if (newDueDate != null) {
      widget.subscribe.dueDate = newDueDate;
      widget.subscribe.isReminded = false;
    }
  }

  void cDropdownCallback(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        currencyValue = selectedValue;
      });
    }
  }

  void fDropdownCallback(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        freqValue = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleController = TextEditingController(text: widget.subscribe.title);
    final descController = TextEditingController(
        text: widget.subscribe.desc == "" ? "" : widget.subscribe.desc);
    final moneyController = TextEditingController(
      text: widget.subscribe.price.toString(),
    );
    return ChangeNotifierProvider.value(
      value: widget.subscribe,
      child: Consumer<Subscription>(
        builder: (context, value, child) {
          return Container(
            height: 400,
            width: 400,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            child: Card(
              elevation: 6.3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: SizedBox(
                width: 400.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isEdit == true
                          ? TextField(
                              controller: titleController,
                              decoration:
                                  const InputDecoration(labelText: "Title"),
                            )
                          : Text(
                              widget.subscribe.title,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                      const SizedBox(height: 8.0),
                      isEdit == true
                          ? TextField(
                              controller: descController,
                              decoration: const InputDecoration(
                                labelText: "Description",
                              ),
                            )
                          : Text(
                              widget.subscribe.desc ?? "No description given",
                              style: const TextStyle(
                                fontSize: 16.5,
                                color: Colors.black,
                              ),
                            ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.payment),
                            iconSize: 25,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: isEdit == true
                                ? TextField(
                                    controller: moneyController,
                                    decoration: const InputDecoration(
                                      labelText: "Price",
                                    ),
                                  )
                                : Text(
                                    NumberFormat.currency(
                                            symbol: '\$', decimalDigits: 2)
                                        .format(widget.subscribe.price),
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.calendar_month),
                            iconSize: 25,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 12.0),
                          isEdit == true
                              ? ActionChip(
                                  label: Text(
                                    DateFormat("dd/MM/yyyy")
                                        .format(widget.subscribe.dueDate),
                                  ),
                                  onPressed: pickDate,
                                )
                              : Chip(
                                  label: Text(
                                    DateFormat("dd/MM/yyyy")
                                        .format(widget.subscribe.dueDate),
                                  ),
                                  backgroundColor: isDark
                                      ? Colors.grey[800]
                                      : const Color.fromRGBO(254, 251, 254, 1),
                                ),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.currency_exchange),
                            iconSize: 25,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 12.0),
                          isEdit == true
                              ? DropdownButton(
                                  items: const [
                                    DropdownMenuItem(
                                        value: "None selected",
                                        child: Text("Select currency")),
                                    DropdownMenuItem(
                                        value: "SGD", child: Text("SGD")),
                                    DropdownMenuItem(
                                        value: "USD", child: Text("USD")),
                                    DropdownMenuItem(
                                        value: "EUR", child: Text("EUR")),
                                    DropdownMenuItem(
                                        value: "JPY", child: Text("JPY")),
                                    DropdownMenuItem(
                                        value: "GBP", child: Text("GBP")),
                                    DropdownMenuItem(
                                        value: "CAD", child: Text("CAD")),
                                    DropdownMenuItem(
                                        value: "AUD", child: Text("AUD")),
                                    DropdownMenuItem(
                                        value: "CHF", child: Text("CHF")),
                                    DropdownMenuItem(
                                        value: "CNY", child: Text("CNY")),
                                    DropdownMenuItem(
                                        value: "HKD", child: Text("HKD")),
                                    DropdownMenuItem(
                                        value: "NZD", child: Text("NZD")),
                                  ],
                                  value: currencyValue,
                                  onChanged: cDropdownCallback,
                                )
                              : Text(
                                  widget.subscribe.currency,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.schedule),
                            iconSize: 25,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 12.0),
                          isEdit == true
                              ? DropdownButton(
                                  items: const [
                                    DropdownMenuItem(
                                        value: "None selected",
                                        child: Text("Select frequency")),
                                    DropdownMenuItem(
                                        value: "per day", child: Text("Daily")),
                                    DropdownMenuItem(
                                        value: "per week",
                                        child: Text("Weekly")),
                                    DropdownMenuItem(
                                        value: "per month",
                                        child: Text("Monthly")),
                                    DropdownMenuItem(
                                        value: "per year",
                                        child: Text("Yearly")),
                                  ],
                                  value: freqValue,
                                  onChanged: fDropdownCallback,
                                )
                              : Text(
                                  widget.subscribe.freq,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isEdit == false)
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 2.5,
                                disabledBackgroundColor:
                                    const Color(0xFFFFFFFF),
                                backgroundColor: const Color(0xFFFFFFFF),
                                minimumSize: const Size(0, 58.5),
                              ),
                              onPressed: () async {
                                if (widget.subscribe.isReminded == true) return;
                                NotificationService().scheduleNotification(
                                    title: widget.subscribe.title,
                                    body: widget.subscribe.desc ??
                                        "${widget.subscribe.price}",
                                    scheduledNotificationDateTime:
                                        widget.subscribe.dueDate);
                                widget.subscribe.isReminded =
                                    !widget.subscribe.isReminded;
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return AlertDialog(
                                      title: const Text(
                                          "Subscription reminder notification set."),
                                      content: Text(
                                          "You will be sent a notification about the subscription at ${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.subscribe.dueDate)}"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(dialogContext);
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                int index =
                                    Subscripts.indexOf(widget.subscribe);
                                if (index != -1) {
                                  Subscripts.removeAt(index);
                                  Subscripts.add(widget.subscribe);
                                }
                                subStreamController
                                    .add(SubscriptStream.refreshSubs);
                                await widget.subscribe.updateSub();
                              },
                              icon: widget.subscribe.isReminded
                                  ? const Icon(Icons.done)
                                  : const Icon(Icons.add),
                              label: widget.subscribe.isReminded
                                  ? const Text("Added")
                                  : const Text("Set reminder"),
                            ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (isEdit == false)
                            FloatingActionButton(
                              onPressed: () async {
                                late bool confirmCheck;
                                await showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return AlertDialog(
                                      title: const Text(
                                          "Are you sure you want to delete this subcription?"),
                                      content: const Text(
                                          "Please confirm deletion."),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            confirmCheck = true;
                                            Navigator.pop(dialogContext);
                                          },
                                          child: const Text("Confirm"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            confirmCheck = false;
                                            Navigator.pop(dialogContext);
                                          },
                                          child: const Text("Cancel"),
                                        )
                                      ],
                                    );
                                  },
                                );
                                if (confirmCheck == false) return;
                                setState(() {
                                  isLoading2 = true;
                                });
                                await widget.subscribe.deleteSub();
                                Subscripts.remove(widget.subscribe);
                                subStreamController
                                    .add(SubscriptStream.refreshSubs);
                                setState(() {
                                  isLoading2 = false;
                                });
                              },
                              backgroundColor: const Color(0xFFFFFFFF),
                              child: isLoading2
                                  ? const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    )
                                  : const Icon(
                                      Icons.delete,
                                    ),
                            ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (isLoading)
                            const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.8,
                              ),
                            ),
                          isEdit == true
                              ? TextButton(
                                  onPressed: () async {
                                    if (isLoading) return;
                                    setState(() {
                                      isLoading = !isLoading;
                                    });
                                    final updateFirestoreMap = {
                                      "title": titleController.text,
                                      "description": descController.text,
                                      "price": moneyController.text,
                                      "currency": currencyValue,
                                      "frequency": freqValue
                                    };
                                    if (updateFirestoreMap["title"] != "") {
                                      widget.subscribe.title =
                                          updateFirestoreMap["title"]!;
                                    }
                                    widget.subscribe.desc =
                                        updateFirestoreMap["description"] == ""
                                            ? null
                                            : updateFirestoreMap["description"];
                                    if (updateFirestoreMap["price"] != "") {
                                      widget.subscribe.price =
                                          double.parse(moneyController.text);
                                    }
                                    if (updateFirestoreMap["currency"] != "") {
                                      widget.subscribe.currency =
                                          currencyValue!;
                                    }
                                    if (updateFirestoreMap["frequency"] != "") {
                                      widget.subscribe.freq = freqValue!;
                                    }
                                    await widget.subscribe.updateSub();
                                    setState(() {
                                      isLoading = !isLoading;
                                      isEdit = false;
                                    });
                                  },
                                  child: const Text("Done"),
                                )
                              : FloatingActionButton(
                                  onPressed: () {
                                    setState(() {
                                      isEdit = true;
                                    });
                                  },
                                  backgroundColor: const Color(0xFFFFFFFF),
                                  child: const Icon(Icons.edit),
                                )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}




/*
prev widget
Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(widget.subscribe.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("$formattedPrice "),
                            Text(widget.subscribe.freq),
                          ],
                        ),
                        Chip(
                          label: Text(formattedDate),
                          backgroundColor: isDark
                              ? Colors.grey[800]
                              : const Color.fromRGBO(254, 251, 254, 1),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.subscribe.isReminded
                        ? const Icon(
                            Icons.done,
                            color: Colors.green,
                            size: 30,
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              NotificationService().scheduleNotification(
                                  title: widget.subscribe.title,
                                  body: widget.subscribe.desc ??
                                      "${widget.subscribe.price}",
                                  scheduledNotificationDateTime:
                                      widget.subscribe.dueDate);
                              widget.subscribe.isReminded =
                                  !widget.subscribe.isReminded;
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertDialog(
                                    title: const Text(
                                        "Subscription reminder notification set."),
                                    content: Text(
                                        "You will be sent a notification about the subscription at ${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.subscribe.dueDate)}"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                        },
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );
                              int index = Subscripts.indexOf(widget.subscribe);
                              if (index != -1) {
                                Subscripts.removeAt(index);
                                Subscripts.add(widget.subscribe);
                              }
                              subStreamController
                                  .add(SubscriptStream.refreshSubs);
                              await widget.subscribe.updateSub();
                            },
                            style: filledButtonStyle,
                            child: const Text("Add reminder"),
                          ),
                  ],
                )
              ],
            ),
          )
*/