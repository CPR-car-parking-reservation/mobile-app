class car_data {
    String id;
    String car_number;
    String car_model;
    String car_type;
    String user_id;
    String image_url;

    car_data({
        required this.id,
        required this.car_number,
        required this.car_model,
        required this.car_type,
        required this.user_id,
        required this.image_url,
    });

    factory car_data.fromJson(Map<String, dynamic> json) => car_data(
        id: json["id"] ?? '',
        car_number: json["car_number"] ?? '',
        car_model: json["car_model"] ?? '',
        car_type: json["car_type"] ?? '',
        user_id: json["user_id"] ?? '',
        image_url: json["image_url"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "car_number": car_number,
        "car_model": car_model,
        "car_type": car_type,
        "user_id": user_id,
        "image_url": image_url,
    };
}