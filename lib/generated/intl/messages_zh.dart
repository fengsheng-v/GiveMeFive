// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static m0(name) => "已经找到来自 ${name} 的应答!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "have_find" : m0,
    "over_time" : MessageLookupByLibrary.simpleMessage("超时啦!"),
    "prepare_press_hand" : MessageLookupByLibrary.simpleMessage("点击上方手掌按钮击掌"),
    "source" : MessageLookupByLibrary.simpleMessage("来源"),
    "title" : MessageLookupByLibrary.simpleMessage("掌击"),
    "waiting_for_back" : MessageLookupByLibrary.simpleMessage("正在等待世界上某人应答")
  };
}
