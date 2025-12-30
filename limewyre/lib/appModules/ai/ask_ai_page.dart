import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limewyre/appModules/ai/ai_controller.dart';
import 'package:limewyre/appModules/ai/source_list.dart';
import 'package:limewyre/utils/const_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AskAiPage extends StatelessWidget {
  final AiController controller = Get.isRegistered()
      ? Get.find<AiController>()
      : Get.put(AiController());
  final textController = TextEditingController();
  AskAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.aiChat.isEmpty) {
                  return _emptyPage();
                }
                return _chatView();
              }),
            ),
            _chatInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _emptyPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: ColorConst.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text("Ask me anything", style: Get.textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(
            "I'll search your notes instantly",
            style: Get.textTheme.bodySmall!.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Try asking:",
                  style: Get.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Column(
                  children: controller.suggestions
                      .map((text) => _suggestionCard(text))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _suggestionCard(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: () {
          textController.text = text;
          controller.messageText.value = text;
        },
        child: Text(
          text,
          style: Get.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _chatInputBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            // autofocus: true,
            onChanged: (val) => controller.messageText.value = val,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus!.unfocus(),
            controller: textController,
            textInputAction: TextInputAction.newline,
            textCapitalization: TextCapitalization.sentences,
            style: Get.textTheme.bodyMedium,
            decoration: InputDecoration(
              fillColor: Colors.grey.shade100,
              hintText: "Ask from your notes...",
              hintStyle: Get.textTheme.bodyMedium!.copyWith(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Obx(
          () => IconButton(
            style: IconButton.styleFrom(
              backgroundColor: ColorConst.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed:
                (controller.aiChat.isNotEmpty &&
                    controller.aiChat.last['text'] == 'Thinking...')
                ? null
                : () {
                    if (controller.messageText.value.isEmpty ||
                        textController.text.isEmpty) {
                      return;
                    }
                    // controller.sendMessage();
                    controller.queryQuestions(
                      question: controller.messageText.value,
                    );
                    textController.clear();
                  },
            icon: Icon(Icons.send_rounded),
          ),
        ),
      ],
    );
  }

  Widget _chatView() {
    return Obx(() {
      return ListView.separated(
        padding: const EdgeInsets.only(bottom: 10),
        itemCount: controller.aiChat.length,
        controller: controller.scrollController,
        itemBuilder: (context, index) {
          final message = controller.aiChat[index];
          bool isAi = index.isOdd;
          return isAi
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    message['text'] == ""
                        ? _errorResponse()
                        : message['text'] == 'is_thinking'
                        ? _isThinking()
                        : Text(
                            message['text'],
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                    if (message['source'] != null)
                      SourcesDropdown(
                        sources: message['source']
                            .map<String>(
                              (e) => e['metadata']['text'].toString(),
                            )
                            .toList(),
                      ),
                  ],
                )
              : Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 10,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConst.primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.end,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              runAlignment: WrapAlignment.spaceBetween,
                              spacing: 10,
                              children: [
                                Text(
                                  message['text'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        },
        separatorBuilder: (context, index) =>
            SizedBox(height: index.isOdd ? 20 : 0),
      );
    });
  }

  Widget _isThinking() {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
            color: ColorConst.primaryColor,
            size: 15,
          ),
          const SizedBox(width: 10),
          Text(
            'Searching your notes',
            style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _errorResponse() {
    return Row(
      children: [
        Icon(Icons.info_outline, color: Colors.red, size: 15),
        const SizedBox(width: 5),
        Text(
          'Error getting responce',
          style: Get.textTheme.bodySmall!.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
