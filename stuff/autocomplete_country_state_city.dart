import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'utilities/methods.dart';

Future<void> main() async {
  await dotenv.load(fileName: 'lib/.env');
  runApp(
    MaterialApp(
      title: 'AutoComplete Widget',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.blue,
      ),
      home: const MainPage(),
    ),
  );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<GeoModel> countryList = [];
  List<GeoModel> stateList = [];
  List<GeoModel> cityList = [];
  String country = '';
  String state = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCountries();
  }

  Future<void> getCountries() async {
    setState(() => isLoading = true);
    await networkRequest('https://api.countrystatecity.in/v1/countries')
        .then((value) {
      if (value.data != [] && value.status) {
        final tempCountries = <GeoModel>[];
        for (final element in value.data as List<dynamic>) {
          tempCountries.add(GeoModel.fromJson(element as Map<String, dynamic>));
        }
        countryList = tempCountries;
        isLoading = false;
        setState(() {});
      }
    });
  }

  Future<void> getStateByCountry(GeoModel x) async {
    setState(() => isLoading = true);
    await networkRequest(
            'https://api.countrystatecity.in/v1/countries/${x.iso2}/states')
        .then((value) {
      if (value.data != [] && value.status) {
        final tempStates = <GeoModel>[];
        for (final element in value.data as List<dynamic>) {
          tempStates.add(GeoModel.fromJson(element as Map<String, dynamic>));
        }
        stateList = tempStates;
        country = x.iso2;
        isLoading = false;
        setState(() {});
      }
    });
  }

  Future<void> getCitiesByState(GeoModel x) async {
    setState(() => isLoading = true);
    await networkRequest(
            'https://api.countrystatecity.in/v1/countries/$country/states/${x.iso2}/cities')
        .then((value) {
      if (value.data != [] && value.status) {
        final tempCities = <GeoModel>[];
        for (final element in value.data as List<dynamic>) {
          tempCities.add(GeoModel.fromJson(element as Map<String, dynamic>));
        }
        cityList = tempCities;
        isLoading = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Country City State API'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoCompleteGeoWidget(
                    list: countryList,
                    onSelected: getStateByCountry,
                    label: 'Country',
                  ),
                  if (stateList.isNotEmpty)
                    AutoCompleteGeoWidget(
                      list: stateList,
                      onSelected: getCitiesByState,
                      label: 'State',
                    ),
                  if (cityList.isNotEmpty)
                    AutoCompleteGeoWidget(
                      list: cityList,
                      label: 'City',
                    ),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.transparent,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: const Text('Reset'),
          onPressed: () {
            stateList = [];
            cityList = [];
            country = '';
            setState(() {});
          },
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('state', state));
    properties.add(StringProperty('country', country));
    properties.add(IterableProperty<GeoModel>('cityList', cityList));
    properties.add(IterableProperty<GeoModel>('stateList', stateList));
    properties.add(IterableProperty<GeoModel>('countryList', countryList));
    properties.add(DiagnosticsProperty<bool>('isLoading', isLoading));
  }
}

class GeoModel {
  GeoModel({
    required this.name,
    required this.iso2,
    required this.id,
  });

  factory GeoModel.fromJson(Map<String, dynamic> json) => GeoModel(
        id: json['id'].toString(),
        iso2: json['iso2'].toString(),
        name: json['name'].toString(),
      );

  final String id, name, iso2;

  @override
  String toString() => 'GeoModel{name: $name, id: $id, iso2: $iso2';
}

Future<ResponseModel> networkRequest(String url) async {
  try {
    final headers = <String, String>{
      'X-CSCAPI-KEY': dotenv.env['CSCAPI'] ?? ''
    };
    final response = await get(Uri.parse(url), headers: headers);
    return ResponseModel(
        message: '', status: true, data: jsonDecode(response.body));
  } on TimeoutException catch (e) {
    return ResponseModel(message: e.message.toString(), status: false);
  } on SocketException catch (e) {
    return ResponseModel(message: e.message, status: false);
  } on Exception catch (e) {
    debugPrint(e.toString());
    return ResponseModel(message: 'Connection Problem! 😐', status: false);
  }
}

class AutoCompleteGeoWidget extends StatelessWidget {
  const AutoCompleteGeoWidget({
    super.key,
    required this.list,
    this.onSelected,
    required this.label,
  });
  final List<GeoModel> list;
  final String label;
  final void Function(GeoModel)? onSelected;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Autocomplete<GeoModel>(
          optionsBuilder: (textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<GeoModel>.empty();
            }
            return list.where((option) => option.name
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: onSelected,
          displayStringForOption: (x) => x.name,
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) =>
                  TextFormField(
            controller: textEditingController,
            decoration: InputDecoration(
              labelText: label,
              hintText: 'Enter $label Name',
              border: const OutlineInputBorder(),
            ),
            focusNode: focusNode,
            onFieldSubmitted: (value) {
              onFieldSubmitted();
            },
          ),
        ),
      );
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<GeoModel>('list', list));
    properties.add(ObjectFlagProperty<void Function(GeoModel p1)?>.has(
        'onSelected', onSelected));
    properties.add(StringProperty('label', label));
  }
}
