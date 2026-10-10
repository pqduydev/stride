import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stride/model/route_model.dart';
import 'package:stride/features/route/route_cubit/route_state.dart';
import 'package:stride/repository/route_repository.dart';
import 'package:stride/services/api_exception.dart';

class RouteCubit extends Cubit<RouteState> {
  final RouteRepository _routeRepository;

  RouteCubit(this._routeRepository) : super(RouteState());

  void resetErrors() {
    emit(
      state.copyWith(
        actionStatus: RouteStatus.initial,
        fieldErrors: {},
        clearErrorMessage: true,
      ),
    );
  }

  Future<void> loadRoutes() async {
    emit(
      state.copyWith(listStatus: RouteStatus.loading, clearErrorMessage: true),
    );

    try {
      final routes = await _routeRepository.fetchRoutes();

      emit(
        state.copyWith(
          listStatus: RouteStatus.success,
          routes: routes,
          clearErrorMessage: true,
        ),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          listStatus: RouteStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          listStatus: RouteStatus.failure,
          errorMessage: 'route_cubit.error_load'.tr(),
        ),
      );
    }
  }

  // Thêm lộ trình
  Future<void> addRoute(RouteModel route) async {
    emit(
      state.copyWith(
        actionStatus: RouteStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      await _routeRepository.addRoute(route);
      if (isClosed) return;

      emit(
        state.copyWith(
          actionStatus: RouteStatus.success,
          clearErrorMessage: true,
        ),
      );

      await loadRoutes(); // Tải lại danh sách
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          actionStatus: RouteStatus.failure,
          errorMessage: e.message,
          fieldErrors: e.fieldErrors,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: RouteStatus.failure,
          errorMessage: 'route_cubit.error_add'.tr(),
        ),
      );
    }
  }

  // Cập nhật lộ trình
  Future<void> updateRoute(RouteModel route) async {
    emit(
      state.copyWith(
        actionStatus: RouteStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      await _routeRepository.updateRoute(route, route.id!);
      if (isClosed) return;

      emit(
        state.copyWith(
          actionStatus: RouteStatus.success,
          clearErrorMessage: true,
        ),
      );

      await loadRoutes(); // Tải lại danh sách sau khi sửa
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          actionStatus: RouteStatus.failure,
          errorMessage: e.message,
          fieldErrors: e.fieldErrors,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: RouteStatus.failure,
          errorMessage: 'route_cubit.error_update'.tr(),
        ),
      );
    }
  }

  // Xóa lộ trình
  Future<void> deleteRoute(int id) async {
    emit(
      state.copyWith(
        actionStatus: RouteStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      await _routeRepository.deleteRoute(id);
      if (isClosed) return;

      emit(
        state.copyWith(
          actionStatus: RouteStatus.success,
          clearErrorMessage: true,
        ),
      );

      await loadRoutes(); // Tải lại danh sách sau khi sửa
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          actionStatus: RouteStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: RouteStatus.failure,
          errorMessage: 'route_cubit.error_delete'.tr(),
        ),
      );
    }
  }
}
