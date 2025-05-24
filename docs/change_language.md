# Hướng dẫn thay đổi message trong các thư mục locale

Tài liệu này hướng dẫn cách cập nhật hoặc chỉnh sửa các thông điệp (message) trong các file locale dạng `.po` để hỗ trợ đa ngôn ngữ cho ứng dụng Django.

## Các bước thực hiện:

1. Xác định thư mục `locale` chứa các file ngôn ngữ (ví dụ: `vi/LC_MESSAGES/django.po`, `en/LC_MESSAGES/django.po`, ...).
2. Mở file `.po` tương ứng với ngôn ngữ bạn muốn thay đổi.
3. Tìm đến key message cần chỉnh sửa và cập nhật nội dung theo yêu cầu.
4. Lưu file `.po` sau khi chỉnh sửa.
5. Chạy lệnh sau để biên dịch lại file ngôn ngữ:
    ```bash
    django-admin compilemessages
    ```
6. Kiểm tra lại giao diện ứng dụng để đảm bảo thay đổi đã được áp dụng.

## Lưu ý:

- Đảm bảo cú pháp file `.po` hợp lệ sau khi chỉnh sửa.
- Có thể cần khởi động lại ứng dụng hoặc xóa cache để thấy thay đổi.