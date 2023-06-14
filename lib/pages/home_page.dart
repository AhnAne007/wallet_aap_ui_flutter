import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallet_app_ui/model/model_class_card.dart';
import 'package:wallet_app_ui/pages/login_page.dart';
import 'package:wallet_app_ui/pages/transaction_history_page.dart';
import 'package:wallet_app_ui/pages/user_send_page.dart';
import 'package:wallet_app_ui/resources/auth_methods.dart';
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

  Future<void> _fetchBalance() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          balance =
              (snapshot.data() as Map<String, dynamic>)['balance'].toString();
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
          _showSnackbar("Your Current Balnce is " + balance);
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        child: Text(
                          "My",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () async {
                          await AuthMethods().loginOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LogInPage();
                              },
                            ),
                          );
                        },
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

            Container(
              height: 151,
              //color: Colors.red,
              child: PageView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                children: [
                  CardWidget(
                    cardObject: CardModelClass(
                      12,
                      23,
                      5010,
                      3120267449878,
                      Colors.deepPurpleAccent,
                    ),
                  ),
                  CardWidget(
                    cardObject: CardModelClass(
                      12,
                      23,
                      7090,
                      3120267449878,
                      Colors.orange,
                    ),
                  ),
                  CardWidget(
                    cardObject: CardModelClass(
                      12,
                      23,
                      1567,
                      3120267449878,
                      Colors.lightGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.blueGrey.shade700,
              ),
            ),

            SizedBox(height: 25),
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
                    iconImagePath: "assets/payment.png",
                    buttonText: "Pay",
                  ),
                  ShadowButtonWidget(
                    iconImagePath: "assets/bill.png",
                    buttonText: "Bill",
                  ),
                ],
              ),
            ),

            SizedBox(height: 5),


            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  InkWell(
                    child: ListTileButtonWidget(
                      imageAsset: "assets/statistics.png",
                      tileHeader: "Statistics",
                      tileSubName: "Payments and Income",
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return TransactionHistoryPage();
                          },
                        ),
                      );
                    },
                  ),
                  ListTileButtonWidget(
                    imageAsset: "assets/transaction.png",
                    tileHeader: "Transaction",
                    tileSubName: "Transaction History",
                  ),
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
