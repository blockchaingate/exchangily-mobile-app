import 'package:exchangilymobileapp/services/api.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void serviceLocator() {
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => WalletService());
}
