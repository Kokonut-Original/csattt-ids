# Lab Security - Docker Compose

Môi trường lab gồm 3 container dùng để thực hành tấn công/giám sát (SSH brute-force, Nmap scan, log cho Wazuh).

## Danh sách máy

| Tên máy | IP          | Vai trò                          | Cổng expose (host) |
|---------|-------------|-----------------------------------|----------------------|
| victim  | 172.28.0.10 | Máy nạn nhân: SSH + Web (Apache)  | 127.0.0.1:2222 -> 22, 127.0.0.1:8080 -> 80 |
| kali    | 172.28.0.20 | Máy tấn công: nmap, hydra, hping3 | (không expose)       |
| server3 | 172.28.0.30 | Máy agent thứ 2: SSH              | 127.0.0.1:2223 -> 22 |

Network: lab_net, subnet 172.28.0.0/24, tên bridge cố định trên host: br-lab.
Múi giờ container: Asia/Ho_Chi_Minh.

## Tài khoản test

- victim: user testuser, password 123456
- server3: user testuser2, password 123456

## Cách chạy

cd lab
docker compose up -d
docker compose ps

## Test nhanh

Ping giữa các máy (ví dụ từ kali):

docker exec -it kali bash
ping -c 3 172.28.0.10
ping -c 3 172.28.0.30

SSH vào victim (từ máy host):

ssh testuser@127.0.0.1 -p 2222

SSH vào server3 (từ máy host):

ssh testuser2@127.0.0.1 -p 2223

Web victim (trình duyệt):

http://127.0.0.1:8080

Hydra brute-force thử (từ trong kali):

hydra -l testuser -P /root/pass.txt ssh://172.28.0.10

Xem log SSH của victim (để kiểm tra Wazuh có đọc được không):

docker logs victim --tail 50

## Tắt lab

docker compose down
