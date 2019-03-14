# Apodidae

The iOS app for Studs 2019, written in Swift.

## Set up locally

Install dependencies (requires [Cocoapods](https://cocoapods.org)):

```
$ pod repo update
$ pod install
```

Then open the project with XCode.

The app uses `http://localhost:5040` as the back-end target in development mode, see [overlord](https://github.com/studieresan/overlord) for instructions on how to set it up.

Production uses `https://studs18-overlord.herokuapp.com` for the back-end.
