import 'package:flutter/material.dart';
import 'package:wallet_app_ui/pages/transaction_page.dart';

class UserTileWidget extends StatefulWidget {
  final String userName;
  final String userToId;
  final String userToName;
  const UserTileWidget(
      {Key? key,
        required this.userToId,
        required this.userToName,
        required this.userName})
      : super(key: key);

  @override
  State<UserTileWidget> createState() => _GroupTileState();
}

class _GroupTileState extends State<UserTileWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>  TransactionPage(
              userToId: widget.userToId,
              userToName: widget.userToName,
              userName: widget.userName,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red[700],
            child: Text(
              widget.userToName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.userToName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Send the Transaction as ${widget.userName}",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}