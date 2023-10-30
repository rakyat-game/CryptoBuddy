enum SortingMetric {
  marketCap(name: 'Market Cap', longName: 'Market Capitalization'),
  hour(name: '1h', longName: '1 hour'),
  day(name: '1d', longName: '1 day'),
  week(name: '1w', longName: '1 week'),
  month(name: '1m', longName: '1 month'),
  year(name: '1y', longName: '1 year');

  const SortingMetric({required this.name, required this.longName});

  final String name;
  final String longName;
}
