-- 下载表
CREATE TABLE download
(
    id                 INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    md5                CHAR(32)      NULL,-- 文件md5
    thumb              VARCHAR(512)  NULL, -- 缩略图
    name               VARCHAR(256)  NOT NULL, -- 文件名
    path               VARCHAR(1024) NOT NULL, -- 文件保存路径
    url                VARCHAR(512)  NOT NULL, -- 下载url
    size               INT8          NOT NULL DEFAULT 0, -- 文件大小
    downloadedSize     INT8          NOT NULL DEFAULT 0, -- 已下载大小
    state              INT1          NOT NULL DEFAULT 0, -- 下载状态 0：等待下载  1：上传中   2：暂停中  3:错误  10：上传完成
    msg                VARCHAR(1024) NULL, -- 错误消息等
    saveToImageGallery INT1          NOT NULL DEFAULT 0, -- 下载完成之后保存到手机相册
    date               DATETIME      NOT NULL DEFAULT current_timestamp -- 创建日期
);
CREATE INDEX index_md5 ON download (md5);
CREATE INDEX index_url ON download (url);
CREATE INDEX index_state ON download (state);
