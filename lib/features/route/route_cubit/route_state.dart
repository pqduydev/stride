import 'package:equatable/equatable.dart';
import 'package:stride/model/route_model.dart';

enum RouteStatus { initial, loading, success, failure }

class RouteState extends Equatable {
  final RouteStatus listStatus;
  final RouteStatus actionStatus;
  final List<RouteModel> routes;
  final String? errorMessage;

  const RouteState({
    this.listStatus = RouteStatus.initial,
    this.actionStatus = RouteStatus.initial,
    this.routes = const [],
    this.errorMessage,
  });

  RouteState copyWith({
    RouteStatus? listStatus,
    RouteStatus? actionStatus,
    List<RouteModel>? routes,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RouteState(
      listStatus: listStatus ?? this.listStatus,
      actionStatus: actionStatus ?? this.actionStatus,
      routes: routes ?? this.routes,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [listStatus, actionStatus, routes, errorMessage];
}
