import 'package:flutter/material.dart';
import 'package:subscript/services/listenerEnums.dart';
import 'package:subscript/services/subscription.dart';
import 'package:subscript/components/subitem.dart';
import 'package:subscript/components/add_sub_bottom_sheet.dart';
import 'package:subscript/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = true;

  @override
  void initState() {
    subStreamController.stream.listen(subStreamControllerListener);
    asyncinit();
    super.initState();
  }

  void subStreamControllerListener(SubscriptStream value) {
    switch (value) {
      case SubscriptStream.refreshSubs:
        setState(() {});
        break;
      default:
    }
  }

  Future<void> asyncinit() async {
    final subQuerySnapshot = await FirebaseFirestore.instance
        .collection("accounts")
        .doc(uid)
        .collection("subscriptions")
        .get();
    for (var i = 0; i < subQuerySnapshot.docs.length; i++) {
      final eachSubDoc = subQuerySnapshot.docs[i];
      Subscripts.add(
          Subscription.initializeFromDocSnapshot(documentSnapshot: eachSubDoc));
    }
    setState(() {
      isLoading = false;
    });
  }

  void showAddSubBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (bottomSheetContext) => const AddSubBottomSheet(),
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      home: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: showAddSubBottomSheet,
          label: const Text("Add subscription"),
          icon: const Icon(Icons.add_outlined),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 45,
                height: 45,
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(
                    profilePicURL == ""
                        ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                        : profilePicURL,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "My Subscriptions",
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
        body: SafeArea(
          top: true,
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(5, 30, 0, 0),
                  child: SizedBox(
                    height: 500,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: Subscripts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final eachSub = Subscripts[index];
                        return SubItem(subscribe: eachSub);
                      },
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
