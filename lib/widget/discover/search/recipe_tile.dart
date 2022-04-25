import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:instayum/model/recipe_rating.dart';

class RecipeTile extends StatefulWidget {
  RecipeTile({
    Key? key,
    this.recipeID,
    this.onTap,
    this.name,
    this.type,
    this.image,
    this.count,
    this.rating = 0.0,
    this.showButton = true,
    this.category,
    this.cuisine,
  }) : super(key: key);
  final bool showButton;
  final String? image, name, type, category, cuisine, recipeID;
  final VoidCallback? onTap;
  final int? count;
  double rating;

  @override
  State<RecipeTile> createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  void initState() {
    super.initState();
    getData();
    //we call the method here to get the data immediately when init the page.
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      onTap: widget.onTap,
      contentPadding: EdgeInsets.zero,
      // User image circle
      leading: Container(
        width: 60,
        height: 50,
        color: Colors.grey[300],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            widget.image ??
                "https://www.pinclipart.com/picdir/big/538-5383281_recipes-app-icon-clipart.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
      //Follow User Display Name
      title: Text(
        '${widget.name ?? ''} ',
        maxLines: 1,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      //Follow UserName
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.type ?? ''}, ${widget.category ?? ''}, ${widget.cuisine ?? ''} ",
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54),
          ),
          SizedBox(height: 5),
          _showRatingAndCount(),
        ],
      ),
    );
  }

  Widget _showRatingAndCount() {
    getData();
    return Row(
      children: [
        //create stars for rating
        Row(
          children: [
            RatingBarIndicator(
              rating: widget.rating,
              itemCount: 5,
              itemSize: 15,
              unratedColor: Colors.grey[400],
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
            ),
            SizedBox(width: 4),
            Text(
              '(${numOfRevewis ?? 0})',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  var numOfRevewis;

  double avg = 0.0;

  getData() async {
    //to get previous rating info from firestor
    await FirebaseFirestore.instance
        //.collection("users")
        // .doc(widget.autherId)
        .collection("recipes")
        .doc(widget.recipeID)
        .collection("rating")
        .doc("recipeRating")
        .snapshots()
        .listen((userData) {
      if (mounted)
        setState(() {
          numOfRevewis = userData.data()!["num_of_reviews"];
          avg = userData.data()!["average_rating"];
          widget.rating = avg;
        });
    });
  }
}
