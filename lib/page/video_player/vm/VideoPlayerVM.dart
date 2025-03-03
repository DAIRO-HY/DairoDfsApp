/// 图片查看试图模型
class VideoPlayerVM {
  /// 文件id
  final int id;

  /// 名称
  final String name;

  /// 文件缩略图
  final String? thumb;

  VideoPlayerVM({required this.id,required this.name,required this.thumb});

  ///得到文件预览url
  String get preview => "/app/files/preview/${this.id}/${this.name}";
}
