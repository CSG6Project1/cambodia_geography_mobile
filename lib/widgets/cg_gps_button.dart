import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/providers/user_location_provider.dart';
import 'package:provider/provider.dart';

class CgGpsButton extends StatelessWidget {
  const CgGpsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserLocationProvider userLocationProvider = Provider.of<UserLocationProvider>(context, listen: true);
    String tooltip = userLocationProvider.currentPosition.toString();
    if (userLocationProvider.placemarks?.isNotEmpty == true) {
      tooltip = tooltip + "\n" + userLocationProvider.placemarks!.first.toString();
    }
    return GestureDetector(
      onLongPress: userLocationProvider.currentPosition == null
          ? () async {
              await userLocationProvider.determinePosition();
              if (userLocationProvider.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(userLocationProvider.errorMessage!),
                  ),
                );
              }
            }
          : null,
      child: IconButton(
        tooltip: tooltip != 'null' ? tooltip : null,
        icon: Icon(Icons.gps_fixed),
        onPressed: () async {
          await userLocationProvider.determinePosition();
          if (userLocationProvider.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(userLocationProvider.errorMessage!),
              ),
            );
          }
        },
      ),
    );
  }
}
