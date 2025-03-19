module ourdb

import time
import json
import rand
import net.http

fn test_ourdb_server() {
	// mut server := new_server(OurDBServerArgs{
	// 	port:               3000
	// 	allowed_hosts:      ['localhost']
	// 	allowed_operations: ['set', 'get', 'delete']
	// 	secret_key:         rand.string_from_set('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
	// 		32)
	// 	config:             OurDBConfig{
	// 		record_nr_max:    100
	// 		record_size_max:  1024
	// 		file_size:        10_000
	// 		path:             '/tmp/ourdb'
	// 		incremental_mode: true
	// 		reset:            true
	// 	}
	// }) or { panic(err) }

	// server.run(RunParams{ background: true })
	// time.sleep(1 * time.second)

	// // Test set record
	// mut request_body := json.encode({
	// 	'value': 'Test Value'
	// })

	// mut req := http.new_request(.post, 'http://localhost:3000/set', request_body)
	// mut response := req.do()!

	// assert response.status_code == 201

	// mut decoded_response := json.decode(map[string]string, response.body)!
	// assert decoded_response['message'].str() == 'Successfully set the key'

	// // Test get record
	// time.sleep(500 * time.millisecond)
	// req = http.new_request(.get, 'http://localhost:3000/get/0', '')
	// response = req.do()!

	// assert response.status_code == 200
	// decoded_response = json.decode(map[string]string, response.body)!
	// assert decoded_response['message'].str() == 'Successfully get record'

	// // Test delete record
	// req = http.new_request(.delete, 'http://localhost:3000/delete/0', '')
	// response = req.do()!
	// assert response.status_code == 204

	// // Test invalid operation
	// req = http.new_request(.post, 'http://localhost:3000/invalid', '')
	// response = req.do()!
	// assert response.status_code == 400
}
