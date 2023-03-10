import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:random_string/random_string.dart';
import 'package:username/username.dart';
import 'package:wechat/hive/conversation_list_adapter.dart';
import 'package:wechat/hive/hive_tool.dart';
import 'package:wechat/page/conversation/wechat_conversataion_list_widget.dart';
import 'package:wechat/page/conversation/wechat_conversation_window.dart';
import 'package:wechat/tools/random_image_url.dart';

class WechatConversataionPage extends ConsumerWidget {
  const WechatConversataionPage({
    super.key,
    this.dbUtil,
  });
  final DBUtil? dbUtil;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Container(
            width: 250,
            color: const Color.fromRGBO(247, 247, 247, 1),
            child: Column(children: [
              Container(
                height: 60,
                color: const Color.fromRGBO(247, 247, 247, 1),
                margin: const EdgeInsets.only(left: 13),
                child: Row(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 26,
                        maxWidth: 190,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 12),
                          hintText: '搜索',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: const Color.fromRGBO(233, 233, 233, 1),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onLongPress: () {
                        dbUtil!.conversationListBox.clear();
                      },
                      onTap: () {
                        ///添加联系人
                        ConversationListModel conversation =
                            ConversationListModel(
                                conversationId: randomAlphaNumeric(15),
                                userID: randomAlphaNumeric(20),
                                userName: Username.cn().fullname,
                                userIcon: RandomImageUrl.getUrl(),
                                content: randomAlphaNumeric(20),
                                conversationType: 1,
                                isMute: 0,
                                time: DateTime.now().toString());
                        dbUtil!.conversationListBox.add(conversation);
                      },
                      child: Container(
                          width: 26,
                          height: 26,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(233, 233, 233, 1),
                              borderRadius: BorderRadius.circular(4)),
                          child: const Icon(Icons.add_outlined,
                              size: 18, color: Colors.grey)),
                    )
                  ],
                ),
              ),
              Expanded(
                child: dbUtil != null
                    ? ValueListenableBuilder(
                        valueListenable:
                            dbUtil!.conversationListBox.listenable(),
                        builder: (context, value, child) {
                          List<ConversationListModel> result = value.values
                              .toList()
                              .cast<ConversationListModel>();
                          return WechatConversataionListWidget(
                            dbUtil,
                            result: result,
                            onTap: (index) {
                              dbUtil!.conversationListBox.deleteAt(index);
                            },
                          );
                        })
                    : Container(),
              )
            ])),
        const VerticalDivider(
          color: Color.fromRGBO(228, 223, 222, 1),
          thickness: 0,
          width: 1,
        ),
        dbUtil == null
            ? Container()
            : Expanded(child: WechatConversataionListPage(dbUtil: dbUtil))
      ],
    );
  }
}
