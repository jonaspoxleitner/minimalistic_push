# Minimalistic Push

[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://pub.dev/packages/effective_dart)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Minimalistic Push is one of the simplest push-up trackers out there. You can track your push-ups in the training mode and see an overview of your sessions.

<img src="https://user-images.githubusercontent.com/18596113/101342862-71707a00-3883-11eb-951b-51d66f3c611f.gif" height="400" width="400">

## Table of Contents
- [Minimalistic Push](#minimalistic-push)
  - [Table of Contents](#table-of-contents)
  - [Background](#background)
  - [Functionality](#functionality)
  - [Design](#design)
  - [Features](#features)
  - [Features (upcoming versions)](#features-upcoming-versions)
  - [Platforms](#platforms)
  - [Contributions](#contributions)

## Background
A few years ago, I experimented with PhoneGap and uploaded a more simpler app to the Google Play Store ([Google Play](https://play.google.com/store/apps/details?id=com.byBjorn.Push&hl=en_US)). As it turns out, people still download and try the app, even if there isn't much functionalty there. The project files can still be found in the 'legacy_web' directory in this repository. To improve my Flutter skills, I decided to give the app the update it deserves and provide maybe the simplest push-up tracker to the stores.

## Functionality
On the first start, the user is welcomed by three onboarding pages. These pages inform about the use and benefits of the app. After this, the user gets navigated to the main screen of the app.
The main purpose of the app is to do your push-ups and track your progress with your nose ('Training Mode'). You can save your sessions in an offline database and also list your previous sessions ('Sessions Overview'). Furthermore, the 'Settings' screen gives the user the ability to clear all the sessions and change the theme of the app.

## Design
The design is planned to be both simple and beatiful. One of the key design elements is the variable background. Is should inform the user about the training progress and also show the progress from session to session in a subtile way.

## Features
* onboarding experience
* track sessions with your nose (hardcore)
* track sessions with the proximity sensor
* insert session into the database
* list you previous sessions
* share your progress
* export and import sessions
* change themes in the settings

## Features (upcoming versions)
Please feel free to mail me your ideas and wishes for future versions of 'Minimalistic Push'.

## Platforms
This Flutter app is already released for both iOS and Android. There is also a beta version available for iOS TestFlight. Feel free to get all the links from [my website](https://jonaspoxleitner.com).

## Contributions
Because the main features and the design of the app are not finished, there won't be any collaborations for now. This will possibly change in the future.
