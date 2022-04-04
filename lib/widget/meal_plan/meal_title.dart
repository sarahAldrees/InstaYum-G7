import 'package:flutter/material.dart';

class MealTitle extends StatefulWidget {
  final String title;
  final String description;

  MealTitle(
    this.title,
    this.description,
  );

  @override
  _MealTitleState createState() => _MealTitleState();
}

class _MealTitleState extends State<MealTitle> {
  @override
  Widget build(BuildContext context) {
    // RawMaterialButton _buildFavoriteButton() {
    // return RawMaterialButton(
    //   constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0),
    //   onPressed: () => onFavoriteButtonPressed(recipe.id),
    //   child: Icon(
    //     // Conditional expression:
    //     // show "favorite" icon or "favorite border" icon depending on widget.inFavorites:
    //     inFavorites == true ? Icons.favorite : Icons.favorite_border,
    //   ),
    //   elevation: 2.0,
    //   fillColor: Colors.white,
    //   shape: CircleBorder(),
    // );
    // }

    Padding _buildTitleSection() {
      return Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          // Default value for crossAxisAlignment is CrossAxisAlignment.center.
          // We want to align title and description of recipes left:
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              // RECIPE TITLE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
              "egg",
            ),
            // Empty space:
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(
                  Icons.restaurant_rounded,
                  size: 20.0,
                  color: Colors.grey[600],
                ), // change
                SizedBox(width: 5.0),
                Text("Breakfast" // THE TYPE OF RECIPE!!!!!!!!!!!!!!!!!!!!!!!!!1
                    ),
              ],
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => print("Tapped!"),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // We overlap the image and the button by
              // creating a Stack object:
              Stack(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 16.0 / 9.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        image: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/recpie_image%2Fhow-to-fry-an-egg-3-1200.jpg%7D?alt=media&token=8f05b8a2-5a3c-454d-ae1b-8fe08497f2b2"),
                        //   "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/recpie_image%2FdefaultRecipeImage.png?alt=media&token=f12725db-646b-4692-9ccf-131a99667e43"),
                        fit: BoxFit.cover,
                      ),
                    ),

                    //  Image.network(
                    //   // RECIPE IMAGE
                    //   "https://firebasestorage.googleapis.com/v0/b/instayum-f7a34.appspot.com/o/recpie_image%2FdefaultRecipeImage.png?alt=media&token=f12725db-646b-4692-9ccf-131a99667e43",
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  // Positioned(
                  //   // child: _buildFavoriteButton(),
                  //   top: 2.0,
                  //   right: 2.0,
                  // ),
                ],
              ),
              _buildTitleSection(),
            ],
          ),
        ),
      ),
    );
  }
}

    // return Container(
    //   margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
    //   height: 136,
    //   width: 50,
    //   decoration: const BoxDecoration(
    //     color: Colors.black12,
    //     borderRadius: BorderRadius.all(Radius.circular(20)),
    //   ),
    //   child:
    //       //Padding(
    //       // padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
    //       // child:
    //       Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Text(
    //         widget.title,
    //         style: const TextStyle(
    //             color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
    //         textAlign: TextAlign.center,
    //       ),
    //       const SizedBox(
    //         height: 20,
    //       ),
    //       Text(
    //         widget.description,
    //         style: const TextStyle(
    //           color: Colors.black,
    //           fontSize: 15,
    //         ),
    //         textAlign: TextAlign.center,
    //       ),
    //       const SizedBox(
    //         height: 20,
    //       ),
    //     ],
    //   ),
    //   //  ),
    // );
  

