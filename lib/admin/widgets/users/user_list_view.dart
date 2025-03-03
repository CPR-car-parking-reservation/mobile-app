import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:car_parking_reservation/model/admin/users.dart';

class AdminListViewUser extends StatefulWidget {
  final List<ModelUsers> users;

  const AdminListViewUser({super.key, required this.users});

  @override
  State<AdminListViewUser> createState() => _AdminListViewUserState();
}

class _AdminListViewUserState extends State<AdminListViewUser> {
  Map<int, bool> isExpanded = {};
  @override
  Widget build(BuildContext context) {
    String baseUrl = dotenv.env['BASE_URL'].toString();
    return SizedBox(
      height: 600,
      child: Scrollbar(
        child: ListView.separated(
          itemBuilder: (context, index) {
            final user = widget.users[index];
            final fullName = '${user.name} ${user.surname}';
            final car_data = user.cars;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(
                      color: const Color.fromARGB(255, 203, 203, 203),
                      width: 1.5),
                ),
                child: Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    trailing: Icon(
                      isExpanded[index] ?? false
                          ? Icons.arrow_drop_up_sharp
                          : Icons.arrow_drop_down_sharp,
                      size: 35,
                      color: Colors.red.shade400,
                    ),
                    onExpansionChanged: (value) {
                      setState(() => isExpanded[index] = value);
                    },
                    title: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage('$baseUrl${user.image_url}'),
                          radius: 30,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Name : ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Amiko",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      fullName,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontFamily: "Amiko",
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Email : ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Amiko",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      user.email,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Amiko",
                                        fontSize: 15,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Phone : ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "Amiko",
                                      fontWeight: FontWeight.w700,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    user.phone,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "Amiko",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    children: [
                      car_data.isEmpty
                          ? Column(
                              children: [
                                SizedBox(height: 20),
                                const Text(
                                  "No cars registered",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Amiko"),
                                ),
                                SizedBox(height: 20),
                              ],
                            )
                          : Column(
                              children: car_data
                                  .map((car) => ListTile(
                                        title: Row(
                                          children: [
                                            Text(
                                              "License plate : ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: "Amiko",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              car.license_plate,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: "Amiko",
                                              ),
                                            ),
                                          ],
                                        ),
                                        subtitle: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            car.car_type == "Fuels"
                                                ? Icon(
                                                    Icons.local_gas_station,
                                                    size: 15,
                                                  )
                                                : Icon(
                                                    Icons.battery_charging_full,
                                                    size: 15,
                                                  ),
                                            const SizedBox(width: 5),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 3),
                                              child: Text(
                                                car.car_model,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily: "Amiko",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        leading: Image.network(
                                          baseUrl + car.image_url,
                                          width: 80,
                                          height: 80,
                                        ),
                                      ))
                                  .toList(),
                            )
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 5);
          },
          itemCount: widget.users.length,
        ),
      ),
    );
  }
}
