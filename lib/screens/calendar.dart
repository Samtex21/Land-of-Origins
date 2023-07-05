import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:abushakir/abushakir.dart';
import 'package:beautiful_land_2/blocs/blocs.dart';
import 'package:beautiful_land_2/size_config.dart';
import 'package:hexcolor/hexcolor.dart';

const List<String> _dayNumbers = [
  "፩",
  "፪",
  "፫",
  "፬",
  "፭",
  "፮",
  "፯",
  "፰",
  "፱",
  "፲",
  "፲፩",
  "፲፪",
  "፲፫",
  "፲፬",
  "፲፭",
  "፲፮",
  "፲፯",
  "፲፰",
  "፲፱",
  "፳",
  "፳፩",
  "፳፪",
  "፳፫",
  "፳፬",
  "፳፭",
  "፳፮",
  "፳፯",
  "፳፰",
  "፳፱",
  "፴",
];

class MyCalendar extends StatelessWidget {
  EtDatetime _today = EtDatetime.now();

  List<Text> _days = [
    Text(
      "ሰ",
      style: TextStyle(
          fontSize: 2.08335 * SizeConfigu.textMultiplier,
          fontWeight: FontWeight.bold),
    ),
    Text("ማ",
        style: TextStyle(
            fontSize: 2.08335 * SizeConfigu.textMultiplier,
            fontWeight: FontWeight.bold)),
    Text("ረ",
        style: TextStyle(
            fontSize: 2.08335 * SizeConfigu.textMultiplier,
            fontWeight: FontWeight.bold)),
    Text("ሐ",
        style: TextStyle(
            fontSize: 2.08335 * SizeConfigu.textMultiplier,
            fontWeight: FontWeight.bold)),
    Text("አ",
        style: TextStyle(
            fontSize: 2.08335 * SizeConfigu.textMultiplier,
            fontWeight: FontWeight.bold)),
    Text("ቅ",
        style: TextStyle(
            fontSize: 2.08335 * SizeConfigu.textMultiplier,
            fontWeight: FontWeight.bold)),
    Text("እ",
        style: TextStyle(
            fontSize: 2.08335 * SizeConfigu.textMultiplier,
            fontWeight: FontWeight.bold)),
  ];

  String clockDivision(int hour) {
    if (hour >= 0 && hour <= 4)
      return "ከሌሊቱ";
    else if (hour >= 5 && hour <= 9)
      return "ከጠዋቱ";
    else if (hour >= 10 && hour <= 12)
      return "ከረፋዱ";
    else if (hour >= 13 && hour <= 16)
      return "ከሰአት";
    else
      return "ከምሽቱ";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                final month = state.moment;
                  return Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: _nameAndActions(context, month)),
                      _dayNames(),
                      Expanded(
                          child: GestureDetector(
                        onPanEnd: (e) {
                          if (e.velocity.pixelsPerSecond.dx < 0) {
                            BlocProvider.of<CalendarBloc>(context)
                                .add(NextMonthCalendar(month));
                          } else if (e.velocity.pixelsPerSecond.dx > 0) {
                            BlocProvider.of<CalendarBloc>(context)
                                .add(PrevMonthCalendar(month));
                          }
                        },
                        child: _daysGridList(context, month),
                      )),
                    ],
                  );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameAndActions(BuildContext context, ETC a) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.chevron_left),
          color: Colors.white,
          iconSize: 6.94 * SizeConfigu.imageSizeMultiplier,
          onPressed: () {
            BlocProvider.of<CalendarBloc>(context).add(PrevMonthCalendar(a));
          },
        ),
        Text(
          "${a.monthName}, ${a.year}",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 3.177 * SizeConfigu.textMultiplier,
              color: Colors.black),
        ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          color: Colors.white,
          iconSize: 6.94 * SizeConfigu.imageSizeMultiplier,
          onPressed: () {
            BlocProvider.of<CalendarBloc>(context).add(NextMonthCalendar(a));
          },
        ),
      ],
    );
  }

  Widget _dayNames() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _days.asMap().entries.map((MapEntry map) {
          return Container(
            child: map.value,
            padding: EdgeInsets.symmetric(
                horizontal: 4.63 * SizeConfigu.widthMultiplier,
                vertical: 1.838 * SizeConfigu.heightMultiplier),
          );
        }).toList());
  }

  Widget _daysGridList(BuildContext context, ETC a) {
    int today;
    return GridView.count(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.symmetric(
          horizontal: 0.694 * SizeConfigu.widthMultiplier,
          vertical: 0.3676 * SizeConfigu.heightMultiplier),
      crossAxisCount: 7,
      children: List.generate(
          (a.monthDays().toList().length! + a.monthDays().toList()[0][3])
              .toInt(), (index) {
        if (a.monthDays().toList()[0][3] > 0 &&
            index < a.monthDays().toList()[0][3]) {
          // NULL printer
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: 0.98 * SizeConfigu.heightMultiplier,
                horizontal: 1.852 * SizeConfigu.widthMultiplier),
            child: Container(
              alignment: Alignment.center,
              height: 1.225 * SizeConfigu.heightMultiplier,
              width: 2.315 * SizeConfigu.widthMultiplier,
              child: Text(
                "",
                style: TextStyle(color: Colors.black),
              ),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          );
        } else {
          // mark if currentday == today
          if (a.monthDays().toList()[
                      (index - a.monthDays().toList()[0][3]).toInt()][0] ==
                  EtDatetime.now()?.year &&
              a.monthDays().toList()[
                      (index - a.monthDays().toList()[0][3]).toInt()][1] ==
                  EtDatetime.now()?.month &&
              a.monthDays().toList()[
                      (index - a.monthDays().toList()[0][3]).toInt()][2] ==
                  EtDatetime.now()?.day) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 0.98 * SizeConfigu.heightMultiplier,
                  horizontal: 1.852 * SizeConfigu.widthMultiplier),
              child: Container(
                alignment: Alignment.center,
                height: 1.225 * SizeConfigu.heightMultiplier,
                width: 2.315 * SizeConfigu.widthMultiplier,
                child: Text(
                  "${a.monthDays().toList()[(index - a.monthDays().toList()[0][3]).toInt()][2]}",
                  style: TextStyle(color: Colors.white70),
                ),
                decoration: BoxDecoration(
                  color: HexColor('#31572C'),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: 0.98 * SizeConfigu.heightMultiplier,
                horizontal: 1.852 * SizeConfigu.widthMultiplier),
            child: Container(
              alignment: Alignment.center,
              height: 2 * SizeConfigu.heightMultiplier,
              width: 3 * SizeConfigu.widthMultiplier,
              child: Text(
                "${a.monthDays().toList()[(index - a.monthDays().toList()[0][3]).toInt()][2]}",
                style: TextStyle(color: Colors.black),
              ),
              decoration: BoxDecoration(
                color: HexColor('#90A955'),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          );
        }
      }),
    );
  }
}
