class RecipeRating {
  double? averageRating;
  int? numOfReviews;
  double? sumOfAllRating;
  List<String>? userAlreadyReview;

  RecipeRating({
    this.averageRating,
    this.numOfReviews,
    this.sumOfAllRating,
    this.userAlreadyReview,
  });

  RecipeRating.fromJson(Map<String, dynamic> json) {
    averageRating = double.parse("${json['average_rating']}");
    numOfReviews = json['num_of_reviews'];
    sumOfAllRating = double.parse("${json['sum_of_all_rating']}");
    userAlreadyReview = json['user_already_review'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average_rating'] = this.averageRating;
    data['num_of_reviews'] = this.numOfReviews;
    data['sum_of_all_rating'] = this.sumOfAllRating;
    data['user_already_review'] = this.userAlreadyReview;
    return data;
  }
}
