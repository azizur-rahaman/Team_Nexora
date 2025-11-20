import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

import 'core/network/network_info.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login.dart';
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

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      login: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
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

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  //! External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
