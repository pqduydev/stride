import 'package:stride/model/route_model.dart';

class RouteRepository {
  final List<RouteModel> _routes = [
    RouteModel(
      id: '1',
      title: 'Lộ trình Tăng Cơ 1 tháng',
      category: 'Sức khỏe',
      duration: '1 tháng',
      startDate: '11/09/2026',
      endDate: '11/10/2026',
      description: 'Lộ trình tập luyện chuyên sâu dành cho người mới bắt đầu.',
    ),
    RouteModel(
      id: '2',
      title: 'Lộ trình Tăng Cơ 2 tháng',
      category: 'Học tập',
      duration: '2 tháng',
      startDate: '11/09/2026',
      endDate: '11/11/2026',
      description: 'Lộ trình tập luyện chuyên sâu dành cho người mới bắt đầu.',
    ),
    RouteModel(
      id: '3',
      title: 'Lộ trình Tăng Cơ 3 tháng',
      category: 'Cá nhân',
      duration: '3 tháng',
      startDate: '11/09/2026',
      endDate: '11/12/2026',
      description: 'Lộ trình tập luyện chuyên sâu dành cho người mới bắt đầu.',
    ),
  ];

  // Lấy danh sách Lộ trình
  Future<List<RouteModel>> fetchRoutes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_routes);
    // Trả về một bản sao của danh sách để tránh thay đổi trực tiếp
    // không thông qua repository
  }

  // Thêm Lộ trình mới
  Future<void> addRoute(RouteModel newRoute, {bool isError = false}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (isError) {
      throw Exception('Không thể thêm lộ trình. Bạn hãy thử lại.');
    }
    _routes.add(newRoute);
  }

  // Cập nhật Lộ trình cũ
  Future<void> updateRoute(
    RouteModel updatedRoute, {
    bool isError = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (isError) {
      throw Exception('Không thể sửa lộ trình. Bạn hãy thử lại.');
    }
    final index = _routes.indexWhere((r) => r.id == updatedRoute.id);
    if (index != -1) {
      _routes[index] = updatedRoute;
    }
  }
}
