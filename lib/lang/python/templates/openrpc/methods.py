#!/usr/bin/env python3
import os
import json
import signal
import asyncio
from typing import Union

import uvicorn
from fastapi import FastAPI, Response, WebSocket, WebSocketDisconnect
from jsonrpcobjects.objects import (
    ErrorResponse,
    Notification,
    ParamsNotification,
    ParamsRequest,
    Request,
    ResultResponse,
)
from openrpc import RPCServer

# Calculator methods
@rpc.method()
async def add(a: float, b: float) -> float:
    return a + b

@rpc.method()
async def subtract(a: float, b: float) -> float:
    return a - b

@rpc.method()
async def multiply(a: float, b: float) -> float:
    return a * b

@rpc.method()
async def divide(a: float, b: float) -> float:
    if b == 0:
        # Keep it simple; library turns this into a JSON-RPC error
        raise ValueError("Division by zero")
    return a / b
