import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:dairo_dfs_app/Const.dart';
import 'package:dairo_dfs_app/api/FilesApi.dart';
import 'package:dairo_dfs_app/code/FileOrderBy.dart';
import 'package:dairo_dfs_app/code/FileViewType.dart';
import 'package:dairo_dfs_app/extension/BuildContext++.dart';
import 'package:dairo_dfs_app/extension/ValueNotifier++.dart';
import '../../../code/FileSortType.dart';
import '../../../uc/UCOptionMenuButton.dart';
import '../../../uc/dialog/UCAlertDialog.dart';
import '../../../uc/dialog/UCInputDialog.dart';
import '../../../util/shared_preferences/SettingShared.dart';
import '../FilePage.dart';
import 'UCDownloadWaitDialog.dart';
import 'UCProperty.dart';

///操作菜单自定义组件
class UCFileOptionMenu extends StatelessWidget {
  ///排序按钮高度
  static const _SORT_BTN_HEIGHT = 40.0;

  ///剪切板路径列表
  static Set<String>? clipboardPaths;

  ///剪贴板类型 1:剪切  2:复制
  static int? clipboardType;

  ///重新绘制操作菜单标记
  final redrawVN = ValueNotifier(0);

  ///排序方式改变通知
  final sortVN = ValueNotifier(0);

  var menus1 = <UCOptionMenuButton>[];
  var menus2 = <UCOptionMenuButton>[];

  ///文件页面状态对象
  final FilePageState filePageState;

  late BuildContext _context;

