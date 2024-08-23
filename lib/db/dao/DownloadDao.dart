import 'package:dairo_dfs_app/db/DBUtil.dart';
import 'package:dairo_dfs_app/extension/Database++.dart';
import 'package:sqlite3/sqlite3.dart';
import '../dto/DownloadDto.dart';

class DownloadDao {
  //添加数据
  static insert(List<DownloadDto> dtos) => DBUtil.db.useSync((it) {
        // 开始事务
        it.execute('BEGIN TRANSACTION');
        try {
          for (final dto in dtos) {
            it.execute("insert into download(thumb,name,path,url,size,saveToImageGallery) values (?,?,?,?,?,?);",
                [dto.thumb, dto.name, dto.path, dto.url, dto.size, dto.saveToImageGallery]);
          }

          // 提交事务
          it.execute('COMMIT');
        } catch (e) {
          // 如果有错误，回滚事务
          it.execute('ROLLBACK');
          throw e;
        }
      });

  ///只获取一条没有下载的数据
  static DownloadDto? selectOneByDb(Database db, int id) {
    final rs = db.select("select * from download where id = $id;");
    if (rs.isEmpty) {
      return null;
    }
    return DownloadDto.fromRow(rs.first);
  }

  ///只获取一条没有下载的数据
  static DownloadDto? selectOneByNotDownload(String downloadingIds) => DBUtil.db.useSync((it) {
        if (downloadingIds.isEmpty) {
          downloadingIds = "0";
        }
        final rs = it.select("select * from download where id not in ($downloadingIds) and state = 0 order by id asc limit 1;");
        if (rs.isEmpty) {
          return null;
        }
        return DownloadDto.fromRow(rs.first);
      });

  ///获取所有没有下载id列表
  static List<int> selectNotDownloadIds() => DBUtil.db.useSync((it) {
        final rs = it.select("select id from download where state != 10 order by id desc;");
        return rs.map((it) => it.values[0] as int).toList();
      });

  ///获取所有已经下载完成的id列表
  static List<int> selectFinishIds() => DBUtil.db.useSync((it) {
        final rs = it.select("select id from download where state = 10 order by id desc;");
        return rs.map((it) => it.values[0] as int).toList();
      });

  ///获取正在下载中的文件列表
  static int selectDownloadCount() => DBUtil.db.useSync((it) {
        final rs = it.select("select count(*) from download where state = 0;");
        return rs.first.values[0];
      });

  ///通过ids获取下载数据列表
  static List<DownloadDto> selectByIds(String ids) => DBUtil.db.useSync((it) {
        final rs = it.select("select * from download where id in ($ids);");
        return rs.map((it) => DownloadDto.fromRow(it)).toList();
      });

  ///设置状态
  static void setState(int id, int state, [String? msg]) => DBUtil.db.useSync((it) {
        it.execute("update download set state = ?,msg=? where id = ?;", [state, msg, id]);
      });

  ///设置文件大小
  static void setSize(int id, int size) => DBUtil.db.useSync((it) {
        it.execute("update download set size = ? where id = ?;", [size, id]);
      });

  ///设置文件大小和md5
  static void setSizeAndMd5(int id, int size, String md5) => DBUtil.db.useSync((it) {
        it.execute("update download set size = ?, md5 = ? where id = ?;", [size, md5, id]);
      });

  ///设置下载进度
  static void setProgress(int id, int downloadedSize) => DBUtil.db.useSync((it) {
        it.execute("update download set downloadedSize = ? where id = ?;", [downloadedSize, id]);
      });

  ///暂停所有
  static void pauseAll() => DBUtil.db.useSync((it) {
        it.execute("update download set state = 2 where state in(0,1);");
      });

  ///开始所有
  static void downloadAll() => DBUtil.db.useSync((it) {
        it.execute("update download set state = 0 where state in (2,3);");
      });

  ///删除数据
  static void deleteByIds(String ids) => DBUtil.db.useSync((it) {
        it.execute("delete from download where id in ($ids);");
      });

  ///通过下载URL获取一条已经下载完成的数据
  static DownloadDto? selectOneByUrlAndFinish(String url) => DBUtil.db.useSync((it) {
    final rs = it.select("select * from download where url = ? and state = 10 order by id asc limit 1;", [url]);
    if (rs.isEmpty) {
      return null;
    }
    return DownloadDto.fromRow(rs.first);
  });

  ///通过下载MD5获取一条已经下载完成的数据
  static DownloadDto? selectOneByMd5AndFinish(String md5) => DBUtil.db.useSync((it) {
    final rs = it.select("select * from download where md5 = ? and state = 10 order by id desc limit 1;", [md5]);
    if (rs.isEmpty) {
      return null;
    }
    return DownloadDto.fromRow(rs.first);
  });

  ///设置文件下载目录,下载文件已经存在的情况用到
  static void setPath(int id, String path) => DBUtil.db.useSync((it) {
    it.execute("update download set path = ? where id = ?;", [path, id]);
  });
}
