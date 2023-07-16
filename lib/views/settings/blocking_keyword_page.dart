import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pica_comic/views/widgets/pop_up_widget_scaffold.dart';
import '../../base.dart';

class BlockingKeywordPageLogic extends GetxController{
  var keywords = appdata.blockingKeyword;
  bool down = true;
  final controller = TextEditingController();
}

class BlockingKeywordPage extends StatelessWidget {
  BlockingKeywordPage({this.popUp = false,Key? key}) : super(key: key){
    Get.put(BlockingKeywordPageLogic());
  }
  final bool popUp;

  @override
  Widget build(BuildContext context) {
    var addButton = Tooltip(
      message: "添加".tr,
      child: IconButton(
        icon: const Icon(Icons.add),
        onPressed: (){
          showDialog(context: context,
            builder: (dialogContext)=>GetBuilder<BlockingKeywordPageLogic>(builder: (logic)=>SimpleDialog(
              title: Text("添加屏蔽关键词".tr),
              children: [
                const SizedBox(width: 400,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: TextField(
                    controller: logic.controller,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "添加关键词".tr
                    ),
                    onEditingComplete: (){
                      appdata.blockingKeyword.add(logic.controller.text);
                      logic.update();
                      Get.back();
                      logic.controller.text = "";
                      appdata.writeData();
                    },
                  ),
                ),
                Center(
                  child: FilledButton(
                    child: Text("提交".tr),
                    onPressed: (){
                      appdata.blockingKeyword.add(logic.controller.text);
                      logic.update();
                      Get.back();
                      logic.controller.text = "";
                      appdata.writeData();
                    },
                  ),
                )
              ],
          )));
        },
      ),
    );

    var orderButton = GetBuilder<BlockingKeywordPageLogic>(
      builder: (logic) {
        return Tooltip(
          message: "显示顺序",
          child: IconButton(
            icon: logic.down?const Icon(Icons.arrow_downward):const Icon(Icons.arrow_upward),
            onPressed: (){
              logic.down = !logic.down;
              logic.update();
            },
          ),
        );
      },
    );

    var widget = GetBuilder<BlockingKeywordPageLogic>(
      builder: (logic){
        var keywords = logic.down?appdata.blockingKeyword:appdata.blockingKeyword.reversed.toList();
        return ListView.builder(
          itemCount: keywords.length+1,
          padding: EdgeInsets.zero,
          itemBuilder: (context,index){
            if(index==0){
              return appdata.firstUse[0]=="1"?MaterialBanner(
                  forceActionsBelow: true,
                  padding: const EdgeInsets.all(15),
                  leading: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary,size: 30,),
                  content: Text("关键词屏蔽不会生效于收藏夹和历史记录, 屏蔽的依据仅限加载漫画列表时能够获取到的信息".tr), actions: [
                TextButton(onPressed: (){
                  appdata.firstUse[0] = "0";
                  appdata.writeData();
                  logic.update();
                }, child: const Text("关闭"))
              ]):const SizedBox(height: 0,);
            }else{
              return ListTile(
                title: Text(keywords[index-1]),
                trailing: IconButton(
                  icon: Icon(Icons.close,color: Theme.of(context).colorScheme.secondary,),
                  onPressed: (){
                    logic.keywords.remove(keywords[index-1]);
                    logic.update();
                    appdata.writeData();
                  },
                ),
              );
            }
          },
        );
      }
    );

    return popUp?
      PopUpWidgetScaffold(title: "关键词屏蔽".tr, body: widget,tailing: [addButton, orderButton],)
        :Scaffold(
          appBar: AppBar(title: Text("关键词屏蔽".tr),actions: [addButton, orderButton],),
          body: widget,
    );
  }
}
