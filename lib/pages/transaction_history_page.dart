import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallet_app_ui/resources/auth_methods.dart';
import 'package:wallet_app_ui/widgets/transactions_tile.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<TransactionHistoryPage> {
  Map<String, dynamic> transactionHistory = {};
  String authenticatedUserId = FirebaseAuth.instance.currentUser!.uid;

  void _fetchTransactions() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('TransactionHistory')
          .doc(authenticatedUserId)
          .collection("transactions")
          .get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          transactionHistory = Map.fromIterable(
            snapshot.docs,
            key: (doc) => doc.id,
            value: (doc) => doc.data(),
          );
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
//        color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.home,
                    size: 32,
                    color: Colors.deepOrange,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.grey[300],
        body: transactionHistory.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Transaction",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            " History",
                            style: TextStyle(
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                transactionListFromUser()
              ])));
  }

  transactionListFromUser() {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: transactionHistory.length,
      itemBuilder: (context, index) {
        String userId = transactionHistory.keys.elementAt(index);
        Map<String, dynamic> transaction = transactionHistory[userId];
        String userFrom = transaction['toname'];
        int status = transaction['status'];
        String amount = transaction['balance'];
        return TransactionTileWidget(
            status: status,
            userToName: AuthMethods().giveUserName().toString(),
            userFromName: userFrom,
            imageAssetSent: "assets/to_other_account.png",
            imageAssetReceived: "assets/to_your_account.png", amount: amount,);
      },
    );
  }
}
