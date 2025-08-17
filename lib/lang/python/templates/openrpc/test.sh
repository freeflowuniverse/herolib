#!/usr/bin/env bash
set -euo pipefail

HTTP_URL="http://127.0.0.1:7766/rpc"
HTTP_SPEC="http://127.0.0.1:7766/openrpc.json"
UDS_PATH="/tmp/server1"
UDS_URL="http://nothing/rpc"
UDS_SPEC="http://nothing/openrpc.json"

fail() {
  echo "❌ Test failed: $1"
  exit 1
}

echo "🔎 Testing HTTP endpoint..."
resp_http=$(curl -s -H 'content-type: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"add","params":{"a":2,"b":3}}' \
  "$HTTP_URL")

val_http=$(echo "$resp_http" | jq -r '.result')
[[ "$val_http" == "5.0" ]] || fail "HTTP add(2,3) expected 5, got '$val_http'"

echo "✅ HTTP add works"

spec_http=$(curl -s "$HTTP_SPEC" | jq -r '.openrpc')
[[ "$spec_http" =~ ^1\..* ]] || fail "HTTP spec invalid"
echo "✅ HTTP spec available"

echo "🔎 Testing UDS endpoint..."
resp_uds=$(curl -s --unix-socket "$UDS_PATH" \
  -H 'content-type: application/json' \
  -d '{"jsonrpc":"2.0","id":2,"method":"add","params":{"a":10,"b":4}}' \
  "$UDS_URL")

val_uds=$(echo "$resp_uds" | jq -r '.result')
[[ "$val_uds" == "14.0" ]] || fail "UDS add(10,4) expected 14, got '$val_uds'"

echo "✅ UDS add works"

spec_uds=$(curl -s --unix-socket "$UDS_PATH" "$UDS_SPEC" | jq -r '.openrpc')
[[ "$spec_uds" =~ ^1\..* ]] || fail "UDS spec invalid"
echo "✅ UDS spec available"

echo "🎉 All tests passed successfully"
