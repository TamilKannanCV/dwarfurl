// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dwarfurl/app_module.dart' as _i8;
import 'package:dwarfurl/data/repositories/app_repo.dart' as _i5;
import 'package:dwarfurl/data/repositories/app_repo_impl.dart' as _i6;
import 'package:dwarfurl/data/services/api_services.dart' as _i4;
import 'package:dwarfurl/screens/home/home_screen_vm.dart' as _i7;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.factory<_i3.FirebaseDynamicLinks>(() => appModule.dynamicLinks);
    gh.factory<_i4.ApiServices>(
        () => _i4.ApiServices(gh<_i3.FirebaseDynamicLinks>()));
    gh.factory<_i5.AppRepo>(() => _i6.AppRepoImpl(gh<_i4.ApiServices>()));
    gh.factory<_i7.HomScreenVm>(() => _i7.HomScreenVm(gh<_i5.AppRepo>()));
    return this;
  }
}

class _$AppModule extends _i8.AppModule {}
