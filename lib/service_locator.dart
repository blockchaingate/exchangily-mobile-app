import 'package:exchangilymobileapp/services/api.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/view_models/create_password_view_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void serviceLocator() {
  locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton(() => WalletService());
  locator.registerLazySingleton(() => CreatePasswordViewModel());
}
