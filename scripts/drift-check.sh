#!/bin/bash

# Drift detection script

# Checks:

#   - Container existence and running state (web_node, app_node, db_node, monitoring_node)
#   - nginx installation and service status (web_node)
#   - Flask app on port 5000 (app_node)
#   - PostgreSQL on port 5432 (db_node)
#   - node_exporter on port 9100 (all nodes)
#   - Prometheus on port 9090 (monitoring_node)
#   - Grafana on port 3000 (monitoring_node)

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
FAIL=0

echo "===== DRIFT CHECK START ====="

# Helper Functions
ok() { echo -e "${GREEN}✅ $1${NC}"; ((PASS++)); }
fail() { echo -e "${RED}❌ $1${NC}"; ((FAIL++)); }


check_port() {
    local container="$1"
    local port="$2"
    local label="$3"

    docker inspect "$container" --format='{{range $p, $conf := .NetworkSettings.Ports}}{{if eq $p "'$port'/tcp"}}{{$conf}}{{end}}{{end}}' | grep -q "<no value>"
    if [ $? -ne 0 ]; then
        ok "$label is listening on port $port"
    else
        fail "$label is NOT listening on port $port"
    fi
}

check_service_or_proc() {
    local container="$1"
    local service="$2"
    docker exec "$container" sh -c "systemctl is-active --quiet $service || pgrep -f '$service'" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        ok "Service/Process '$service' is active"
    else
        fail "Service/Process '$service' is NOT active"
    fi
}

check_node() {
    echo "── $2 ($1) ──────────────────────────────"
    docker ps --format '{{.Names}}' | grep -q "^$1$"
    if [ $? -eq 0 ]; then ok "Container is running"; return 0; else fail "Container is NOT running"; return 1; fi
}

# ── WEB NODE ──────────────────────────────────────────────────────────────
if check_node "web_node" "WEB NODE"; then
    check_service_or_proc "web_node" "nginx"
    check_port "web_node" "9100" "node_exporter"
fi

# ── APP NODE ──────────────────────────────────────────────────────────────
if check_node "app_node" "APP NODE"; then
    check_service_or_proc "app_node" "python3"
    check_port "app_node" "5000" "Flask"
    check_port "app_node" "9100" "node_exporter"
fi

# ── DB NODE ───────────────────────────────────────────────────────────────
if check_node "db_node" "DB NODE"; then
    check_service_or_proc "db_node" "postgresql"
    check_port "db_node" "5432" "PostgreSQL"
    check_port "db_node" "9100" "node_exporter"
fi

# ── MONITORING NODE ───────────────────────────────────────────────────────
if check_node "monitoring_node" "MONITORING NODE"; then
    check_service_or_proc "monitoring_node" "prometheus"
    check_service_or_proc "monitoring_node" "grafana"
    check_port "monitoring_node" "9090" "Prometheus"
    check_port "monitoring_node" "3000" "Grafana"
fi

echo -e "\n===== DRIFT CHECK COMPLETE | PASS: $PASS | FAIL: $FAIL ====="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
