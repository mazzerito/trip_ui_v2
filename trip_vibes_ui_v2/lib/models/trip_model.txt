class Trip {
  final String title;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final double cost;
  final String imageUrl;

  Trip({
    required this.title,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.cost,
    required this.imageUrl,
  });
}

final List<Trip> trips = [
  Trip(
    title: 'Italy Trip',
    location: 'Sant Paulo, Milan, Italy',
    startDate: DateTime(2025, 2, 15),
    endDate: DateTime(2025, 2, 25),
    cost: 450.0,
    imageUrl: 'https://cdn.britannica.com/19/115519-050-D2B15CF0/view-Sao-Paulo.jpg',
  ),
  Trip(
    title: 'Thailand Adventure',
    location: 'Phuket, Thailand',
    startDate: DateTime(2025, 3, 5),
    endDate: DateTime(2025, 3, 15),
    cost: 550.0,
    imageUrl: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1b/4b/5d/c8/caption.jpg?w=1400&h=1400&s=1&cx=2606&cy=1838&chk=v1_a61182fd4040ed4ecc4e',
  ),
  Trip(
    title: 'Japan Exploration',
    location: 'Tokyo, Japan',
    startDate: DateTime(2025, 4, 10),
    endDate: DateTime(2025, 4, 20),
    cost: 750.0,
    imageUrl: 'https://media.cntraveler.com/photos/63482b255e7943ad4006df0b/16:9/w_1920,c_limit/tokyoGettyImages-1031467664.jpeg',
  ),
  Trip(
    title: 'Paris Getaway',
    location: 'Paris, France',
    startDate: DateTime(2025, 5, 12),
    endDate: DateTime(2025, 5, 22),
    cost: 680.0,
    imageUrl: 'https://149990825.v2.pressablecdn.com/wp-content/uploads/2023/09/Paris1.jpg',
  ),
  Trip(
    title: 'New York City Tour',
    location: 'New York City, USA',
    startDate: DateTime(2025, 6, 1),
    endDate: DateTime(2025, 6, 10),
    cost: 900.0,
    imageUrl: 'https://assets.simpleviewinc.com/simpleview/image/upload/c_fill,h_474,q_75,w_640/v1/clients/newyorkstate/5232359e_e163_475c_abe3_0f20af112a8c_ae020bfc-a771-4564-87b7-479fbe55735d.jpg',
  ),
];
