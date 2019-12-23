import 'package:exchangilymobileapp/services/api.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:provider/provider.dart';

List<SingleChildCloneableWidget> providers = [];

List<SingleChildCloneableWidget> independentServices = [
  Provider.value(value: Api())
];
List<SingleChildCloneableWidget> dependentServices = [];
List<SingleChildCloneableWidget> uiConsumableProviders = [];
