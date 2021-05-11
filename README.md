# tappo_app

Dashboard app for [tappo](https://github.com/fedepaj/tappo/tree/main) IoT device.

> :warning: **Spaghetti code warning**: Be very careful here!

## How to build

First of all download android studio and install flutter.
Then create an new flutter project and copy/paste these files in the created directory.

Then run
```sh
flutter clean
```
on first run (this is probably necessary since we are replacing the pubspec file) and to run the application on your mobile device in debug mode
```sh
flutter run
```
Edit the eps.dart file with your AWS Api Gateway REST endpoints.

Thats it for now.

## Features

![app_gif](https://github.com/fedepaj/tappo/blob/assets/app_gif.gif)

The current features of the app are:

* Shows the latest reading from the sensor: last percentual value and if the cap is placed or not.
* Shows the aggregated values: 
    * shows last hour's fill percentage (eg: in the last hour you've gone from 30% to 80%, so you made 50%);
    * shows the time since the cap has changed state (placed or removed).
* Shows all the value obtained from the device in the last hour.
* Shows and let the user control the device's actuators state.

## Future features

* Support for multiple devices
