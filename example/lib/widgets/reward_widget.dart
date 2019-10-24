import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class GoldMoney {
  bool isSelected;
  int price;
  GoldMoney({this.isSelected, this.price});
}

class Reward extends StatefulWidget {
  final List<GoldMoney> items;
  final EdgeInsetsGeometry padding;
  final Color borderColor = Color(0xFFCCCCCC);
  final Color borderSelectedColor = Color(0xFF000000);
  final Function onTap;

  Reward({Key key, this.items, this.padding, this.onTap})
      : assert(items.length > 0),
        super(key: key);
  @override
  _RewardState createState() => _RewardState();
}

class _RewardState extends State<Reward> {
  //final flagSubject = new BehaviorSubject<bool>();
  final listSubject = new BehaviorSubject<List<GoldMoney>>();
  var curIndex = 0;
  @override
  void initState() {
    super.initState();
    listSubject.add(widget.items);
  }
  @override
  void dispose(){
    listSubject?.close();
    super.dispose();
  }
  void changeIndex(int index) {
    if (index != curIndex) {
      widget.items[curIndex].isSelected = false;
      widget.items[index].isSelected = true;
      curIndex=index;
      listSubject.add(widget.items);
      if(widget.onTap!=null){
        widget.onTap(widget.items[index].price);
      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: listSubject.stream,
      builder: (_,AsyncSnapshot<List<GoldMoney>> snapshot) {
        if(snapshot.hasData){
          return  GridView.builder(
            padding: widget.padding != null
                ? widget.padding
                : EdgeInsets.only(top: 15.0),
            primary: false,
            reverse: false,
            shrinkWrap: true,
            addAutomaticKeepAlives: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 2.4,
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0),
            itemCount: snapshot.data.length,
            itemBuilder: (_, index)=>Container(
                  decoration: BoxDecoration(
                     
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color:snapshot.data[index].isSelected? widget.borderSelectedColor:widget.borderColor, width: 0.5)),
                  child: Material(
                     color:snapshot.data[index].isSelected? Color(0xFFFF5A5F):Color(0xFFFFFFFF),
                     borderRadius: BorderRadius.circular(4.0),
                      child: InkWell(
                          onTap: () => changeIndex(index),
                          child: Center(
                            child: Text("${snapshot.data[index].price}YB", style: TextStyle(color:snapshot.data[index].isSelected? Color(0xFFFFFFFF):Color(0xFF666666)),),
                          ))),
                ),
          );
        }else{
          return Container();
        }
      },
    );
  }
}
