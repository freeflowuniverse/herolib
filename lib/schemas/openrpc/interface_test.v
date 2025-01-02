module openrpc

import os
import veb
import x.json2 {Any}
import net.http {CommonHeader}
import freeflowuniverse.herolib.schemas.jsonrpc

const specification_path = os.join_path(os.dir(@FILE), '/testdata/openrpc.json')

// handler for test echoes JSONRPC Request as JSONRPC Response
fn handler(request jsonrpc.Request) !jsonrpc.Response {
    return jsonrpc.Response {
        jsonrpc: request.jsonrpc
        id: request.id
        result: request.params
    }
}

fn test_new_server() {
    specification := new(path: specification_path)!
    new_controller(
        specification: specification
        handler: Handler{
            specification: specification
            handler: handler
        }
    )
}

fn test_run_server() {
    specification := new(path: specification_path)!
    mut controller := new_controller(
        specification: specification
        handler: Handler{
            specification: specification
            handler: handler
        }
    )
    spawn controller.run()
}