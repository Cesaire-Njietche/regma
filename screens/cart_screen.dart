import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/colors.dart';
import '../providers/cart_provider.dart' show CartProvider;
import '../widgets/cart_item.dart';
import '../widgets/center_no_history.dart';

class CartScreen extends StatelessWidget {
  static String routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: myOrange,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Your Cart'),
      ),
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent.withOpacity(0.06),
                Colors.transparent.withOpacity(0.1),
                Colors.transparent.withOpacity(0.04)
              ],
            ),
          ),
        ),
        Column(
          children: [
            Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Total : '),
                    Spacer(),
                    Chip(
                      label: Text(
                        '€${cart.total.toStringAsFixed(2)}',
                        style: GoogleFonts.quicksand(
                            fontSize: 15, color: Colors.black54),
                      ),
                      backgroundColor: Theme.of(context).accentColor,
                    ),
                    //OrderButton(cart),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: cart.items.values.length == 0
                  ? CenterNoHistory('Empty Cart!')
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, ind) {
                        var cartItem = cart.items.values.toList()[ind];
                        return CartItem(
                            id: cartItem.id,
                            productId: cartItem.productId,
                            title: cartItem.productName,
                            image: cartItem.productImage,
                            price: cartItem.price);
                      },
                      itemCount: cart.items.values.length,
                    ),
            )
          ],
        ),
      ]),
    );
  }
}

class OrderButton extends StatefulWidget {
  final CartProvider cart;
  OrderButton(this.cart);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  void orderNow() {
    //async function that will trigger the payment module. Once the payment is done, we store the order information to FirebaseFirestore
    // Upon failure, the user is notified about the reasons
    setState(() {
      _isLoading = true;
    });
    // Provider.of<PaidMediaProvider>(context, listen: false)
    //     .addPaidMedia(widget.cart.items.values.toList(), widget.cart.total);
    // widget.cart.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.total == 0.0 || _isLoading) ? null : orderNow,
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
