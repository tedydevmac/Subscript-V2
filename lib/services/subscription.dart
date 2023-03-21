import 'dart:ffi';
import '../main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Subscription extends ChangeNotifier {
  late final String id;
  late String _title;
  late String? _desc;
  late DateTime _dueDate;
  late double _price;
  late String _currency;
  late String _freq;
  bool _isReminded = false;

  String get title => _title;
  set title(String title) {
    _title = title;
    notifyListeners();
  }

  String? get desc => _desc;
  set desc(String? desc) {
    _desc = desc;
    notifyListeners();
  }

  DateTime get dueDate => _dueDate;
  set dueDate(DateTime dueDate) {
    _dueDate = dueDate;
    notifyListeners();
  }

  double get price => _price;
  set price(double price) {
    _price = price;
    notifyListeners();
  }

  String get currency => _currency;
  set currency(String currency) {
    _currency = currency;
    notifyListeners();
  }

  String get freq => _freq;
  set freq(String freq) {
    _freq = freq;
    notifyListeners();
  }

  bool get isReminded => _isReminded;
  set isReminded(bool isReminded) {
    _isReminded = isReminded;
    notifyListeners();
  }

  DocumentReference get _firebaseDocReference => FirebaseFirestore.instance
      .collection("accounts")
      .doc(uid)
      .collection("subscriptions")
      .doc(id);
  Map<String, dynamic> get _firebaseDocMap => {
        "id": id,
        "title": _title,
        "description": _desc,
        "dueDate": dueDate.millisecondsSinceEpoch,
        "price": _price,
        "currency": _currency,
        "frequency": _freq,
        "isReminded": _isReminded
      };

  Subscription(
      {required this.id,
      required String title,
      required String? description,
      required DateTime dueDate,
      required double price,
      required String currency,
      required String frequency}) {
    _title = title;
    _desc = description;
    _dueDate = dueDate;
    _price = price;
    _currency = currency;
    _freq = frequency;
  }
  Subscription.initializeFromDocSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot["id"];
    _title = documentSnapshot["title"];
    _desc = documentSnapshot["description"];
    _dueDate = DateTime.fromMillisecondsSinceEpoch(documentSnapshot["dueDate"]);
    _price = documentSnapshot["price"];
    _currency = documentSnapshot["currency"];
    _freq = documentSnapshot["frequency"];
    _isReminded = documentSnapshot["isReminded"];
  }

  Future<void> storeSub() async {
    await _firebaseDocReference.set(_firebaseDocMap);
  }

  Future<void> updateSub() async {
    await _firebaseDocReference.update(_firebaseDocMap);
  }

  Future<void> deleteSub() async {
    await _firebaseDocReference.delete();
  }
}
