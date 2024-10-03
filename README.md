#  Sunrisers app

## What it does

Simple application that can detect and show your current location and show a list of sunrise & sunset times for the forthcoming 7 days.

## How it does it

The application uses MapKit and the SwiftUI convenience Location button to help extract coordinates + display friendly name of your current location.
It then uses an external API (https://sunrise-sunset.org/api) to download the sunrise & sunset data for that location.

## How to use it

1. If it is a first launch or if you want to refresh your current location, press the location button. You may be asked for permissions to share your location.
2. When location has been detected and is displayed, the button to refresh sunrise data becomes available. Press the refresh button to refresh the sunrise data.
3. Sunrise data is now displayedr in a list.
4. Tapping on a specific sunrise date in the list will reveal a tiny bit more information in a details view.

Both location and latest sunrise data is persisted and will be remembered if the application is launched anew.

Both iOS & iPad, horizontal & vertical orientation, light and dark theme supported. 

Built and tested using XCode 16, iOS/iPad OS 18 & Swift 6

NOTE: if running in Simulator - there seems to be a framework bug where the location button sometimes goes missing. Changing orientation on simulator back and forth brings the button back. Have not seen the issue on real device.
