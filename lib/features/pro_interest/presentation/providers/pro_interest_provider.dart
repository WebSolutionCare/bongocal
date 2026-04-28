import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../data/datasources/pro_interest_remote_datasource.dart';
import '../../data/repositories/pro_interest_repository_impl.dart';
import '../../domain/repositories/pro_interest_repository.dart';

final Provider<http.Client> proInterestHttpClientProvider =
    Provider<http.Client>(
  (Ref ref) {
    final http.Client client = http.Client();
    ref.onDispose(client.close);
    return client;
  },
);

final Provider<ProInterestRemoteDataSource>
    proInterestRemoteDataSourceProvider =
    Provider<ProInterestRemoteDataSource>(
  (Ref ref) => ProInterestRemoteDataSource(
    client: ref.watch(proInterestHttpClientProvider),
  ),
);

final Provider<ProInterestRepository> proInterestRepositoryProvider =
    Provider<ProInterestRepository>(
  (Ref ref) => ProInterestRepositoryImpl(
    dataSource: ref.watch(proInterestRemoteDataSourceProvider),
  ),
);
