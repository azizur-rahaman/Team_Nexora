import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/network/http_client_interceptor.dart';
import 'core/network/token_storage.dart';
import 'core/network/logging_interceptor.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/inventory/data/datasources/inventory_data_source.dart';
import 'features/inventory/data/repositories/inventory_repository_impl.dart';
import 'features/inventory/domain/repositories/inventory_repository.dart';
import 'features/inventory/domain/usecases/add_inventory_item.dart';
import 'features/inventory/domain/usecases/delete_inventory_item.dart';
import 'features/inventory/domain/usecases/filter_inventory_items.dart';
import 'features/inventory/domain/usecases/get_all_inventory_items.dart';
import 'features/inventory/domain/usecases/update_inventory_item.dart';
import 'features/inventory/presentation/bloc/inventory_bloc.dart';
import 'features/resources/data/datasources/resource_data_source.dart';
import 'features/resources/data/repositories/resource_repository_impl.dart';
import 'features/resources/domain/repositories/resource_repository.dart';
import 'features/resources/domain/usecases/get_all_resources.dart';
import 'features/resources/domain/usecases/get_resource_by_id.dart';
import 'features/resources/domain/usecases/filter_resources.dart';
import 'features/resources/domain/usecases/toggle_bookmark.dart';
import 'features/resources/domain/usecases/increment_views.dart';
import 'features/resources/presentation/bloc/resource_bloc.dart';
import 'features/surplus/data/datasources/surplus_data_source.dart';
import 'features/surplus/data/repositories/surplus_repository_impl.dart';
import 'features/surplus/domain/repositories/surplus_repository.dart';
import 'features/surplus/domain/usecases/get_all_surplus_items.dart';
import 'features/surplus/domain/usecases/get_surplus_item_by_id.dart';
import 'features/surplus/domain/usecases/create_surplus_request.dart';
import 'features/surplus/domain/usecases/increment_surplus_views.dart';
import 'features/surplus/presentation/bloc/surplus_bloc.dart';

final sl = GetIt.instance;

Future<void> init(SharedPreferences sharedPreferences) async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      login: sl(),
      registerUser: sl(),
      logout: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: sl(),
      tokenStorage: sl<TokenProvider>() as TokenStorage,
    ),
  );

  //! Features - Inventory
  // Bloc
  sl.registerFactory(
    () => InventoryBloc(
      getAllItems: sl(),
      addItem: sl(),
      updateItem: sl(),
      deleteItem: sl(),
      filterItems: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllInventoryItems(sl()));
  sl.registerLazySingleton(() => AddInventoryItem(sl()));
  sl.registerLazySingleton(() => UpdateInventoryItem(sl()));
  sl.registerLazySingleton(() => DeleteInventoryItem(sl()));
  sl.registerLazySingleton(() => FilterInventoryItems(sl()));

  // Repository
  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(
      dataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<InventoryDataSource>(
    () => InventoryLocalDataSource(),
  );

  //! Features - Resources
  // Bloc
  sl.registerFactory(
    () => ResourceBloc(
      getAllResources: sl(),
      getResourceById: sl(),
      filterResources: sl(),
      toggleBookmark: sl(),
      incrementViews: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllResources(sl()));
  sl.registerLazySingleton(() => GetResourceById(sl()));
  sl.registerLazySingleton(() => FilterResources(sl()));
  sl.registerLazySingleton(() => ToggleBookmark(sl()));
  sl.registerLazySingleton(() => IncrementViews(sl()));

  // Repository
  sl.registerLazySingleton<ResourceRepository>(
    () => ResourceRepositoryImpl(
      dataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ResourceDataSource>(
    () => ResourceLocalDataSource(),
  );

  //! Features - Surplus
  // Bloc
  sl.registerFactory(
    () => SurplusBloc(
      getAllSurplusItems: sl(),
      getSurplusItemById: sl(),
      createSurplusRequest: sl(),
      incrementSurplusViews: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllSurplusItems(sl()));
  sl.registerLazySingleton(() => GetSurplusItemById(sl()));
  sl.registerLazySingleton(() => CreateSurplusRequest(sl()));
  sl.registerLazySingleton(() => IncrementSurplusViews(sl()));

  // Repository
  sl.registerLazySingleton<SurplusRepository>(
    () => SurplusRepositoryImpl(
      dataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<SurplusDataSource>(
    () => SurplusDataSourceImpl(),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  //! External
  // SharedPreferences is passed as parameter and initialized in main.dart
  sl.registerLazySingleton(() => sharedPreferences);

  // Token Storage
  sl.registerLazySingleton<TokenProvider>(
    () => TokenStorage(sharedPreferences: sl()),
  );

  // HTTP Client with interceptors
  sl.registerLazySingleton<http.Client>(
    () => HttpClientInterceptor(
      inner: http.Client(),
      tokenProvider: sl<TokenProvider>(),
      onRequest: LoggingInterceptor.logRequest,
      onResponse: LoggingInterceptor.logResponse,
      onError: LoggingInterceptor.logError,
    ),
  );

  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
