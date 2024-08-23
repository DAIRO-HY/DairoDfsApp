-- 下载表
CREATE TABLE upload
(
    id           INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    md5          CHAR(32) NULL,-- 文件md5
    thumb           VARCHAR(512)     NULL, -- 缩略图
    name         VARCHAR(256)  NOT NULL, -- 文件名
    path         VARCHAR(1024) NOT NULL, -- 文件保存路径
    size         INT8          NOT NULL DEFAULT 0, -- 文件大小
    dfsFolder    VARCHAR(1024) NOT NULL, -- 服务器端文件夹路径
    uploadedSize INT8          NOT NULL DEFAULT 0, -- 已经上传了的大小
    state        INT1          NOT NULL DEFAULT 0, -- 状态 0：等待上传  1：上传中   2：暂停中  3:错误  10：上传完成
    msg          VARCHAR(1024) NULL, -- 错误消息等
    date         DATETIME      NOT NULL DEFAULT current_timestamp -- 创建日期
);
CREATE INDEX index_state ON upload (state);
