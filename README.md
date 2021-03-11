# Apodidae

The iOS app for Studs 2019, written in Swift.

## Set up locally

Install dependencies (requires [Cocoapods](https://cocoapods.org)):

```
$ pod repo update
$ pod install
```

This app uses Firebase Cloud Messaging for push notifications and Firebase Realtime Database for the travel section. Add `GoogleService-Info.plist` in the `Studs` folder. See [here](https://support.google.com/firebase/answer/7015592) for more info.

Then open the project with Xcode.

The app uses `http://localhost:5040` as the back-end target in development mode, see [overlord](https://github.com/studieresan/overlord) for instructions on how to set it up.

Production uses `https://studs18-overlord.herokuapp.com` for the back-end.

## Important
If the app ever uses any other kind of encryption not covered by exempt, the key `ITSAppUsesNonExemptEncryption` in `Studs/Info.plist` must be toggled or removed as to avoid legal trouble. Read more [here](https://developer.apple.com/documentation/bundleresources/information_property_list/itsappusesnonexemptencryption). Currently (Mars 2021) the app only uses SSL which is covered by the exempt

