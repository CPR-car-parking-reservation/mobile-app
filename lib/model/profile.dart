// ignore: camel_case_types
class Profile_data {
  String id;
  String name;
  String surname;
  String phone ; 
  String email;
  String image_url;
  String role;
  List<Car> cars;

  Profile_data({
    required this.id,
    required this.name,
    required this.surname,
    required this.phone,
    required this.email,
    required this.image_url,
    this.role = 'USER',
    required this.cars,
  });

  factory Profile_data.fromJson(Map<String, dynamic> json) => Profile_data(
        id: json["data"]?["id"] ,
        name: json["data"]?["name"] ,
        surname: json["data"]?["surname"] ,
        phone: json["data"]?["phone"] ,
        email: json["data"]?["email"] ,
        image_url: json["data"]?["image_url"] ,
        role: json["data"]?["role"] ?? 'USER',
        cars: (json["data"]?["car"] as List?)?.map((x) => Car.fromJson(x)).toList() ?? [],
      );

  Map<String, dynamic> toJson() => {
        "data": {
          "id": id,
          "name": name,
          "surname": surname,
          "phone": phone,
          "email": email,
          "image_url": image_url,
          "role": role,
          "Car": cars.map((x) => x.toJson()).toList(),
        },
        "status": 200,
      };
}

class Car {
  String id;
  String car_number;
  String car_model;
  String car_type;
  String image_url;
  String created_at;
  String updated_at;
  String user_id;

  Car({
    required this.id,
    required this.car_number,
    required this.car_model,
    required this.car_type,
    required this.image_url,
    required this.created_at,
    required this.updated_at,
    required this.user_id,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        id: json["id"] ,
        car_number: json["car_number"] ,
        car_model: json["car_model"] ,
        car_type: json["car_type"] ,
        image_url: json["image_url"] ,
        created_at: json["created_at"] ,
        updated_at: json["updated_at"] ,
        user_id: json["user_id"] ,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "car_number": car_number,
        "car_model": car_model,
        "car_type": car_type,
        "image_url": image_url,
        "created_at": created_at,
        "updated_at": updated_at,
        "user_id": user_id,
      };
}
