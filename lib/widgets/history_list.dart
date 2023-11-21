import 'package:code_frame/constants/colors.dart';
import 'package:code_frame/providers/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    var historyProvider = Provider.of<HistoryProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: ConstantColors.tileDark,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: ConstantColors.tileDarkest,
          width: 3,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text(
              "History",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                historyProvider.clearHistory();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(
            height: 0,
            color: ConstantColors.tileDarkest,
          ),
          for (var i = 0; i < historyProvider.actions.length; i++)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: ConstantColors.tileDarkest,
                borderRadius: i == historyProvider.actions.length - 1
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28))
                    : null,
              ),
              child: ListTile(
                title: Text(
                  historyProvider.actions[i],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
