import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.name,
    required this.iconName,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final String iconName;
  final Color color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/$iconName.svg',
            height: 14,
            width: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
