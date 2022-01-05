import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../models/subscription.dart';
import 'auth_service_provider.dart';
import 'cart_provider.dart';
import 'courses_provider.dart';
import 'media_provider.dart';
import 'subscriptions_provider.dart';

enum StoreState { available, notAvailable }

enum ProductType { media, course }

class PurchaseProvider with ChangeNotifier {
  StreamSubscription<List<PurchaseDetails>> _subscription;
  StoreState storeState;
  List<ProductDetails> allProducts;
  var purchasedProducts = <String>[];
  CoursesProvider courses;
  CartProvider cart;
  MediaProvider media;
  SubscriptionsProvider subscriptions;
  AuthServiceProvider authService;
  ProductType productType;
  String currentItemID;
  Plan _plan;
  List<String> purchasedMedia; //List of bought media ids
  bool success = false;

  PurchaseProvider({
    this.courses,
    this.media,
    this.subscriptions,
    this.authService,
    this.cart,
  }) {
    final purchasedUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchasedUpdated.listen(_onPurchasedUpdated);
    //loadPurchases();
  }

  Future<void> loadPurchases(String id, ProductType type) async {
    final available = await InAppPurchase.instance.isAvailable();

    if (!available) {
      //When the user has not signed in to google play store
      storeState = StoreState.notAvailable;
      print('Yes');
      notifyListeners();
      return;
    }

    var ids = <String>{}; //get all courses and media ids
    //ids.addAll(courses.ids);
    ids.add(id);

    if (type == ProductType.course) ids.add(id + '_sub');
    // List<String> strings = [];
    // for (var s in courses.ids) {
    //   strings.add(s + '_sub');
    // }

    //ids.addAll(strings);
    print(ids);
    //ids.addAll(media.ids);
    var response = await InAppPurchase.instance.queryProductDetails(ids);
    allProducts = response.productDetails;
    storeState = StoreState.available;
    allProducts.forEach((element) {
      print(element.id);
    });

    //await InAppPurchase.instance.restorePurchases();
    print('All products ${allProducts.length}');
  }

  Future<void> buy(String id, ProductType type, [Plan plan]) async {
    // id of the media/course from firebase/underlying store
    success = false;

    if (plan != null && plan == Plan.Monthly) id = id + '_sub';
    final product = allProducts.firstWhere((product) => product.id == id);
    final purchaseParam = PurchaseParam(productDetails: product);

    await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);

    productType = type;
    currentItemID = id;
    type == ProductType.course ? _plan = plan : _plan = null;
    success = true;
  }

  void _onPurchasedUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach(_handlePurchase);
  }

  void setSuccessPurchased(bool val) {
    success = val;
    notifyListeners();
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.pendingCompletePurchase) {
      InAppPurchase.instance.completePurchase(purchaseDetails);
    }
    if (purchaseDetails.status == PurchaseStatus.purchased) {
      //Modify the current course or media status to free
      //Store subscriptions to firebase
      //Store purchased media to firebase
      //Store purchased course to firebase
      switch (productType) {
        case ProductType.course:
          currentItemID = _plan == Plan.Monthly
              ? currentItemID.substring(0, currentItemID.length - 4)
              : currentItemID;
          courses.setCourseToFreeById(currentItemID);
          // courses.setSuccessPurchased(true);
          await subscriptions.addNewSubscription(
            currentItemID,
            authService.currentUser.uid,
            DateTime.now(),
            _plan == Plan.Monthly
                ? DateTime.now().add(Duration(days: 30))
                : null,
            _plan,
          );
          await courses.setBoughtCourse(
              currentItemID, _plan == Plan.Monthly ? 'Monthly' : 'Yearly');
          break;
        case ProductType.media:
          media.setMediaToFreeById(currentItemID);
          setSuccessPurchased(true);

          var med = media.findMediaById(currentItemID);
          await media.setBoughtMedia(
              currentItemID, med.imageUrl, med.title, med.price);
          cart.removeItem(currentItemID);
      }
    }
    if (purchaseDetails.status == PurchaseStatus.restored) {
      print(purchaseDetails.productID);
    }
  }

  // Future<bool> hasPurchased(String id, ProductType type) async {
  //   switch (type) {
  //     case ProductType.media:
  //       purchasedMedia = await loadPurchasedMediaId();
  //       return purchasedMedia.any((element) => element == id);
  //     case ProductType.course:
  //       purchasedCourses = await loadPurchasedCoursesId();
  //       return purchasedCourses.any((element) => element == id);
  //     default:
  //       return false;
  //   }
  // }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
