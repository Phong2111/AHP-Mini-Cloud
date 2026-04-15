import socket
hosts = [
    'web-frontend-server1',
    'web-frontend-server2',
    'relational-database-server',
    'authentication-identity-server',
    'object-storage-server',
    'internal-dns-server',
    'monitoring-prometheus-server',
    'monitoring-grafana-dashboard-server',
    'monitoring-node-exporter-server',
    'api-gateway-proxy-server'
]
print("=== Ping Test (DNS resolve) từ application-backend-server ===")
for h in hosts:
    try:
        ip = socket.gethostbyname(h)
        print(f"  OK  {h} => {ip}")
    except Exception as e:
        print(f"  FAIL {h} => {e}")
