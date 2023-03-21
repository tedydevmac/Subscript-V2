import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:subscript/pages/moreinfopage.dart';
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
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final theme = Theme.of(context);
    final formattedDate =
        DateFormat("dd/MM/yyyy").format(widget.subscribe.dueDate);
    final formattedPrice = NumberFormat.currency(symbol: '\$', decimalDigits: 2)
        .format(widget.subscribe.price);
    final isDark = theme.brightness == Brightness.dark;
    return InkWell(
      onTap: () {
        const String placeholder = "Reminder not set";
        navigator.push(
          MaterialPageRoute(
            builder: (context) => MoreInfo(
              subscribe: widget.subscribe,
            ),
          ),
        );
      },
      onLongPress: () {},
      child: ChangeNotifierProvider.value(
        value: widget.subscribe,
        child: Consumer<Subscription>(
          builder: (context, value, child) {
            return Padding(
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
                              style: filledButtonStyle,
                              child: const Text("Add reminder"),
                            ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
