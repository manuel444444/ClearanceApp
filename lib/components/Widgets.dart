import 'package:clearanceapp/screens/HOD/Hod_StudentProfile.dart';
import 'package:clearanceapp/screens/STU/menu_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class Button1 extends StatelessWidget {
  final String text;
  final studentID;

  const Button1({
    super.key,
    required this.text,
    required this.studentID
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
          elevation: MaterialStatePropertyAll(8),
          backgroundColor: MaterialStatePropertyAll(Color(0xFF20607B)),
          padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 90, vertical: 12))),
     onPressed: () {

     },
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
      ),
    );
  }
}

//Button 2

class Button2 extends StatelessWidget {
  final VoidCallback onPressed;

  const Button2({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
          elevation: MaterialStatePropertyAll(8),
          backgroundColor: MaterialStatePropertyAll(Color(0xFF20607B)),
          padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 90, vertical: 1))),
      onPressed:
        onPressed ,

      child: const Text(
        "view summary",
        style: TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

//OVERVIEWCARD

class OverviewCard extends StatefulWidget {
  final String header;
  final String status;
  final String comments;
  final VoidCallback onPressed;

  const OverviewCard({
    super.key,
    required this.header,
    required this.status,
    required this.comments,
    required this.onPressed,
  });

  @override
  State<OverviewCard> createState() => _OverviewCardState();
}

class _OverviewCardState extends State<OverviewCard> {

  @override
  final int truncateLength = 19;


  Widget build(BuildContext context) {
    final String truncatedText = widget.comments.length > truncateLength
        ? widget.comments.substring(0, truncateLength) + '...'
        : widget.comments;
    return Container(
      height: 167,
      width: 359,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: const Color(0xFFA6C4CA)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.header,
                style: const TextStyle(
                  color: Color(0xFF003F4D),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                )),
            Row(
              children: [
                Text("Status: " ,style: const TextStyle(
                color: Color(0xFF003F4D),
        fontSize: 15,
      )),
                Text("${widget.status}",
                    style:
                    widget.status  =="Cleared"?
                    const TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                    ):widget.status== "Pending"?
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ):
                    const TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                    )
                ),
              ],
            ),
            Row(
              children: [
                Text("Comments: ",
            style: const TextStyle(
                color: Color(0xFF003F4D),
        fontSize: 15,
      )
                ),

                Text(
                    widget.status  =="Cleared" && widget.header=="ACCOUNTANT"?
                        "Arreares have been cleared":
                    widget.status  =="Cleared" && widget.header=="LIBRARY"?
                    "Arreares have been cleared":
                     widget.header=="HOD"?
                     "$truncatedText":
                         "You have arrears to clear"

                ,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    )),
              ],
            ),
            Center(
              child:  ElevatedButton(
                style: const ButtonStyle(
                    elevation: MaterialStatePropertyAll(8),
                    backgroundColor: MaterialStatePropertyAll(Color(0xFF20607B)),
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 90, vertical: 1))),

                onPressed: () {
                  widget.header=="HOD"?
                      QuickAlert.show(context: context, type: QuickAlertType.info ,text: "${widget.comments}"):
                  QuickAlert.show(context: context, type: QuickAlertType.error);
                },
                child: const Text(
                  "view summary",
                  style: TextStyle(
                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Notification Card

class NotificationCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Widget screen;

  const NotificationCard(
      {super.key,
      required this.text,
      required this.icon,
      required this.screen});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: Colors.white,
              ),
              const SizedBox(
                width: 41,
              ),
              Text(
                text,
                style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => screen,
            ),
            (route) => false,
          );
        },
      ),
    );
  }
}

//Dash tittle

class Dash_title extends StatefulWidget {
  final String text;
  final studentID;

  const Dash_title({
    super.key,
    required this.text,
    required this.studentID
  });

  @override
  State<Dash_title> createState() => _Dash_titleState();
}

class _Dash_titleState extends State<Dash_title> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 21),
      child: Row(
        children: [
          Text(
            widget.text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 23, color: Colors.white),
          ),
          const Spacer(),
          GestureDetector(
            child: const Icon(
              Icons.menu_rounded,
              size: 24,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>  Menu_page(studentID: widget.studentID),
              ));
            },
          ),
        ],
      ),
    );
  }
}

