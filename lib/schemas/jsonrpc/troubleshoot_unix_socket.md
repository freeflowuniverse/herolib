use netcat:

nc -U /tmp/zinit.sock

now copy following
{"jsonrpc":"2.0","method":"service_list","params":[],"id":286703868}

should return something like this:
{"jsonrpc":"2.0","id":286703868,"result":{"test_service":"Running"}}



now copy following
{"jsonrpc":"2.0","method":"rpc.discover","params":[],"id":286703868}



