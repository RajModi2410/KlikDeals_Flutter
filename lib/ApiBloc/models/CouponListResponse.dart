class CouponListResponse {
  bool status;
  String message;
  Data response;

  CouponListResponse({this.status, this.message, this.response});

  CouponListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    response = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.response != null) {
      data['data'] = this.response.toJson();
    }
    return data;
  }
}

class Coupon {
  int currentPage;
  List<Coupon> data;
  int from;
  String nextPageUrl;
  String path;
  String perPage;
  Null prevPageUrl;
  int to;

  Coupon(
      {this.currentPage,
      this.data,
      this.from,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to});

  Coupon.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = new List<Coupon>();
      json['data'].forEach((v) {
        data.add(new Coupon.fromJson(v));
      });
    }
    from = json['from'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['from'] = this.from;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    return data;
  }
}

class Data {
  int id;
  String vendorId;
  Null reddemBy;
  String couponCode;
  String description;
  String status;
  Null grabDate;
  Null approvedBy;
  Null approvedDate;
  Null approvedLatLong;
  Null displayCount;
  String startDate;
  String endDate;

  Data(
      {this.id,
      this.vendorId,
      this.reddemBy,
      this.couponCode,
      this.description,
      this.status,
      this.grabDate,
      this.approvedBy,
      this.approvedDate,
      this.approvedLatLong,
      this.displayCount,
      this.startDate,
      this.endDate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    reddemBy = json['reddem_by'];
    couponCode = json['coupon_code'];
    description = json['description'];
    status = json['status'];
    grabDate = json['grab_date'];
    approvedBy = json['approved_by'];
    approvedDate = json['approved_date'];
    approvedLatLong = json['approved_lat_long'];
    displayCount = json['display_count'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['reddem_by'] = this.reddemBy;
    data['coupon_code'] = this.couponCode;
    data['description'] = this.description;
    data['status'] = this.status;
    data['grab_date'] = this.grabDate;
    data['approved_by'] = this.approvedBy;
    data['approved_date'] = this.approvedDate;
    data['approved_lat_long'] = this.approvedLatLong;
    data['display_count'] = this.displayCount;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}
