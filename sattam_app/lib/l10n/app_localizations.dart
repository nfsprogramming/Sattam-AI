import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @aiChat.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get aiChat;

  /// No description provided for @cases.
  ///
  /// In en, this message translates to:
  /// **'Cases'**
  String get cases;

  /// No description provided for @lawyers.
  ///
  /// In en, this message translates to:
  /// **'Lawyers'**
  String get lawyers;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// No description provided for @myCases.
  ///
  /// In en, this message translates to:
  /// **'My Cases'**
  String get myCases;

  /// No description provided for @addCase.
  ///
  /// In en, this message translates to:
  /// **'Add Case'**
  String get addCase;

  /// No description provided for @addNewCase.
  ///
  /// In en, this message translates to:
  /// **'Add New Case'**
  String get addNewCase;

  /// No description provided for @caseTitle.
  ///
  /// In en, this message translates to:
  /// **'Case Title'**
  String get caseTitle;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @saveCase.
  ///
  /// In en, this message translates to:
  /// **'Save Case'**
  String get saveCase;

  /// No description provided for @noActiveCases.
  ///
  /// In en, this message translates to:
  /// **'No Active Cases'**
  String get noActiveCases;

  /// No description provided for @keepTrackHere.
  ///
  /// In en, this message translates to:
  /// **'Keep track of your legal matters here.'**
  String get keepTrackHere;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @askAi.
  ///
  /// In en, this message translates to:
  /// **'Ask AI'**
  String get askAi;

  /// No description provided for @generateDocument.
  ///
  /// In en, this message translates to:
  /// **'Generate Document'**
  String get generateDocument;

  /// No description provided for @exploreCategories.
  ///
  /// In en, this message translates to:
  /// **'Explore Legal Categories'**
  String get exploreCategories;

  /// No description provided for @typeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Type your legal question...'**
  String get typeQuestion;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help you today?'**
  String get howCanWeHelp;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String welcomeUser(String name);

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @generateRti.
  ///
  /// In en, this message translates to:
  /// **'Generate RTI Application'**
  String get generateRti;

  /// No description provided for @generateNotice.
  ///
  /// In en, this message translates to:
  /// **'Generate Legal Notice'**
  String get generateNotice;

  /// No description provided for @searchLegalTopics.
  ///
  /// In en, this message translates to:
  /// **'Search legal topics, acts, cases...'**
  String get searchLegalTopics;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @askAiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get instant legal answers'**
  String get askAiSubtitle;

  /// No description provided for @generateDocumentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create legal docs easily'**
  String get generateDocumentSubtitle;

  /// No description provided for @generateLegalDocuments.
  ///
  /// In en, this message translates to:
  /// **'Generate Legal Documents'**
  String get generateLegalDocuments;

  /// No description provided for @generateLegalDocumentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-generate RTIs & Legal Notices'**
  String get generateLegalDocumentsSubtitle;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get seeMore;

  /// No description provided for @lawyersNearYou.
  ///
  /// In en, this message translates to:
  /// **'Lawyers Near You'**
  String get lawyersNearYou;

  /// No description provided for @searchLawyers.
  ///
  /// In en, this message translates to:
  /// **'Search by name, practice area...'**
  String get searchLawyers;

  /// No description provided for @allFilters.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilters;

  /// No description provided for @catCriminalLaw.
  ///
  /// In en, this message translates to:
  /// **'Criminal Law'**
  String get catCriminalLaw;

  /// No description provided for @catTrafficMotor.
  ///
  /// In en, this message translates to:
  /// **'Traffic & Motor'**
  String get catTrafficMotor;

  /// No description provided for @catConsumerLaw.
  ///
  /// In en, this message translates to:
  /// **'Consumer Law'**
  String get catConsumerLaw;

  /// No description provided for @catLabourLaw.
  ///
  /// In en, this message translates to:
  /// **'Labour Law'**
  String get catLabourLaw;

  /// No description provided for @catFamilyLaw.
  ///
  /// In en, this message translates to:
  /// **'Family Law'**
  String get catFamilyLaw;

  /// No description provided for @catCyberLaw.
  ///
  /// In en, this message translates to:
  /// **'Cyber Law'**
  String get catCyberLaw;

  /// No description provided for @docComplaintLetter.
  ///
  /// In en, this message translates to:
  /// **'Complaint\nLetter'**
  String get docComplaintLetter;

  /// No description provided for @docLegalNotice.
  ///
  /// In en, this message translates to:
  /// **'Legal\nNotice'**
  String get docLegalNotice;

  /// No description provided for @docRtiApplication.
  ///
  /// In en, this message translates to:
  /// **'RTI\nApplication'**
  String get docRtiApplication;

  /// No description provided for @docRepresentationLetter.
  ///
  /// In en, this message translates to:
  /// **'Representation\nLetter'**
  String get docRepresentationLetter;

  /// No description provided for @docAffidavit.
  ///
  /// In en, this message translates to:
  /// **'Affidavit'**
  String get docAffidavit;

  /// No description provided for @docOtherDocument.
  ///
  /// In en, this message translates to:
  /// **'Other\nDocument'**
  String get docOtherDocument;

  /// No description provided for @catCivilLaw.
  ///
  /// In en, this message translates to:
  /// **'Civil Law'**
  String get catCivilLaw;

  /// No description provided for @catCorporateLaw.
  ///
  /// In en, this message translates to:
  /// **'Corporate Law'**
  String get catCorporateLaw;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bn',
    'en',
    'hi',
    'mr',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
