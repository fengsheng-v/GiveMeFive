// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `GIVE ME FIVE`
  String get title {
    return Intl.message(
      'GIVE ME FIVE',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Press the hand for a live high-five exchange!`
  String get prepare_press_hand {
    return Intl.message(
      'Press the hand for a live high-five exchange!',
      name: 'prepare_press_hand',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for someone to high-five you back.`
  String get waiting_for_back {
    return Intl.message(
      'Waiting for someone to high-five you back.',
      name: 'waiting_for_back',
      desc: '',
      args: [],
    );
  }

  /// `You got a high-five from {name}!`
  String have_find(Object name) {
    return Intl.message(
      'You got a high-five from $name!',
      name: 'have_find',
      desc: '',
      args: [name],
    );
  }

  /// `Over Time!`
  String get over_time {
    return Intl.message(
      'Over Time!',
      name: 'over_time',
      desc: '',
      args: [],
    );
  }

  /// `source`
  String get source {
    return Intl.message(
      'source',
      name: 'source',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}