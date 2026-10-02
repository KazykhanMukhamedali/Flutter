class Contact {
  const Contact({
    required this.name,
    required this.email,
    this.avatar = '',
    this.unread = 0,
    this.role = '',
    this.clanColor = 0xFF6A5ACD,
  });

  final String name;
  final String email;
  final String avatar;
  final int unread;
  final String role;
  final int clanColor;

  String get initial => name.isEmpty ? '?' : name[0];
}

const _data = [
  ('Naruto Uzumaki',  'Seventh Hokage',  0xFFF4A300, 3, 'assets/avatars/naruto.png'),
  ('Sasuke Uchiha',   'Shadow Hokage',   0xFF4A4A8A, 2, 'assets/avatars/sasuke.png'),
  ('Sakura Haruno',   'Head Medic',      0xFFE85D75, 0, 'assets/avatars/sakura.png'),
  ('Kakashi Hatake',  'Sixth Hokage',    0xFF8C8C8C, 1, 'assets/avatars/kakashi.png'),
  ('Hinata Hyuga',    'Clan Heiress',    0xFF9B8BC4, 0, 'assets/avatars/hinata.png'),
  ('Rock Lee',        'Taijutsu Master', 0xFF2E7D32, 0, 'assets/avatars/rocklee.png'),
  ('Gaara',           'Fifth Kazekage',  0xFFA52A2A, 5, 'assets/avatars/gaara.png'),
  ('Itachi Uchiha',   'Akatsuki',        0xFF2B2B4F, 9, 'assets/avatars/itachi.png'),
  ('Jiraiya',         'Pervy Sage',      0xFFE5E5E5, 0, 'assets/avatars/jiraiya.png'),
  ('Tsunade',         'Fifth Hokage',    0xFFF2C46B, 1, 'assets/avatars/tsunade.png'),
  ('Orochimaru',      'Sannin',          0xFFB39DDB, 0, 'assets/avatars/orochimaru.png'),
  ('Minato Namikaze', 'Fourth Hokage',   0xFFFFD54F, 2, 'assets/avatars/minato.png'),
  ('Tobi',            'Akatsuki',        0xFF37474F, 7, 'assets/avatars/tobi.png'),
  ('Madara Uchiha',   'Legendary',       0xFF4A148C, 4, 'assets/avatars/madara.png'),
];

final contacts = [
  for (var i = 0; i < _data.length; i++)
    Contact(
      name: _data[i].$1,
      role: _data[i].$2,
      clanColor: _data[i].$3,
      unread: _data[i].$4,
      avatar: _data[i].$5,
      email: '${_data[i].$1.split(' ').first.toLowerCase()}@konoha.jp',
    ),
];