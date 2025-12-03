import '../resources/resources.dart';
enum DashboardBottomBarEnum { home, progress, motivation, rest, craving }
String dashboardBottomBarIcons(DashboardBottomBarEnum a) {
  switch (a) {
    case DashboardBottomBarEnum.home:
      return R.images.Home;
    case DashboardBottomBarEnum.progress:
      return R.images.shop;
    case DashboardBottomBarEnum.motivation:
      return R.images.book;
    case DashboardBottomBarEnum.rest:
      return R.images.direct;
    case DashboardBottomBarEnum.craving:
      return R.images.user;
  }

}


String dashboardBottomBarTitle(DashboardBottomBarEnum a) {
  switch (a) {
    case DashboardBottomBarEnum.home:
      return "BHBD.";
    case DashboardBottomBarEnum.progress:
      return "Shop";
    case DashboardBottomBarEnum.motivation:
    return "Courses";
    case DashboardBottomBarEnum.rest:
    return "Reset";
    case DashboardBottomBarEnum.craving:
      return "Profile";
  }
}
