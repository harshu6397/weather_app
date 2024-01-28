import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/components/additional_info_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double convertToCelsius(double temp) {
    return temp - 273.15;
  }

  String convertTo12HourFormat(String time) {
    int hour = int.parse(time.split(":")[0]);
    int minute = int.parse(time.split(":")[1]);
    String amOrPm = "AM";
    if (hour > 12) {
      hour = hour - 12;
      amOrPm = "PM";
    }

    return hour < 10 && minute < 10
        ? "0$hour:0$minute $amOrPm"
        : hour < 10
            ? "0$hour:$minute $amOrPm"
            : minute < 10
                ? "$hour:0$minute $amOrPm"
                : "$hour:$minute $amOrPm";  
  }

  Future<Map<String, dynamic>> getWeatherData() async {
    try {
      String cityName = "Meerut";
      final url = Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=5a087b4be6b2625b7cbafe2f04d44141");
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      if (data["cod"] != "200") {
        throw "An unexpected error occured";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getWeatherData(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshots.hasError) {
            return Center(
              child: Text(
                snapshots.error.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          if (snapshots.data == null) {
            return const Center(
              child: Text(
                "No data found",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final data = snapshots.data!;

          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main card
                Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 280,
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "${data['city']['name']}",
                              style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              data['list'][0]['weather'][0]['main'] == "Clouds"
                                  ? Icons.cloud
                                  : data['list'][0]['weather'][0]['main'] ==
                                          "Clear"
                                      ? Icons.wb_sunny
                                      : Icons.water_drop_outlined,
                              size: 100,
                            ),
                            Text(
                              "${convertToCelsius(data['list'][0]['main']['temp']).toStringAsFixed(2)}°C",
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${data['list'][0]['weather'][0]['description'].split(" ")[0][0].toUpperCase()}${data['list'][0]['weather'][0]['description'].split(" ")[0].substring(1)} ${data['list'][0]['weather'][0]['description'].split(" ")[1][0].toUpperCase()}${data['list'][0]['weather'][0]['description'].split(" ")[1].substring(1)}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // weather forecast card list
                const Text(
                  "Hourly Forecast",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ),
                            child: Container(
                              width: 150,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    convertTo12HourFormat(data['list']
                                            [index + 1]['dt_txt']
                                        .toString()
                                        .split(" ")[1]
                                        .substring(0, 5)),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    data['list'][index + 1]['weather'][0]
                                                ['main'] ==
                                            "Clouds"
                                        ? Icons.cloud
                                        : data['list'][index + 1]['weather'][0]
                                                    ['main'] ==
                                                "Clear"
                                            ? Icons.wb_sunny
                                            : Icons.water_drop_outlined,
                                    size: 40,
                                  ),
                                  Text(
                                    "${convertToCelsius(data['list'][index + 1]['main']['temp']).toStringAsFixed(2)}°C",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // Additonal details card
                const Text(
                  "Additional Details",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdditionalDetailsCard(
                      "Wind Speed",
                      data['list'][0]['wind']['speed'].toString(),
                      "km/h",
                      Icons.air,
                    ),
                    AdditionalDetailsCard(
                      "Humidity",
                      data['list'][0]['main']['humidity'].toString(),
                      "%",
                      Icons.water_drop,
                    ),
                    AdditionalDetailsCard(
                      "Pressure",
                      data['list'][0]['main']['pressure'].toString(),
                      "Pa",
                      Icons.speed,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