//Card profile

class Card_profile extends StatelessWidget {
  final String Profile;

  const Card_profile({super.key, required this.Profile});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 50,
      child: Text("ddd"),
    );
  }
}

//ClearanceCard

class Clearance_card extends StatelessWidget {
  final String Name;
  final String Course;
  final String Student_num;
  final String Profile;


  const Clearance_card(
      {super.key,
      required this.Name,
      required this.Course,
      required this.Profile,
      required this.Student_num,
      });

  @override
  Widget build(BuildContext context) {
    return


      Container(
        margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21), color: Colors.white),

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card_profile(Profile: Profile),
                  const SizedBox(
                    width: 13,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold )),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(Course,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(Student_num,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  )
                ],
              ),
              const Spacer(),
              const Icon(Icons.arrow_right)
            ],
          ),
        ),
    );
  }
}

// search
class NeumorphicSearchField extends StatelessWidget {
  const NeumorphicSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 21),
      child: PrimaryContainer(
        child: TextField(
          onChanged: (value) {},
          style: const TextStyle(fontSize: 16, color: Colors.white),
          textAlignVertical: TextAlignVertical.center,
          controller: TextEditingController(),
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 3),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: 'Search',
              suffixIcon: Container(
                width: 70,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color(0XFF5E5E5E),
                      Color(0XFF3E3E3E),
                    ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    borderRadius: BorderRadius.circular(30)),
                child: const Icon(Icons.search, color: Color(0xFF222222)),
              ),
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey)),
        ),
      ),
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? color;

  const PrimaryContainer({
    Key? key,
    this.radius,
    this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 30),
        boxShadow: [
          BoxShadow(
            color: color ?? const Color(0XFF1E1E1E),
          ),
          const BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Colors.black,
          ),
        ],
      ),
      child: child,
    );
  }
}

//Profile Card

class Profile_card extends StatelessWidget {
  final String Profile;
  final String Name;
  final String Program;
  final String Level;

  const Profile_card(
      {super.key,
      required this.Profile,
      required this.Name,
      required this.Program,
      required this.Level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 7,
      ),
      height: 82,
      width: 353,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          Card_profile(Profile: Profile),
          const SizedBox(width: 19),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(Name), Text("$Program - $Level")],
          )
        ],
      ),
    );
  }
}

class StudentInfoCard extends StatelessWidget {
  final String Fees;

  final String Books;

  final String Deferment;

  final String Trailed;

  final String Project;

  final String Internship;

  const StudentInfoCard(
      {super.key,
      required this.Fees,
      required this.Books,
      required this.Deferment,
      required this.Trailed,
      required this.Project,
      required this.Internship});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 28),
      width: 365,
      height: 458,
      decoration: BoxDecoration(
          color: const Color(0xFF0B222D),
          borderRadius: BorderRadius.circular(35)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //1
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Accountant",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.white),
                ),
                Row(
                  children: [
                    const Text("FEES PAID  ",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.white)),
                    Text(Fees,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          //2
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Library",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.white)),
                Text("$Books",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white)),
              ],
            ),
          ),
          //3
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Deferement Status",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.white)),
                Text("$Deferment",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white)),
              ],
            ),
          ),
          //4
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Trailed Status",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.white)),
                Text("$Trailed",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white)),
              ],
            ),
          ),
          //5
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Project Status",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.white)),
                Text("$Project",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white)),
              ],
            ),
          ),
          //
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Internship Requirement",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.white)),
                Text("$Internship",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//Curved CARD

class Curved_card extends StatelessWidget {
  final Widget Fidget;

  const Curved_card({super.key, required this.Fidget});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 37, left: 16, right: 16),
        decoration: const BoxDecoration(
          borderRadius:const BorderRadius.only(
              topLeft:const Radius.circular(30), topRight:const Radius.circular(30)),
          color:const Color(0xFFD7E4E6),
        ),
        child: Fidget,
      ),
    );
  }
}

////////////
class TabItem extends StatelessWidget {
  final String title;
  final int count;

  const TabItem({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
          ),
          count > 0
              ? Container(
                  margin: const EdgeInsetsDirectional.only(start: 5),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      count > 9 ? "9+" : count.toString(),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
              : const SizedBox(width: 0, height: 0),
        ],
      ),
    );
  }
}
