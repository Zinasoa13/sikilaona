import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meteo/bloc/weather_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Widget getWeatherIcon(int code) {
    switch (code) {
      case > 200 && <= 300:
        return Image.asset('assets/images/1.png');
      case >= 300 && < 400:
        return Image.asset('assets/images/2.png');
      case >= 500 && <= 600:
        return Image.asset('assets/images/3.png');
      case >= 600 && < 700:
        return Image.asset('assets/images/4.png');
      case >= 700 && < 800:
        return Image.asset('assets/images/5.png');
      case == 800:
        return Image.asset('assets/images/6.png');
      case > 801 && <= 804:
        return Image.asset('assets/images/7.png');
      default:
        return Image.asset('assets/images/1.png');
    }
  }

  String getMessage(String city) {
    switch (city) {
      case 'Antananarivo':
        return 'Salama eh';
      case 'Toamasina':
        return ' Akory aby?';
      case 'Toliara':
        return 'Akory aby?';
      case 'Fianarantsoa':
        return 'Karakory?';
      case 'Mahajanga':
        return 'Mbôla tsara?';
      case 'Antsiranana':
        return 'Mbôla tsara?';
      default:
        return 'Salama eh';
    }
  }

  late AnimationController _controller;

  late Animation<double> _translateYAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _translateXAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _translateYAnimation = Tween<double>(
      begin: 0,
      end: 80,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _translateXAnimation = Tween<double>(
      begin: 0,
      end: 30,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 0.2 * kToolbarHeight, 30, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              FutureBuilder(
                future: Future.delayed(
                  Duration(seconds: 2),
                ), // Délai de 1 seconde
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AnimatedBuilder(
                      animation: _translateYAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _translateYAnimation.value),
                          child: Transform.scale(
                            scale: _scaleAnimation.value, // Animation de scale
                            child: child,
                          ),
                        );
                      },
                      child: Align(
                        alignment: AlignmentDirectional(4, -0.2),

                        child: Container(
                          height: 350,
                          width: 350,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 101, 0, 189),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(); // On ne montre rien tant que le délai n'est pas passé
                  }
                },
              ),

              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      _translateXAnimation.value,
                      _translateYAnimation.value,
                    ),
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Align(
                  alignment: AlignmentDirectional(0, -1.2),
                  child: Container(
                    height: 300,
                    width: 400,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 1, 7, 123),
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      _translateXAnimation.value,
                      _translateYAnimation.value,
                    ),
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Align(
                  alignment: AlignmentDirectional(-5, 0),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 1, 25, 123),
                    ),
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
              ),
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherSucsess) {
                    String city = state.weather.areaName ?? 'Inconnu';
                    String mess = getMessage(city);
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.withAlpha(70),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  '${state.weather.areaName}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'monts',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                mess,
                                style: TextStyle(
                                  fontFamily: 'pac',
                                  fontSize: 22,
                                  color: const Color.fromARGB(255, 0, 183, 255),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 15),

                          Center(
                            child: Container(
                              width: 200,
                              height: 200,
                              padding: EdgeInsets.all(5),
                              child: getWeatherIcon(
                                state.weather.weatherConditionCode!,
                              ),
                            ),
                          ),

                          Center(
                            child: Text(
                              '${state.weather.temperature!.celsius!.round()}°C',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'pac',
                                fontSize: 40,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),

                          Center(
                            child: Text(
                              state.weather.weatherMain!,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'monts',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          Center(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(144, 102, 0, 255),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(
                                      144,
                                      102,
                                      0,
                                      255,
                                    ).withAlpha(
                                      102,
                                    ), // Couleur de l'ombre avec opacité
                                    offset: Offset(
                                      2,
                                      4,
                                    ), // Décalage horizontal (2) et vertical (4)
                                    blurRadius: 10, // Rayon de flou
                                    spreadRadius: 2, // Étendue de l'ombre
                                  ),
                                ],
                              ),
                              child: Text(
                                DateFormat(
                                  'EEEE dd . ',
                                ).add_jm().format(state.weather.date!),
                                // 'Zoma 16  ¤  7:20am',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'monts',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 45),

                          Container(
                            padding: EdgeInsets.all(12),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/11.png',
                                      scale: 11,
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sunrise',
                                          style: TextStyle(
                                            letterSpacing: 2,
                                            color: Colors.deepPurple,
                                            fontFamily: 'pac',
                                            fontWeight: FontWeight.w200,
                                            fontSize: 15,
                                          ),
                                        ),

                                        SizedBox(height: 5),

                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.deepPurple,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Text(
                                            DateFormat().add_jm().format(
                                              state.weather.sunrise!,
                                            ),
                                            // '5:00 am',
                                            style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontFamily: 'monts',
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/12.png',
                                      scale: 11,
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sunset',
                                          style: TextStyle(
                                            letterSpacing: 2,
                                            color: Colors.deepPurple,
                                            fontFamily: 'pac',
                                            fontWeight: FontWeight.w200,
                                            fontSize: 15,
                                          ),
                                        ),

                                        SizedBox(height: 5),

                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.deepPurple,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Text(
                                            DateFormat().add_jm().format(
                                              state.weather.sunset!,
                                            ),
                                            style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontFamily: 'monts',
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 8),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider(height: 2, color: Colors.grey),
                          ),

                          SizedBox(height: 8),

                          Container(
                            padding: EdgeInsets.all(12),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/13.png',
                                      scale: 11,
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Temp max',
                                          style: TextStyle(
                                            letterSpacing: 2,
                                            color: Colors.white,
                                            fontFamily: 'pac',
                                            fontWeight: FontWeight.w200,
                                            fontSize: 15,
                                          ),
                                        ),

                                        SizedBox(height: 5),

                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Text(
                                            '${state.weather.tempMax!.celsius!.round()}°C',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'monts',
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/14.png',
                                      scale: 11,
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Temp min',
                                          style: TextStyle(
                                            letterSpacing: 2,
                                            color: Colors.white,
                                            fontFamily: 'pac',
                                            fontWeight: FontWeight.w200,
                                            fontSize: 15,
                                          ),
                                        ),

                                        SizedBox(height: 5),

                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Text(
                                            '${state.weather.tempMin!.celsius!.round()}°C',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'monts',
                                              fontSize: 10,
                                            ),
                                          ),
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
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
