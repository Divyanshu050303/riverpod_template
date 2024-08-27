import 'package:get_it/get_it.dart';
import 'package:instagram_clone/services/hive/hive.dart';

final locator = GetIt.I;
void setUpLoactor() {
  locator.registerSingleton<HiveBoxServices>(HiveBoxServices());
}
