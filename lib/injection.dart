import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/repository/repository.dart';
import 'package:mkp_hris/utils/constant.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton(() => BottomNavCubit());

  getIt.registerLazySingleton(
    () => AuthCubit(
      authRepository: AuthRepository(
        supabaseClient: SupabaseClient(supabaseUrl, anonKey),
      ),
      karyawanRepository: KaryawanRepository(
        supabaseClient: SupabaseClient(supabaseUrl, anonKey),
      ),
    ),
  );
  getIt.registerLazySingleton(
    () => KaryawanCubit(
      authRepository: AuthRepository(
        supabaseClient: SupabaseClient(supabaseUrl, anonKey),
      ),
      karyawanRepository: KaryawanRepository(
        supabaseClient: SupabaseClient(supabaseUrl, anonKey),
      ),
    ),
  );
  getIt.registerLazySingleton(
    () => AbsensiCubit(
      karyawanRepository: KaryawanRepository(
        supabaseClient: SupabaseClient(supabaseUrl, anonKey),
      ),
    ),
  );
  getIt.registerLazySingleton(
    () => PengumumanCubit(
      karyawanRepository: KaryawanRepository(
        supabaseClient: SupabaseClient(supabaseUrl, anonKey),
      ),
    ),
  );
  getIt.registerLazySingleton(
    () => GajiCubit(
      karyawanRepository: KaryawanRepository(
        supabaseClient: SupabaseClient(supabaseUrl, anonKey),
      ),
    ),
  );
  getIt.registerLazySingleton(
    () => CutiCubit(
      karyawanRepository: KaryawanRepository(
        supabaseClient: SupabaseClient(supabaseUrl, anonKey),
      ),
    ),
  );
}
