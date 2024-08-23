import 'dart:collection';

import 'EventCode.dart';

/**
 * 消息广播类
 */
class EventUtil {

  ///目标对象 -> code -> 回调函数
  static final Map<Object, Map<EventCode, void Function(Object?)>> observer2Code2Event = {};

  ///code -> 目标对象List
  static final Map<EventCode, Set<Object>> code2ObserverSet = {};

  ///目标对象 -> code
  static final Map<Object, Set<EventCode>> observer2CodeSet = {};

  /// 注册广播
  /// [observer] 广播携带对象,及当该对象被销毁是,此广播也随之销毁
  /// [code] 广播名,标记发送对象
  /// [event] 广播回调
  static void regist(Object observer, EventCode code, void Function(Object? data) event) {
    var observerSet = code2ObserverSet[code];
    if (observerSet == null) {
      observerSet = HashSet<Object>();
      code2ObserverSet[code] = observerSet;
    }
    observerSet.add(observer);

    var codeSet = observer2CodeSet[observer];
    if (codeSet == null) {
      codeSet = HashSet<EventCode>();
      observer2CodeSet[observer] = codeSet;
    }
    codeSet.add(code);

    var code2Event = observer2Code2Event[observer];
    if (code2Event == null) {
      code2Event = <EventCode, void Function(Object? tag)>{};
      observer2Code2Event[observer] = code2Event;
    }
    code2Event[code] = event;
  }

  /// 注销广播
  /// [observer] 广播携带对象
  static void unregist(Object observer) {
    final codeSet = observer2CodeSet[observer];
    observer2CodeSet.remove(observer);
    codeSet?.forEach((code) {
      final observerSet = code2ObserverSet[code];
      if(observerSet == null){
        return;
      }
      observerSet.remove(observer);
      if (observerSet.isEmpty) {
        code2ObserverSet.remove(code);
      }
    });
    observer2Code2Event.remove(observer);
  }

  ///发送广播消息
  ///[code] 广播标识
  ///[data] 广播数据
  static void post(EventCode code, [Object? data]) {
    final observerSet = code2ObserverSet[code];
    observerSet?.forEach((observer) {
      final code2Event = observer2Code2Event[observer];
      if(code2Event == null){
        return;
      }
      final event = code2Event[code];
      if(event == null){
        return;
      }
      event(data);
    });
  }
}
