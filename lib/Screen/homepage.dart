import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Data/imageand%20data%20list.dart';
import 'package:weather_app/Services/location%20provider.dart';
import 'package:weather_app/Services/weather%20.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool clicked = true;

  TextEditingController CitySearchController = TextEditingController();

  @override
  void dispose() {
    CitySearchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ////////////// current location\\\\\\\\\\\\
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.determinePosition().then((_) {
      if (locationProvider.currentLocationName != null) {
        var city = locationProvider.currentLocationName!.locality;
        if (city != null) {
          Provider.of<WeatherServiceProvider>(context, listen: false)
              .fetchWeatherDataByCity(city.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final locationprovider = Provider.of<LocationProvider>(context);
    final weatherprovider = Provider.of<WeatherServiceProvider>(context);
    /////////////sunrise and sunset cunvert time stamp\\\\\\\\\\\\\\\\\
    int sunriseTimestamp = weatherprovider.weather?.sys?.sunrise ?? 0;
    int sunsetTimestamp = weatherprovider.weather?.sys?.sunset ?? 0;

    DateTime sunriseDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
    DateTime sunsetDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);

    String Sunrise = DateFormat.Hm().format(sunriseDateTime);
    String Sunset = DateFormat.Hm().format(sunsetDateTime);

    bool isLoading = weatherprovider.weather == null;
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
            future: null,
            builder: (context, snapshot) {
              SizedBox(
                height: 60,
              );
              return Container(
                padding:
                    EdgeInsets.only(top: 50, right: 20, bottom: 50, left: 25),
                height: size.height,
                width: size.width,
                color: Colors.white,
                child: Column(
                  children: [
                    clicked == true
                        ? Container(
                            height: 50,
                            width: 265,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.black),
                                    controller: CitySearchController,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    print(CitySearchController.text);
                                    Provider.of<WeatherServiceProvider>(
                                      context,
                                      listen: false,
                                    ).fetchWeatherDataByCity(
                                      CitySearchController.text.toString(),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                    Consumer<LocationProvider>(
                      builder: (context, LocationProvider, child) {
                        var locationCity;
                        if (locationprovider.currentLocationName != null) {
                          locationCity =
                              locationprovider.currentLocationName!.locality;
                        } else {
                          locationCity = "Unknown Location";
                        }

                        return Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          locationCity.toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1,
                                        ),
                                        Text(
                                          _timechanger(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 80,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    clicked = !clicked;
                                  });
                                },
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 350,
                              width: 250,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 7,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    child: Image.asset(imagepaths[
                                            weatherprovider.weather?.weather![0]
                                                    .main ??
                                                "N/A"] ??
                                        "assets/images/default.png"),
                                  ),
                                  if (isLoading)
                                    Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    height: 130,
                                    width: 200,
                                    child: Column(
                                      children: [
                                        Text(
                                          "${weatherprovider.weather?.main?.temp.toString() ?? "N/A"} \u00B0C",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          "${weatherprovider.weather?.name ?? "N/A"}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                          "${weatherprovider.weather?.weather![0].main ?? "N/A"}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          DateFormat("hh:mm: a")
                                              .format(DateTime.now()),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 7,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            height: 185,
                            width: 300,
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.device_thermostat_outlined,
                                      color: Colors.red,
                                      size: 45,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Temp-max",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          "${weatherprovider.weather?.main?.tempMax.toString()}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.device_thermostat_outlined,
                                          color: Colors.blue,
                                          size: 45,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "Temp-min",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              "${weatherprovider.weather?.main?.tempMin.toString()}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 50,
                                  color: Colors.black,
                                  thickness: 2,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/sun.png",
                                      height: 55,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "sunrise",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          "${Sunrise} AM",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/moon.png",
                                          height: 55,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "sunset",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              "${Sunset} PM",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

String _timechanger() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return "GOOD MORNING";
  } else if (hour < 16) {
    return "GOOD AFTERNOON";
  } else if (hour < 19) {
    return "GOOD EVENING";
  } else {
    return 'GOOD NIGHT';
  }
}
