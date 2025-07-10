// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:one_go/core/di/injection.dart' as _i702;
import 'package:one_go/features/auth/data/repositories/auth_repository.dart'
    as _i272;
import 'package:one_go/features/auth/presentation/bloc/auth_bloc.dart' as _i734;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i272.AuthRepository>(
        () => _i272.AuthRepositoryImpl(gh<_i361.Dio>()));
    gh.factory<_i734.AuthBloc>(
        () => _i734.AuthBloc(gh<_i272.AuthRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i702.RegisterModule {}
