import '../model/mode.dart';

String apiKey ='33nkQamxd1KypFv83U06RGIW6nMMEpfS8We6XYLqgZt9ppc3c1IDxR8a';

List<Categories> getCategories() {
  List<Categories> categories = [];

  Categories categoriesmodel = Categories();

  categoriesmodel.imgUrl = 'https://images.pexels.com/photos/1647121/pexels-photo-1647121.jpeg?auto=compress&cs=tinysrgb&w=600';
  categoriesmodel.CategoriesName = 'Street Arts';
  categories.add(categoriesmodel);
  categoriesmodel = Categories();

  categoriesmodel.imgUrl = 'https://images.pexels.com/photos/1034559/pexels-photo-1034559.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  categoriesmodel.CategoriesName = 'Wildlife';
  categories.add(categoriesmodel);
  categoriesmodel = Categories();

  categoriesmodel.imgUrl = 'https://images.pexels.com/photos/169647/pexels-photo-169647.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  categoriesmodel.CategoriesName = 'City';
  categories.add(categoriesmodel);
  categoriesmodel = Categories();

  categoriesmodel.imgUrl = 'https://images.pexels.com/photos/3408744/pexels-photo-3408744.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  categoriesmodel.CategoriesName = 'Nature';
  categories.add(categoriesmodel);
  categoriesmodel = Categories();

  categoriesmodel.imgUrl = 'https://images.pexels.com/photos/21696/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=600';
  categoriesmodel.CategoriesName = 'Motivation';
  categories.add(categoriesmodel);
  categoriesmodel = Categories();

  categoriesmodel.imgUrl = 'https://images.pexels.com/photos/2116475/pexels-photo-2116475.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  categoriesmodel.CategoriesName = 'Bikes';
  categories.add(categoriesmodel);
  categoriesmodel = Categories();

  categoriesmodel.imgUrl = 'https://images.pexels.com/photos/70912/pexels-photo-70912.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  categoriesmodel.CategoriesName = 'Cars';
  categories.add(categoriesmodel);
  categoriesmodel = Categories();

  return categories;
}
