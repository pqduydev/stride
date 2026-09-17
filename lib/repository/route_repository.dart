import 'package:dio/dio.dart';
import 'package:stride/model/route_model.dart';
import 'package:stride/services/api_exception.dart';

class RouteRepository {
  final Dio _dio;

  RouteRepository({required this._dio});

  // Lấy danh sách Lộ trình
  Future<List<RouteModel>> fetchRoutes() async {
    try {
      final response = await _dio.get('/v1/roadmaps/');

      // Kiểm tra nếu có dữ liệu trả về
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        return data.map((json) => RouteModel.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: 'Đã có lỗi xảy ra, vui lòng thử lại');
    }
  }

  // Thêm lộ trinh
  Future<void> addRoute(RouteModel newRoute) async {
    try {
      await _dio.post(
        '/v1/roadmaps/',
        data: {
          "title": newRoute.title,
          "description": newRoute.description,
          "goal": newRoute.goal,
          "start_date": newRoute.startDate,
          "end_date": newRoute.endDate,
          "is_active": newRoute.isActive,
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: 'Đã có lỗi xảy ra, vui lòng thử lại');
    }
  }

  // Sửa lộ trình
  Future<void> updateRoute(RouteModel editRoute, int id) async {
    try {
      await _dio.patch(
        'v1/roadmaps/$id/',
        data: {
          "title": editRoute.title,
          "description": editRoute.description,
          "goal": editRoute.goal,
          "start_date": editRoute.startDate,
          "end_date": editRoute.endDate,
          "is_active": editRoute.isActive,
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: 'Đã có lỗi xảy ra, vui lòng thử lại');
    }
  }
}
