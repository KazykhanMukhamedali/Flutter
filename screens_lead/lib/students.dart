class Student {
  const Student({
    required this.name,
    required this.group,
    required this.email,
    required this.image,
    required this.village,
    required this.rank,
  });

  final String name;
  final String group;
  final String email;
  final String image;
  final String village;
  final String rank;

  Student copyWith({String? name, String? rank}) => Student(
    name: name ?? this.name,
    group: group,
    email: email,
    image: image,
    village: village,
    rank: rank ?? this.rank,
  );
}

final List<Student> students = [
  const Student(
    name: 'Naruto Uzumaki',
    group: 'Konoha',
    email: 'Nine-Tails Jinchuriki',
    image: 'assets/naruto/naruto.png',
    village: 'Hidden Leaf',
    rank: 'Genin',
  ),
  const Student(
    name: 'Sasuke Uchiha',
    group: 'Konoha',
    email: 'Sharingan',
    image: 'assets/naruto/sasuke.png',
    village: 'Hidden Leaf',
    rank: 'Genin',
  ),
  const Student(
    name: 'Sakura Haruno',
    group: 'Konoha',
    email: 'Medical Ninjutsu',
    image: 'assets/naruto/sakura.png',
    village: 'Hidden Leaf',
    rank: 'Genin',
  ),
  const Student(
    name: 'Kakashi Hatake',
    group: 'Konoha',
    email: 'Copy Ninja',
    image: 'assets/naruto/kakashi.png',
    village: 'Hidden Leaf',
    rank: 'Jonin',
  ),
  const Student(
    name: 'Hinata Hyuga',
    group: 'Konoha',
    email: 'Byakugan',
    image: 'assets/naruto/hinata.png',
    village: 'Hidden Leaf',
    rank: 'Genin',
  ),
  const Student(
    name: 'Rock Lee',
    group: 'Konoha',
    email: 'Eight Gates',
    image: 'assets/naruto/rocklee.png',
    village: 'Hidden Leaf',
    rank: 'Genin',
  ),
  const Student(
    name: 'Gaara',
    group: 'Suna',
    email: 'Sand Manipulation',
    image: 'assets/naruto/gaara.png',
    village: 'Hidden Sand',
    rank: 'Genin',
  ),
  const Student(
    name: 'Itachi Uchiha',
    group: 'Akatsuki',
    email: 'Tsukuyomi',
    image: 'assets/naruto/itachi.png',
    village: 'Hidden Leaf',
    rank: 'S-rank (Akatsuki)',
  ),
  const Student(
    name: 'Jiraiya',
    group: 'Konoha',
    email: 'Toad Sage',
    image: 'assets/naruto/jiraiya.png',
    village: 'Hidden Leaf',
    rank: 'Sannin',
  ),
  const Student(
    name: 'Tsunade',
    group: 'Konoha',
    email: 'Strength of a Hundred',
    image: 'assets/naruto/tsunade.png',
    village: 'Hidden Leaf',
    rank: 'Sannin',
  ),
  const Student(
    name: 'Orochimaru',
    group: 'Otogakure',
    email: 'Snake Sage',
    image: 'assets/naruto/orochimaru.png',
    village: 'Hidden Sound',
    rank: 'Sannin (Rogue)',
  ),
  const Student(
    name: 'Minato Namikaze',
    group: 'Konoha',
    email: 'Flying Raijin',
    image: 'assets/naruto/minato.png',
    village: 'Hidden Leaf',
    rank: 'Fourth Hokage',
  ),
  const Student(
    name: 'Tobi',
    group: 'Akatsuki',
    email: 'Kamui',
    image: 'assets/naruto/tobi.png',
    village: 'Unknown',
    rank: 'Unknown',
  ),
  const Student(
    name: 'Madara Uchiha',
    group: 'Akatsuki',
    email: 'Perfect Susanoo',
    image: 'assets/naruto/madara.png',
    village: 'Hidden Leaf',
    rank: 'Legend',
  ),
];