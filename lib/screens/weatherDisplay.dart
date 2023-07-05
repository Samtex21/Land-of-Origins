import 'package:beautiful_land_2/services/weather_api_client.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../model/weather_model.dart';
class weatherDisplay extends StatefulWidget {
  const weatherDisplay({Key? key}) : super(key: key);

  @override
  State<weatherDisplay> createState() => _weatherDisplayState();
}

class _weatherDisplayState extends State<weatherDisplay> {
  WeatherApiClient client = WeatherApiClient();
  Weather? Addis_Ababa;
  // Weather? Adama;
  // Weather? Bahir_Dar;
  // Weather? Gonder;
  // Weather? Mekele;

  Future<void> get_weather_data() async {
    Addis_Ababa = await client.getCurrentweather("Addis Ababa");
    // Adama = await client.getCurrentweather("Adama");
    // Bahir_Dar = await client.getCurrentweather("Bahir Dar");
    // Gonder = await client.getCurrentweather("Gonder");
    // Mekele = await client.getCurrentweather("Mekele");
  }

  @override
  void initState() {
    super.initState();
    get_weather_data();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'.tr()),
        backgroundColor:HexColor('#31572C'),
      ),
      body: FutureBuilder(
        future: get_weather_data(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            return Wrap(
              direction: Axis.horizontal,
              spacing: 10,
              runSpacing: 10,
              children: [
                Center(
                  child: Text(
                    "Current Weather Conditions on Major Ethiopian Cities".tr(),
                    style: TextStyle(
                      fontSize: 26,
                      color: HexColor('#90A955'),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  color: HexColor('#90A955'),
                  child: Container(
                    width: 180,
                    height: 80,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.sunny,color: Colors.white70,),
                          title: Text('Addis Ababa'.tr()),
                          subtitle: Text('Temp: ${Addis_Ababa!.temp}c Humidity: ${Addis_Ababa!.humidity}'),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  color: HexColor('#90A955'),
                  child: Container(
                    width: 180,
                    height: 80,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.cloud,color: Colors.white70,),
                          title: Text('Adama'.tr()),
                          subtitle: Text('Temp: ${Addis_Ababa!.temp}c Humidity: ${Addis_Ababa!.humidity}'),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  color: HexColor('#90A955'),
                  child: Container(
                    width: 180,
                    height: 80,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.sunny,color: Colors.white70,),
                          title: Text('Gonder'.tr()),
                          subtitle: Text('Temp: ${Addis_Ababa!.temp}c Humidity: ${Addis_Ababa!.humidity}'),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  color: HexColor('#90A955'),
                  child: Container(
                    width: 180,
                    height: 80,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.sunny,color: Colors.white70,),
                          title: Text('Bahir Dar'.tr()),
                          subtitle: Text('Temp: ${Addis_Ababa!.temp}c Humidity: ${Addis_Ababa!.humidity}'),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  color: HexColor('#90A955'),
                  child: Container(
                    width: 180,
                    height: 80,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.sunny,color: Colors.white70,),
                          title: Text('Hawasa'.tr()),
                          subtitle: Text('Temp: ${Addis_Ababa!.temp}c Humidity: ${Addis_Ababa!.humidity}'),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  color: HexColor('#90A955'),
                  child: Container(
                    width: 180,
                    height: 80,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.sunny,color: Colors.white70,),
                          title: Text('Mekele'.tr()),
                          subtitle: Text('Temp: ${Addis_Ababa!.temp}c Humidity: ${Addis_Ababa!.humidity}'),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container(
              child: Center(child: Text("Connecting ...")),
            );
          }
        }
      )
    );
  }
}
