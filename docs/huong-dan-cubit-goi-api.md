# Hướng dẫn: Dùng Cubit gọi API từ Backend trong Flutter


## Mục lục

1. [Bức tranh tổng thể](#1-bức-tranh-tổng-thể)
2. [Các khái niệm cần nắm trước](#2-các-khái-niệm-cần-nắm-trước)
3. [Project hiện tại đang có gì](#3-project-hiện-tại-đang-có-gì)
4. [Bước 1 – Cài thư viện `dio`](#4-bước-1--cài-thư-viện-dio)
5. [Bước 2 – Model: chuyển JSON ⇄ Object](#5-bước-2--model-chuyển-json--object)
6. [Bước 3 – Tạo Dio client](#6-bước-3--tạo-dio-client)
7. [Bước 4 – Lớp lỗi `ApiException`](#7-bước-4--lớp-lỗi-apiexception)
8. [Bước 5 – Repository gọi API thật](#8-bước-5--repository-gọi-api-thật)
9. [Bước 6 – State](#9-bước-6--state)
10. [Bước 7 – Cubit](#10-bước-7--cubit)
11. [Bước 8 – Cung cấp Repository & Cubit (main.dart)](#11-bước-8--cung-cấp-repository--cubit-maindart)
12. [Bước 9 – UI: BlocBuilder, BlocListener, BlocConsumer](#12-bước-9--ui-blocbuilder-bloclistener-blocconsumer)
13. [Chưa có Backend? Dựng API giả để test](#13-chưa-có-backend-dựng-api-giả-để-test)
14. [Lỗi thường gặp & cách sửa](#14-lỗi-thường-gặp--cách-sửa)
15. [Viết test cho Cubit](#15-viết-test-cho-cubit)
16. [Bài tập thực hành](#16-bài-tập-thực-hành)
17. [Checklist tổng kết](#17-checklist-tổng-kết)

---

## 1. Bức tranh tổng thể

Ứng dụng được chia thành **các lớp (layer)**, mỗi lớp chỉ làm đúng một việc:

```
┌──────────────────────────────────────────────────────────────┐
│ UI (Widget)                                                  │
│  - Hiển thị dữ liệu theo state                               │
│  - Bấm nút → gọi hàm của Cubit                               │
│  - KHÔNG biết URL, JSON, HTTP là gì                          │
└───────────────┬──────────────────────────────▲───────────────┘
                │ context.read<RouteCubit>()   │ state mới
                │   .loadRoutes()              │ (BlocBuilder rebuild)
┌───────────────▼──────────────────────────────┴───────────────┐
│ Cubit                                                        │
│  - Giữ state: loading / success / failure                    │
│  - Gọi Repository, nhận kết quả, emit state mới              │
│  - KHÔNG biết dữ liệu lấy từ đâu (API, DB, file...)          │
└───────────────┬──────────────────────────────▲───────────────┘
                │ fetchRoutes()                │ List<RouteModel>
                │                              │ hoặc throw ApiException
┌───────────────▼──────────────────────────────┴───────────────┐
│ Repository                                                   │
│  - Gọi API bằng Dio                                          │
│  - Chuyển JSON → Model                                       │
│  - Chuyển lỗi mạng (DioException) → lỗi dễ hiểu              │
└───────────────┬──────────────────────────────▲───────────────┘
                │ HTTP GET /routes             │ JSON
┌───────────────▼──────────────────────────────┴───────────────┐
│ Backend (server)                                             │
└──────────────────────────────────────────────────────────────┘
```

### Tại sao phải chia lớp?

| Lợi ích | Giải thích |
|---|---|
| **Dễ thay đổi** | Đổi từ data giả sang API thật → chỉ sửa Repository. Cubit & UI giữ nguyên. |
| **Dễ test** | Test Cubit bằng Repository giả, không cần mạng. |
| **Dễ đọc** | Lỗi hiển thị sai → xem UI. Lỗi logic loading → xem Cubit. Lỗi JSON → xem Repository/Model. |
| **Tái sử dụng** | Nhiều Cubit có thể dùng chung một Repository. |

---

## 2. Các khái niệm cần nắm trước

### 2.1. `Future`, `async`, `await`

Gọi API **mất thời gian** (vài trăm ms đến vài giây). Dart không "đứng chờ" mà trả về một `Future` – lời hứa "sẽ có kết quả sau".

```dart
Future<List<RouteModel>> fetchRoutes() async {   // hàm bất đồng bộ
  final res = await _dio.get('/routes');         // chờ server trả về
  return ...;                                    // rồi mới chạy tiếp
}
```

- `async`: đánh dấu hàm có dùng `await`, hàm luôn trả về `Future`.
- `await`: tạm dừng **hàm này** (không đứng UI) cho đến khi Future xong.
- `Future<void>`: hàm bất đồng bộ không trả về giá trị.

### 2.2. `try / catch` và `throw`

```dart
try {
  final routes = await repository.fetchRoutes(); // có thể lỗi
} on ApiException catch (e) {                    // bắt đúng loại lỗi này
  print(e.message);
} catch (e) {                                    // bắt mọi lỗi còn lại
  print('Lỗi khác: $e');
}
```

- `throw` ném lỗi ra ngoài, hàm dừng ngay.
- `on Type catch (e)` chỉ bắt lỗi thuộc kiểu `Type`.
- `catch (e)` bắt tất cả.

### 2.3. JSON

Server trả dữ liệu dạng text JSON. Dio tự parse thành kiểu Dart:

| JSON | Dart |
|---|---|
| `{ "id": 1 }` | `Map<String, dynamic>` |
| `[ 1, 2, 3 ]` | `List<dynamic>` |
| `"abc"` | `String` |
| `12` / `1.5` | `int` / `double` |
| `true` | `bool` |
| `null` | `null` |

### 2.4. HTTP method & status code

| Method | Ý nghĩa | Ví dụ |
|---|---|---|
| `GET` | Lấy dữ liệu | `GET /routes` – lấy danh sách |
| `POST` | Tạo mới | `POST /routes` + body – thêm lộ trình |
| `PUT` / `PATCH` | Cập nhật (toàn bộ / một phần) | `PUT /routes/1` + body |
| `DELETE` | Xoá | `DELETE /routes/1` |

| Status | Ý nghĩa |
|---|---|
| `200`, `201` | Thành công / Tạo thành công |
| `400` | Dữ liệu gửi lên sai |
| `401` | Chưa đăng nhập / token hết hạn |
| `403` | Không có quyền |
| `404` | Không tìm thấy |
| `500` | Lỗi server |

Với Dio, status **ngoài khoảng 2xx** sẽ tự `throw DioException` loại `badResponse`.

### 2.5. Cubit là gì?

Cubit = **một class giữ state + các hàm để đổi state**.

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);          // state ban đầu = 0

  void increment() => emit(state + 1); // emit = phát ra state mới
}
```

- `state`: giá trị hiện tại.
- `emit(newState)`: đổi state → mọi widget đang lắng nghe tự rebuild.
- Cubit khác Bloc: Cubit gọi **hàm** trực tiếp; Bloc gửi **event**. Người mới nên bắt đầu với Cubit vì ít code hơn.

### 2.6. `Equatable` và `copyWith`

- **Equatable**: giúp so sánh 2 object theo **giá trị** thay vì địa chỉ bộ nhớ. Nếu `emit` một state **bằng** state cũ, Cubit **bỏ qua** (không rebuild) → tiết kiệm hiệu năng.
- **copyWith**: tạo bản sao state, chỉ đổi vài trường. State nên **bất biến (immutable)** – không sửa trực tiếp, luôn tạo object mới.

```dart
emit(state.copyWith(listStatus: RouteStatus.loading));
// giữ nguyên routes, errorMessage... chỉ đổi listStatus
```

---

## 3. Project hiện tại đang có gì

| File | Vai trò | Tình trạng |
|---|---|---|
| [lib/model/route_model.dart](../lib/model/route_model.dart) | Model lộ trình | Chưa có `fromJson` / `toJson` |
| [lib/repository/route_repository.dart](../lib/repository/route_repository.dart) | Lấy / thêm / sửa lộ trình | Dùng **data giả** + `Future.delayed` + cờ `isError` giả lập lỗi |
| [lib/route/route_cubit/route_state.dart](../lib/route/route_cubit/route_state.dart) | State | Tốt, có `listStatus` & `actionStatus` tách riêng |
| [lib/route/route_cubit/route_cubit.dart](../lib/route/route_cubit/route_cubit.dart) | Cubit | Tốt, nhưng `updateRoute` gọi `loadRoutes()` **2 lần** (bug) |
| [lib/main.dart](../lib/main.dart) | Cung cấp Repository + Cubit | `RouteRepository()` không nhận Dio |
| [lib/screens/route_create_screen.dart](../lib/screens/route_create_screen.dart) | Màn tạo/sửa | Dòng 94 truyền `isError: true` → cần bỏ khi dùng API thật |

👉 **Tin tốt:** kiến trúc đã đúng. Việc cần làm chủ yếu là thay "ruột" Repository.

---

## 4. Bước 1 – Cài thư viện `dio`

```bash
flutter pub add dio
```

Lệnh này tự thêm `dio` vào `pubspec.yaml` và chạy `pub get`.

### Vì sao chọn `dio` thay vì `http`?

| Tính năng | `http` | `dio` |
|---|---|---|
| Tự parse JSON | ❌ phải `jsonDecode` | ✅ |
| `baseUrl` dùng chung | ❌ | ✅ |
| Timeout | Phải tự viết | ✅ có sẵn |
| Interceptor (gắn token, log, refresh token) | ❌ | ✅ |
| Phân loại lỗi (timeout, mất mạng, 4xx/5xx) | ❌ | ✅ `DioExceptionType` |

---

## 5. Bước 2 – Model: chuyển JSON ⇄ Object

Giả sử Backend trả về một lộ trình như sau:

```json
{
  "id": 1,
  "title": "Lộ trình Tăng Cơ 1 tháng",
  "category": "Sức khỏe",
  "duration": "1 tháng",
  "start_date": "11/09/2026",
  "end_date": "11/10/2026",
  "description": "Lộ trình tập luyện chuyên sâu..."
}
```

Sửa [lib/model/route_model.dart](../lib/model/route_model.dart):

```dart
import 'package:equatable/equatable.dart';

class RouteModel extends Equatable {
  final String id;
  final String title;
  final String category;
  final String duration;
  final String startDate;
  final String endDate;
  final String description;

  const RouteModel({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  /// JSON (Map) → RouteModel. Dùng khi NHẬN dữ liệu từ server.
  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'].toString(),                 // server có thể trả int → ép về String
      title: json['title'] as String? ?? '',     // null → chuỗi rỗng, tránh crash
      category: json['category'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  /// RouteModel → JSON (Map). Dùng khi GỬI dữ liệu lên server.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'duration': duration,
      'start_date': startDate,
      'end_date': endDate,
      'description': description,
    };
  }

  RouteModel copyWith({
    String? id,
    String? title,
    String? category,
    String? duration,
    String? startDate,
    String? endDate,
    String? description,
  }) {
    return RouteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, category, duration, startDate, endDate, description];
}
```

### Giải thích

- **`factory`**: constructor đặc biệt, được phép xử lý logic trước khi tạo object.
- **`json['id'].toString()`**: BE có thể trả `1` (int) hoặc `"1"` (String). `toString()` xử lý cả hai.
- **`as String? ?? ''`**: nếu field bị thiếu/`null` thì dùng chuỗi rỗng thay vì crash.
- **Key phải khớp 100% với BE**: `start_date` khác `startDate`. Hỏi BE hoặc xem Swagger/Postman.
- **Thêm `Equatable`**: 2 model cùng dữ liệu được coi là bằng nhau → dễ so sánh, dễ viết test.

> 💡 Khi model nhiều field, có thể dùng `json_serializable` hoặc `freezed` để sinh code tự động. Người mới nên viết tay trước để hiểu bản chất.

---

## 6. Bước 3 – Tạo Dio client

Tạo file `lib/network/api_client.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Tạo một Dio dùng chung cho toàn app.
Dio createDio() {
  final dio = Dio(
    BaseOptions(
      // Địa chỉ gốc của BE. Mọi request sẽ nối vào sau.
      // VD: _dio.get('/routes') → http://10.0.2.2:3000/api/routes
      baseUrl: 'http://10.0.2.2:3000/api',

      // Quá thời gian kết nối → throw DioException (connectionTimeout)
      connectTimeout: const Duration(seconds: 10),

      // Quá thời gian chờ server trả dữ liệu → receiveTimeout
      receiveTimeout: const Duration(seconds: 10),

      headers: {'Content-Type': 'application/json'},
    ),
  );

  // Interceptor 1: gắn token cho mọi request (dùng khi app có đăng nhập)
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // final token = await tokenStorage.read();
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        handler.next(options); // cho request đi tiếp
      },
      onError: (error, handler) {
        // if (error.response?.statusCode == 401) { ... đăng xuất / refresh token }
        handler.next(error); // chuyển lỗi đi tiếp
      },
    ),
  );

  // Interceptor 2: in log request/response ra console – CHỈ khi debug
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  return dio;
}
```

### Giải thích

- **`baseUrl`**: tránh lặp lại địa chỉ server ở mọi request. Đổi server chỉ cần sửa một chỗ.
- **`10.0.2.2`**: trên **Android emulator**, `localhost` là chính emulator chứ không phải máy tính của bạn. `10.0.2.2` là địa chỉ trỏ về máy tính.
  - iOS simulator: dùng `localhost` được.
  - Điện thoại thật: dùng IP LAN của máy tính (VD `192.168.1.10`), điện thoại và máy tính cùng Wi-Fi.
- **Interceptor**: "trạm kiểm soát" chạy trước mỗi request / sau mỗi response / khi lỗi. Dùng để gắn token, log, xử lý 401 chung cho cả app.
- **`kDebugMode`**: log có thể chứa token, mật khẩu → **không bật log ở bản release**.

---

## 7. Bước 4 – Lớp lỗi `ApiException`

`DioException` chứa rất nhiều thông tin kỹ thuật, không phù hợp để hiển thị cho người dùng. Ta chuyển nó thành lỗi riêng, có sẵn câu thông báo tiếng Việt.

Tạo file `lib/network/api_exception.dart`:

```dart
import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;   // câu thông báo cho người dùng
  final int? statusCode;  // mã HTTP (nếu có) để xử lý riêng, VD 401

  ApiException(this.message, {this.statusCode});

  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      // Quá thời gian
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Kết nối quá lâu. Bạn hãy thử lại.');

      // Không kết nối được (mất mạng, sai địa chỉ, server tắt)
      case DioExceptionType.connectionError:
        return ApiException('Không có kết nối mạng.');

      // Server trả về status 4xx / 5xx
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        final data = e.response?.data;
        // Nếu BE trả { "message": "..." } thì dùng luôn câu đó
        final serverMessage =
            (data is Map && data['message'] is String) ? data['message'] as String : null;
        return ApiException(
          serverMessage ?? _messageForStatus(code),
          statusCode: code,
        );

      case DioExceptionType.cancel:
        return ApiException('Yêu cầu đã bị huỷ.');

      default:
        return ApiException('Có lỗi xảy ra. Bạn hãy thử lại.');
    }
  }

  static String _messageForStatus(int? code) {
    switch (code) {
      case 400:
        return 'Dữ liệu không hợp lệ.';
      case 401:
        return 'Phiên đăng nhập đã hết hạn.';
      case 403:
        return 'Bạn không có quyền thực hiện thao tác này.';
      case 404:
        return 'Không tìm thấy dữ liệu.';
      default:
        return 'Lỗi máy chủ ($code). Bạn hãy thử lại.';
    }
  }

  @override
  String toString() => message;
}
```

### Giải thích

- **`implements Exception`**: đánh dấu đây là một loại lỗi, dùng được với `throw` và `on ApiException catch`.
- **Tách lỗi theo `e.type`**: người dùng thấy "Không có kết nối mạng" dễ hiểu hơn "SocketException: Failed host lookup".
- **Ưu tiên message từ BE**: BE thường biết rõ nhất lý do lỗi (VD "Tên lộ trình đã tồn tại").

---

## 8. Bước 5 – Repository gọi API thật

Thay toàn bộ [lib/repository/route_repository.dart](../lib/repository/route_repository.dart):

```dart
import 'package:dio/dio.dart';
import 'package:stride/model/route_model.dart';
import 'package:stride/network/api_exception.dart';

class RouteRepository {
  final Dio _dio;

  // Nhận Dio từ bên ngoài (dependency injection) → dễ thay bằng Dio giả khi test
  RouteRepository(this._dio);

  /// GET /routes – Lấy danh sách lộ trình
  Future<List<RouteModel>> fetchRoutes() async {
    try {
      final res = await _dio.get('/routes');

      // Giả sử BE trả: { "data": [ {...}, {...} ] }
      // Nếu BE trả thẳng mảng [ {...} ] thì dùng: final list = res.data as List;
      final list = res.data['data'] as List;

      return list
          .map((item) => RouteModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// POST /routes – Thêm lộ trình
  Future<void> addRoute(RouteModel route) async {
    try {
      await _dio.post('/routes', data: route.toJson());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// PUT /routes/:id – Sửa lộ trình
  Future<void> updateRoute(RouteModel route) async {
    try {
      await _dio.put('/routes/${route.id}', data: route.toJson());
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
```

### Giải thích từng dòng quan trọng

| Code | Ý nghĩa |
|---|---|
| `await _dio.get('/routes')` | Gửi GET tới `baseUrl + /routes`, chờ phản hồi |
| `res.data` | Body đã được Dio parse từ JSON sang `Map`/`List` |
| `res.data['data'] as List` | Lấy mảng nằm trong key `data`, khẳng định kiểu là `List` |
| `.map(... fromJson ...)` | Biến từng `Map` thành `RouteModel` |
| `.toList()` | `map` trả về `Iterable` → chuyển sang `List` |
| `data: route.toJson()` | Body gửi lên server, Dio tự chuyển `Map` thành JSON |
| `on DioException catch (e)` | Bắt lỗi mạng/HTTP |
| `throw ApiException.fromDio(e)` | Ném lỗi dễ hiểu lên cho Cubit |

> ⚠️ **Nguyên tắc:** Repository **không** `emit`, **không** hiển thị SnackBar. Nó chỉ trả dữ liệu hoặc ném lỗi. Quyết định hiển thị gì là việc của Cubit & UI.

---

## 9. Bước 6 – State

[lib/route/route_cubit/route_state.dart](../lib/route/route_cubit/route_state.dart) hiện tại **đã tốt, không cần sửa**. Giải thích thiết kế:

```dart
enum RouteStatus { initial, loading, success, failure }

class RouteState extends Equatable {
  final RouteStatus listStatus;    // trạng thái TẢI DANH SÁCH
  final RouteStatus actionStatus;  // trạng thái THÊM / SỬA
  final List<RouteModel> routes;
  final String? errorMessage;
  ...
}
```

### Vì sao tách `listStatus` và `actionStatus`?

Nếu chỉ có một `status`: khi bấm "Lưu" → `status = loading` → màn danh sách phía sau cũng hiện vòng xoay, mất danh sách. Tách ra thì:

- `listStatus`: điều khiển màn danh sách (loading / hiển thị list / báo lỗi tải).
- `actionStatus`: điều khiển nút Lưu (disable khi loading, SnackBar khi lỗi, `pop` khi thành công).

### `clearErrorMessage`

`copyWith` dùng `errorMessage ?? this.errorMessage`, nên truyền `null` **không xoá** được lỗi cũ. Cờ `clearErrorMessage: true` sinh ra để giải quyết đúng vấn đề đó.

### 4 trạng thái của một lần gọi API

```
initial ──(gọi API)──> loading ──(OK)────> success
                          │
                          └──(lỗi)──> failure ──(thử lại)──> loading
```

---

## 10. Bước 7 – Cubit

Sửa [lib/route/route_cubit/route_cubit.dart](../lib/route/route_cubit/route_cubit.dart):

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stride/model/route_model.dart';
import 'package:stride/network/api_exception.dart';
import 'package:stride/repository/route_repository.dart';
import 'package:stride/route/route_cubit/route_state.dart';

class RouteCubit extends Cubit<RouteState> {
  final RouteRepository _routeRepository;

  RouteCubit(this._routeRepository) : super(const RouteState());

  /// Tải danh sách lộ trình
  Future<void> loadRoutes() async {
    // 1. Báo UI: đang tải
    emit(state.copyWith(
      listStatus: RouteStatus.loading,
      clearErrorMessage: true,
    ));

    try {
      // 2. Gọi Repository (có thể mất vài giây)
      final routes = await _routeRepository.fetchRoutes();

      // 3. Trong lúc chờ, người dùng có thể đã thoát màn → Cubit bị close
      if (isClosed) return;

      // 4. Báo UI: thành công + dữ liệu
      emit(state.copyWith(
        listStatus: RouteStatus.success,
        routes: routes,
      ));
    } on ApiException catch (e) {
      // 5a. Lỗi mạng / HTTP
      if (isClosed) return;
      emit(state.copyWith(
        listStatus: RouteStatus.failure,
        errorMessage: e.message,
      ));
    } catch (_) {
      // 5b. Lỗi khác: JSON sai format, sai kiểu dữ liệu...
      if (isClosed) return;
      emit(state.copyWith(
        listStatus: RouteStatus.failure,
        errorMessage: 'Dữ liệu không hợp lệ.',
      ));
    }
  }

  /// Thêm lộ trình
  Future<void> addRoute(RouteModel route) async {
    emit(state.copyWith(
      actionStatus: RouteStatus.loading,
      clearErrorMessage: true,
    ));

    try {
      await _routeRepository.addRoute(route);
      if (isClosed) return;
      emit(state.copyWith(actionStatus: RouteStatus.success));
      await loadRoutes(); // Tải lại danh sách để thấy item mới
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        actionStatus: RouteStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  /// Sửa lộ trình
  Future<void> updateRoute(RouteModel route) async {
    emit(state.copyWith(
      actionStatus: RouteStatus.loading,
      clearErrorMessage: true,
    ));

    try {
      await _routeRepository.updateRoute(route);
      if (isClosed) return;
      emit(state.copyWith(actionStatus: RouteStatus.success));
      await loadRoutes(); // chỉ gọi MỘT lần, trong nhánh thành công
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        actionStatus: RouteStatus.failure,
        errorMessage: e.message,
      ));
    }
    // ❌ Code cũ có thêm `await loadRoutes();` ở đây → gọi API 2 lần. Đã bỏ.
  }
}
```

### Giải thích

- **Mẫu chuẩn của mọi hàm gọi API trong Cubit:**
  1. `emit(loading)`
  2. `try { await repository... }`
  3. `emit(success)` hoặc `emit(failure)` trong `catch`
- **`if (isClosed) return;`**: Cubit bị đóng khi widget chứa `BlocProvider` bị huỷ. Nếu `emit` sau khi đóng, flutter_bloc sẽ ném `StateError: Cannot emit new states after calling close`. Luôn kiểm tra **sau mỗi `await`**.
- **Cubit không `import 'package:dio/dio.dart'`**: Cubit chỉ biết `ApiException`, không biết Dio tồn tại. Sau này đổi Dio sang thư viện khác, Cubit không phải sửa.

### ⚠️ Nhớ sửa màn tạo lộ trình

[lib/screens/route_create_screen.dart:94](../lib/screens/route_create_screen.dart#L94) đang giả lập lỗi:

```dart
cubit.addRoute(newRoute, isError: true);   // ❌ tham số isError không còn
```

Đổi thành:

```dart
cubit.addRoute(newRoute);                  // ✅
```

---

## 11. Bước 8 – Cung cấp Repository & Cubit (main.dart)

Sửa [lib/main.dart](../lib/main.dart):

```dart
import 'package:stride/network/api_client.dart';
// ... các import khác giữ nguyên

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => RouteRepository(createDio()),   // ← chỉ đổi dòng này
      child: BlocProvider(
        create: (context) =>
            RouteCubit(context.read<RouteRepository>())..loadRoutes(),
        child: MaterialApp.router(
          title: 'Stride App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF7F8FA)),
            fontFamily: 'Inter',
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}
```

### Giải thích

- **`RepositoryProvider`**: "cất" một object (Repository) vào cây widget để widget con lấy ra dùng, không phải truyền tay qua từng constructor.
- **`BlocProvider`**: giống vậy nhưng dành cho Bloc/Cubit, và **tự `close()` Cubit** khi bị huỷ.
- **`context.read<RouteRepository>()`**: lấy object gần nhất thuộc kiểu đó trong cây widget. Tương đương `RepositoryProvider.of<RouteRepository>(context)`.
- **`..loadRoutes()`** (cascade): gọi `loadRoutes()` trên Cubit vừa tạo, **nhưng vẫn trả về chính Cubit** (không phải `Future`). Tức là tạo xong gọi API ngay.

### Nên đặt Provider ở đâu?

| Vị trí | Khi nào dùng |
|---|---|
| Trên `MaterialApp` (như hiện tại) | Dữ liệu dùng ở **nhiều màn** (VD danh sách lộ trình dùng ở màn list + màn tạo/sửa) |
| Trong `GoRoute.builder` của một màn | Dữ liệu **chỉ dùng trong màn đó**, thoát màn thì huỷ Cubit |

---

## 12. Bước 9 – UI: BlocBuilder, BlocListener, BlocConsumer

### 12.1. So sánh

| Widget | Dùng để | Chạy khi nào |
|---|---|---|
| `BlocBuilder` | **Vẽ** giao diện theo state | Mỗi lần state đổi (có thể rebuild nhiều lần) |
| `BlocListener` | Làm **hành động một lần**: SnackBar, Dialog, điều hướng | Mỗi lần state đổi, **không vẽ gì** |
| `BlocConsumer` | Cần cả hai | Gộp Builder + Listener |

> Quy tắc: **không** gọi `showSnackBar` / `context.pop()` bên trong `builder`. Builder có thể chạy nhiều lần → SnackBar hiện nhiều lần.

### 12.2. `context.read` vs `context.watch`

| | `context.read<T>()` | `context.watch<T>()` |
|---|---|---|
| Lắng nghe thay đổi | ❌ | ✅ (rebuild widget) |
| Dùng ở đâu | Trong `onPressed`, `initState`, callback | Trong `build` |
| Ví dụ | `context.read<RouteCubit>().loadRoutes()` | `final state = context.watch<RouteCubit>().state;` |

### 12.3. Màn danh sách – `BlocBuilder`

[lib/route/screen/my_route_screen.dart](../lib/route/screen/my_route_screen.dart) đã dùng `BlocBuilder`. Bổ sung nút **Thử lại** và **kéo để làm mới**:

```dart
BlocBuilder<RouteCubit, RouteState>(
  // Chỉ rebuild khi phần liên quan tới danh sách thay đổi
  buildWhen: (prev, curr) =>
      prev.listStatus != curr.listStatus || prev.routes != curr.routes,
  builder: (context, state) {
    switch (state.listStatus) {
      case RouteStatus.initial:
      case RouteStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case RouteStatus.failure:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(state.errorMessage ?? 'Có lỗi xảy ra'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.read<RouteCubit>().loadRoutes(),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        );

      case RouteStatus.success:
        if (state.routes.isEmpty) {
          return const Center(child: Text('Chưa có lộ trình nào'));
        }
        return RefreshIndicator(
          onRefresh: () => context.read<RouteCubit>().loadRoutes(),
          child: ListView.builder(
            itemCount: state.routes.length,
            itemBuilder: (context, index) {
              final route = state.routes[index];
              return ListTile(title: Text(route.title));
            },
          ),
        );
    }
  },
)
```

**Giải thích:**
- **`buildWhen`**: khi bấm "Lưu" ở màn tạo, `actionStatus` đổi → không cần rebuild danh sách. `buildWhen` lọc bớt các lần rebuild thừa.
- **`switch` trên enum**: Dart bắt buộc xử lý đủ mọi case → không quên trạng thái nào.
- **Trạng thái rỗng**: API thành công nhưng trả `[]` là trường hợp hay bị quên.
- **`RefreshIndicator.onRefresh`** cần một `Future` → `loadRoutes()` trả `Future<void>` nên dùng trực tiếp được.

### 12.4. Màn tạo/sửa – `BlocConsumer`

[lib/screens/route_create_screen.dart](../lib/screens/route_create_screen.dart) đã có sẵn cấu trúc này. Mẫu tổng quát:

```dart
BlocConsumer<RouteCubit, RouteState>(
  // Chỉ phản ứng khi vừa xong một thao tác (loading → success/failure)
  listenWhen: (prev, curr) =>
      prev.actionStatus == RouteStatus.loading &&
      curr.actionStatus != RouteStatus.loading,
  listener: (context, state) {
    if (state.actionStatus == RouteStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lưu thành công')),
      );
      context.pop();
    } else if (state.actionStatus == RouteStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? 'Có lỗi xảy ra')),
      );
    }
  },
  builder: (context, state) {
    final isLoading = state.actionStatus == RouteStatus.loading;
    return ElevatedButton(
      // Disable nút khi đang gửi → tránh bấm 2 lần tạo 2 bản ghi
      onPressed: isLoading ? null : () => context.read<RouteCubit>().addRoute(newRoute),
      child: isLoading
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : const Text('Lưu'),
    );
  },
)
```

**Giải thích:**
- **`listenWhen`** kiểm tra `prev == loading`: tránh việc mở lại màn tạo mà `actionStatus` cũ vẫn là `success` → tự `pop` ngay lập tức.
- **Disable nút khi loading**: người dùng bấm liên tục khi mạng chậm sẽ tạo nhiều bản ghi trùng.

---

## 13. Chưa có Backend? Dựng API giả để test

### Cách 1: `json-server` (chạy trên máy)

Cần cài Node.js. Tạo file `db.json` ở ngoài project:

```json
{
  "routes": [
    {
      "id": "1",
      "title": "Lộ trình Tăng Cơ 1 tháng",
      "category": "Sức khỏe",
      "duration": "1 tháng",
      "start_date": "11/09/2026",
      "end_date": "11/10/2026",
      "description": "Lộ trình tập luyện chuyên sâu dành cho người mới bắt đầu."
    }
  ]
}
```

Chạy:

```bash
npx json-server db.json --port 3000
```

Có ngay các API:

| Method | URL |
|---|---|
| GET | `http://localhost:3000/routes` |
| POST | `http://localhost:3000/routes` |
| PUT | `http://localhost:3000/routes/1` |
| DELETE | `http://localhost:3000/routes/1` |

Điều chỉnh code cho khớp json-server:

```dart
baseUrl: 'http://10.0.2.2:3000',          // bỏ /api
final list = res.data as List;            // json-server trả thẳng mảng, không có key "data"
```

### Cách 2: mockapi.io

Tạo resource `routes` trên web, lấy URL dạng `https://xxxx.mockapi.io/api/v1` làm `baseUrl`. Không cần cài gì, chạy được cả trên máy thật. Có `https` nên không gặp lỗi cleartext.

### Kiểm tra API trước khi code

Luôn thử API bằng **Postman** hoặc trình duyệt trước. Nếu Postman không gọi được thì lỗi nằm ở BE/mạng, không phải Flutter.

---

## 14. Lỗi thường gặp & cách sửa

### 14.1. `DioException [connection error]` / `Connection refused` trên Android emulator

**Nguyên nhân:** dùng `localhost` hoặc `127.0.0.1`.
**Sửa:** dùng `10.0.2.2`. Máy thật: dùng IP LAN của máy tính (`ipconfig` trên Windows để xem).

### 14.2. `Cleartext HTTP traffic to 10.0.2.2 not permitted`

**Nguyên nhân:** Android 9+ chặn `http://` (không mã hoá).
**Sửa (chỉ dùng khi dev):** trong `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:usesCleartextTraffic="true"
    ...>
```

Bản production nên dùng `https` và bỏ dòng này.

### 14.3. Bản debug gọi API được, bản release thì không

**Nguyên nhân:** quyền INTERNET chỉ có sẵn trong manifest `debug`/`profile`.
**Sửa:** thêm vào `android/app/src/main/AndroidManifest.xml` (ngoài thẻ `<application>`):

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### 14.4. `Bad state: Cannot emit new states after calling close`

**Nguyên nhân:** thoát màn hình khi API chưa trả về, Cubit đã bị close.
**Sửa:** thêm `if (isClosed) return;` sau mỗi `await`, trước `emit`.

### 14.5. `type 'int' is not a subtype of type 'String'`

**Nguyên nhân:** `fromJson` khai báo sai kiểu so với JSON thật.
**Sửa:** xem log của `LogInterceptor` để biết BE trả kiểu gì, sửa `fromJson` (VD dùng `.toString()`).

### 14.6. `type 'List<dynamic>' is not a subtype of type 'Map<String, dynamic>'`

**Nguyên nhân:** BE trả thẳng mảng `[...]` nhưng code đọc `res.data['data']`, hoặc ngược lại.
**Sửa:** xem log response, chọn đúng `res.data as List` hoặc `res.data['data'] as List`.

### 14.7. Đã `emit` nhưng UI không đổi

**Nguyên nhân:**
- `emit` state **bằng** state cũ (Equatable coi là giống nhau → bỏ qua).
- Sửa trực tiếp list cũ (`state.routes.add(x)`) rồi emit lại cùng list đó.
- Widget không nằm dưới `BlocProvider`, hoặc có 2 `BlocProvider` tạo 2 Cubit khác nhau.

**Sửa:** luôn tạo list mới: `routes: [...state.routes, newRoute]`. Chỉ tạo `BlocProvider` một lần.

### 14.8. `ProviderNotFoundException` / `BlocProvider.of() called with a context that does not contain a RouteCubit`

**Nguyên nhân:** `context` dùng để `read` nằm **trên** hoặc **ngoài** `BlocProvider`.
**Sửa:** đảm bảo widget gọi `context.read` là con của `BlocProvider`. Nếu cùng một hàm `build` vừa tạo Provider vừa đọc, bọc phần đọc bằng `Builder`.

### 14.9. SnackBar hiện nhiều lần / `pop` nhiều lần

**Nguyên nhân:** gọi trong `builder` của `BlocBuilder`.
**Sửa:** chuyển sang `BlocListener` + `listenWhen`.

### 14.10. Gọi API liên tục không dừng

**Nguyên nhân:** gọi `loadRoutes()` bên trong `build()`.
**Sửa:** gọi ở `BlocProvider(create: ... ..loadRoutes())`, trong `initState`, hoặc khi bấm nút.

---

## 15. Viết test cho Cubit

Nhờ tách lớp, có thể test Cubit mà **không cần mạng**.

### Cài thư viện

```bash
flutter pub add --dev bloc_test mocktail
```

### Test file `test/route_cubit_test.dart`

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stride/model/route_model.dart';
import 'package:stride/network/api_exception.dart';
import 'package:stride/repository/route_repository.dart';
import 'package:stride/route/route_cubit/route_cubit.dart';
import 'package:stride/route/route_cubit/route_state.dart';

// Repository giả: không gọi mạng, trả về gì là do ta quyết định
class MockRouteRepository extends Mock implements RouteRepository {}

void main() {
  late MockRouteRepository repo;

  const sampleRoutes = [
    RouteModel(
      id: '1',
      title: 'Test',
      category: 'Sức khỏe',
      duration: '1 tháng',
      startDate: '11/09/2026',
      endDate: '11/10/2026',
      description: 'Mô tả',
    ),
  ];

  setUp(() {
    repo = MockRouteRepository();
  });

  blocTest<RouteCubit, RouteState>(
    'loadRoutes thành công → [loading, success]',
    build: () {
      when(() => repo.fetchRoutes()).thenAnswer((_) async => sampleRoutes);
      return RouteCubit(repo);
    },
    act: (cubit) => cubit.loadRoutes(),
    expect: () => [
      const RouteState(listStatus: RouteStatus.loading),
      const RouteState(listStatus: RouteStatus.success, routes: sampleRoutes),
    ],
  );

  blocTest<RouteCubit, RouteState>(
    'loadRoutes lỗi mạng → [loading, failure + message]',
    build: () {
      when(() => repo.fetchRoutes())
          .thenThrow(ApiException('Không có kết nối mạng.'));
      return RouteCubit(repo);
    },
    act: (cubit) => cubit.loadRoutes(),
    expect: () => [
      const RouteState(listStatus: RouteStatus.loading),
      const RouteState(
        listStatus: RouteStatus.failure,
        errorMessage: 'Không có kết nối mạng.',
      ),
    ],
  );
}
```

Chạy:

```bash
flutter test test/route_cubit_test.dart
```

**Giải thích:**
- **`Mock implements RouteRepository`**: tạo class giả có đủ hàm như Repository thật.
- **`when(...).thenAnswer(...)`**: "khi gọi `fetchRoutes()` thì trả về danh sách mẫu".
- **`thenThrow(...)`**: giả lập lỗi.
- **`expect`**: danh sách các state Cubit phải emit **theo đúng thứ tự**. So sánh được là nhờ `Equatable` ở cả `RouteState` và `RouteModel`.

---

## 16. Bài tập thực hành

Làm theo thứ tự, mỗi bài dựa trên bài trước.

### Bài 1 – Chỉ GET
Dựng json-server, sửa Model + Repository `fetchRoutes` + `main.dart`. Chạy app thấy danh sách từ server.
**Thử:** tắt json-server → app phải hiện "Không có kết nối mạng" + nút Thử lại.

### Bài 2 – POST và PUT
Hoàn thiện `addRoute`, `updateRoute`. Thêm/sửa trên app, mở `db.json` xem dữ liệu đã đổi.

### Bài 3 – Xoá lộ trình
Tự viết `deleteRoute` ở cả Repository và Cubit, thêm nút xoá ở màn danh sách.

<details>
<summary>Gợi ý đáp án</summary>

```dart
// Repository
Future<void> deleteRoute(String id) async {
  try {
    await _dio.delete('/routes/$id');
  } on DioException catch (e) {
    throw ApiException.fromDio(e);
  }
}

// Cubit
Future<void> deleteRoute(String id) async {
  emit(state.copyWith(actionStatus: RouteStatus.loading, clearErrorMessage: true));
  try {
    await _routeRepository.deleteRoute(id);
    if (isClosed) return;
    emit(state.copyWith(
      actionStatus: RouteStatus.success,
      // Xoá ngay trên UI, không cần gọi lại API danh sách
      routes: state.routes.where((r) => r.id != id).toList(),
    ));
  } on ApiException catch (e) {
    if (isClosed) return;
    emit(state.copyWith(actionStatus: RouteStatus.failure, errorMessage: e.message));
  }
}
```

</details>

### Bài 4 – Chi tiết lộ trình
Tạo `RouteDetailCubit` riêng, gọi `GET /routes/:id`, provide trong `GoRoute.builder` của `/route_details` (Cubit tự huỷ khi thoát màn).

### Bài 5 – Test
Viết test `blocTest` cho `addRoute` thành công và thất bại.

---

## 17. Checklist tổng kết

Mỗi khi làm một tính năng gọi API mới, đi qua checklist này:

- [ ] Đã thử API bằng Postman, biết rõ format JSON request/response
- [ ] Model có `fromJson` / `toJson`, key khớp BE, xử lý `null`
- [ ] Repository nhận `Dio` qua constructor, bắt `DioException` → ném `ApiException`
- [ ] Repository không `emit`, không đụng UI
- [ ] State có đủ `initial / loading / success / failure` + `errorMessage`
- [ ] State dùng `Equatable`, cập nhật bằng `copyWith`, không sửa list trực tiếp
- [ ] Cubit: `emit(loading)` → `try/await` → `emit(success|failure)`
- [ ] Có `if (isClosed) return;` sau mỗi `await`
- [ ] UI dùng `BlocBuilder` để vẽ, `BlocListener` cho SnackBar/điều hướng
- [ ] Xử lý đủ: đang tải, lỗi + Thử lại, danh sách rỗng, có dữ liệu
- [ ] Nút gửi bị disable khi đang loading
- [ ] Không gọi API trong `build()`
- [ ] Log Dio chỉ bật ở `kDebugMode`
- [ ] Android: `10.0.2.2` cho emulator, quyền INTERNET, cleartext chỉ khi dev

---

## Tài liệu tham khảo

- flutter_bloc: https://bloclibrary.dev
- dio: https://pub.dev/packages/dio
- bloc_test: https://pub.dev/packages/bloc_test
- json-server: https://github.com/typicode/json-server
