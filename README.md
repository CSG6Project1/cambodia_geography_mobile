# Cambodia Geography

![Image](https://user-images.githubusercontent.com/29684683/127860708-a0047a41-5add-469c-a6c3-853dbd22e8e8.png)

## Getting Started

In this project, we use flutter 2.2.3. If you have different version, you should consider [install FVM](https://soksereyphon8.medium.com/flutter-version-management-3c318c4ff97d).

### Prerequisites

```
fvm flutter pub get
fvm flutter run
```
## Built with

* [Flutter 2.2.3](https://flutter.dev) - The framework used
* [Dart](https://dart.dev/) - The language used

## Data use
* [Cambodia Geography API](https://github.com/CSG6Project1/cambodia_geography_api) - By our backend team.
* [https://geo.nestcode.co](https://geo.nestcode.co) - A website that inspired us to do this project.

## Code generation 
### Model generations with JSON Serialization
We uses Json Serializable [ https://flutter.dev/docs/development/data-and-backend/json#code-generation ] package build tool to generate model from Json to Class object. In case you want to add more fields model or even change the model data type, you need to run the command:
```
flutter pub run build_runner build --delete-conflicting-outputs
```

### Assets generations with flutter_gen
We also use [flutter_gen](https://pub.dev/packages/flutter_gen) which is the Flutter code generator for your assets, fonts, colors, … — to Get rid of all String-based APIs.

Installation: [https://pub.dev/packages/flutter_gen/install]

Generate new assets:
```
fluttergen
```

```dart
Widget build(BuildContext context) {
  return Assets.images.profile.image();
}
```

### Generation Translation from GoogleSheet
We use Google Sheet as the source of our translation.
Run this following command to generate the translation file. eg. `km.json`
```
./scripts/translation_gen/generate_localize_json_files.sh
```

## Check sign in report
Get info such as `Variant, Config, Store, Alias, MD5, SHA1, SHA-256, Valid until` with following command:
```shell
cd android
./gradlew signingReport
```

## Authors

**Group 4** - [CADT's students](http://www.cadt.edu.kh/).
See also the list of [contributors](https://github.com/CSG6Project1/cambodia_geography_mobile/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
