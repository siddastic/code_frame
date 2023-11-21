import 'package:code_frame/constants/colors.dart';
import 'package:flutter/material.dart';

class EditAction extends StatelessWidget {
  final VoidCallback onRemove;
  final String actionName;
  const EditAction({
    required this.onRemove,
    required this.actionName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff14433e),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text(
              "Edit Action :",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              actionName,
              style: const TextStyle(
                color: ConstantColors.midGrayText,
              ),
            ),
          ),
          const Divider(
            height: 0,
            color: Color(0xff0c2e30),
          ),
          ListTile(
            onTap: onRemove,
            leading: const Icon(
              Icons.close,
              color: Colors.red,
            ),
            title: const Text(
              "Remove",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
