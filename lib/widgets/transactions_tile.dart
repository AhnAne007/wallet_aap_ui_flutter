import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallet_app_ui/pages/transaction_page.dart';

class TransactionTileWidget extends StatefulWidget {
  final String userFromName;
  final int status;
  final String userToName;
  final String imageAssetSent;
  final String imageAssetReceived;
  final String amount;

  const TransactionTileWidget(
      {Key? key,
      required this.status,
      required this.userToName,
      required this.userFromName,
      required this.imageAssetSent,
      required this.imageAssetReceived,
      required this.amount})
      : super(key: key);

  @override
  State<TransactionTileWidget> createState() => _GroupTileState();
}

class _GroupTileState extends State<TransactionTileWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //late String name;

  Future<String> getUsername(String userId) async {
    String username = '';

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        username = (snapshot.data() as Map<String, dynamic>)['name'].toString();
      }
    } catch (e) {
      print('Error retrieving username: $e');
    }

    return username;
  }

  @override
  void initState() {
    super.initState();
    //name = getUsername(widget.userToName) as String;
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 70,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade100),
                child: widget.status == 1
                    ? Image.asset(widget.imageAssetReceived)
                    : Image.asset(widget.imageAssetSent),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userFromName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.userToName,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            widget.amount,
            style: TextStyle(
              color: widget.status == 1
                  ? Colors.green
                : Colors.redAccent,
              fontSize: 22,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
