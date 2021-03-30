import 'package:call_api/Ecran/pays.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TousLesPays extends StatefulWidget {
  @override
  _TousLesPaysState createState() => _TousLesPaysState();
}

class _TousLesPaysState extends State<TousLesPays> {
  List countries = [];
  List filteredCountries = [];
  bool isSearching = false;

  get country => null;

  getCountries() async {
    var response = await Dio().get('https://restcountries.eu/rest/v2/all');
    return response.data;
  }

  @override
  void initState() {
    getCountries().then((data) {
      setState(() {
        countries = filteredCountries = data;
      });
    });
    super.initState();
  }

  @override
  // ignore: override_on_non_overriding_member
  void _filteredCountries(value) {
    setState(() {
      filteredCountries = countries
          .where((countries) =>
              country['name'].toLowerCase().contains(value.toLowercase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
          title: !isSearching
            ? Text('Tous Les Pays')
            : TextField(
                onChanged: (value) {
                  _filteredCountries(value);
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Recherchez les pays ici",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
                      filteredCountries = countries;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  })
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: filteredCountries.length > 0
              ? ListView.builder(
                  itemCount: filteredCountries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(Country.routeName,
                            arguments: filteredCountries[index]);
                      },
                      child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          child: Text(
                            filteredCountries[index]['name'],
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
