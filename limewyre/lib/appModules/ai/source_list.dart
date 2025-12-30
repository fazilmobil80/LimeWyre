import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:limewyre/utils/const_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SourcesDropdown extends StatefulWidget {
  final List<String> sources;

  const SourcesDropdown({super.key, required this.sources});

  @override
  State<SourcesDropdown> createState() => _SourcesDropdownState();
}

class _SourcesDropdownState extends State<SourcesDropdown> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.sources.isEmpty) return const SizedBox();
    final rest = widget.sources.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.grey.shade300),
        Row(
          children: [
            Text(
              "Sources: (${widget.sources.length})",
              style: Get.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => setState(() => expanded = !expanded),
              child: Text(
                expanded ? "Hide ▲" : "Show ▼",
                style: Get.textTheme.bodySmall!.copyWith(
                  color: ColorConst.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        if (expanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              rest.length,
              (index) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Linkify(
                  text: "${index + 1}. ${rest[index]}",
                  style: Get.textTheme.bodySmall!.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  onOpen: (link) async {
                    final uri = Uri.parse(link.url);
                    await launchUrl(uri);
                  },
                  linkStyle: Get.textTheme.bodySmall!.copyWith(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
