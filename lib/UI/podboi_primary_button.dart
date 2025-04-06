import 'package:flutter/material.dart';

class PodboiPrimaryButton extends StatelessWidget {
  const PodboiPrimaryButton({
    required this.onTap,
    required this.child,
    this.customWitdh,
    this.color,
    super.key,
  });

  final void Function()? onTap;
  final Widget child;
  final Color? color;
  final double? customWitdh;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: SizedBox(
        width: customWitdh ?? MediaQuery.of(context).size.width * 0.25,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 8.0,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                color ?? Theme.of(context).primaryColorLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ),
    );
  }
}
