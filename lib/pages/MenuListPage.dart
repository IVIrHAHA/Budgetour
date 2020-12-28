import 'package:flutter/material.dart';

class MenuListPage extends StatelessWidget {
  final Map<Widget, Function> itemList;

  MenuListPage(this.itemList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Behaviour'),),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: itemList.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
              child: ListTile(
                onTap: entry.value,
                title: Center(child: entry.key),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
