import 'package:car_parking_reservation/model/admin/users.dart';
import 'package:flutter/material.dart';

class AdminListViewUser extends StatelessWidget {
  final List<ModelUsers> users;

  const AdminListViewUser({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Scrollbar(
          child: ListView.separated(
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // showDialog(
                          //   context: context,
                          //   builder: (context) {
                          //     return DeleteParkingDialog(
                          //       parking: parking,
                          //     );
                          //   },
                          // );
                        },
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: users.length)),
    );
  }
}