  UCFileOptionMenu(this.filePageState, {super.key});

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return this.redrawVN.build((value) {
      if (value == 0) {
        return SizedBox();
      }
      return Container(
          // margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(color: context.color.primaryContainer),
          child: Column(children: [
            Divider(height: .7, color: context.color.outline), // 加一条线
            this.sortVN.build((value) => this.sortView),
            Divider(height: .7, color: context.color.outline), // 加一条线
            Row(children: this.menus1),
            Row(children: this.menus2),
          ]));
    });
  }

  ///排序方式视图
  Widget get sortView {
    final sortType = SettingShared.sortType;
    final sortOrderBy = SettingShared.sortOrderBy;
    final children = [Gap(10), this._context.textBody("排序:", color: this._context.color.secondary)];

    ({FileSortType.NAME: "名称", FileSortType.DATE: "时间", FileSortType.SIZE: "大小", FileSortType.EXT: "类型"}).forEach((type, label) {
      children.add(this.sortBtn(label, isCheck: type == sortType, sortType: type, orderBy: sortOrderBy));
    });
    children.add(Spacer());

    //文件列表或表格显示类型
    children.add(GestureDetector(
        onTap: () {
          SettingShared.viewType = SettingShared.viewType == FileViewType.LIST ? FileViewType.GRID : FileViewType.LIST;
          this.sortVN.value++;
          this.filePageState.ucFileList.reload();
        },
        child: SizedBox(
            width: UCFileOptionMenu._SORT_BTN_HEIGHT,
            height: UCFileOptionMenu._SORT_BTN_HEIGHT,
            child: Icon(SettingShared.viewType == FileViewType.LIST ? Icons.grid_view : Icons.list_alt, size: 20))));
    return Row(children: children);
  }

  ///排序方式小按钮
  Widget sortBtn(String label, {required bool isCheck, required int sortType, required int orderBy}) {
    final Widget icon;
    if (isCheck) {
      icon = Icon(orderBy == FileOrderBy.UP ? Icons.arrow_drop_up : Icons.arrow_drop_down, size: Const.TEXT);
    } else {
      icon = SizedBox();
    }
    return GestureDetector(
        onTap: () {
          if (isCheck) {
            //如果已经是选中状态
            SettingShared.sortOrderBy = orderBy == FileOrderBy.UP ? FileOrderBy.DOWN : FileOrderBy.UP;
            this.sortVN.value++;
            this.filePageState.ucFileList.reload();
            return;
          }
          SettingShared.sortType = sortType;
          this.sortVN.value++;
          this.filePageState.ucFileList.reload();
        },
        child: SizedBox(
            height: UCFileOptionMenu._SORT_BTN_HEIGHT,
            child: Row(children: [
              Gap(10),
              icon,
              this._context.textBody(label, color: isCheck ? this._context.color.onSurface : this._context.color.onSurface.withOpacity(.3))
            ])));
  }

  ///重新绘制
  void redraw() {
    //当前被选中的文件数量
    int selectedCount = this.filePageState.selectedCount;
    this.menus1 = [
      UCOptionMenuButton("复制", icon: Icons.copy, disabled: selectedCount == 0, onPressed: () {
        this.toClipboard(2);
      }),
      UCOptionMenuButton("剪切", icon: Icons.cut, disabled: selectedCount == 0, onPressed: () {
        this.toClipboard(1);
      }),
      UCOptionMenuButton("粘贴", icon: Icons.paste_outlined, disabled: UCFileOptionMenu.clipboardType == null, onPressed: this.onClipboardClick),
      UCOptionMenuButton("删除", icon: Icons.delete_forever_outlined, disabled: selectedCount == 0, onPressed: this.onDeleteClick),
      UCOptionMenuButton("下载", icon: Icons.download_for_offline_outlined, disabled: selectedCount == 0, onPressed: this.onDownloadClick),
    ];
    this.menus2 = [
      UCOptionMenuButton("全选", icon: Icons.library_add_check_outlined, onPressed: this.onCheckAllClick),
      UCOptionMenuButton("全取消", icon: Icons.indeterminate_check_box_outlined, disabled: selectedCount == 0, onPressed: this.onUncheckAllClick),
      UCOptionMenuButton("刷新", icon: Icons.refresh_outlined, onPressed: this.filePageState.ucFileList.reload),
      UCOptionMenuButton("重命名", icon: Icons.drive_file_rename_outline, disabled: selectedCount != 1, onPressed: this.onRenameClick),
      UCOptionMenuButton("属性", icon: Icons.info_outlined, disabled: selectedCount == 0, onPressed: this.onPropertyClick),
    ];
    this.redrawVN.value++;
  }

  ///全选
  void onCheckAllClick() {
    for (var it in this.filePageState.ucFileList.dfsFileList) {
      it.isSelected = true;
    }
    this.filePageState.selectedCount = this.filePageState.ucFileList.dfsFileList.length;
    this.redraw();
    this.filePageState.ucFileList.redraw();
  }

  ///全取消
  void onUncheckAllClick() {
    for (var it in this.filePageState.ucFileList.dfsFileList) {
      it.isSelected = false;
    }
    this.filePageState.selectedCount = 0;
    this.redraw();
    this.filePageState.ucFileList.redraw();
  }

  ///重命名
  void onRenameClick() {
    final dfsFile = this.filePageState.ucFileList.dfsFileList.firstWhere((it) => it.isSelected);
    UCInputDialog.show(this._context, title: "重命名", value: dfsFile.name, okFun: (value) {
      if (value == dfsFile.name) {
        //没有修改
        return;
      }
      FilesApi.rename(sourcePath: dfsFile.path, name: value).post(() async {
        this.filePageState.ucFileList.reload();
      }, this._context);
    });
  }

  ///删除
  void onDeleteClick() {
    UCAlertDialog.show(this._context, title: "删除确认", msg: "确定要删除选中的${this.filePageState.selectedCount}个文件或文件夹吗？", okFun: () {
      FilesApi.delete(paths: this.filePageState.ucFileList.selectedPaths).post(() async {
        this.filePageState.ucFileList.reload();
        this._context.toast("删除成功");
      }, this._context);
    }, cancelFun: () {});
  }

  ///下载按钮点击事件
  void onDownloadClick() async {
    UCDownloadWaitDialog(this._context,this.filePageState.ucFileList.selected).show();
  }

  /// 放到剪贴板
  /// [clipboardType] 剪贴板类型,1:剪切  2:复制
  void toClipboard(int clipboardType) {
    final clipboardPaths = <String>{};
    clipboardPaths.addAll(this.filePageState.ucFileList.selectedPaths);
    if (clipboardPaths.isEmpty) {
      return;
    }
    UCFileOptionMenu.clipboardType = clipboardType;
    UCFileOptionMenu.clipboardPaths = clipboardPaths;
    this.filePageState.ucFileList.redraw();
    this._context.toast("选择的文件已放到剪切板,请选择一个文件夹然后粘贴。");
  }

  ///粘贴
  void onClipboardClick() {
    final clipboardPaths = <String>[];
    clipboardPaths.addAll(UCFileOptionMenu.clipboardPaths as Iterable<String>);

    final folder = this.filePageState.currentFolderVN.value;

    // let isOverWrite = false

    //↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓检查目标目录是否存在同名文件或文件夹↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    // const path = paths[0]
    // if (path.substring(0, path.lastIndexOf("/")) === folder) {//同一个文件夹下复制,会自动加上序号
    //   ;
    // } else {
    //   const nameSet = new Set()
    //   paths.forEach(item => {
    //   const name = item.substring(item.lastIndexOf("/") + 1)
    //   nameSet.add(name)
    //   })
    //   const fileList = getFileList()
    //   for (let i in fileList) {
    //     const item = fileList[i]
    //     if (nameSet.has(item.name)) {//目标目录已经存在同名文件
    //       const isOk = confirm("目标文件或文件夹已经已经存在,是否替换?")
    //       if (!isOk) {
    //         return
    //       }
    //       isOverWrite = true
    //       break
    //     }
    //   }
    // }
    //↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

    final successFun = () async {
      //清空剪切板
      UCFileOptionMenu.clipboardType = null;
      UCFileOptionMenu.clipboardPaths = null;
      this.filePageState.ucFileList.reload();
    };
    if (UCFileOptionMenu.clipboardType == 1) {
      FilesApi.move(sourcePaths: clipboardPaths, targetFolder: folder, isOverWrite: false).post(successFun, this._context);
    } else {
      FilesApi.copy(sourcePaths: clipboardPaths, targetFolder: folder, isOverWrite: false).post(successFun, this._context);
    }
  }

  ///属性点击事件
  void onPropertyClick() {
    UCProperty.show(this._context, this.filePageState.ucFileList.selectedPaths);
  }

  ///设置显示位置
  void hide() {
    this.redrawVN.value = 0;
  }
}
