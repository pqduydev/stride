import 'package:equatable/equatable.dart';
import 'package:stride/model/route_model.dart';

enum RouteStatus { initial, loading, success, failure }

class RouteState extends Equatable {
  final RouteStatus status;
  final List<RouteModel> routes;
  final String? errorMessage;

  const RouteState({
    this.status = RouteStatus.initial,
    this.routes = const [],
    this.errorMessage,
  });

  RouteState copyWith({
    RouteStatus? status,
    List<RouteModel>? routes,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RouteState(
      status: status ?? this.status,
      routes: routes ?? this.routes,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, routes, errorMessage];
}
