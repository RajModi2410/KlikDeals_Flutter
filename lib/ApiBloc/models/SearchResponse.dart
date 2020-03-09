import 'package:klik_deals/commons/ApiResponse.dart';

class SearchResponse extends ApiResponse{
  int resultsFound;
  int resultsStart;
  int resultsShown;
  List<Restaurants> restaurants;

  SearchResponse({this.resultsFound,
    this.resultsStart,
    this.resultsShown,
    this.restaurants}): super.error(false);

  SearchResponse.fromJson(Map<String, dynamic> json): super.error(false) {
    resultsFound = json['results_found'];
    resultsStart = json['results_start'];
    resultsShown = json['results_shown'];
    if (json['restaurants'] != null) {
      restaurants = new List<Restaurants>();
      json['restaurants'].forEach((v) {
        restaurants.add(new Restaurants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['results_found'] = this.resultsFound;
    data['results_start'] = this.resultsStart;
    data['results_shown'] = this.resultsShown;
    if (this.restaurants != null) {
      data['restaurants'] = this.restaurants.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  bool isTokenError() {
    
    return false;
  }
}

class Restaurants {
  Restaurant restaurant;

  Restaurants({this.restaurant});

  Restaurants.fromJson(Map<String, dynamic> json) {
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant.toJson();
    }
    return data;
  }
}

class Restaurant {
  String id;
  String name;
  String url;
  Location location;
  String cuisines;
  String timings;
  int averageCostForTwo;
  int priceRange;
  String currency;
  String thumb;
  UserRating userRating;
  int allReviewsCount;
  String photosUrl;
  String menuUrl;
  String featuredImage;

  Restaurant({this.id,
    this.name,
    this.url,
    this.location,
    this.cuisines,
    this.timings,
    this.averageCostForTwo,
    this.priceRange,
    this.currency,
    this.thumb,
    this.userRating,
    this.allReviewsCount,
    this.photosUrl,
    this.menuUrl,
    this.featuredImage});

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    cuisines = json['cuisines'];
    timings = json['timings'];
    averageCostForTwo = json['average_cost_for_two'];
    priceRange = json['price_range'];
    currency = json['currency'];

    thumb = json['thumb'];
    userRating = json['user_rating'] != null
        ? new UserRating.fromJson(json['user_rating'])
        : null;
    allReviewsCount = json['all_reviews_count'];
    photosUrl = json['photos_url'];

    menuUrl = json['menu_url'];
    featuredImage = json['featured_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }

    data['cuisines'] = this.cuisines;
    data['timings'] = this.timings;
    data['average_cost_for_two'] = this.averageCostForTwo;
    data['price_range'] = this.priceRange;
    data['currency'] = this.currency;
    data['thumb'] = this.thumb;
    if (this.userRating != null) {
      data['user_rating'] = this.userRating.toJson();
    }
    data['all_reviews_count'] = this.allReviewsCount;
    data['photos_url'] = this.photosUrl;
    data['menu_url'] = this.menuUrl;
    data['featured_image'] = this.featuredImage;
    return data;
  }
}

class HasMenuStatus {
  int delivery;
  int takeaway;

  HasMenuStatus({this.delivery, this.takeaway});

  HasMenuStatus.fromJson(Map<String, dynamic> json) {
    delivery = json['delivery'];
    takeaway = json['takeaway'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivery'] = this.delivery;
    data['takeaway'] = this.takeaway;
    return data;
  }
}

class Location {
  String address;
  String locality;
  String city;
  int cityId;
  String latitude;
  String longitude;
  String zipCode;
  int countryId;
  String localityVerbose;

  Location({this.address,
    this.locality,
    this.city,
    this.cityId,
    this.latitude,
    this.longitude,
    this.zipCode,
    this.countryId,
    this.localityVerbose});

  Location.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    locality = json['locality'];
    city = json['city'];
    cityId = json['city_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zipCode = json['zipcode'];
    countryId = json['country_id'];
    localityVerbose = json['locality_verbose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['locality'] = this.locality;
    data['city'] = this.city;
    data['city_id'] = this.cityId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['zipcode'] = this.zipCode;
    data['country_id'] = this.countryId;
    data['locality_verbose'] = this.localityVerbose;
    return data;
  }
}

class UserRating {
  String aggregateRating;
  String ratingText;
  String ratingColor;
  RatingObj ratingObj;
  String votes;

  UserRating({this.aggregateRating,
    this.ratingText,
    this.ratingColor,
    this.ratingObj,
    this.votes});

  UserRating.fromJson(Map<String, dynamic> json) {
    if (json['aggregate_rating'] is String) {
      aggregateRating = json['aggregate_rating'].toString();
    } else {
      aggregateRating = "$json['aggregate_rating']";
    }
    ratingText = json['rating_text'];
    ratingColor = json['rating_color'];
    ratingObj = json['rating_obj'] != null
        ? new RatingObj.fromJson(json['rating_obj'])
        : null;
    if (json['votes'] is String) {
      votes = json['votes'];
    } else {
      aggregateRating = "$json['votes']";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aggregate_rating'] = this.aggregateRating;
    data['rating_text'] = this.ratingText;
    data['rating_color'] = this.ratingColor;
    if (this.ratingObj != null) {
      data['rating_obj'] = this.ratingObj.toJson();
    }
    data['votes'] = this.votes;
    return data;
  }
}

class RatingObj {
  Title title;
  BgColor bgColor;

  RatingObj({this.title, this.bgColor});

  RatingObj.fromJson(Map<String, dynamic> json) {
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    bgColor = json['bg_color'] != null
        ? new BgColor.fromJson(json['bg_color'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.title != null) {
      data['title'] = this.title.toJson();
    }
    if (this.bgColor != null) {
      data['bg_color'] = this.bgColor.toJson();
    }
    return data;
  }
}

class Title {
  String text;

  Title({this.text});

  Title.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    return data;
  }
}

class BgColor {
  String type;
  String tint;

  BgColor({this.type, this.tint});

  BgColor.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    tint = json['tint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['tint'] = this.tint;
    return data;
  }
}

class User {
  String name;
  String zomatoHandle;
  String foodieLevel;
  int foodieLevelNum;
  String foodieColor;
  String profileUrl;
  String profileImage;
  String profileDeeplink;

  User({this.name,
    this.zomatoHandle,
    this.foodieLevel,
    this.foodieLevelNum,
    this.foodieColor,
    this.profileUrl,
    this.profileImage,
    this.profileDeeplink});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    zomatoHandle = json['zomato_handle'];
    foodieLevel = json['foodie_level'];
    foodieLevelNum = json['foodie_level_num'];
    foodieColor = json['foodie_color'];
    profileUrl = json['profile_url'];
    profileImage = json['profile_image'];
    profileDeeplink = json['profile_deeplink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['zomato_handle'] = this.zomatoHandle;
    data['foodie_level'] = this.foodieLevel;
    data['foodie_level_num'] = this.foodieLevelNum;
    data['foodie_color'] = this.foodieColor;
    data['profile_url'] = this.profileUrl;
    data['profile_image'] = this.profileImage;
    data['profile_deeplink'] = this.profileDeeplink;
    return data;
  }
}
