import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../providers/cart_provider.dart';
import '../providers/purchase_provider.dart';

class CartItem extends StatefulWidget {
  final String id;
  final String productId;
  final String image;
  final String title;
  final double price;
  CartItem(
      {@required this.id,
      @required this.productId,
      @required this.title,
      @required this.image,
      @required this.price});

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int quantity = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var fontSizeRegma = w >= 410 ? 15.0 : 13.0;
    var purchase = Provider.of<PurchaseProvider>(context, listen: false);
    var purchased = purchase.success;

    return Dismissible(
      key: ValueKey(widget.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false)
            .removeItem(widget.productId);
      },
      confirmDismiss: (direction) {
        return showCupertinoDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                  'Remove item from the cart',
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'Do you want to remove this item from the cart?',
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w400),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      'No',
                      textAlign: TextAlign.end,
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      'Yes',
                      textAlign: TextAlign.end,
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              );
            });

        //   showDialog(
        //   context: context,
        //   builder: (ctx) => AlertDialog(
        //     title: Text(
        //       'Remove item from the cart',
        //       style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        //     ),
        //     content: Text(
        //       'Do you want to remove this item from the cart?',
        //       style: GoogleFonts.quicksand(fontWeight: FontWeight.w400),
        //     ),
        //     actions: [
        //       TextButton(
        //         onPressed: () {
        //           Navigator.of(context).pop(false);
        //         },
        //         child: Text(
        //           'No',
        //           textAlign: TextAlign.end,
        //         ),
        //       ),
        //       TextButton(
        //         onPressed: () {
        //           Navigator.of(context).pop(true);
        //         },
        //         child: Text(
        //           'YES',
        //           textAlign: TextAlign.end,
        //         ),
        //       )
        //     ],
        //   ),
        // );
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: myOrange.withOpacity(.3),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Image.network(widget.image),
            ),
          ),
          title: Text(
            widget.title,
            style: GoogleFonts.quicksand(
                fontSize: fontSizeRegma,
                color: Colors.black54,
                fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '€${(quantity * widget.price).toStringAsFixed(2)}',
            style: GoogleFonts.quicksand(color: myOrange, fontSize: 14),
          ),
          trailing: TextButton(
            child: Text(
              'Buy',
              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              try {
                await Provider.of<PurchaseProvider>(context, listen: false)
                    .loadPurchases(widget.productId, ProductType.media);
                await Provider.of<PurchaseProvider>(context, listen: false)
                    .buy(widget.productId, ProductType.media);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Error while buying ${widget.title}',
                    style: GoogleFonts.quicksand(color: Colors.white),
                  ),
                  duration: Duration(seconds: 3),
                ));
              }

              // Provider.of<PaidMediaProvider>(context, listen: false)
              //     .addPaidMedia(widget.image, widget.title, widget.price);
            },
          ),
        ),
      ),
    );
  }
}
