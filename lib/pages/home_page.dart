import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallet_app_ui/model/model_class_card.dart';
import 'package:wallet_app_ui/utils/card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = PageController();
  late Future<List<CardModelClass>> cardList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            // app bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[400],
                    ),
                    child: Icon(Icons.add),
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
            SizedBox(
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

            //column of options

            // navigation bar
          ],
        ),
      ),
    );
  }
}
