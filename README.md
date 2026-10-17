# Weather App

A simple Flutter app that shows the weather at the device's current location.

Use Flutter 3.47 or newer. Android, iOS, and web project files are included.

## Open in VS Code

1. Download or clone this repository and open its project folder in VS Code.
2. Install the Flutter extension if needed.
3. Open Terminal > New Terminal and run `flutter pub get`.
4. Start an Android emulator or connect an Android phone with USB debugging on.
5. Choose the device in VS Code, then press F5 with the **Weather App** launch configuration.
6. Tap **Check My Weather** and allow location access.

The local `config/api_key.json` file contains the supplied API key. It is ignored by Git. If you download the project from GitHub, copy `config/api_key.example.json` to `config/api_key.json` and enter your own key.

You can also run it from the terminal:

```sh
flutter run --dart-define-from-file=config/api_key.json
```

For Chrome, run:

```sh
flutter run -d chrome --dart-define-from-file=config/api_key.json
```

Allow location access in the browser. Use Chrome on localhost. Android is a good choice for the assignment demonstration.

## How it works

- `lib/main.dart`: home page and navigation to the weather page.
- `lib/weather_service.dart`: location permission, GPS, HTTP request, and JSON decoding.
- `lib/weather_page.dart`: loading spinner, weather display, refresh, and errors.

The app requests current weather each time the weather page opens or Refresh Weather is tapped. It uses the coordinates returned by Geolocator, rather than a fixed city. Temperature is in Fahrenheit. The loading spinner runs while location and weather are being fetched.

## Record the video

Record about 30 to 60 seconds showing:

1. The home page.
2. Tap Check My Weather.
3. Allow location access if prompted.
4. Show the spinner and then the city, temperature, conditions, and humidity.
5. Tap Refresh Weather and show the spinner again.
6. Tap Back to Home.

On a Mac, press Command + Shift + 5 and record the emulator window. On an Android emulator, set a location in Extended Controls > Location if GPS times out. The weather should match the emulator location, which may differ from your physical location.

## GitHub repository

https://github.com/basilwaz/ASE456-Weather-App

The API key is excluded from the published source. Copy `config/api_key.example.json` to `config/api_key.json`, enter your key, and run the app with the included VS Code launch configuration.

## Make the Canvas ZIP

Once your recording is ready, run:

```sh
python3 make_submission.py https://github.com/basilwaz/ASE456-Weather-App /full/path/to/weather_demo.mov
```

This creates `submission/ASE456_Weather_Submission.zip` containing only the video and `GitHub_Link.txt`, as the assignment requests. Upload that ZIP to Canvas. The project source belongs on GitHub.

## Common problems

- **Location denied:** Allow location in the device settings, then tap Try Again.
- **GPS timeout:** Turn on device location and set an emulator location.
- **401 API error:** Check the key in `config/api_key.json`, then stop and restart the app. Hot reload does not update compile-time API keys.
- **No Flutter command:** Install Flutter and add its `bin` directory to PATH.
- **Android SDK missing:** Open Android Studio's SDK Manager and install the SDK requested by Flutter. Run `flutter doctor` to check your setup.

## Validation

The supplied key returned HTTP 200 with real weather in a separate API check. JSON, Android XML, iOS property lists, and the Gradle wrapper archive passed static checks. Flutter execution was blocked by this environment's automatic security review, so dependency resolution, app compilation, GPS behavior, and the UI have not been verified here. Run the app on your device before recording. A demo recording still needs to be made on a working device or emulator.

## Class materials

Based on the navigation, Geolocator, HTTP/JSON, and SpinKit examples in:
https://github.com/Ashwin-Dhakal/ASE-456

OpenWeatherMap current weather documentation:
https://openweathermap.org/current

Package documentation:
https://pub.dev/packages/geolocator
https://pub.dev/packages/http
https://pub.dev/packages/flutter_spinkit
