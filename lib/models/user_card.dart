class UserCard {
  late String cardNumber;
  late String expiryDate;
  late String cardHolderName;
  late String cvvCode;

  UserCard({
    this.cardNumber = '',
    this.expiryDate = '',
    this.cardHolderName = '',
    this.cvvCode = '',
  });

  UserCard.fromJson(Map<String, dynamic>? json) {
    cardNumber = json?['cardNumber'] ?? "";
    expiryDate = json?['expiryDate'] ?? "";
    cardHolderName = json?['cardHolderName'] ?? "";
    cvvCode = json?['cvvCode'] ?? "";
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["cardNumber"] = cardNumber;
    data["expiryDate"] = expiryDate;
    data["cardHolderName"] = cardHolderName;
    data["cvvCode"] = cvvCode;
    return data;
  }
}

class UserCards {
  late List<UserCard> items;

  UserCards({
    required this.items,
  });

  UserCards.fromJson(Map<String, dynamic>? json) {
    items = [];
    if (json != null) {
      var aa = json['items'];
      if (aa is List<dynamic>) {
        for (var value in aa) {
          items.add(UserCard.fromJson(value));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["items"] = items.map((e) => e.toJson());
    return data;
  }
}
