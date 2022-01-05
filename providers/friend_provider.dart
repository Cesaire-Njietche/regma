import 'package:flutter/material.dart';

import '../models/friendship.dart';
import '../services/regma_services.dart';

class FriendProvider with ChangeNotifier {
  var _friends = <Friendship>[];
  var _invitation = <Friendship>[];
  var _request = <Friendship>[];

  List<Friendship> get friends {
    return [..._friends];
  }

  List<Friendship> get invitation {
    return [..._invitation];
  }

  List<Friendship> get pendingRequest {
    return [..._request];
  }

  Future<List<Friendship>> fetchAllFriends() async {
    _friends = await RegmaServices().getAllFriends();

    return _friends;
  }

  Future<List<Friendship>> searchFriendsByName(String name) async {
    _friends = await RegmaServices().searchFriendsByName(name);

    return _friends;
  }

  Future<List<Friendship>> fetchAllRequests() async {
    _friends = await RegmaServices().getAllRequests();
    _invitation =
        _friends.where((element) => element.isInvitation == 1).toList();
    _request = _friends.where((element) => element.isInvitation == 2).toList();

    notifyListeners();
    return _friends;
  }

  Future<void> sendFriendRequest(String peerId) async {
    var friend = await RegmaServices().sendFriendRequest(peerId);

    _request.add(friend);

    notifyListeners();
  }

  Future<void> acceptFriendRequest(String requestId) async {
    await RegmaServices().acceptFriendRequest(requestId);
    _invitation.removeWhere((element) => element.id == requestId);

    notifyListeners();
  }

  Future<void> cancelFriendRequest(String requestId) async {
    await RegmaServices().cancelFriendRequest(requestId);
    _invitation.removeWhere((element) => element.id == requestId);

    notifyListeners();
  }
}
