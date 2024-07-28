class RegattaManager {
  static final List<Boat> boats = initBoats();

  static List<Boat> initBoats() {
    List<Boat> list = [];
    list.add(Boat(" 900", 0));
    list.add(Boat("1000", 200));
    list.add(Boat("1000", 210));
    return list;
  }
}

class Boat {
  String distance;
  double rowed = 0;

  Boat(this.distance, this.rowed);
}
