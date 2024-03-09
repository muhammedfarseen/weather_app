import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Data/imageand%20data%20list.dart';
import 'package:weather_app/Services/location%20provider.dart';
import 'package:weather_app/Services/weather%20.dart';
import 'package:weather_app/weather_respond_model.dart';

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

         ///////////locationprovider\\\\\\\\\\\
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

  Weather? obbj;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    /////////locationprovider\\\\\\\\\\\\\
    final locationprovider = Provider.of<LocationProvider>(context);
    final weatherprovider = Provider.of<WeatherServiceProvider>(context);


         ////////////sunrise and sunset convert to time stamp////////////////

    int sunriseTimestamp = weatherprovider.weather?.sys?.sunrise ?? 0;
    int sunsetTimestamp = weatherprovider.weather?.sys?.sunset ?? 0;
 
    
    DateTime sunriseDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
    DateTime sunsetDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);


    String Sunrise = DateFormat.Hm().format(sunriseDateTime);
    String Sunset = DateFormat.Hm().format(sunsetDateTime);

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
              return Container(
                padding:
                    EdgeInsets.only(top: 55, right: 20, bottom: 20, left: 60),
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/thunder.jpg"),
                  ),
                ),
                child: Column(
                  children: [
                    clicked == true
                        ? Container(
                            height: 45,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: CitySearchController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),))
                                ),
                                IconButton(
                                    onPressed: () {
                                      //////////// this is user search cuntry and click the icon and show the cuntry\\\\\\\\\\\\\ 
                                      print(CitySearchController.text);
                                        Provider.of<WeatherServiceProvider>(context, listen: false).fetchWeatherDataByCity(CitySearchController.text.toString());
                                    },
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                                  ////////////user current location\\\\\\\\\\\
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
                            children: [
                              Container(
                                child: Row(
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
                                          ///////////calling the user current location\\\\\\\\\\\\
                                           locationCity.toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
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
                                            color: Colors.white,
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
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: 150,
                      width: 150,
                      //////////////this image show the current cloudsisteme\\\\\\\\
                      child: Image.asset(imagepaths[
                              weatherprovider.weather?.weather![0].main ??
                                  "N/A"] ??
                          "assets/images/default.png"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 130,
                      width: 200,
                      child: Column(
                        children: [
                          Text(
                            //////////////this calling the tempracher\\\\\\\\\\\\\
                            "${weatherprovider.weather?.main?.temp.toString() ?? "N/A"} \u00B0C",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                           Text(
                            /////////this show cuntry name\\\\\\\\\\\\\
                            "${weatherprovider.weather?.name ?? "N/A"}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                           ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                               /////////this is weather show in user\\\\\\\
                            "${weatherprovider.weather?.weather![0].main ?? "N/A"}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                             /////////////this is show the current time\\\\\\\\\\
                            DateFormat("hh:mm: a").format(DateTime.now()),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black87.withOpacity(.5),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    /////////////temp-max\\\\\\\\\\\\\\\\\
                                    "${weatherprovider.weather?.main?.tempMax.toString()}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                         //////////temp-main\\\\\\\\\\\\\
                                        "${weatherprovider.weather?.main?.tempMin.toString()}",
                                        style: TextStyle(
                                          color: Colors.white,
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
                            color: Colors.white,
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    //////////sunrise timestamp\\\\\\\\\\
                                    "${Sunrise} AM",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        //////////sunset timestamp\\\\\\\\\\
                                        "${Sunset} PM",
                                        style: TextStyle(
                                          color: Colors.white,
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
