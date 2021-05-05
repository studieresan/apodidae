# Apodidae

The iOS app created for Studs 2019 and expanded upon by Studs 2021, written in Swift. 

## Set up locally

Install dependencies (requires [Cocoapods](https://cocoapods.org)):

```
$ pod repo update
$ pod install
```

Then open the project with Xcode (Studs.xcworkspace).

The app uses [overlord](https://github.com/studieresan/overlord) as the backend service, see that page for API definition etc.

## Current functionality
> Last updated: May 5th, 2021 by Glenn Olsson

### Logged in vs not logged in
Everyone can use the Studs app; from the companies who host events, to travel partners, to the actual Studs members. As a Studs member, you can log in to the app to access more functionality than a ordinary user might. This login is the same as on [studs.se](studs.se).

### Events
As a public user (without login) you can see all previous events that have been published, just like on studs.se. You can also see a detailed view of the event with a photo gallery from the event, the same photos found on the website. This is also currently the only feature for logged in users.

As a studs user, you will also see the upcoming events and information about these. The photo gallery is switched for a map of the event location and there are buttons for the pre- and post-event forms, as well as internal descriptions of the events. 

There is also a widget available for users with iOS 14+ which shows information about the next event if you are logged in, and information about the latest event if not. 

### Happenings
Introduced by Studs21 is the happenings feature. This gives studs members the possibility to create a Happening when they are doing something and tagg people in it. The idea is similar to apps like *Beer with me* and *Beer buddy*, you make an entry when you are out and about, doing something such as having a beer with a few fellow studsers. A map and list view helps you see what the other studsers are up to at the moment. The idea is that it can be used on the trip, but it is fully functional where ever there is internet connection and at least one studser. Notifications shall be sent out to all others when a happning is created, but this has yet to be implemented at the time of writing this.

## Important
If the app ever uses any other kind of encryption not covered by exempt, the key `ITSAppUsesNonExemptEncryption` in `Studs/Info.plist` must be toggled or removed as to avoid legal trouble. Read more [here](https://developer.apple.com/documentation/bundleresources/information_property_list/itsappusesnonexemptencryption). Currently (Mars 2021) the app only uses SSL which is covered by the exempt

