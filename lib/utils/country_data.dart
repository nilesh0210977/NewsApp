class CountryData {
  final String name;
  final String code;
  final String flag;

  CountryData({
    required this.name,
    required this.code,
    required this.flag,
  });
}

List<CountryData> countries = [
  CountryData(name: 'United States', code: 'us', flag: '🇺🇸'),
  CountryData(name: 'United Kingdom', code: 'gb', flag: '🇬🇧'),
  CountryData(name: 'India', code: 'in', flag: '🇮🇳'),
  CountryData(name: 'Australia', code: 'au', flag: '🇦🇺'),
  CountryData(name: 'Canada', code: 'ca', flag: '🇨🇦'),
  CountryData(name: 'Germany', code: 'de', flag: '🇩🇪'),
  CountryData(name: 'France', code: 'fr', flag: '🇫🇷'),
  CountryData(name: 'Japan', code: 'jp', flag: '🇯🇵'),
];