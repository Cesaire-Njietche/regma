import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:regma/services/regma_services.dart';

import '../models/media.dart';
import '../models/paid_media_item.dart';
import '../services/file.dart';

class MediaProvider with ChangeNotifier {
  var _media = <Media>[];
  var purchasedMedia = <String>[];
  var paymentOptions = false;
  // bool success = false;

  var _items = <PaidMediaItem>[];
  List<PaidMediaItem> get items {
    return [..._items];
  }

  List<Media> get allMedia {
    return [..._media];
  }

  List<String> get ids {
    return _media.map((media) => media.id).toList();
  }

  List<Media> get books {
    var _books = _media.where((media) => media.type == 'Book').toList();
    return [..._books];
  }

  List<Media> get events {
    var _events = _media.where((media) => media.type == 'Event').toList();
    return [..._events];
  }

  List<Media> get musics {
    var _musics = _media.where((media) => media.type == 'Music').toList();
    return [..._musics];
  }

  List<Media> get podcasts {
    var _podcasts = _media.where((media) => media.type == 'Podcast').toList();
    return [..._podcasts];
  }

  List<Media> get videos {
    var _videos = _media.where((media) => media.type == 'Movie').toList();
    return [..._videos];
  }

  Future<void> addNewMedia(
      Media media, File thumbnail, File mediaFile, bool isAdding) async {
    if (thumbnail != null) {
      if (!isAdding) {
        //updating
        await MFile().delete(media.imageUrl);
      }
      media.imageUrl = await MFile().uploadFile(
          'media-thumbnails', path.basename(thumbnail.path), thumbnail);
    }
    if (mediaFile != null) {
      if (!isAdding) {
        //updating
        await MFile().delete(media.contentUrl);
      }
      media.contentUrl = await MFile()
          .uploadFile('media', path.basename(mediaFile.path), mediaFile);
    }

    var id = await RegmaServices().saveMedia(media.toJson());

    if (isAdding) {
      _media.add(media);
    } else {
      var ind = _media.indexWhere((media) => media.id == id);
      _media[ind] = media;
    }

    notifyListeners();
  }

  Future<void> deleteMediaById(String id) async {
    await RegmaServices().deleteEntity('media', 'id', id);
    await MFile().delete(findMediaById(id).imageUrl);
    await MFile().delete(findMediaById(id).contentUrl);

    _media.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<List<Media>> fetchAllMedia() async {
    _media = await RegmaServices().getAllMedia();
    purchasedMedia = await loadPurchasedMediasId();

    paymentOptions = await RegmaServices().getPaymentOptions();

    var ind = 0;
    if (purchasedMedia.length > 0) {
      purchasedMedia.forEach((id) {
        ind = _media.indexWhere((media) => media.id == id);
        if (ind != -1) _media[ind].isBought = true;
      });
    }
    //_media = Dummy.media;
    //notifyListeners();
    return _media;
  }

  Future<List<String>> loadPurchasedMediasId() async {
    return await RegmaServices().getAllBoughtItems('media');
  }

  Future<List<PaidMediaItem>> fetchPaidMedias() async {
    _items = await RegmaServices().getBoughtMedia();

    return _items;
  }

  Media findMediaById(String id) =>
      _media.firstWhere((media) => media.id == id);

  Future<bool> downloadMedia(String url, Function func) async {
    return await MFile().loadFileFromNetwork(url, func);
    // return file != null;
  }

  void setMediaToFreeById(String id) {
    var ind = _media.indexWhere((media) => media.id == id);
    //_media[ind].price = 0.0;
    _media[ind].isBought = true;
    notifyListeners();
  }

  Future<void> openMedia(String url) async {
    await MFile().openMedia(url);
  }

  Future<void> setBoughtMedia(
      String id, String image, String name, double price) async {
    await RegmaServices().setBoughtMedia(id, image, name, price);
    notifyListeners();
  }

  void setPaymentOptions(bool val) {
    paymentOptions = val;
    notifyListeners();
  }

  Future<Map<String, double>> getDownloadSize() async {
    var result = await RegmaServices().getDownloadSize();

    return result;
  }
}
