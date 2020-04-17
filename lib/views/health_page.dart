import 'package:coronavision/models/covid_details.dart';
import 'package:coronavision/style/palette.dart';
import 'package:coronavision/style/text_styles.dart';
import 'package:coronavision/style/ui_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:line_icons/line_icons.dart';

class HealthPage extends StatefulWidget {
  @override
  _HealthPageState createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {

  Widget _title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Health", style: TextStyles.pageHeader),
        Text("Tips and screening", style: TextStyles.pageSubHeader),
      ],
    );
  }

  Widget _selfCheckCard() {
    return _HeaderCard(
      title: "COVID-19 Self Checkup",
      description: "Answer a list of questions to determine your health and risk",
      color: Palette.navyBlue,
      icon: Icon(LineIcons.angle_right_solid, color: Colors.white),
    );
  }

  Widget _safeHabitsCard() {
    return _HeaderCard(
      title: "Safe Living Habits",
      description: "A list of safe lifestyle habits to prevent spread of COVID-19",
      color: Palette.leafGreen,
      icon: Icon(LineIcons.angle_right_solid, color: Colors.white),
    );
  }

  Widget _symptoms() {
    var title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Covid-19", style: TextStyles.pageSubHeader.copyWith(fontWeight: FontWeight.normal)),
        Text("Symptoms", style: TextStyles.pageH2),
      ],
    );

    List<Symptom> symptoms = [
      Symptom(name: "Chest Pain", description: "Pain or pressure in chest"),
      Symptom(name: "Breathing Issues", description: "Shortness of breath"),
      Symptom(name: "Fever", description: "Mild to high fever"),
      Symptom(name: "Body Aches", description: "Sever body aches and chills"),
    ];
    
    var gridView = StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      itemCount: symptoms.length,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      itemBuilder: (context, index) {
        Symptom symptom = symptoms[index];
        return Container(
          padding: EdgeInsets.all(24),
          height: index.isEven ? 200 : 230,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: UIValues.boxShadow
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(symptom.name, style: TextStyles.dataHeader.copyWith(color: Colors.black)),
              Text(symptom.description, style: TextStyle(color: Colors.black)),
            ],
          ),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title,
        SizedBox(height: 24),
        gridView
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(24.0),
      children: <Widget>[
        _title(),
        SizedBox(height: 18),
        _selfCheckCard(),
        SizedBox(height: 13),
        _safeHabitsCard(),
        SizedBox(height: 24),
        _symptoms()
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final Function onClick;
  final String title;
  final String description;
  final Color color;
  final Icon icon;

  _HeaderCard({this.onClick, @required this.title, @required this.description, @required this.color, @required this.icon})
  : assert(title != null),
    assert(description != null),
    assert(color != null),
    assert(icon != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color,
            boxShadow: UIValues.boxShadow
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width-96-24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: TextStyles.pageSubHeader.copyWith(color: Colors.white)),
                  SizedBox(height: 14),
                  Text(description, style: TextStyle(color: Colors.white))
                ],
              ),
            ),
            Center(
              child: icon,
            )
          ],
        ),
      ),
    );
  }

}