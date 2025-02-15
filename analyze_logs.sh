#!/bin/bash
cat <<EOL > access.log
192.168.1.1 - - [28/Jul/2024:12:34:56 +0000] "GET /index.html HTTP/1.1" 200 1234
192.168.1.2 - - [28/Jul/2024:12:35:56 +0000] "POST /login HTTP/1.1" 200 567
192.168.1.3 - - [28/Jul/2024:12:36:56 +0000] "GET /home HTTP/1.1" 404 890
192.168.1.1 - - [28/Jul/2024:12:37:56 +0000] "GET /index.html HTTP/1.1" 200 1234
192.168.1.4 - - [28/Jul/2024:12:38:56 +0000] "GET /about HTTP/1.1" 200 432
192.168.1.2 - - [28/Jul/2024:12:39:56 +0000] "GET /index.html HTTP/1.1" 200 1234
EOL

# Общее количество запросов
total=$(wc -l <  access.log)

# Уникальные IP-адреса
ips=$(awk '{print $1}' access.log | sort | uniq | wc -l)

# Количесвто запросов
get_res=$(awk -F'"' '$2 ~ /^GET/ {count++} END {print count+0}' access.log)
post_res=$(awk -F'"' '$2 ~ /^POST/ {count++} END {print count+0}' access.log)

# Самый популярный URL
pop_url_info=$(awk -F'"' '{print $2}' access.log | cut -d' ' -f2 | sort | uniq -c | sort -nr | head -n1)
pop_url_count=$(echo "$pop_url_info" | awk '{print $1}')
pop_url=$(echo "$pop_url_info" | awk '{print $2}')

# Итоговый отчет
cat <<EOF > report.txt
Отчет о логе веб-сервера
=========================
Общее количесвто запросов:      $total
Количесвто уникальных IP-адресов:       $ips


Количество запросов по методам:
        $get_res GET
        $post_res POST


Самый популярный URL:   $pop_url_count $pop_url
EOF
