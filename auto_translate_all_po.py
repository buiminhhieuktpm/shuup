import os
import re
from googletrans import Translator

def is_vi_folder(path):
    # Kiểm tra nếu 'vi' là một phần của đường dẫn thư mục cha
    parts = os.path.normpath(path).split(os.sep)
    return 'vi' in parts

def translate_msgid(msgid, translator):
    if not msgid.strip():
        return ""
    try:
        return translator.translate(msgid, src='en', dest='vi').text
    except Exception:
        return msgid  # fallback nếu lỗi mạng

def process_po_file(filepath, translator):
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    new_lines = []
    i = 0
    while i < len(lines):
        line = lines[i]
        new_lines.append(line)
        if line.startswith('msgid "') and i+1 < len(lines) and lines[i+1].startswith('msgstr ""'):
            msgid = re.match(r'msgid "(.*)"', line).group(1)
            # Ghép msgid nhiều dòng
            while not line.rstrip().endswith('"'):
                i += 1
                line = lines[i]
                msgid += line.strip().strip('"')
                new_lines.append(line)
            vi = translate_msgid(msgid, translator)
            new_lines.append(f'msgstr "{vi}"\n')
            i += 1  # bỏ qua msgstr cũ
        i += 1

    with open(filepath, 'w', encoding='utf-8') as f:
        f.writelines(new_lines)

def find_and_translate_vi_po_files(root_dir):
    translator = Translator()
    for dirpath, _, filenames in os.walk(root_dir):
        if not is_vi_folder(dirpath):
            continue
        for filename in filenames:
            if filename.endswith('.po'):
                po_path = os.path.join(dirpath, filename)
                print(f"Dịch: {po_path}")
                process_po_file(po_path, translator)

if __name__ == "__main__":
    # Thay '.' bằng đường dẫn thư mục gốc nếu cần
    find_and_translate_vi_po_files('.')