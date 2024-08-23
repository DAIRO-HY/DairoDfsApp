extension ListExtension<E> on List<E> {
  /// 查找一条数据
  E? find(bool Function(E it) isFun) {
    for (final it in this) {
      if (isFun(it)) {
        return it;
      }
    }
    return null;
  }

  /// 查找索引
  int findIndex(bool Function(E it) isFun) {
    for (var i = 0; i < this.length; i++) {
      final it = this[i];
      if (isFun(it)) {
        return i;
      }
    }
    return -1;
  }
}
