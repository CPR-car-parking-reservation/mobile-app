class car_data {
    String id;
    String license_plate;
    String car_model;
    String car_type;
    String user_id;
    String image_url;

    car_data({
        required this.id,
        required this.license_plate,
        required this.car_model,
        required this.car_type,
        required this.user_id,
        required this.image_url,
    });

    factory car_data.fromJson(Map<String, dynamic> json) => car_data(
        id: json["id"] ?? '',
        license_plate: json["license_plate"] ?? '',
        car_model: json["car_model"] ?? '',
        car_type: json["car_type"] ?? '',
        user_id: json["user_id"] ?? '',
        image_url: json["image_url"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "license_plate": license_plate,
        "car_model": car_model,
        "car_type": car_type,
        "user_id": user_id,
        "image_url": image_url,
    };
}