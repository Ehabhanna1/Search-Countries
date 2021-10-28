import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class SearchCountries extends StatefulWidget {
  const SearchCountries({Key? key}) : super(key: key);

  @override
  _SearchCountriesState createState() => _SearchCountriesState();
}

class _SearchCountriesState extends State<SearchCountries> {
  TextEditingController controller = TextEditingController();

  getCountries() async {
    var url = Uri.parse("https://restcountries.eu/rest/v2/");
    final response = await http.get(url);
    final responsebody = jsonDecode(response.body);
    setState(() {
      _totalResult.clear();
      for (Map i in responsebody) {
        _totalResult.add(CountryModel.fromJson(i));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    getCountries();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Icon(Icons.arrow_back_ios),
        centerTitle: true,
        title: Text("Countries", style: TextStyle(color: Colors.white,

        ),
        ),
       // elevation: 3,

      ),
      body: Column(
        children: [
          Container(
            color:Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.search),
                  trailing: IconButton(onPressed: () {
                    print("Hi");
                    controller.clear();
                    onSearchTextChanged('');
                  },

                    icon: Icon(Icons.cancel),
                  ),
                  title: TextField(
                    controller: controller,
                    onChanged: onSearchTextChanged,
                    decoration: InputDecoration(
                      hintText: "search",
                      border: InputBorder.none,
                    ),
                  ),
                ),


              ),
            ),
          ),
          Expanded(

            child: _searchResult.length!=0||controller.text.isEmpty?
                ListView.builder(
                itemCount: _searchResult.length,

                  itemBuilder: (BuildContext context, int index) {

                  return  Card(
                    child: ListTile(title: Text(
                      _searchResult[index].name, textAlign: TextAlign.center, style: TextStyle(
                      color: Color(0xfff000000),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),),),
                  );

                  },):
                ListView.builder(
                itemCount: _totalResult.length,

                  itemBuilder: (BuildContext context, int index) {

                  return  Card(
                    child: ListTile(title: Text(
                      _totalResult[index].name, textAlign: TextAlign.center, style: TextStyle(
                      color: Color(0xfff000000),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),),),
                  );

                  },)

           ),


        ],
      ),

    );
  }

  onSearchTextChanged(String text) {
    _searchResult.clear();
    if (text.isEmpty) {
      return;
    }
    _totalResult.forEach((element) {
      if (element.name.contains(text) ||
        element.name.toLowerCase().contains(text.toLowerCase()))
      {
      _searchResult.add(element);
      }


      });
  }


}

List<CountryModel>_searchResult = [];
List<CountryModel>_totalResult = [];

class CountryModel {
  var name;

  CountryModel({this.name});

  factory CountryModel.fromJson(Map<dynamic, dynamic>json){
    return CountryModel(
      name: json["name"],

    );
  }
}