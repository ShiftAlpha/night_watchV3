class Location {
  final int id =0;

  static List<Location> fetchAll(){
  return[
    Location(),
    Location(),
    Location()
  ];
}

}




class Items {
  String title;
  String subtitle;
  String event;
  String img;
  Items({required this.title, required this.subtitle, required this.event, required this.img});
}