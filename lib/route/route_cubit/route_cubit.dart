import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stride/model/route_model.dart';
import 'package:stride/route/route_cubit/route_state.dart';
import 'package:stride/repository/route_repository.dart';

class RouteCubit extends Cubit<RouteState> {
  final RouteRepository _routeRepository;

  RouteCubit(this._routeRepository) : super(RouteState());

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
    } catch (e) {
      emit(
        state.copyWith(
          listStatus: RouteStatus.failure,
          errorMessage: 'Không tải được buổi tập. Bạn hãy thử lại.',
        ),
      );
    }
  }

  // Thêm lộ trình
  Future<void> addRoute(RouteModel route, {bool isError = false}) async {
    emit(
      state.copyWith(
        actionStatus: RouteStatus.loading,
        clearErrorMessage: true,
      ),
    );
    try {
      await _routeRepository.addRoute(route, isError: isError);
      emit(
        state.copyWith(
          actionStatus: RouteStatus.success,
          clearErrorMessage: true,
        ),
      );
      await loadRoutes(); // Tải lại danh sách sau khi thêm
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: RouteStatus.failure,
          errorMessage: 'Không thể thêm lộ trình. Bạn hãy thử lại.',
        ),
      );
    }
  }

  // Sửa lộ trình
  Future<void> updateRoute(RouteModel route, {bool isError = false}) async {
    emit(
      state.copyWith(
        actionStatus: RouteStatus.loading,
        clearErrorMessage: true,
      ),
    );
    try {
      await _routeRepository.updateRoute(route, isError: isError);
      emit(
        state.copyWith(
          actionStatus: RouteStatus.success,
          clearErrorMessage: true,
        ),
      );
      await loadRoutes(); // Tải lại danh sách sau khi sửa
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: RouteStatus.failure,
          errorMessage: 'Không thể sửa lộ trình. Bạn hãy thử lại.',
        ),
      );
    }
    await loadRoutes(); // Tải lại danh sách sau khi sửa
  }
}
