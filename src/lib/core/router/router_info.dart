enum RouterInfo {
  home(name: 'home', path: '/home'),
  ignoreNumbers(name: 'ignoreNumbers', path: '/ignoreNumbers'),
  currentStatus(name: 'currentStatus', path: '/currentStatus');

  const RouterInfo({
    required this.name,
    required this.path,
  });

  final String name;
  final String path;
}
