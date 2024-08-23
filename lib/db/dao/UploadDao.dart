import 'package:dairo_dfs_app/db/DBUtil.dart';
import 'package:dairo_dfs_app/extension/Database++.dart';
import 'package:sqlite3/sqlite3.dart';
import '../dto/UploadDto.dart';

class UploadDao {
  //添加数据
  static insert(List<UploadDto> dtos) => DBUtil.db.useSync((it) {
        // 开始事务
        it.execute('BEGIN TRANSACTION');
        try {
          for (final dto in dtos) {
            it.execute("insert into upload(thumb,name,path,dfsFolder,size) values (?,?,?,?,?);", [dto.thumb,dto.name, dto.path, dto.dfsFolder, dto.size]);
          }

          // 提交事务
          it.execute('COMMIT');
        } catch (e) {
          // 如果有错误，回滚事务
          it.execute('ROLLBACK');
          throw e;
        }
      });

  ///只获取一条没有上传的数据
  static UploadDto? selectOneByDb(Database db, int id) {
    final rs = db.select("select * from upload where id = $id;");
    if (rs.isEmpty) {
      return null;
    }
    return UploadDto.fromRow(rs.first);
  }

  ///只获取一条没有上传的数据
  static UploadDto? selectOneByNotUpload(String uploadingIds) => DBUtil.db.useSync((it) {
        if (uploadingIds.isEmpty) {
          uploadingIds = "0";
        }
        final rs = it.select("select * from upload where id not in ($uploadingIds) and state = 0 order by id asc limit 1;");
        if (rs.isEmpty) {
          return null;
        }
        return UploadDto.fromRow(rs.first);
      });

  ///获取所有没有上传id列表
  static List<int> selectNotUploadIds() => DBUtil.db.useSync((it) {
        final rs = it.select("select id from upload where state != 10 order by id desc;");
        return rs.map((it) => it.values[0] as int).toList();
      });

  ///获取所有已经上传完成的id列表
  static List<int> selectFinishIds() => DBUtil.db.useSync((it) {
        final rs = it.select("select id from upload where state = 10 order by id desc;");
        return rs.map((it) => it.values[0] as int).toList();
      });

  ///获取正在上传中的文件列表
  static int selectUploadCount() => DBUtil.db.useSync((it) {
    final rs = it.select("select count(*) from upload where state = 0;");
    return rs.first.values[0];
  });

  ///设置状态
  static void setState(int id, int state, [String? msg]) => DBUtil.db.useSync((it) {
        it.execute("update upload set state = ?,msg=? where id = ?;", [state, msg, id]);
      });

  ///设置上传进度
  static void setProgress(int id, int uploadedSize) => DBUtil.db.useSync((it) {
        it.execute("update upload set uploadedSize = ? where id = ?;", [uploadedSize, id]);
      });

  ///暂停所有
  static void pauseAll() => DBUtil.db.useSync((it) {
        it.execute("update upload set state = 2 where state in(0,1);");
      });

  ///开始所有
  static void uploadAll() => DBUtil.db.useSync((it) {
        it.execute("update upload set state = 0 where state in (2,3);");
      });

  ///删除数据
  static void deleteByIds(String ids) => DBUtil.db.useSync((it) {
        it.execute("delete from upload where id in ($ids);");
      });

  ///设置文件的MD5
  static void setMd5(int id, String md5) => DBUtil.db.useSync((it) {
        it.execute("update upload set md5 = ? where id = ?;", [md5, id]);
      });
}
