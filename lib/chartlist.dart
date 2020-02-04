import 'package:flutter/material.dart';
import 'package:gym_chartsheet/models/days.dart';

class ChartList extends StatefulWidget {
  final List<Days> tabs;

  ChartList({this.tabs});

  @override
  State<StatefulWidget> createState() {
    return _ChartList();
  }
}

class _ChartList extends State<ChartList> with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool isDone = false;
  TextDecoration _textDecoration = TextDecoration.none;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  iconTheme: IconThemeData(color: Colors.white),
                  title: Text(
                    'Gym Chart Sheet',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Color(0xff283593),
                  floating: true,
                  pinned: true,
                  snap: false,
                  primary: true,
                  forceElevated: true,
                  bottom: TabBar(
                    indicatorColor: Colors.white,
                    controller: _tabController,
                    isScrollable: true,
                    // These are the widgets to put in each tab in the tab bar.
                    tabs: widget.tabs
                        .map((Days day) => Tab(
                              child: Text(
                                day.dayName,
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: widget.tabs.map((Days day) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<String>(day.dayName),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                height: 50,
                                child: ListTile(
                                  leading: Checkbox(
                                      value: isDone,
                                      onChanged: (val) {
                                        setState(() {
                                          isDone = val;
                                          if (isDone) {
                                            _textDecoration =
                                                TextDecoration.lineThrough;
                                          } else {
                                            _textDecoration =
                                                TextDecoration.none;
                                          }
                                        });
                                      }),
                                  title: Text(
                                    '1',
                                    style:
                                        TextStyle(decoration: _textDecoration),
                                  ),
                                ),
                              );
                            },
                            childCount: 6,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
