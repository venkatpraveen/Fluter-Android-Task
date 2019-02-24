import 'package:flutter/material.dart';
import 'package:food_truck/Domain/Cart.dart';
import 'package:food_truck/Domain/Fnblist.dart';
import 'package:food_truck/Domain/Subitem.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;
import 'dart:convert';
import 'package:food_truck/Domain/MockJSON.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Truck',
      theme: _appTheme(),
      home: new FoodTruck(),
    );
  }

  _appTheme() {
    return new ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF000000),
      accentColor: Colors.amberAccent,
      canvasColor: const Color(0xFF000000),
      fontFamily: 'Roboto',
    );
  }
}

class FoodTruck extends StatefulWidget {
  @override
  _MainState createState() => new _MainState();
}

class _MainState extends State<FoodTruck> with TickerProviderStateMixin {
  bool isLoaded = false;
  MockJSON mockJSON;
  TabController _tabController;
  TabPageSelector _tabPageSelector;
  List<Widget> subitemList = [];
  List<Cart> selectedItemsList = [];
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: _actionBar(),
      body: _foodtruckBody(),
      bottomNavigationBar: _bottomNavigationButton(),
    );
  }

  Widget _actionBar() {
    return new AppBar(
        title: Center(
          child: Text("Food Truck"),
        ),
        backgroundColor: Colors.black,
        bottom: new PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: new Theme(
                data: Theme.of(context).copyWith(accentColor: Colors.grey),
                child: new FutureBuilder(
                    future: _loadData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        isLoaded = true;
                        return Center(
                          child: new Container(
                            key: UniqueKey(),
                            height: 50.0,
                            alignment: Alignment.center,
                            child: _tabPageSelector,
                          ),
                        );
                      } else {
                        return new Container(
                          height: 30.0,
                        );
                      }
                    }))));
  }

  Widget _foodtruckBody() {
    return isLoaded
        ? Center(
            child: mockJSON.foodList.isEmpty
                ? new Container(
                    height: 30.0,
                  )
                : TabBarView(
                    controller: _tabController,
                    children: mockJSON.foodList.isEmpty
                        ? <Widget>[]
                        : mockJSON.foodList.map((tabContent) {
                            return new Card(
                              child: new Container(
                                color: const Color(0xFF000000),
                                child: tabContent.fnblist.isEmpty
                                    ? <Widget>[]
                                    : ListView.builder(
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                _buildFoodItem(
                                                    index, tabContent.fnblist),
                                      ),
                              ),
                            );
                          }).toList(),
                  ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget _bottomNavigationButton() {
    return new Container(
      child: new Row(children: <Widget>[
        new Expanded(
          child: new Container(
            padding: new EdgeInsets.only(right: 15.0, left: 15.0),
            child: new FlatButton(
                key: null,
                onPressed: _onSelectedItemButtonPressed,
                child: new Row(
                  children: <Widget>[
                    new Text(
                      "AED 0",
                      style: new TextStyle(
                          fontSize: 18.0,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                    new Icon(
                      Icons.expand_less,
                      color: Colors.black,
                    ),
                  ],
                )),
          ),
          flex: 7,
        ),
        new Expanded(
          child: new Container(
            padding: new EdgeInsets.only(right: 15.0),
            child: new FlatButton(
                key: null,
                onPressed: null,
                child: new Row(
                  children: <Widget>[
                    new Text(
                      "PAY",
                      style: new TextStyle(
                        fontSize: 20.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    new Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                    ),
                  ],
                )),
          ),
          flex: 3,
        )
      ]),
      color: Colors.amberAccent,
      padding: const EdgeInsets.all(0.0),
      alignment: Alignment.center,
      height: 60.0,
    );
  }

  Widget _buildFoodItem(int index, List<Fnblist> fnblist) {
    if (index >= fnblist.length) {
      return null;
    } else {
      return Container(
        child: new Column(children: <Widget>[
          new ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            child: Align(
              alignment: Alignment.center,
              heightFactor: 0.5,
              child: Image.network(
                fnblist[index].imageUrl,
              ),
            ),
          ),
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: fnblist[index].subitems.isEmpty
                  ? <Widget>[].toList()
                  : _buildSubitem(index, fnblist[index])),
          new Row(children: <Widget>[
            new Expanded(
              child: _buildItemDescription(fnblist[index]),
              flex: 6,
            ),
            new Expanded(
              child: new Container(
                  child: new IconButton(
                key: UniqueKey(),
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  _onItemUnselected(index, fnblist[index], index);
                },
                iconSize: 30.0,
                color: Colors.white,
              )),
              flex: 1,
            ),
            new Expanded(
              child: new Container(
                child: new Text(
                  _getItemCount(index, fnblist[index], index).toString(),
                  key: UniqueKey(),
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: const Color(0xFFffffff),
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              flex: 1,
            ),
            new Expanded(
              child: new Container(
                child: new IconButton(
                  key: UniqueKey(),
                  icon: const Icon(Icons.add_circle_outline),
//                  onPressed: _incrementCounter,
                  onPressed: () {
                    _onItemSelected(index, fnblist[index], index);
                  },
                  iconSize: 30.0,
                  color: Colors.white,
                ),
              ),
              flex: 1,
            ),
          ])
        ]),
        margin: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 10.0),
        decoration: new BoxDecoration(
          border: new Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(15.0), bottom: Radius.circular(0)),
        ),
        alignment: Alignment.center,
      );
    }
  }

  List<Widget> _buildSubitem(int index, Fnblist fnb) {
    subitemList = [];
    fnb.subitems.map((item) {
      subitemList.add(
        new OutlineButton(
            key: UniqueKey(),
            onPressed: null,
            textColor: Colors.white,
            color: Colors.amberAccent,
            child: new Text(
              item.name,
              style: new TextStyle(
                  fontSize: 16.0,
                  color: const Color(0xFFffffff),
                  fontWeight: FontWeight.w200),
            )),
      );
    }).toList();

    return subitemList;
  }

  /*TabBar _buildTabs() {
    List<Tab> tabs = [];
    TabBar tabBar;
    new FutureBuilder(
        future: _loadData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print("Check inside builder");
          if (snapshot.hasData) {
            isLoaded = true;
            print("Check inside hasData");
            mockJSON.foodList.map((tabContent) {
              print("Check inside food List-> " + tabContent.tabName);
              tabs.add(new Tab(text: tabContent.tabName));
            });
            tabBar = new TabBar(controller: _tabController, tabs: tabs);
          }
        });
    return tabBar;
  }*/

  _buildItemDescription(Fnblist fnblist) {
    return new Container(
      padding:
          new EdgeInsets.only(top: 15.0, bottom: 10.0, right: 15.0, left: 15.0),
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              fnblist.name,
              key: UniqueKey(),
              style: new TextStyle(
                  fontSize: 16.0,
                  color: const Color(0xFFffffff),
                  fontWeight: FontWeight.w200),
              textAlign: TextAlign.left,
            ),
            new Text(
              mockJSON.currency + " " + fnblist.itemPrice,
              key: UniqueKey(),
              style: new TextStyle(
                  fontSize: 18.0,
                  color: const Color(0xFFffffff),
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            )
          ]),
    );
  }

  int _getItemCount(int index, Fnblist fnb, int subItemIndex) {
    if (selectedItemsList != null) {
      Cart cartItem = null;
      for (var i = 0; i < selectedItemsList.length; i++) {
        cartItem = selectedItemsList[i];
        if (cartItem.id == fnb.vistaFoodItemId) {
          return selectedItemsList[i].quantity;
        }
      }
    } else {
      return 0;
    }

    return totalPrice;
  }

  void _onItemSelected(int index, Fnblist fnb, int subItemIndex) {
    if (selectedItemsList != null) {
      Cart cartItem = null;
      for (var i = 0; i < selectedItemsList.length; i++) {
        cartItem = selectedItemsList[i];
        print("cartItem.id->" + cartItem.name);
        if (cartItem.id == fnb.vistaFoodItemId) {
          selectedItemsList[i].quantity++;
          setState(() {
            totalPrice += cartItem.cost as int;
          });
        }
      }
    } else {
      Cart cartItem = new Cart(fnb.vistaFoodItemId, fnb.name, subItemIndex,
          double.parse(fnb.subitems[subItemIndex].subitemPrice), 0);
      selectedItemsList.add(cartItem);
      setState(() {
        totalPrice += cartItem.cost as int;
      });
    }
  }

  /*_onSubitemSelected(Subitem subItem) {
    print("Selected" + subItem.vistaSubFoodItemId);
    _getItemCount(14, mockJSON.foodList[0].fnblist[0], 2);
  }*/

  void _onItemUnselected(int index, Fnblist fnb, int subItemIndex) {
    if (selectedItemsList != null) {
      Cart cartItem = null;
      for (var i = 0; i < selectedItemsList.length; i++) {
        cartItem = selectedItemsList[i];
        print("cartItem.id->" + cartItem.name);
        if (cartItem.id == fnb.vistaFoodItemId && cartItem.quantity > 0) {
          selectedItemsList[i].quantity--;
          setState(() {
            totalPrice -= cartItem.cost as int;
          });
        }
      }
    }
  }

  void _onSelectedItemButtonPressed() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
              height: 300.0,
              color: Colors.amberAccent,
              child: new Center(
                  child: new Text(
                "Selected List of Item Goes Here!",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w300),
                textAlign: TextAlign.left,
              )));
        });
  }

  Future<MockJSON> _loadData() async {
    final response =
        await http.get("http://www.mocky.io/v2/5b700cff2e00005c009365cf");

    if (response.statusCode == 200) {
      String jsonString = response.body;
      final jsonResponse = json.decode(jsonString);
      Future<MockJSON> tempJson = Future.value(MockJSON.fromJson(jsonResponse));
      tempJson.then((onValue) {
        mockJSON = onValue;
        _tabController =
            new TabController(vsync: this, length: mockJSON.foodList?.length);
        _tabPageSelector = new TabPageSelector(controller: _tabController);
        setState(() {});
      });
      return tempJson;
//      mockJSON = MockJSON.fromJson(jsonResponse);

    } else {
      throw Exception('Failed to load json');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
