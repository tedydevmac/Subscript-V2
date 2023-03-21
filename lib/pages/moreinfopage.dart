import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subscript/main.dart';
import 'package:subscript/services/subscription.dart';

class MoreInfo extends StatelessWidget {
  final Subscription subscribe;
  const MoreInfo(
      {super.key, required this.subscribe});

  @override
  Widget build(BuildContext context) {
    final String whyIsTheTitleLikeThis = subscribe.title;
    final navigator = Navigator.of(context);
    final List<dynamic> infoList = [
      subscribe.title,
      subscribe.desc ?? "no description given",
      subscribe.price,
      subscribe.currency,
      subscribe.isReminded,
      DateFormat("dd/MM/yyyy").format(subscribe.dueDate),
      DateFormat('yyyy-MM-dd HH:mm:ss').format(subscribe.dueDate),
      subscribe.freq,
    ];
    final List<String> infoHeader = [
      "Title",
      "Description",
      "Price",
      "Price currency",
      "Reminder added",
      "Payment date",
      "Payment date & time",
      "Payment frequency",
    ];
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              navigator.pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(whyIsTheTitleLikeThis),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text("Edit details"),
            )
          ],
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListView.separated(
                  separatorBuilder: (separatorContext, index) => const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                    height: 0,
                  ),
                  itemBuilder: (context, index) {
                    final eachInfo = infoList[index];
                    final eachHeader = infoHeader[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: "$eachHeader: ",
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: "$eachInfo",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    );
                  },
                  itemCount: infoList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
