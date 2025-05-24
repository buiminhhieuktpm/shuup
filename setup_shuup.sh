#!/bin/bash

# Dừng nếu có lỗi
set -e

echo "🛠️ Bắt đầu thiết lập môi trường Shuup..."

# Bước 1: Tạo virtualenv nếu chưa có
if [ ! -d ".venv" ]; then
    echo "📦 Tạo Python virtual environment (.venv)..."
    python3 -m venv .venv
fi

# Bước 2: Kích hoạt virtualenv
echo "✅ Kích hoạt virtual environment..."
source .venv/bin/activate

# Bước 3: Cập nhật pip và cài đặt các gói
echo "⬆️ Cập nhật pip..."
pip install --upgrade pip

# Bước 4: Cài đặt requirements nếu có
if [ -f "requirements.txt" ]; then
    echo "📚 Cài đặt requirements.txt..."
    pip install -r requirements.txt
else
    echo "📚 Cài đặt Django và Shuup..."
    pip install Django
    pip install -e .
fi

# Bước 5: Kiểm tra django-admin
echo "🧪 Kiểm tra django-admin..."
django-admin --version || echo "⚠️ django-admin không tìm thấy!"

# Bước 6: Biên dịch messages (không bắt buộc)
echo "🌐 Biên dịch thông điệp ngôn ngữ (compilemessages)..."
django-admin compilemessages || echo "⚠️ Lỗi compilemessages (bỏ qua nếu không dùng i18n)"

echo "✅ Thiết lập hoàn tất!"