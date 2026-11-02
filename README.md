# BarberBook

BarberBook là ứng dụng đặt lịch cắt tóc, kết nối khách hàng với các cửa hàng và stylist. Ứng dụng được xây dựng bằng Flutter.

## Mục lục

- [Tính năng](#tính-năng)
- [Công nghệ](#công-nghệ)
- [Yêu cầu](#yêu-cầu)
- [Cài đặt và chạy](#cài-đặt-và-chạy)
- [Cấu hình Supabase](#cấu-hình-supabase)
- [Kiểm tra chất lượng](#kiểm-tra-chất-lượng)
- [Cấu trúc dự án](#cấu-trúc-dự-án)
- [Bảo mật](#bảo-mật)

## Tính năng

### Khách hàng

- Đăng ký, đăng nhập và quản lý hồ sơ.
- Tìm kiếm cửa hàng, xem thông tin cửa hàng và dịch vụ.
- Chọn dịch vụ, stylist và khung giờ còn trống để tạo lịch hẹn.
- Xem và quản lý lịch hẹn.
- Nhận thông báo về lịch hẹn; danh sách thông báo được cập nhật khi có thông báo mới.
- Gửi và xem đánh giá.

### Quản lý

- Theo dõi tổng quan hoạt động cửa hàng.
- Quản lý stylist, dịch vụ và lịch làm việc.
- Gửi và xử lý yêu cầu nghỉ phép.
- Xem hồ sơ.

## Công nghệ

- **Flutter / Dart** — ứng dụng đa nền tảng.
- **Supabase** — xác thực, cơ sở dữ liệu và lưu trữ dữ liệu ứng dụng.
- **Riverpod** — quản lý trạng thái và dependency injection.
- **GoRouter** — điều hướng.
- **Freezed / json_serializable** — model và tuần tự hóa dữ liệu.

## Yêu cầu

- Flutter SDK có Dart SDK phiên bản `3.5.0` trở lên.
- Một dự án Supabase có URL và anon/public key.
- Thiết bị hoặc máy ảo để chạy ứng dụng Android hoặc iOS.

## Cài đặt và chạy

1. Tải mã nguồn và cài dependencies:

   ```sh
   git clone https://github.com/hoangganhh0211/barberbook_app.git
   cd barberbook_app
   flutter pub get
   ```

2. Cấu hình Supabase theo hướng dẫn tại [Cấu hình Supabase](#cấu-hình-supabase).

3. Chạy ứng dụng, thay các giá trị ví dụ bằng thông tin dự án của bạn:

   ```sh
   flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT_ID.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
   ```

   Hai giá trị được đọc từ compile-time environment variables trong `lib/core/config/app_config.dart`. Ứng dụng cần cả hai giá trị để khởi tạo Supabase. Tùy chọn, tắt log mạng khi chạy bằng cách thêm `--dart-define=ENABLE_NETWORK_LOGGING=false`.

## Cấu hình Supabase

1. Tạo một dự án Supabase và lấy **Project URL** cùng **anon/public key** trong phần cấu hình API.
2. Tạo schema và policy cho cơ sở dữ liệu bằng các script SQL trong thư mục [`supabase/`](./supabase/). Đọc nội dung script để xác định các bảng phụ thuộc và áp dụng theo thứ tự phù hợp với dự án.
3. Với thông báo, áp dụng `schema_notifications.sql` sau khi đã tạo bảng lịch hẹn; bật Supabase Realtime cho bảng `notifications` để danh sách trong ứng dụng nhận cập nhật mới.
4. Kiểm tra bảng, quyền truy cập và Row Level Security (RLS) trước khi chạy ứng dụng.
5. Truyền Project URL và anon/public key vào lệnh `flutter run` như ví dụ ở trên.

Các script trong `supabase/` bao gồm schema cho hồ sơ, cửa hàng, dịch vụ, stylist, lịch hẹn, thông báo, đánh giá và quản lý lịch làm việc. Schema thông báo tạo thông báo khi lịch hẹn được tạo hoặc trạng thái thay đổi; cập nhật thời gian thực chỉ hoạt động khi bật Realtime cho bảng tương ứng.

## Kiểm tra chất lượng

Chạy phân tích tĩnh:

```sh
flutter analyze
```

Chạy các bài kiểm thử:

```sh
flutter test
```

## Cấu trúc dự án

```text
lib/
├── core/                 # Cấu hình, tiện ích, theme và thành phần dùng chung
├── features/             # Các tính năng theo nghiệp vụ
├── routes/               # Khai báo route và điều hướng
├── shared/               # Model được chia sẻ giữa các tính năng
├── app.dart              # Cấu hình MaterialApp
└── main.dart             # Điểm khởi chạy ứng dụng
supabase/                 # SQL schema và policy của Supabase
test/                     # Kiểm thử
```

## Bảo mật

- Chỉ dùng anon/public key trong ứng dụng khách; **không** nhúng `service_role` key hoặc bí mật quản trị vào ứng dụng.
- Cấu hình RLS và policy phù hợp trên Supabase; anon key không thay thế cho kiểm soát quyền truy cập ở cơ sở dữ liệu.
- Không đưa thông tin xác thực thật vào mã nguồn hoặc commit lên Git.
