import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallet_app_ui/model/model_class_card.dart';
import 'package:wallet_app_ui/pages/user_send_page.dart';
import 'package:wallet_app_ui/widgets/card.dart';
import 'package:wallet_app_ui/widgets/list_tile_button_widget.dart';
import 'package:wallet_app_ui/widgets/shadow_button_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = PageController();
  late Future<List<CardModelClass>> cardList;
  late String balance;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  void _fetchBalance() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          balance = (snapshot.data() as Map<String, dynamic>)['balance'].toString();
        });
      } else {
        setState(() {
          balance = 'No data available';
        });
      }
    } catch (e) {
      setState(() {
        balance = 'Error occurred';
      });
      print(e.toString());
    }
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: Icon(Icons.monetization_on),
        onPressed: () {
          _fetchBalance();
          _showSnackbar("Your Current Balnce is "+balance);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
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
      body: SafeArea(
        child: Column(
          children: [
            // app bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text(
                        "My",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " Cards",
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[400],
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),

            // cards
            Container(
              height: 151,
              //color: Colors.red,
              child: PageView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                children: [
                  CardWidget(
                    cardObject: CardModelClass(
                        12, 23, 5010, 3120267449878, Colors.deepPurpleAccent),
                  ),
                  CardWidget(
                    cardObject: CardModelClass(
                        12, 23, 7090, 3120267449878, Colors.orange),
                  ),
                  CardWidget(
                    cardObject: CardModelClass(
                        12, 23, 1567, 3120267449878, Colors.lightGreen),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // A controller directly related to the showing options of it
            SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.blueGrey.shade700,
              ),
            ),

            //row of options
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return UsersPage();
                          },
                        ),
                      );
                    },
                    child: ShadowButtonWidget(
                      iconImagePath: "assets/send_money.png",
                      buttonText: "Send",
                    ),
                  ),
                  ShadowButtonWidget(
                      iconImagePath: "assets/payment.png", buttonText: "Pay"),
                  ShadowButtonWidget(
                      iconImagePath: "assets/bill.png", buttonText: "Bill"),
                ],
              ),
            ),

            SizedBox(
              height: 5,
            ),
            //column of options

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  ListTileButtonWidget(
                      imageAsset: "assets/statistics.png",
                      tileHeader: "Statistics",
                      tileSubName: "Payments and Income"),
                  ListTileButtonWidget(
                      imageAsset: "assets/transaction.png",
                      tileHeader: "Transaction",
                      tileSubName: "Transaction History"),
                ],
              ),
            )
            // navigation bar
          ],
        ),
      ),
    );
  }
}
