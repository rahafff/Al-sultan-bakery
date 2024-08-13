import 'package:get_it/get_it.dart';
import 'package:grocerymart/injection_container.config.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
void configureDependencies(String env) => getIt.init(environment: env);


