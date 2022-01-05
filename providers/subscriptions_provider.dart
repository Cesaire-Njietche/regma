import 'package:flutter/material.dart';

import '../models/subscription.dart';
import '../services/regma_services.dart';

class SubscriptionsProvider with ChangeNotifier {
  var _items = <Subscription>[];

  List<Subscription> get subscriptions {
    return [..._items];
  }

  Future<void> addNewSubscription(String courseId, String userId,
      DateTime startDate, DateTime endDate, Plan plan) async {
    var sub = Subscription(
      id: DateTime.now().toString(),
      userId: userId,
      courseId: courseId,
      startDate: startDate,
      endDate: endDate,
      plan: plan,
    );
    //async function to add a new subscription to FirebaseFireStore. Update the _items variable and call notify listener
    await RegmaServices().saveSubscription(sub.toJson());
    _items.add(sub);
    notifyListeners();
  }

  Future<List<Subscription>> fetchSubscriptions() async {
    //async function to fetch all subscriptions of the current user. Update the _items variable and call notify listener
    _items = await RegmaServices().getSubscriptions();
    return _items;
  }

  void renewSubscription(String id) {
    //async function to renew a subscription. Prolong the expired due date
  }
}
