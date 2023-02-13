import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:random_string/random_string.dart';
import 'package:username/username.dart';
import 'package:wechat/hive/conversation_list_adapter.dart';
import 'package:wechat/hive/hive_tool.dart';
import 'package:wechat/page/conversation/wechat_conversation_widget.dart';

class WechatConversataionListPage extends ConsumerWidget {
  const WechatConversataionListPage({
    super.key,
    this.dbUtil,
  });
  final DBUtil? dbUtil;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
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
                  onTap: () {
                    ConversationListModel conversationListModel =
                        ConversationListModel(
                            conversationId: randomAlphaNumeric(15),
                            userID: randomAlphaNumeric(20),
                            userName: Username.cn().fullname,
                            userIcon:
                                "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fblog%2F202103%2F23%2F20210323132934_d2473.thumb.1000_0.png&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1678416650&t=3fa34a17cfe6aa35381f56df9b6beb4e",
                            content: randomAlphaNumeric(20),
                            conversationType: 1,
                            isMute: 0,
                            time: DateTime.now().toString());

                    dbUtil!.conversationListBox.add(conversationListModel);
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
                    valueListenable: dbUtil!.conversationListBox.listenable(),
                    builder: (context, value, child) {
                      List<ConversationListModel> result =
                          value.values.toList().cast<ConversationListModel>();
                      return WechatConversataionWidget(
                        result: result,
                        onTap: (index) {
                          dbUtil!.conversationListBox.deleteAt(index);
                        },
                      );
                    })
                : Container(),
          )
        ]));
  }
}