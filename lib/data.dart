import 'model/recipe.dart';
import 'model/cookbook.dart';

const Cookbook_Data = const [
  Cookbook(
    id: 'c1',
    cookbookName: 'Default cookbook',
    imageURLCookbook:
        'https://lacuisinedegeraldine.fr/wp-content/uploads/2021/06/Pancakes-04483-2-scaled.jpg',
  ),
];

const Recipes_Data = const [
  Recipe(
    id: 'r1',
    recipeName: 'Pancakes',
    category: 'c1',
    imageURL:
        'https://lacuisinedegeraldine.fr/wp-content/uploads/2021/06/Pancakes-04483-2-scaled.jpg',
    ingredients: [
      '4 Tomatoes',
      '1 Tablespoon of Olive Oil',
      '1 Onion',
    ],
    steps: [
      'Tenderize the veal to about 2–4mm, and salt on both sides.',
      'On a flat plate, stir the eggs briefly with a fork.',
      'Lightly coat the cutlets in flour then dip into the egg, and finally, coat in breadcrumbs.',
    ],
    duration: 30,
  ),
  Recipe(
    id: 'r2',
    recipeName: 'Orange Mousse',
    category: 'c1',
    imageURL:
        'https://amandascookin.com/wp-content/uploads/2021/03/Whipped-Jello-Mandarin-Orange-Mousse-SQ.jpg',
    ingredients: [
      '4 Tomatoes',
      '1 Tablespoon of Olive Oil',
      '1 Onion',
    ],
    steps: [
      'Tenderize the veal to about 2–4mm, and salt on both sides.',
      'On a flat plate, stir the eggs briefly with a fork.',
      'Lightly coat the cutlets in flour then dip into the egg, and finally, coat in breadcrumbs.',
    ],
    duration: 30,
  ),
];
