========================
CODE SNIPPETS
========================
TITLE: Basic HTTP Basic Auth with FastAPI
DESCRIPTION: This snippet demonstrates the basic implementation of HTTP Basic Authentication in FastAPI. It imports HTTPBasic and HTTPBasicCredentials, creates a security scheme, and uses it as a dependency in a path operation to retrieve the username and password.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/advanced/security/http-basic-auth.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.security import HTTPBasic, HTTPBasicCredentials

app = FastAPI()

security = HTTPBasic()


def get_current_username(credentials: HTTPBasicCredentials = Depends(security)):
    return credentials.username


@app.get("/items/")
def read_items(username: str = Depends(get_current_username)):
    return {"username": username}
```

----------------------------------------

TITLE: Creating a Basic FastAPI Application
DESCRIPTION: This Python code defines a simple FastAPI application with two endpoints: `/` which returns a greeting, and `/items/{item_id}` which returns the item ID and an optional query parameter. It demonstrates the basic structure of a FastAPI application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/he/docs/index.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Implement Simple HTTP Basic Auth in FastAPI
DESCRIPTION: Demonstrates how to set up basic HTTP authentication in a FastAPI application using `HTTPBasic` and `HTTPBasicCredentials` to protect a path operation. It shows how to define a security dependency and access the provided username and password.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/security/http-basic-auth.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI, Depends
from fastapi.security import HTTPBasic, HTTPBasicCredentials

app = FastAPI()

security = HTTPBasic()

@app.get("/users/me")
def read_current_user(credentials: HTTPBasicCredentials = Depends(security)):
    return {"username": credentials.username, "password": credentials.password}
```

----------------------------------------

TITLE: Simple Function Example
DESCRIPTION: A basic Python function that takes a first name and last name, capitalizes them, and returns the full name. It demonstrates a simple string manipulation task.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_0

LANGUAGE: Python
CODE:
```
def get_full_name(first_name, last_name):
    full_name = first_name.title() + " " + last_name.title()
    return full_name

print(get_full_name("john", "doe"))
```

----------------------------------------

TITLE: Creating a basic FastAPI application
DESCRIPTION: This Python code creates a basic FastAPI application with two endpoints: a root endpoint ("/") that returns a greeting and an endpoint for retrieving items by ID ("/items/{item_id}"). It uses type hints and Pydantic for data validation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/index.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Initializing FastAPI App
DESCRIPTION: Create a basic FastAPI application with two endpoints: `/` which returns a simple greeting, and `/items/{item_id}` which returns the item ID and an optional query parameter.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/vi/docs/index.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Creating a Basic FastAPI App
DESCRIPTION: This code snippet demonstrates how to create a basic FastAPI application with two GET routes: one for the root path ('/') and another for '/items/{item_id}'. The '/items/{item_id}' route accepts an integer item_id and an optional string query parameter q.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/index.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Initializing FastAPI and Defining Basic Routes
DESCRIPTION: This code initializes a FastAPI application and defines two GET routes: one for the root path ('/') and another for '/items/{item_id}' with a path parameter 'item_id' and an optional query parameter 'q'. It demonstrates basic route definition and parameter handling in FastAPI.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/tr/docs/index.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Create Basic API with FastAPI
DESCRIPTION: Create a simple FastAPI application with two endpoints: a root endpoint that returns a greeting and an `/items/{item_id}` endpoint that returns the item ID and an optional query parameter.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh-hant/docs/index.md#_snippet_2

LANGUAGE: python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Initialize a Basic FastAPI Application
DESCRIPTION: This snippet demonstrates the standard setup for a FastAPI application, including importing `FastAPI` and defining a simple path operation. This forms the base for extending OpenAPI.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/how-to/extending-openapi.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/items/")
async def read_items():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Basic FastAPI Application Testing with TestClient
DESCRIPTION: Demonstrates how to set up a basic FastAPI application and test it using `TestClient` from `fastapi.testclient` and `pytest`. This self-contained example shows a simple GET endpoint and its corresponding test function, illustrating the fundamental approach to testing FastAPI apps.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/testing.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
from fastapi.testclient import TestClient

app = FastAPI()

@app.get("/")
def read_main():
    return {"msg": "Hello World"}

client = TestClient(app)

def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"msg": "Hello World"}
```

----------------------------------------

TITLE: Create a Basic FastAPI Application
DESCRIPTION: This snippet shows the minimal Python code required to set up a FastAPI application. It imports `FastAPI`, creates an application instance, and defines a root endpoint (`/`) that returns a simple JSON message. This forms the foundation for any FastAPI project.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/first-steps.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def read_root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Example JSON response for basic path parameter
DESCRIPTION: Shows the JSON output when accessing a FastAPI endpoint with a basic path parameter. This illustrates how the parameter's value is captured from the URL and returned in the response body.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/path-params.md#_snippet_1

LANGUAGE: JSON
CODE:
```
{"item_id":"foo"}
```

----------------------------------------

TITLE: Creating a basic FastAPI application
DESCRIPTION: This Python code defines a simple FastAPI application with two endpoints: `/` which returns a greeting, and `/items/{item_id}` which returns the item ID and an optional query parameter. It imports FastAPI, creates an app instance, and defines the endpoints using decorators.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pl/docs/index.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Returning a basic Response object
DESCRIPTION: This code snippet demonstrates how to return a basic Response object directly. It imports the Response class and returns an instance of it with custom content and media type.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/advanced/custom-response.md#_snippet_8

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
from fastapi.responses import Response

app = FastAPI()


@app.get("/")
async def main():
    content = """
    <html>
        <head>
            <title>Some HTML in here</title>
        </head>
        <body>
            <h1>Hello World!</h1>
        </body>
    </html>
    """
    return Response(content=content, media_type="text/html")
```

----------------------------------------

TITLE: Adding Basic Type Hints to Function Parameters
DESCRIPTION: This snippet demonstrates how to add basic type hints (e.g., `str`) to function parameters. By specifying parameter types, developers gain improved editor autocompletion and static analysis capabilities, enhancing code reliability.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/python-types.md#_snippet_1

LANGUAGE: Python
CODE:
```
{!../../docs_src/python_types/tutorial002.py!}
```

----------------------------------------

TITLE: Create a Basic FastAPI Application
DESCRIPTION: This Python code defines a minimal FastAPI application. It initializes an `app` instance and includes two basic GET endpoints: a root endpoint ('/') returning a simple JSON message, and an item endpoint ('/items/{item_id}') demonstrating path parameters and optional query parameters.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/deployment/docker.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Creating a Basic FastAPI Application
DESCRIPTION: This code defines a basic FastAPI application with two routes: a root route ('/') that returns a simple JSON response, and an '/items/{item_id}' route that accepts an integer path parameter 'item_id' and an optional string query parameter 'q'. It uses the FastAPI framework to handle HTTP requests and responses.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fa/docs/index.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Example JSON Response from FastAPI Root Endpoint
DESCRIPTION: This JSON snippet illustrates the typical response received when accessing the root endpoint (`/`) of the basic FastAPI application. It's a simple dictionary containing a 'message' key with 'Hello World' as its value, demonstrating a fundamental API output.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/first-steps.md#_snippet_2

LANGUAGE: JSON
CODE:
```
{"message": "Hello World"}
```

----------------------------------------

TITLE: Creating a Basic FastAPI Application
DESCRIPTION: This code creates a basic FastAPI application with two endpoints: a root endpoint that returns a simple JSON response and an items endpoint that accepts an item ID and an optional query parameter.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/bn/docs/index.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Initializing FastAPI App with Basic Endpoints
DESCRIPTION: Creates a FastAPI application instance and defines two GET endpoints: one for the root path ('/') and another for '/items/{item_id}' with a path parameter and an optional query parameter. It uses the FastAPI library and returns JSON responses.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/index.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Create a Basic FastAPI 'Hello World' Application
DESCRIPTION: This comprehensive snippet demonstrates the fundamental structure of a FastAPI application. It includes importing FastAPI, initializing the app, defining a GET route for the root path ('/'), and returning a simple JSON response. This is the typical starting point for any FastAPI project.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/first-steps.md#_snippet_5

LANGUAGE: python
CODE:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: FastAPI Default Hello World Response
DESCRIPTION: This JSON snippet shows the typical 'Hello World' response returned by a basic FastAPI application when accessed via a web browser.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/first-steps.md#_snippet_1

LANGUAGE: JSON
CODE:
```
{"message": "Hello World"}
```

----------------------------------------

TITLE: Pydantic Model Definition
DESCRIPTION: Defines a Pydantic model with type annotations for data validation and conversion.  This example shows a basic Pydantic model with string and integer fields.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_18

LANGUAGE: Python
CODE:
```
from typing import List

from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tags: List[str] = []


class Image(BaseModel):
    url: str
    name: str | None = None


class Offer(BaseModel):
    name: str
    description: str | None = None
    price: float
    items: List[Item]

```

----------------------------------------

TITLE: Defining a Basic FastAPI App
DESCRIPTION: This code defines a simple FastAPI application with a single endpoint that returns a JSON response. It imports FastAPI, creates an app instance, and defines a GET route at the root path ('/').

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/first-steps.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}

```

----------------------------------------

TITLE: Example FastAPI JSON response
DESCRIPTION: This JSON object represents the default response from a basic FastAPI application when accessed at its root URL, typically indicating a successful 'Hello World' message.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/first-steps.md#_snippet_1

LANGUAGE: json
CODE:
```
{"message": "Hello World"}
```

----------------------------------------

TITLE: Secure Username Verification with HTTP Basic Auth
DESCRIPTION: This snippet shows how to securely verify a username and password using Python's secrets module to prevent timing attacks. It converts the username and password to UTF-8 encoded bytes before using secrets.compare_digest() to compare them.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/advanced/security/http-basic-auth.md#_snippet_1

LANGUAGE: Python
CODE:
```
import secrets

from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.security import HTTPBasic, HTTPBasicCredentials

app = FastAPI()

security = HTTPBasic()


def get_current_username(credentials: HTTPBasicCredentials = Depends(security)):
    correct_username = secrets.compare_digest(credentials.username, "stanleyjobson".encode("utf8"))
    correct_password = secrets.compare_digest(credentials.password, "swordfish".encode("utf8"))
    if not (correct_username and correct_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Basic"},
        )
    return credentials.username


@app.get("/items/")
def read_items(username: str = Depends(get_current_username)):
    return {"username": username}
```

----------------------------------------

TITLE: Initializing FastAPI App with async
DESCRIPTION: Create a basic FastAPI application with two endpoints: `/` which returns a simple greeting, and `/items/{item_id}` which returns the item ID and an optional query parameter. This example uses `async def` for asynchronous execution.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/vi/docs/index.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: FastAPI: Basic Optional Query Parameter
DESCRIPTION: Demonstrates a basic FastAPI application with an optional query parameter `q` of type `Optional[str]`. This parameter is not required as its default value is `None`, allowing it to be omitted from the request.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/query-params-str-validations.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import FastAPI

app = FastAPI()


@app.get("/items/")
async def read_items(q: Optional[str] = None):
    return {"q": q}
```

----------------------------------------

TITLE: Initializing FastAPI Application
DESCRIPTION: This code initializes a basic FastAPI application with two GET endpoints: one for the root path ('/') and another for retrieving items by ID ('/items/{item_id}'). It demonstrates how to define path parameters and optional query parameters.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/index.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Declaring Standard Python Built-in Types
DESCRIPTION: This section provides examples of declaring common built-in Python types using type hints. It covers basic types such as `int`, `float`, `bool`, and `bytes`, showcasing their straightforward application in function signatures.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/python-types.md#_snippet_4

LANGUAGE: Python
CODE:
```
{!../../docs_src/python_types/tutorial005.py!}
```

----------------------------------------

TITLE: Initializing FastAPI and Defining Basic Routes
DESCRIPTION: This code initializes a FastAPI application and defines two GET routes: one for the root path ('/') and another for '/items/{item_id}'. The '/items/{item_id}' route accepts an integer item_id and an optional string query parameter q.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/az/docs/index.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Simple FastAPI Application
DESCRIPTION: This is a minimal FastAPI application that defines a single route ('/') which returns a JSON response. It demonstrates the basic structure of a FastAPI application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/first-steps.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}

```

----------------------------------------

TITLE: Creating a Basic FastAPI App with Async
DESCRIPTION: This code snippet demonstrates how to create a basic FastAPI application with asynchronous route handlers using `async def`. It includes two GET routes: one for the root path ('/') and another for '/items/{item_id}'. The '/items/{item_id}' route accepts an integer item_id and an optional string query parameter q.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/index.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Simple FastAPI Application
DESCRIPTION: This code defines a basic FastAPI application with a single endpoint that returns a JSON response. It imports the FastAPI class, creates an instance of it, and defines a path operation for the root path ('/').

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/first-steps.md#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Create Basic FastAPI GET Endpoints
DESCRIPTION: This Python code defines a simple FastAPI application with two GET endpoints. The root endpoint ('/') returns a 'Hello World' message, and the '/items/{item_id}' endpoint retrieves an item by ID, optionally accepting a query parameter 'q'.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/id/docs/index.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Basic FastAPI Application
DESCRIPTION: This code snippet defines a simple FastAPI application with a single endpoint that returns a JSON response. It imports the FastAPI class, creates an instance of it, and defines a path operation function that returns a dictionary.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/vi/docs/tutorial/first-steps.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root():
    return {"message": "Hello World"}

```

----------------------------------------

TITLE: Create a basic Dockerfile for FastAPI
DESCRIPTION: This Dockerfile demonstrates how to build a basic Docker image for a FastAPI application using the official `tiangolo/uvicorn-gunicorn-fastapi:python3.9` base image. It copies `requirements.txt`, installs dependencies, and then copies the application code into the `/app` directory.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/deployment/docker.md#_snippet_4

LANGUAGE: Dockerfile
CODE:
```
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9

COPY ./requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

COPY ./app /app
```

----------------------------------------

TITLE: Define Basic FastAPI Application Endpoints
DESCRIPTION: Example Python code for a simple FastAPI application defining a root endpoint and an item endpoint with path and query parameters. Includes both synchronous and asynchronous function definitions for handling requests.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/index.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Securely Compare Credentials with secrets.compare_digest() in FastAPI
DESCRIPTION: Provides a complete example of implementing HTTP Basic Auth with secure credential validation in FastAPI. It uses Python's `secrets.compare_digest()` to prevent timing attacks by ensuring constant-time comparison of usernames and passwords, and raises an `HTTPException` with a 401 status code and `WWW-Authenticate` header on incorrect credentials.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/security/http-basic-auth.md#_snippet_1

LANGUAGE: Python
CODE:
```
import secrets
from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import HTTPBasic, HTTPBasicCredentials

app = FastAPI()

security = HTTPBasic()

@app.get("/users/me")
def read_current_user(credentials: HTTPBasicCredentials = Depends(security)):
    correct_username = secrets.compare_digest(credentials.username.encode("utf-8"), b"stanleyjobson")
    correct_password = secrets.compare_digest(credentials.password.encode("utf-8"), b"swordfish")
    if not (correct_username and correct_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Basic"},
        )
    return {"username": credentials.username, "password": credentials.password}
```

----------------------------------------

TITLE: Basic FastAPI Test with TestClient
DESCRIPTION: This snippet demonstrates a basic test case for a FastAPI application using TestClient. It imports TestClient, creates an instance with the FastAPI app, sends a request, and asserts the response status code.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/testing.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
from fastapi.testclient import TestClient

app = FastAPI()

@app.get("/")
async def read_main():
    return {"msg": "Hello World"}


client = TestClient(app)


def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"msg": "Hello World"}
```

----------------------------------------

TITLE: Simple FastAPI Application
DESCRIPTION: This code defines a basic FastAPI application with a single endpoint that returns a JSON response. It uses the FastAPI framework to create the API and the uvicorn server to run it.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/id/docs/tutorial/first-steps.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Simple FastAPI Application
DESCRIPTION: This code defines a basic FastAPI application with a single endpoint that returns a JSON response. It imports the FastAPI class, creates an instance of it, and defines a path operation decorator for the root endpoint.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/first-steps.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}

```

----------------------------------------

TITLE: Basic Dockerfile for FastAPI
DESCRIPTION: This Dockerfile sets up a basic environment for running a FastAPI application using the tiangolo/uvicorn-gunicorn-fastapi base image. It copies the requirements file, installs dependencies, and then copies the application code.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/deployment/docker.md#_snippet_18

LANGUAGE: Dockerfile
CODE:
```
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9

COPY ./requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

COPY ./app /app
```

----------------------------------------

TITLE: Creating a Basic FastAPI App
DESCRIPTION: This Python code defines a simple FastAPI application with two routes: a root route ('/') that returns a greeting and an '/items/{item_id}' route that returns an item ID and an optional query parameter. It imports FastAPI and uses decorators to define the routes.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/index.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Define a Pydantic Model with a Basic List Field
DESCRIPTION: Demonstrates how to define a Pydantic model field as a simple Python `list`. This allows the field to accept a list of items without explicitly specifying their internal type, providing flexibility for data structures where item types are not strictly enforced.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body-nested-models.md#_snippet_0

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    tags: list
```

----------------------------------------

TITLE: Simple FastAPI Application
DESCRIPTION: This code defines a basic FastAPI application with a single endpoint that returns a JSON response. It imports the FastAPI class, creates an instance of it, and defines a path operation decorator to handle requests to the root path.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pl/docs/tutorial/first-steps.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Build Basic FastAPI Docker Image with Uvicorn and Gunicorn
DESCRIPTION: This Dockerfile provides a basic setup for a FastAPI application using the `tiangolo/uvicorn-gunicorn-fastapi` base image. It copies `requirements.txt`, installs dependencies, and then copies the application code. This is suitable for standard FastAPI projects.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/deployment/docker.md#_snippet_15

LANGUAGE: Dockerfile
CODE:
```
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9

COPY ./requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

COPY ./app /app
```

----------------------------------------

TITLE: Body with Examples
DESCRIPTION: Demonstrates how to pass a single example for the expected data in `Body()`.  This example shows how to define a request body with an example for the API documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/schema-extra-example.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import Body, FastAPI

app = FastAPI()


@app.post("/items/")
async def create_item(
    item: str = Body(
        examples=[
            {
                "name": "Foo",
                "description": "A very nice Item",
                "price": 50.2,
                "tax": 3.2,
            }
        ]
    ),
):
    return item
```

----------------------------------------

TITLE: Create a basic FastAPI application with GET endpoints
DESCRIPTION: This code demonstrates how to define a simple FastAPI application with two GET endpoints: a root path (/) and an item path (/items/{item_id}). The item path includes a path parameter (item_id) and an optional query parameter (q). It shows both synchronous (def) and asynchronous (async def) implementations for the route handlers.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/index.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Create a basic FastAPI application with GET endpoints
DESCRIPTION: This code demonstrates how to define a simple FastAPI application with two GET endpoints: a root path (/) and an item path (/items/{item_id}). The item path includes a path parameter (item_id) and an optional query parameter (q). It shows both synchronous (def) and asynchronous (async def) implementations for the route handlers.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/README.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Simple FastAPI Application
DESCRIPTION: This code defines a basic FastAPI application with a single endpoint that returns a JSON response. It imports FastAPI, creates an app instance, and defines a path operation decorator for the root endpoint.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh-hant/docs/tutorial/first-steps.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}

```

----------------------------------------

TITLE: Basic FastAPI test with TestClient
DESCRIPTION: Demonstrates how to import TestClient, create an instance with your FastAPI app, and write a simple test function using pytest.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/testing.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
from fastapi.testclient import TestClient

app = FastAPI()

@app.get("/")
async def read_main():
    return {"msg": "Hello World"}


client = TestClient(app)


def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"msg": "Hello World"}
```

----------------------------------------

TITLE: Define a Basic List Field in Pydantic Model (Python 3.10+)
DESCRIPTION: This snippet demonstrates how to declare a field as a generic Python `list` within a Pydantic model using Python 3.10+ syntax. This indicates a list without specifying the type of its elements, allowing for flexible content.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/body-nested-models.md#_snippet_0

LANGUAGE: Python
CODE:
```
tags: list
```

----------------------------------------

TITLE: Define a simple query parameter dependency
DESCRIPTION: This dependency function extracts an optional query parameter `q` as a string. It serves as a basic example to illustrate sub-dependency concepts in FastAPI.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/dependencies/sub-dependencies.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Optional

async def query_extractor(q: Optional[str] = None):
    return q
```

----------------------------------------

TITLE: Define Basic Path Parameter in FastAPI
DESCRIPTION: Demonstrates how to define a simple path parameter in a FastAPI application. The parameter's value will be passed directly as a string without automatic type conversion.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/path-params.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/items/{item_id}")
async def read_item(item_id):
    return {"item_id": item_id}
```

----------------------------------------

TITLE: Simple Function Example
DESCRIPTION: This example demonstrates a simple function that concatenates a first name and last name, converting each to title case. It highlights the lack of autocompletion without type hints.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_0

LANGUAGE: Python
CODE:
```
def get_full_name(first_name, last_name):
    full_name = first_name.title() + " " + last_name.title()
    return full_name

print(get_full_name("john", "doe"))
```

----------------------------------------

TITLE: Create a Basic FastAPI Application with Models
DESCRIPTION: This Python code defines a simple FastAPI application. It includes Pydantic models (`Item` and `ResponseMessage`) for defining request and response data structures, and two basic path operations: a GET endpoint for the root and a POST endpoint for creating items. These models are crucial for FastAPI to generate OpenAPI schemas.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/advanced/generate-clients.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


class ResponseMessage(BaseModel):
    message: str


app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.post("/items/{item_id}", response_model=ResponseMessage)
def create_item(item_id: int, item: Item):
    return {"message": f"Item {item_id} created with name {item.name}"}
```

----------------------------------------

TITLE: Example CSS for static files
DESCRIPTION: A simple CSS snippet (`styles.css`) that would be served as a static file by FastAPI, demonstrating basic styling. This file is typically referenced from Jinja2 templates using `url_for`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/advanced/templates.md#_snippet_5

LANGUAGE: CSS
CODE:
```
body {
    font-family: sans-serif;
    color: #333;
}
```

----------------------------------------

TITLE: Simple FastAPI Application
DESCRIPTION: This code defines a basic FastAPI application with a single endpoint that returns a JSON response. It uses the FastAPI framework to create an API endpoint at the root path ('/') that returns a JSON object with a 'message' key.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/first-steps.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}

```

----------------------------------------

TITLE: Import FastAPI status module
DESCRIPTION: Demonstrates the basic import statement for the `status` module from `fastapi`, which provides access to HTTP status code constants.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/reference/status.md#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import status
```

----------------------------------------

TITLE: Python Standard Context Manager Example
DESCRIPTION: Demonstrates the basic syntax and usage of a standard Python context manager with the 'with' statement. This pattern ensures that resources, such as files, are properly managed and closed automatically after their use, even if errors occur.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/events.md#_snippet_0

LANGUAGE: Python
CODE:
```
with open("file.txt") as file:
    file.read()
```

----------------------------------------

TITLE: Detailed Timing Attack Scenario Illustration
DESCRIPTION: Illustrates how a timing attack works by showing how Python's string comparison behavior can inadvertently leak information about correct characters in a username or password, allowing attackers to guess credentials more efficiently.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/security/http-basic-auth.md#_snippet_3

LANGUAGE: Python
CODE:
```
if "johndoe" == "stanleyjobson" and "love123" == "swordfish":
    ...
if "stanleyjobsox" == "stanleyjobson" and "love123" == "swordfish":
    ...
```

----------------------------------------

TITLE: Illustrative Vulnerable Credential Comparison
DESCRIPTION: An example of a common, but insecure, way to compare credentials. This type of comparison is vulnerable to timing attacks because it may short-circuit, revealing information about the correctness of partial inputs based on response time.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/security/http-basic-auth.md#_snippet_2

LANGUAGE: Python
CODE:
```
if not (credentials.username == "stanleyjobson") or not (credentials.password == "swordfish"):
    # Return some error
    ...
```

----------------------------------------

TITLE: Pydantic Model Example
DESCRIPTION: This example demonstrates a basic Pydantic model definition. It shows how to define a class with typed attributes, which Pydantic uses for data validation and conversion. This is a fundamental concept in FastAPI for handling request and response data.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/python-types.md#_snippet_10

LANGUAGE: python
CODE:
```
from typing import Union

from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


# Input data
item_data = {"name": "Foo", "description": "", "price": 50.2, "tax": 3.6}

item = Item(**item_data)

print(item.name)
print(item.price + item.tax)

item_data = {"name": "Foo", "price": 50.2}

item = Item(**item_data)

print(item.description)
```

----------------------------------------

TITLE: Define a Python Function Without Type Hints
DESCRIPTION: This example demonstrates a basic Python function that concatenates first and last names. Without type hints, code editors may not provide useful autocompletion for string methods, making development less efficient.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/python-types.md#_snippet_0

LANGUAGE: python
CODE:
```
def get_full_name(first_name, last_name):
    return f"{first_name.title()} {last_name.title()}"

# Example usage:
# print(get_full_name("john", "doe"))
```

----------------------------------------

TITLE: Initializing WebSocket endpoint
DESCRIPTION: Creates a WebSocket endpoint in a FastAPI application to handle incoming and outgoing messages. It defines the basic structure for handling WebSocket connections, receiving messages, and sending responses.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/advanced/websockets.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI, WebSocket

app = FastAPI()


@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    while True:
        data = await websocket.receive_text()
        await websocket.send_text(f"Message text was: {data}")
```

----------------------------------------

TITLE: Simple Type Declarations
DESCRIPTION: This example demonstrates how to declare simple types such as int, float, bool, and bytes.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_4

LANGUAGE: Python
CODE:
```
age: int
price: float
awake: bool
binary: bytes
```

----------------------------------------

TITLE: Body with Multiple Examples
DESCRIPTION: Demonstrates how to pass multiple examples for the expected data in `Body()`. This example shows how to define a request body with multiple examples for the API documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/schema-extra-example.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import Body, FastAPI

app = FastAPI()


@app.post("/items/")
async def create_item(
    item: str = Body(
        examples=[
            {
                "name": "Foo",
                "description": "A very nice Item",
                "price": 50.2,
                "tax": 3.2,
            },
            {
                "name": "Bar",
                "price": 62,
                "description": "The Bar fighters",
                "tax": 2.2,
            },
        ]
    ),
):
    return item
```

----------------------------------------

TITLE: OpenAPI JSON Schema Example
DESCRIPTION: This JSON schema represents a basic OpenAPI definition generated by FastAPI, including the OpenAPI version, API title, version, and a simple path definition for '/items/'. It demonstrates the structure of the automatically generated API documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/first-steps.md#_snippet_1

LANGUAGE: JSON
CODE:
```
{
    "openapi": "3.1.0",
    "info": {
        "title": "FastAPI",
        "version": "0.1.0"
    },
    "paths": {
        "/items/": {
            "get": {
                "responses": {
                    "200": {
                        "description": "Successful Response",
                        "content": {
                            "application/json": {



... 
```

----------------------------------------

TITLE: Basic FastAPI Application Code
DESCRIPTION: A minimal FastAPI application demonstrating two API endpoints: a root endpoint ('/') returning a simple JSON message, and an item endpoint ('/items/{item_id}') that accepts an integer path parameter and an optional string query parameter. This serves as a foundational example for building RESTful APIs with FastAPI.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/deployment/docker.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Creating a basic FastAPI application
DESCRIPTION: This Python code defines a simple FastAPI application with two endpoints: a root endpoint that returns a greeting and an /items/{item_id} endpoint that returns the item ID and an optional query parameter.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/deployment/docker.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Optional[str] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Run FastAPI Application with WebSockets
DESCRIPTION: Executes the FastAPI application in development mode using `fastapi dev`, making the basic WebSocket endpoint accessible for testing and interaction.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/websockets.md#_snippet_1

LANGUAGE: console
CODE:
```
$ fastapi dev main.py
```

----------------------------------------

TITLE: Declare Simple Python Built-in Types
DESCRIPTION: This example demonstrates how to declare common built-in Python types such as `str`, `int`, `float`, `bool`, and `bytes` as type hints for function parameters. These simple type declarations provide clear expectations for function inputs and enhance code readability and maintainability.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/python-types.md#_snippet_4

LANGUAGE: python
CODE:
```
def process_data(name: str, count: int, price: float, is_active: bool, raw_data: bytes):
    # Example function using various simple types
    # Type hints ensure that arguments passed to this function conform to the specified types.
    pass
```

----------------------------------------

TITLE: Define and Instantiate a Python Class
DESCRIPTION: Illustrates how to define a basic Python class with an `__init__` method and subsequently create an instance of that class, demonstrating that classes are callables and can be used in contexts requiring callable objects.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/dependencies/classes-as-dependencies.md#_snippet_0

LANGUAGE: Python
CODE:
```
class Cat:
    def __init__(self, name: str):
        self.name = name


fluffy = Cat(name="Mr Fluffy")
```

----------------------------------------

TITLE: Declaring an Integer Type
DESCRIPTION: This snippet demonstrates how to declare an integer type for a parameter in FastAPI. It shows the basic syntax for type hinting in Python, which FastAPI uses for data validation and conversion.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pl/docs/index.md#_snippet_7

LANGUAGE: Python
CODE:
```
item_id: int
```

----------------------------------------

TITLE: Handling WebSocket messages
DESCRIPTION: Demonstrates how to receive and send messages through a WebSocket connection in FastAPI. It shows the basic structure for handling WebSocket connections, receiving messages, and sending responses.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/advanced/websockets.md#_snippet_2

LANGUAGE: Python
CODE:
```
await websocket.accept()
while True:
    data = await websocket.receive_text()
    await websocket.send_text(f"Message text was: {data}")
```

----------------------------------------

TITLE: Example JSON Request Body Structures
DESCRIPTION: Provides examples of valid JSON request bodies that conform to the `Item` Pydantic model. The first example includes all defined fields, while the second demonstrates how optional fields can be omitted while still being a valid request.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body.md#_snippet_2

LANGUAGE: JSON
CODE:
```
{
    "name": "Foo",
    "description": "An optional description",
    "price": 45.2,
    "tax": 3.5
}

{
    "name": "Foo",
    "price": 45.2
}
```

----------------------------------------

TITLE: Install Hypercorn
DESCRIPTION: Install Hypercorn, an ASGI server that supports HTTP/2. This command performs a basic installation without specific extras.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/deployment/manually.md#_snippet_1

LANGUAGE: Shell
CODE:
```
pip install hypercorn
```

----------------------------------------

TITLE: Example JSON Request Body (All Fields)
DESCRIPTION: Illustrates a complete JSON object that fully conforms to the `Item` Pydantic model. This example includes all defined fields, both mandatory and optional, with representative values, demonstrating a typical request body structure.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body.md#_snippet_2

LANGUAGE: JSON
CODE:
```
{
    "name": "Foo",
    "description": "Uma descrição opcional",
    "price": 45.2,
    "tax": 3.5
}
```

----------------------------------------

TITLE: Defining a Base Hero Model
DESCRIPTION: This snippet defines a base model for Hero data, containing common fields like name and age. This base model can be inherited by other models to avoid duplication.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/sql-databases.md#_snippet_9

LANGUAGE: Python
CODE:
```
class HeroBase(SQLModel):
    name: str = Field(index=True)
    age: Optional[int] = Field(default=None, index=True)
```

----------------------------------------

TITLE: Run Uvicorn with basic host and port
DESCRIPTION: Defines the default command to run the Uvicorn server inside the Docker container, binding it to all network interfaces on port 80.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/deployment/docker.md#_snippet_4

LANGUAGE: Dockerfile
CODE:
```
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
```

----------------------------------------

TITLE: FastAPI Dependency Injection Flow Diagram
DESCRIPTION: This Mermaid diagram visually represents a basic dependency injection flow in FastAPI. It shows how a single dependency function (`common_parameters`) can be reused and injected into multiple distinct path operations (`/items/` and `/users/`), illustrating the concept of shared dependencies.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/dependencies/index.md#_snippet_3

LANGUAGE: mermaid
CODE:
```
graph TB

common_parameters(["common_parameters"])
read_items["/items/"]
read_users["/users/"]

common_parameters --> read_items
common_parameters --> read_users
```

----------------------------------------

TITLE: Initializing a Dictionary - Python 3.8+
DESCRIPTION: This snippet initializes a dictionary `prices` where keys are strings and values are floats. It uses the `Dict` type from the `typing` module to specify the key and value types.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_9

LANGUAGE: Python
CODE:
```
from typing import Dict

prices: Dict[str, float] = {"apple": 1.5, "banana": 0.7}
```

----------------------------------------

TITLE: Database Dependency with yield
DESCRIPTION: Creates a database session, yields it for use in the route function, and then closes the session after the response is sent. Demonstrates the basic structure of a dependency using `yield` for cleanup.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/dependencies/dependencies-with-yield.md#_snippet_0

LANGUAGE: python
CODE:
```
db = DBSession()
try:
    yield db
finally:
    db.close()
```

----------------------------------------

TITLE: Creating an async FastAPI application
DESCRIPTION: This Python code demonstrates how to create a basic FastAPI application using `async def` for asynchronous request handling. It includes two endpoints: a root endpoint and an endpoint for retrieving items by ID, both defined as asynchronous functions.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/index.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Basic FastAPI Test with TestClient
DESCRIPTION: This snippet demonstrates how to use TestClient to test a FastAPI application. It imports TestClient, creates an instance with the FastAPI app, and then makes requests to the application, asserting the expected responses.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/testing.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
from fastapi.testclient import TestClient

app = FastAPI()

@app.get("/")
async def read_main():
    return {"msg": "Hello World"}


client = TestClient(app)


def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"msg": "Hello World"}
```

----------------------------------------

TITLE: Define a simple FastAPI application
DESCRIPTION: This Python code defines a basic FastAPI application with a single asynchronous GET endpoint at the root path. It returns a JSON object with a 'Hello World' message, serving as the application under test for the asynchronous examples.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/async-tests.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def read_root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Basic Jinja2 template for item display
DESCRIPTION: A simple Jinja2 template (`item.html`) demonstrating how to display a variable (`id`) passed from the FastAPI context. This template would typically reside in a 'templates' directory and be rendered by `Jinja2Templates`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/advanced/templates.md#_snippet_2

LANGUAGE: jinja
CODE:
```
Item ID: {{ id }}
```

----------------------------------------

TITLE: Define Base SQLModel for Hero Attributes
DESCRIPTION: Creates `HeroBase`, a non-table SQLModel (which acts as a Pydantic model) that defines common attributes like `name` and `age`. This base class is used for inheritance to avoid duplicating fields across different representations of the Hero model.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/sql-databases.md#_snippet_11

LANGUAGE: Python
CODE:
```
from typing import Optional
from sqlmodel import Field, SQLModel

class HeroBase(SQLModel):
    name: str
    age: Optional[int] = None
```

----------------------------------------

TITLE: Creating an Asynchronous FastAPI Application
DESCRIPTION: This Python code defines a simple FastAPI application with two asynchronous endpoints: `/` which returns a greeting, and `/items/{item_id}` which returns the item ID and an optional query parameter. It demonstrates the basic structure of a FastAPI application using async def.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/he/docs/index.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Initializing a Dictionary - Python 3.9+
DESCRIPTION: This snippet initializes a dictionary `prices` where keys are strings and values are floats. It uses the built-in `dict` type with type parameters to specify the key and value types.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_10

LANGUAGE: Python
CODE:
```
prices: dict[str, float] = {"apple": 1.5, "banana": 0.7}
```

----------------------------------------

TITLE: Mix Required, Default, and Optional Query Parameters in FastAPI
DESCRIPTION: Demonstrates the flexibility of FastAPI in handling a combination of required, default, and optional query parameters within a single endpoint. This example defines `needy` as required, `skip` with a default value, and `limit` as optional, showcasing robust and versatile parameter management for complex API designs.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params.md#_snippet_5

LANGUAGE: Python
CODE:
```
from typing import Union
from fastapi import FastAPI

app = FastAPI()

@app.get("/items/{item_id}")
async def read_user_item(
    item_id: str, needy: str, skip: int = 0, limit: Union[int, None] = None
):
    item = {"item_id": item_id, "needy": needy, "skip": skip, "limit": limit}
    return item
```

----------------------------------------

TITLE: Example PUT Request Body
DESCRIPTION: An example of a JSON request body sent with an HTTP PUT request. This body demonstrates how providing only a subset of fields can lead to default values being applied to missing fields during a full replacement operation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-updates.md#_snippet_1

LANGUAGE: Python
CODE:
```
{
    "name": "Barz",
    "price": 3,
    "description": None,
}
```

----------------------------------------

TITLE: Overview of HTTP Methods and FastAPI Path Operation Decorators
DESCRIPTION: This documentation outlines the standard HTTP methods (GET, POST, PUT, DELETE) and their typical use cases in RESTful API design. It also lists the corresponding FastAPI decorators (`@app.get()`, `@app.post()`, etc.) used to associate functions with specific HTTP methods and paths.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/first-steps.md#_snippet_4

LANGUAGE: APIDOC
CODE:
```
HTTP Methods:
- `POST`: Create data.
- `GET`: Read data.
- `PUT`: Update data.
- `DELETE`: Delete data.
- Less common methods: `OPTIONS`, `HEAD`, `PATCH`, `TRACE`.

FastAPI Path Operation Decorators:
- `@app.post()`
- `@app.get()`
- `@app.put()`
- `@app.delete()`
- `@app.options()`
- `@app.head()`
- `@app.patch()`
- `@app.trace()`
```

----------------------------------------

TITLE: Define Dictionary-Returning Dependency in FastAPI
DESCRIPTION: Demonstrates a basic FastAPI dependency function that returns a dictionary of common query parameters. This function can then be injected into path operations, providing a structured way to manage common inputs.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/dependencies/classes-as-dependencies.md#_snippet_0

LANGUAGE: Python
CODE:
```
def common_parameters(q: Optional[str] = None, skip: int = 0, limit: int = 100):
    return {"q": q, "skip": skip, "limit": limit}
```

----------------------------------------

TITLE: Import Pydantic BaseModel for Request Body Definition
DESCRIPTION: Imports the `BaseModel` class from the Pydantic library, which serves as the foundational class for defining structured data models. These models are essential for FastAPI to parse, validate, and serialize incoming request body data.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body.md#_snippet_0

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel
```

----------------------------------------

TITLE: Define Path Operation with APIRouter
DESCRIPTION: Demonstrates a basic GET path operation defined on an `APIRouter` instance. The path specified here is relative to any prefix configured on the router, allowing for clean and modular route definitions.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/bigger-applications.md#_snippet_6

LANGUAGE: Python
CODE:
```
@router.get("/{item_id}")
async def read_item(item_id: str):
    ...
```

----------------------------------------

TITLE: Displaying context variable in Jinja2 template
DESCRIPTION: Illustrates the basic syntax for embedding and displaying a variable (e.g., 'id') passed from the context dictionary within a Jinja2 HTML template using double curly braces.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/templates.md#_snippet_1

LANGUAGE: Jinja
CODE:
```
Item ID: {{ id }}
```

----------------------------------------

TITLE: Define a Path Operation with APIRouter
DESCRIPTION: This snippet demonstrates a basic path operation definition using an APIRouter instance. It shows how to define a GET endpoint with a path parameter, illustrating the syntax for a route within a router.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/bigger-applications.md#_snippet_3

LANGUAGE: Python
CODE:
```
@router.get("/{item_id}")
async def read_item(item_id: str):
    ...
```

----------------------------------------

TITLE: FastAPI OpenAPI Specification Structure
DESCRIPTION: This JSON snippet illustrates the basic structure of the OpenAPI specification automatically generated by FastAPI. It includes metadata like API version and title, and defines the available paths and their HTTP methods, along with expected responses.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/first-steps.md#_snippet_0

LANGUAGE: JSON
CODE:
```
{
    "openapi": "3.1.0",
    "info": {
        "title": "FastAPI",
        "version": "0.1.0"
    },
    "paths": {
        "/items/": {
            "get": {
                "responses": {
                    "200": {
                        "description": "Successful Response",
                        "content": {
                            "application/json": {



...

```

----------------------------------------

TITLE: FastAPI Path Operation with Raw Token Dependency
DESCRIPTION: Illustrates a basic FastAPI path operation that directly receives a raw token string from an `OAuth2PasswordBearer` dependency, before processing it into a user object. This is typically the first step in a token-based authentication flow.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/security/get-current-user.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import Depends
from fastapi.security import OAuth2PasswordBearer

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

async def read_users_me(token: str = Depends(oauth2_scheme)):
    # This function would typically process the raw token
    pass
```

----------------------------------------

TITLE: Basic FastAPI Application Testing with TestClient
DESCRIPTION: This snippet illustrates a fundamental approach to testing a FastAPI application. It demonstrates how to import and instantiate `TestClient` with your FastAPI app, then write a `pytest`-compatible function to send requests and assert the expected responses, all within a single file for simplicity.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/testing.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
from fastapi.testclient import TestClient

app = FastAPI()

@app.get("/")
async def read_main():
    return {"msg": "Hello World"}

client = TestClient(app)

def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"msg": "Hello World"}
```

----------------------------------------

TITLE: Awaiting and Sending Messages in WebSocket Route
DESCRIPTION: This snippet shows how to await messages from a WebSocket connection and send messages back to the client. It demonstrates the basic structure for handling WebSocket communication within a FastAPI application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/advanced/websockets.md#_snippet_1

LANGUAGE: Python
CODE:
```
await websocket.accept()
while True:
    data = await websocket.receive_text()
    await websocket.send_text(f"Message text was: {data}")
```

----------------------------------------

TITLE: Adicionar tarefa em segundo plano com BackgroundTasks
DESCRIPTION: Este snippet demonstra como adicionar uma tarefa em segundo plano usando o método .add_task() do objeto BackgroundTasks. Ele recebe a função de tarefa e seus argumentos como parâmetros.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/background-tasks.md#_snippet_2

LANGUAGE: python
CODE:
```
from fastapi import BackgroundTasks, FastAPI

app = FastAPI()


async def write_notification(email: str, message=""):
    with open("log.txt", mode="w") as f:
        f.write(f"notification for {email}: {message}")


@app.post("/send-notification/{email}")
async def send_notification(email: str, background_tasks: BackgroundTasks):
    background_tasks.add_task(write_notification, email, message="some notification")
    return {"message": "Notification sent in the background"}
```

----------------------------------------

TITLE: FastAPI Parameter Functions for Example Data
DESCRIPTION: Documents the parameters available in FastAPI's dependency injection functions (`Path`, `Query`, `Header`, `Cookie`, `Body`, `Form`, `File`) for declaring example data in OpenAPI documentation. Explains the difference and usage of JSON Schema `examples` and OpenAPI-specific `openapi_examples`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/schema-extra-example.md#_snippet_4

LANGUAGE: APIDOC
CODE:
```
FastAPI Parameter Functions: Path(), Query(), Header(), Cookie(), Body(), Form(), File()

These functions accept parameters to include example data in the generated OpenAPI (and JSON Schema) documentation.

1. JSON Schema `examples` parameter:
   - Purpose: To declare an array of examples that will be added to the JSON Schema for the parameter.
   - Usage: `param: Type = Function(examples=[{...
```

----------------------------------------

TITLE: Implementing Basic StreamingResponse in FastAPI
DESCRIPTION: Shows how to use `StreamingResponse` to stream response bodies using an asynchronous generator. This is useful for sending large amounts of data incrementally without loading it all into memory at once.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/advanced/custom-response.md#_snippet_11

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
import asyncio

app = FastAPI()

async def generate_data():
    for i in range(5):
        yield f"data: {i}\n"
        await asyncio.sleep(0.5)

@app.get("/stream")
async def stream_example():
    return StreamingResponse(generate_data(), media_type="text/event-stream")
```

----------------------------------------

TITLE: FastAPI Generated OpenAPI JSON Schema Example
DESCRIPTION: An example of the OpenAPI JSON schema automatically generated by FastAPI, illustrating the basic structure including the OpenAPI version, API information, and defined paths with their operations and responses.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/first-steps.md#_snippet_0

LANGUAGE: JSON
CODE:
```
{
    "openapi": "3.1.0",
    "info": {
        "title": "FastAPI",
        "version": "0.1.0"
    },
    "paths": {
        "/items/": {
            "get": {
                "responses": {
                    "200": {
                        "description": "Successful Response",
                        "content": {
                            "application/json": {



...

```

----------------------------------------

TITLE: Python Standard Synchronous Context Manager
DESCRIPTION: Illustrates the basic usage of a synchronous context manager in Python using the `with` statement. This pattern ensures that resources, such as files, are properly acquired before use and released afterwards, even if errors occur.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/advanced/events.md#_snippet_1

LANGUAGE: Python
CODE:
```
with open("file.txt") as file:
    file.read()
```

----------------------------------------

TITLE: Initializing a Tuple and Set - Python 3.8+
DESCRIPTION: This snippet initializes a tuple `items_t` with specific types for each element (int, int, str) and a set `items_s` where each element is of type bytes. It uses the `Tuple` and `Set` types from the `typing` module.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_7

LANGUAGE: Python
CODE:
```
from typing import Tuple, Set

items_t: Tuple[int, int, str] = (1, 2, "foo")
items_s: Set[bytes] = {b"hallo", b"welt"}
```

----------------------------------------

TITLE: Correct Type Mismatch with Type Conversion
DESCRIPTION: Building on the previous example, this snippet shows the corrected implementation where the integer `age` is explicitly converted to a string using `str(age)` before being included in the f-string. This resolves the type error and ensures the function operates correctly according to its type hints.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/python-types.md#_snippet_3

LANGUAGE: python
CODE:
```
def get_name_and_age(name: str, age: int):
    return f"Hello, {name}. You are {str(age)} years old."
```

----------------------------------------

TITLE: FastAPI Asynchronous GET Endpoints
DESCRIPTION: This Python example demonstrates the same FastAPI GET endpoints as the basic setup, but implements them using `async def`. This approach is recommended when your endpoint logic involves asynchronous operations (e.g., `await` calls) to prevent blocking the event loop.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/id/docs/index.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Python Dictionary Unpacking for Merging Dictionaries
DESCRIPTION: A basic Python example showing how to merge two dictionaries using the `**` (double-asterisk) operator for dictionary unpacking. This technique is useful for combining predefined configurations with custom additions.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/advanced/additional-responses.md#_snippet_2

LANGUAGE: Python
CODE:
```
old_dict = {
    "old key": "old value",
    "second old key": "second old value"
}
new_dict = {**old_dict, "new key": "new value"}
```

----------------------------------------

TITLE: Function with Type Hints and Type Conversion
DESCRIPTION: This example shows how to fix a type error by converting the integer age to a string using str(age).

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_3

LANGUAGE: Python
CODE:
```
def get_name_with_age(name: str, age: int):
    name_with_age = name + " is this old: " + str(age)
    return name_with_age
```

----------------------------------------

TITLE: Simple Types Declaration
DESCRIPTION: Demonstrates declaring variables with simple types such as int, float, bool and bytes.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_4

LANGUAGE: Python
CODE:
```
age: int
price: float
awake: bool
file: bytes
```

----------------------------------------

TITLE: Define FastAPI Application Entrypoint in Dockerfile
DESCRIPTION: This snippet demonstrates the basic `CMD` instruction for a Dockerfile to run a FastAPI application using Uvicorn. It specifies the main application file and the port, serving as the container's default command when it starts.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/deployment/docker.md#_snippet_5

LANGUAGE: Dockerfile
CODE:
```
CMD ["fastapi", "run", "app/main.py", "--port", "80"]
```

----------------------------------------

TITLE: Install FastAPI with Standard Dependencies
DESCRIPTION: Demonstrates how to install FastAPI including its recommended 'standard' set of optional dependencies, which provide common functionalities like email validation, testing, templating, form parsing, and a production-ready server.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/index.md#_snippet_13

LANGUAGE: Python
CODE:
```
pip install "fastapi[standard]"
```

----------------------------------------

TITLE: Python Function Parameters with Optional Types
DESCRIPTION: Illustrates the difference between a parameter with an `Optional` type hint and an actual optional parameter (one with a default value). Shows that a parameter typed `Optional[T]` without a default value is still required, leading to a `TypeError` if not provided, while accepting `None` as a valid value.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/python-types.md#_snippet_5

LANGUAGE: Python
CODE:
```
say_hi()  # Oh, no, this throws an error! 😱
```

LANGUAGE: Python
CODE:
```
say_hi(name=None)  # This works, None is valid 🎉
```

----------------------------------------

TITLE: Declare basic path parameters in FastAPI
DESCRIPTION: Demonstrates how to define a path parameter in a FastAPI path operation using Python's f-string like syntax. The value from the URL path is automatically passed as an argument to the decorated function, allowing for dynamic routing.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/path-params.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/items/{item_id}")
async def read_item(item_id):
    return {"item_id": item_id}
```

----------------------------------------

TITLE: Defining a List Field with Type Hints
DESCRIPTION: Demonstrates how to define a list field with type hints for the elements within the list. The `tags` attribute is explicitly defined as a list of strings.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body-nested-models.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: list[str] = []
```

----------------------------------------

TITLE: Import BackgroundTasks from FastAPI
DESCRIPTION: This code snippet demonstrates the standard way to import the `BackgroundTasks` class directly from the `fastapi` library. This class is essential for defining and managing background tasks within your FastAPI application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/reference/background.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import BackgroundTasks
```

----------------------------------------

TITLE: Field Examples in Pydantic Models
DESCRIPTION: Declares examples for fields within a Pydantic model using the `Field` function. This allows providing example values for each field in the API documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/schema-extra-example.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel, Field


class Item(BaseModel):
    name: str = Field(examples=["Foo"])
    description: Optional[str] = Field(default=None, examples=["A very nice Item"])
    price: float = Field(examples=[50.2])
    tax: Optional[float] = Field(default=None, examples=[3.2])
```

----------------------------------------

TITLE: Define a Simple Test Path Operation in FastAPI
DESCRIPTION: This snippet provides a basic FastAPI path operation (`/hello`) that returns a JSON message. It serves as a simple endpoint to verify that the FastAPI application is running correctly and accessible after configuring custom documentation assets.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/how-to/custom-docs-ui-assets.md#_snippet_2

LANGUAGE: Python
CODE:
```
@app.get("/hello")
async def hello():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Implement OAuth2 Password Bearer Scheme in FastAPI
DESCRIPTION: This example demonstrates a basic FastAPI application using `OAuth2PasswordBearer` to secure an endpoint. It shows how to initialize the scheme with a `tokenUrl` and use it as a dependency to extract the authentication token from incoming requests.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/security/first-steps.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import Depends, FastAPI
from fastapi.security import OAuth2PasswordBearer

app = FastAPI()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

@app.get("/users/me")
async def read_users_me(token: str = Depends(oauth2_scheme)):
    return {"token": token}
```

----------------------------------------

TITLE: Criar uma função de tarefa para BackgroundTasks
DESCRIPTION: Este snippet mostra como criar uma função para ser executada como uma tarefa em segundo plano. A função grava em um arquivo, simulando o envio de um e-mail. A função pode ser async def ou def.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/background-tasks.md#_snippet_1

LANGUAGE: python
CODE:
```
from fastapi import FastAPI

app = FastAPI()


def write_notification(email: str, message=""):
    with open("log.txt", mode="w") as f:
        f.write(f"notification for {email}: {message}")
```

----------------------------------------

TITLE: Creating a Data Model with Pydantic
DESCRIPTION: This code snippet shows how to define a data model using Pydantic's `BaseModel`. The model defines the structure and types of the expected data, including optional fields with default values. This enables automatic data validation and serialization.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/body.md#_snippet_1

LANGUAGE: Python
CODE:
```
class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None
```

----------------------------------------

TITLE: Import Pydantic BaseModel
DESCRIPTION: Imports the `BaseModel` class from the Pydantic library, which is the foundational class for defining data models used in FastAPI for request body validation and serialization.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body.md#_snippet_0

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel
```

----------------------------------------

TITLE: Initialize New Language Directory for FastAPI Documentation
DESCRIPTION: This command utilizes the `docs.py` script to create a new directory structure for a new language, such as Latin (`la`). It sets up the necessary files, including a basic `mkdocs.yml` and `index.md`, to begin translations for a previously unsupported language.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/contributing.md#_snippet_8

LANGUAGE: Shell
CODE:
```
python ./scripts/docs.py new-lang la
```

----------------------------------------

TITLE: Returning JSON Response in FastAPI
DESCRIPTION: Demonstrates the default behavior of FastAPI to return JSON responses. This snippet shows a basic path operation that returns a Python dictionary, which FastAPI automatically serializes to JSON using `JSONResponse` with the `application/json` media type.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/advanced/custom-response.md#_snippet_5

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/items/{item_id}")
async def read_item(item_id: int):
    return {"item_id": item_id, "name": "Awesome Item"}
```

----------------------------------------

TITLE: FastAPI Password Hashing and Validation
DESCRIPTION: This snippet illustrates a basic (pseudo) password hashing and validation mechanism. It checks if the provided password, after being 'hashed', matches the stored hashed password for the retrieved user. An `HTTPException` is raised if the passwords do not match, indicating an authentication failure.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/security/simple-oauth2.md#_snippet_2

LANGUAGE: python
CODE:
```
from fastapi import HTTPException, status

# ... (within the login_for_access_token function, after user_dict is obtained)
# Assuming fake_hash_password is a function that 'hashes' the password
# and user_dict["hashed_password"] contains the stored hash.
if not fake_hash_password(form_data.password) == user_dict["hashed_password"]:
    raise HTTPException(
        status_code=status.HTTP_400_BAD_REQUEST,
        detail="Incorrect username or password",
    )
```

----------------------------------------

TITLE: Python Function Without Type Hints
DESCRIPTION: This example shows a simple Python function that processes first and last names without any type annotations. It illustrates how the absence of type hints can limit editor assistance and make code harder to understand or validate.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/python-types.md#_snippet_0

LANGUAGE: Python
CODE:
```
{!../../docs_src/python_types/tutorial001.py!}
```

----------------------------------------

TITLE: Example User Profile JSON Response
DESCRIPTION: This JSON object represents the typical data returned by a protected FastAPI endpoint, such as `/users/me/`, after a user has successfully authenticated. It includes basic user information like username, email, full name, and disabled status.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/security/oauth2-jwt.md#_snippet_3

LANGUAGE: JSON
CODE:
```
{
  "username": "johndoe",
  "email": "johndoe@example.com",
  "full_name": "John Doe",
  "disabled": false
}
```

----------------------------------------

TITLE: Declaring a Tuple and Set (Python 3.9+)
DESCRIPTION: This snippet demonstrates how to declare a tuple with specific types for each element and a set with a specific type for all elements using Python 3.9+ syntax. `tuple[int, int, str]` defines a tuple with two integers and a string, while `set[bytes]` defines a set containing bytes.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_7

LANGUAGE: Python
CODE:
```
items_t: tuple[int, int, str] = (1, 2, "foo")
items_s: set[bytes] = {b"hallo", b"welt"}
```

----------------------------------------

TITLE: FastAPI Application with Item and Message Models
DESCRIPTION: Demonstrates a basic FastAPI application with Pydantic models for request and response bodies. It defines a POST endpoint for creating an item and a GET endpoint for a root message, showcasing how FastAPI automatically generates OpenAPI schema from these definitions.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/advanced/generate-clients.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


class ResponseMessage(BaseModel):
    message: str


app = FastAPI()


@app.post("/items/", response_model=ResponseMessage)
async def create_item(item: Item):
    return {"message": "Item received"}


@app.get("/")
async def read_root():
    return {"Hello": "World"}
```

----------------------------------------

TITLE: Initializing a Tuple and Set - Python 3.9+
DESCRIPTION: This snippet initializes a tuple `items_t` with specific types for each element (int, int, str) and a set `items_s` where each element is of type bytes. It uses the built-in `tuple` and `set` types.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_8

LANGUAGE: Python
CODE:
```
items_t: tuple[int, int, str] = (1, 2, "foo")
```

----------------------------------------

TITLE: FastAPI Query Parameter String Validations
DESCRIPTION: Demonstrates how to add string validations to FastAPI query parameters using `Query`. This includes setting a minimum length (`min_length`) and defining a regular expression `pattern` for the parameter value, with examples referenced from external files. It also notes the deprecated `regex` parameter from Pydantic v1, shown via an external file reference.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params-str-validations.md#_snippet_4

LANGUAGE: Python
CODE:
```
{* ../../docs_src/query_params_str_validations/tutorial003_an_py310.py hl[10] *}
```

LANGUAGE: Python
CODE:
```
{* ../../docs_src/query_params_str_validations/tutorial004_an_py310.py hl[11] *}
```

LANGUAGE: Python
CODE:
```
{* ../../docs_src/query_params_str_validations/tutorial004_regex_an_py310.py hl[11] *}
```

----------------------------------------

TITLE: Setting and Using Environment Variables (PowerShell)
DESCRIPTION: This snippet demonstrates how to set an environment variable named MY_NAME to "Wade Wilson" and then use it in a subsequent command to print a greeting. It shows the basic syntax for setting and accessing environment variables in PowerShell.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh-hant/docs/environment-variables.md#_snippet_1

LANGUAGE: powershell
CODE:
```
// 建立一個名為 MY_NAME 的環境變數
$ $Env:MY_NAME = "Wade Wilson"

// 在其他程式中使用它，例如
$ echo "Hello $Env:MY_NAME"

Hello Wade Wilson
```

----------------------------------------

TITLE: Setting and Using Environment Variables (Bash)
DESCRIPTION: This snippet demonstrates how to set an environment variable named MY_NAME to "Wade Wilson" and then use it in a subsequent command to print a greeting. It shows the basic syntax for setting and accessing environment variables in a Bash shell.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh-hant/docs/environment-variables.md#_snippet_0

LANGUAGE: bash
CODE:
```
// 你可以使用以下指令建立一個名為 MY_NAME 的環境變數
$ export MY_NAME="Wade Wilson"

// 然後，你可以在其他程式中使用它，例如
$ echo "Hello $MY_NAME"

Hello Wade Wilson
```

----------------------------------------

TITLE: Initialize FastAPI Application Instance
DESCRIPTION: This snippet demonstrates the foundational steps for any FastAPI application: importing the `FastAPI` class and creating an instance of it. The `app` instance serves as the central object for defining all API routes and operations.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/first-steps.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()
```

----------------------------------------

TITLE: Creating OAuth2 Password Request Form in FastAPI
DESCRIPTION: This code snippet demonstrates how to create a FastAPI application with an endpoint that handles OAuth2 password requests. It uses `OAuth2PasswordRequestForm` to receive the username and password, which are then printed to the console. This is a basic setup and does not include actual authentication logic.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/security/first-steps.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import Depends, FastAPI
from fastapi.security import OAuth2PasswordRequestForm

app = FastAPI()


@app.post("/token")
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    return {"username": form_data.username, "password": form_data.password}
```

----------------------------------------

TITLE: Importing BaseModel from Pydantic
DESCRIPTION: Imports the `BaseModel` class from the `pydantic` library. This is the base class for creating data models that define the structure and validation rules for request bodies.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body.md#_snippet_0

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel
```

----------------------------------------

TITLE: Example JSON Request Body (Optional Fields Omitted)
DESCRIPTION: Demonstrates a valid JSON object for the `Item` Pydantic model where optional fields (`description` and `tax`) are intentionally omitted. This showcases FastAPI's ability to handle partial request bodies gracefully, based on the model's definition of optional fields.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body.md#_snippet_3

LANGUAGE: JSON
CODE:
```
{
    "name": "Foo",
    "price": 45.2
}
```

----------------------------------------

TITLE: Usando BackgroundTasks no FastAPI
DESCRIPTION: Este snippet demonstra como importar BackgroundTasks e definir um parâmetro em uma função de operação de caminho para executar tarefas em segundo plano. O FastAPI cria o objeto BackgroundTasks e o passa como um parâmetro.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/background-tasks.md#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import BackgroundTasks, FastAPI

app = FastAPI()


async def write_notification(email: str, message=""):
    with open("log.txt", mode="w") as f:
        f.write(f"notification for {email}: {message}")


@app.post("/send-notification/{email}")
async def send_notification(email: str, background_tasks: BackgroundTasks):
    background_tasks.add_task(write_notification, email, message="some notification")
    return {"message": "Notification sent in the background"}
```

----------------------------------------

TITLE: Request Body with Examples
DESCRIPTION: Shows how to pass examples for the expected data in a request body using the `Body()` function. This allows for providing example data for the request body, which is then included in the generated JSON Schema and used in API documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/schema-extra-example.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import Body, FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item = Body(
        examples=[
            {
                "name": "Foo",
                "description": "A very nice Item",
                "price": 35.4,
                "tax": 3.2,
            }
        ],
    ),
):
    results = {"item_id": item_id, "item": item}
    return results
```

----------------------------------------

TITLE: Combining Required, Default, and Optional Query Parameters in FastAPI
DESCRIPTION: This code snippet shows how to define a combination of required, default, and optional query parameters in a FastAPI endpoint. 'needy' is a required string, 'skip' is an integer with a default value of 0, and 'limit' is an optional integer.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/tr/docs/tutorial/query-params.md#_snippet_5

LANGUAGE: Python
CODE:
```
@app.get("/items/{item_id}")
async def read_items(
    item_id: str, needy: str, skip: int = 0, limit: Union[int, None] = None
):
    item = {"item_id": item_id, "needy": needy, "skip": skip, "limit": limit}
    return item
```

----------------------------------------

TITLE: Traefik Main Configuration File (`traefik.toml`)
DESCRIPTION: The `traefik.toml` file configures Traefik's basic settings, including defining an HTTP entry point on port `9999` and specifying `routes.toml` as the file provider for dynamic routing configurations. This setup allows Traefik to act as a proxy for the FastAPI application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/advanced/behind-a-proxy.md#_snippet_3

LANGUAGE: TOML
CODE:
```
[entryPoints]
  [entryPoints.http]
    address = ":9999"

[providers]
  [providers.file]
    filename = "routes.toml"
```

----------------------------------------

TITLE: FastAPI OAuth2 Password Flow Basic Setup
DESCRIPTION: This snippet demonstrates the fundamental setup for OAuth2 password flow in FastAPI. It initializes `OAuth2PasswordBearer` with a `tokenUrl` parameter, which declares the endpoint where clients will send username and password to obtain a token. The `oauth2_scheme` is then integrated as a dependency for a path operation, allowing FastAPI to automatically generate security definitions in the OpenAPI documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/security/first-steps.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI, Depends
from fastapi.security import OAuth2PasswordBearer

app = FastAPI()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

@app.get("/users/me")
async def read_users_me(token: str = Depends(oauth2_scheme)):
    return {"token": token}
```

----------------------------------------

TITLE: FastAPI API Documentation Concepts: OpenAPI, Paths, and Operations
DESCRIPTION: This section defines key concepts central to building and documenting APIs with FastAPI, including the OpenAPI standard, the structure of API paths (endpoints), and the role of HTTP operations (methods) in defining API interactions.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/first-steps.md#_snippet_4

LANGUAGE: APIDOC
CODE:
```
OpenAPI Specification:
  - Standard: A specification for machine-readable interface files for describing, producing, consuming, and visualizing RESTful web services.
  - Purpose: FastAPI uses OpenAPI to automatically generate interactive API documentation (Swagger UI, ReDoc) and enable client code generation.
  - Components:
    - "Schema": A general term for a named entity or key/value pair.
    - "Operation Schema": Describes how to interact with an API endpoint (e.g., parameters, responses).
    - "Data Schema": Describes the structure of data (e.g., JSON models), often using JSON Schema.

Paths (Endpoints):
  - Definition: The last part of a URL after the domain, representing a specific resource or functionality (e.g., `/items/foo`).
  - Synonyms: Often referred to as "URLs" or "routes".

Operations (HTTP Methods):
  - Definition: Standard HTTP methods used to perform actions on resources. Each path can have one or more operations associated with it.
  - Common Operations:
    - `POST`: Used for creating new data.
    - `GET`: Used for reading/retrieving data.
    - `PUT`: Used for updating/replacing existing data.
    - `DELETE`: Used for removing data.
  - Other Operations: `OPTIONS`, `HEAD`, `PATCH`, `TRACE`.
  - Role in FastAPI: Each operation is typically mapped to a Python function (path operation function) that handles requests for that specific method and path.
```

----------------------------------------

TITLE: FastAPI Response Attribute Access Example (Price)
DESCRIPTION: A partial code snippet demonstrating accessing the `price` attribute from an `item` object within a FastAPI response dictionary. This illustrates the flexibility of changing accessed attributes and the editor's ability to recognize types.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/index.md#_snippet_12

LANGUAGE: Python
CODE:
```
        ... "item_price": item.price ...
```

----------------------------------------

TITLE: Define a Simple FastAPI Path Operation for Testing
DESCRIPTION: This Python code defines a basic FastAPI path operation that returns a simple JSON message. This endpoint can be used to verify the application's general functionality and ensure that the static file serving configuration does not interfere with regular API routes.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/how-to/custom-docs-ui-assets.md#_snippet_8

LANGUAGE: Python
CODE:
```
@app.get("/hello")
async def read_hello():
    return {"message": "Hello from FastAPI!"}
```

----------------------------------------

TITLE: Basic Dockerfile for FastAPI Application
DESCRIPTION: This Dockerfile defines the steps to containerize a FastAPI application. It starts from a Python base image, sets the working directory, and efficiently installs dependencies by leveraging Docker's build cache. Finally, it copies the application code and specifies the command to run the Uvicorn server.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/deployment/docker.md#_snippet_0

LANGUAGE: Dockerfile
CODE:
```
FROM python:3.9

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./app /code/app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
```

----------------------------------------

TITLE: 단순 타입 힌트 예제
DESCRIPTION: 이 예제는 `str`, `int`, `float`, `bool`, `bytes`와 같은 파이썬 표준 타입을 변수에 적용하는 방법을 보여줍니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/python-types.md#_snippet_4

LANGUAGE: python
CODE:
```
name: str
age: int
price: float
is_adult: bool
data: bytes
```

----------------------------------------

TITLE: Importing BaseModel from Pydantic
DESCRIPTION: This code snippet demonstrates how to import the `BaseModel` class from the `pydantic` module. This is the base class for creating data models that define the structure and validation rules for request bodies in FastAPI.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/body.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import FastAPI
from pydantic import BaseModel
```

----------------------------------------

TITLE: Create a Simple Background Task Function
DESCRIPTION: Illustrates how to define a standard Python function that can serve as a background task. This function can be either `async def` or `def` and can accept parameters. The example simulates writing a notification to a log file, which is a common use case for background processing.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/background-tasks.md#_snippet_1

LANGUAGE: Python
CODE:
```
def write_notification(email: str, message: str = ""):
    with open("log.txt", mode="a") as email_file:
        content = f"notification for {email}: {message}\n"
        email_file.write(content)
```

----------------------------------------

TITLE: Declare Python Types and Pydantic Models
DESCRIPTION: Demonstrates how to declare variables with type hints using standard Python types and define data models using Pydantic's BaseModel, including `str`, `int`, and `datetime.date`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/features.md#_snippet_0

LANGUAGE: Python
CODE:
```
from datetime import date

from pydantic import BaseModel

# Declare a variable as a str
# and get editor support inside the function
def main(user_id: str):
    return user_id


# A Pydantic model
class User(BaseModel):
    id: int
    name: str
    joined: date
```

----------------------------------------

TITLE: Injeção de dependência com BackgroundTasks
DESCRIPTION: Este snippet demonstra como usar BackgroundTasks com injeção de dependência. Um parâmetro do tipo BackgroundTasks pode ser declarado em vários níveis: em uma função de operação de caminho, em uma dependência, em uma subdependência, etc. O FastAPI reutiliza o mesmo objeto para todas as tarefas em segundo plano.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/background-tasks.md#_snippet_3

LANGUAGE: python
CODE:
```
from typing import Optional

from fastapi import BackgroundTasks, Depends, FastAPI

app = FastAPI()


def write_log(message: str):
    with open("log.txt", mode="a") as log:
        log.write(message)


def get_query(background_tasks: BackgroundTasks, q: Optional[str] = None):
    if q:
        message = f"found query {q}\n"
        background_tasks.add_task(write_log, message)
    return q


@app.post("/send-notification/{email}")
async def send_notification(
    email: str,
    background_tasks: BackgroundTasks,
    q: str = Depends(get_query),
):
    message = f"message to {email}\n"
    background_tasks.add_task(write_log, message)
    return {"message": "Notification sent in the background"}
```

----------------------------------------

TITLE: Pydantic Model Example (Python 3.10+)
DESCRIPTION: This example demonstrates a Pydantic model definition with type annotations. It shows how to define a class with attributes and their corresponding types, enabling data validation and conversion.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_19

LANGUAGE: Python
CODE:
```
{!> ../../docs_src/python_types/tutorial011_py310.py!}
```

----------------------------------------

TITLE: Import Query from FastAPI
DESCRIPTION: This snippet imports the `Query` class from the `fastapi` module.  `Query` is used to define additional validations and metadata for query parameters.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/query-params-str-validations.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import FastAPI, Query

app = FastAPI()
```

----------------------------------------

TITLE: Import FastAPI HTTP and WebSocket Exceptions
DESCRIPTION: This snippet demonstrates the standard way to import the `HTTPException` and `WebSocketException` classes directly from the `fastapi` library. These classes are essential for raising structured HTTP and WebSocket errors within your FastAPI application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/reference/exceptions.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import HTTPException, WebSocketException
```

----------------------------------------

TITLE: FastAPI application initialization in main.py
DESCRIPTION: This snippet shows the typical structure of a FastAPI application's main entry point. It imports FastAPI, creates an instance of the app, and defines a simple path operation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/testing.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root():
    return {"Hello": "World"}
```

----------------------------------------

TITLE: Pydantic Model Example (Python 3.9+)
DESCRIPTION: This example demonstrates a Pydantic model definition with type annotations. It shows how to define a class with attributes and their corresponding types, enabling data validation and conversion.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_20

LANGUAGE: Python
CODE:
```
{!> ../../docs_src/python_types/tutorial011_py39.py!}
```

----------------------------------------

TITLE: Declaring a Tuple and Set (Python 3.8+)
DESCRIPTION: This snippet demonstrates how to declare a tuple with specific types for each element and a set with a specific type for all elements using the `typing` module in Python 3.8+. `Tuple[int, int, str]` defines a tuple with two integers and a string, while `Set[bytes]` defines a set containing bytes.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_8

LANGUAGE: Python
CODE:
```
from typing import Tuple, Set

items_t: Tuple[int, int, str] = (1, 2, "foo")
items_s: Set[bytes] = {b"hallo", b"welt"}
```

----------------------------------------

TITLE: Markdown Admonition Syntax Example (English)
DESCRIPTION: Illustrates the standard Markdown admonition syntax used in the FastAPI documentation for 'tip' blocks.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/management-tasks.md#_snippet_1

LANGUAGE: Markdown
CODE:
```
/// tip

This is a tip.

///
```

----------------------------------------

TITLE: Install FastAPI with standard dependencies
DESCRIPTION: Command to install FastAPI with its standard dependencies. This is suitable for production applications where specific optional features might be installed separately to minimize dependencies.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/index.md#_snippet_2

LANGUAGE: Shell
CODE:
```
pip install "fastapi[standard]"
```

----------------------------------------

TITLE: Creating a Data Model with Pydantic
DESCRIPTION: This code snippet shows how to define a data model using Pydantic's `BaseModel`. The model defines the structure of the expected JSON request body, including data types and optional fields.  It inherits from `BaseModel` and uses standard Python type annotations for attributes.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/body.md#_snippet_1

LANGUAGE: Python
CODE:
```
class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
```

----------------------------------------

TITLE: Importing BaseModel from Pydantic
DESCRIPTION: This code snippet demonstrates how to import the `BaseModel` class from the `pydantic` library. `BaseModel` is used as the base class for defining data models in FastAPI applications.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/body.md#_snippet_0

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel
```

----------------------------------------

TITLE: Declare Typed List (Python 3.9+ Syntax)
DESCRIPTION: This example illustrates the modern Python 3.9+ syntax for declaring a list where all elements are of a specific type, such as `str`. This provides a concise and clear way to specify homogeneous list types.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/body-nested-models.md#_snippet_2

LANGUAGE: Python
CODE:
```
my_list: list[str]
```

----------------------------------------

TITLE: Declare Examples for Pydantic Fields
DESCRIPTION: Illustrates how to add example data directly to individual fields within a Pydantic model using the `Field()` function's `examples` argument. This allows for field-specific examples in the generated JSON Schema.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/schema-extra-example.md#_snippet_2

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel, Field

class Item(BaseModel):
    name: str = Field(examples=["Foo"])
    description: str | None = Field(default=None, examples=["A very nice Item"])
    price: float = Field(examples=[35.4])
    tax: float | None = Field(default=None, examples=[3.2])
```

----------------------------------------

TITLE: Importing BaseModel from Pydantic
DESCRIPTION: This code snippet demonstrates how to import the `BaseModel` class from the `pydantic` library. `BaseModel` is used as the base class for creating data models that define the structure and validation rules for request bodies in FastAPI.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/body.md#_snippet_0

LANGUAGE: python
CODE:
```
from pydantic import BaseModel
```

----------------------------------------

TITLE: FastAPI Query Parameter Default Values with Validations
DESCRIPTION: Shows how to combine default values with string validations for FastAPI query parameters. This example, referenced from an external file, illustrates setting a `min_length` and a specific default value for a query parameter.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params-str-validations.md#_snippet_5

LANGUAGE: Python
CODE:
```
{* ../../docs_src/query_params_str_validations/tutorial005_an_py39.py hl[9] *}
```

----------------------------------------

TITLE: FastAPI Parameter Example Declaration (APIDOC)
DESCRIPTION: This section details how to declare examples for various FastAPI parameters (`Path`, `Query`, `Header`, `Cookie`, `Body`, `Form`, `File`) using both JSON Schema `examples` and OpenAPI-specific `openapi_examples` for improved documentation UI.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/schema-extra-example.md#_snippet_6

LANGUAGE: APIDOC
CODE:
```
FastAPI Parameter Example Declaration

This section details how to declare examples for various FastAPI parameters (Path, Query, Header, Cookie, Body, Form, File) using both JSON Schema `examples` and OpenAPI-specific `openapi_examples` for improved documentation UI.

1. JSON Schema `examples` (for `Path`, `Query`, `Header`, `Cookie`, `Body`, `Form`, `File`):
   - Purpose: To embed examples directly into the generated JSON Schema for a parameter.
   - Usage: Pass a `list` of example `dict`s to the `examples` argument of the parameter function (e.g., `Body(examples=[...])`).
   - Limitation: Swagger UI may not fully support displaying multiple `examples` from JSON Schema.

2. OpenAPI-specific `openapi_examples` (for `Path`, `Query`, `Header`, `Cookie`, `Body`, `Form`, `File`):
   - Purpose: To provide examples that are part of the OpenAPI specification's path operation details, specifically designed for display in documentation UIs like Swagger UI.
   - Usage: Pass a `dict` of named examples to the `openapi_examples` argument of the parameter function (e.g., `Body(openapi_examples={...})`).
   - Structure of each named example (value in the `openapi_examples` dict):
     - `summary` (string): A short description for the example.
     - `description` (string, optional): A longer description that can contain Markdown text.
     - `value` (any): The actual example data (e.g., a JSON object for a body, a string for a query parameter).
     - `externalValue` (string, optional): A URL pointing to the example data, alternative to `value`. Support may vary across tools.
   - Benefit: Fully supported by Swagger UI for displaying multiple examples.
```

----------------------------------------

TITLE: Function with Type Hints
DESCRIPTION: This Python function uses type hints to specify that the `first_name` and `last_name` parameters should be strings. This enables better code completion and error checking in editors.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_1

LANGUAGE: Python
CODE:
```
def get_full_name(first_name: str, last_name: str):
    return first_name.title() + " " + last_name.title()
```

----------------------------------------

TITLE: Function with Type Hints and Error
DESCRIPTION: This example demonstrates how type hints can help identify errors in your code. The editor can detect that an integer is being used where a string is expected.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_2

LANGUAGE: Python
CODE:
```
def get_name_with_age(name: str, age: int):
    name_with_age = name + " is this old: " + age
    return name_with_age
```

----------------------------------------

TITLE: Declare Request Body Examples in FastAPI
DESCRIPTION: Illustrates how to define single and multiple example payloads for a request body in FastAPI using the `Body()` dependency. These examples are incorporated into the JSON Schema and can be viewed in the API documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/schema-extra-example.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Annotated

from fastapi import FastAPI, Body
from pydantic import BaseModel

app = FastAPI()

class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None

@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Annotated[
        Item,
        Body(
            examples=[
                {
                    "name": "Foo",
                    "description": "A very nice Item",
                    "price": 35.4,
                    "tax": 3.2
                }
            ]
        )
    ]
):
    results = {"item_id": item_id, "item": item}
    return results
```

LANGUAGE: Python
CODE:
```
from typing import Annotated

from fastapi import FastAPI, Body
from pydantic import BaseModel

app = FastAPI()

class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None

@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Annotated[
        Item,
        Body(
            examples=[
                {
                    "name": "Foo",
                    "description": "A very nice Item",
                    "price": 35.4,
                    "tax": 3.2
                },
                {
                    "name": "Bar",
                    "price": 42.0,
                    "description": "The Bar Fighters",
                    "tax": 3.2
                },
                {
                    "name": "Baz",
                    "price": 50.0,
                    "tax": 10.0
                }
            ]
        )
    ]
):
    results = {"item_id": item_id, "item": item}
    return results
```

----------------------------------------

TITLE: Declare Request Body Single Example using FastAPI Body
DESCRIPTION: This method demonstrates how to provide a single example for a request body using FastAPI's `Body()` dependency. The example data will be displayed in the OpenAPI documentation for the endpoint.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/schema-extra-example.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI, Body
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


app = FastAPI()


@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item = Body(
        example={
            "name": "Foo",
            "description": "A very nice Item",
            "price": 35.4,
            "tax": 3.2,
        },
    ),
):
    results = {"item_id": item_id, "item": item}
    return results
```

----------------------------------------

TITLE: Pydantic Model Example (Python 3.8+)
DESCRIPTION: This example demonstrates a Pydantic model definition with type annotations. It shows how to define a class with attributes and their corresponding types, enabling data validation and conversion.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_21

LANGUAGE: Python
CODE:
```
{!> ../../docs_src/python_types/tutorial011.py!}
```

----------------------------------------

TITLE: FastAPI: Data Filtering with Pydantic Inheritance and Return Type Annotations
DESCRIPTION: Demonstrates an advanced pattern using Pydantic model inheritance (`UserIn` inherits from `BaseUser`) and function return type annotations (`-> BaseUser`). This allows the function to return a more comprehensive object (`UserIn`) while FastAPI automatically filters the response to conform to the `BaseUser` schema, providing both strong typing for tooling and effective data filtering.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/response-model.md#_snippet_7

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class BaseUser(BaseModel):
    username: str


class UserIn(BaseUser):
    password: str


@app.post("/user/")
async def create_user(user: UserIn) -> BaseUser:
    return user
```

----------------------------------------

TITLE: Example JSON Response from FastAPI Endpoint
DESCRIPTION: A sample JSON output demonstrating the structure of a response from the `/items/{item_id}` endpoint when accessed with specific parameters, showing the item ID and query parameter.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/index.md#_snippet_3

LANGUAGE: JSON
CODE:
```
{"item_id": 5, "q": "somequery"}
```

----------------------------------------

TITLE: FastAPI: Declare Required Parameters with Ellipsis Default
DESCRIPTION: This example demonstrates the previous method of declaring required path, query, cookie, and header parameters in FastAPI by explicitly setting their default value to `...` (Ellipsis). This ensures the parameters are mandatory for the endpoint.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_23

LANGUAGE: Python
CODE:
```
from fastapi import Cookie, FastAPI, Header, Path, Query

app = FastAPI()


@app.get("/items/{item_id}")
def main(
    item_id: int = Path(default=..., gt=0),
    query: str = Query(default=..., max_length=10),
    session: str = Cookie(default=..., min_length=3),
    x_trace: str = Header(default=..., title="Tracing header"),
):
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Importing List from Typing Module (Python < 3.9)
DESCRIPTION: Shows how to import `List` from Python's `typing` module, which is necessary for declaring lists with type parameters in Python versions prior to 3.9.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-nested-models.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import List
```

----------------------------------------

TITLE: Declaring Request Body Examples (JSON Schema)
DESCRIPTION: Shows how to provide example data for a request body using FastAPI's `Body()` function. This method utilizes the JSON Schema `examples` array, allowing for single or multiple examples to be embedded directly into the body's schema.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/schema-extra-example.md#_snippet_2

LANGUAGE: Python
CODE:
```
from fastapi import Body, FastAPI
from pydantic import BaseModel

app = FastAPI()

class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None

@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item = Body(
        examples=[
            {
                "name": "Foo",
                "description": "A very nice Item",
                "price": 35.4,
                "tax": 3.2,
            }
        ]
    ),
):
    results = {"item_id": item_id, "item": item}
    return results
```

LANGUAGE: Python
CODE:
```
from fastapi import Body, FastAPI
from pydantic import BaseModel

app = FastAPI()

class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None

@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item = Body(
        examples=[
            {
                "name": "Foo",
                "description": "A very nice Item",
                "price": 35.4,
                "tax": 3.2,
            },
            {
                "name": "Bar",
                "price": 42.0,
                "description": "The Bar Fighters",
            },
            {
                "name": "Baz",
                "price": 50.5,
                "tax": 10.5,
                "description": "There goes my baz",
            },
        ]
    ),
):
    results = {"item_id": item_id, "item": item}
    return results
```

----------------------------------------

TITLE: Import BaseSettings for Pydantic Settings
DESCRIPTION: Shows the updated import path for `BaseSettings` when using Pydantic for settings management, now from the dedicated `pydantic_settings` package.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_14

LANGUAGE: Python
CODE:
```
from pydantic_settings import BaseSettings
```

----------------------------------------

TITLE: Instantiate Pydantic Models from Data
DESCRIPTION: This example shows two ways to instantiate a Pydantic BaseModel: directly with keyword arguments and by unpacking a dictionary using the `**` operator. Unpacking a dictionary is useful when data comes from an external source, like a database or an API request, and needs to be validated against the model schema.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/features.md#_snippet_1

LANGUAGE: Python
CODE:
```
my_user: User = User(id=3, name="John Doe", joined="2018-07-19")

second_user_data = {
    "id": 4,
    "name": "Mary",",
    "joined": "2018-11-30"
}

my_second_user: User = User(**second_user_data)
```

----------------------------------------

TITLE: Adding String Validations to FastAPI Query Parameters
DESCRIPTION: Demonstrates how to apply string validations like `max_length` and `min_length` to query parameters using FastAPI's `Query()` dependency. These validations are automatically enforced and documented in the OpenAPI schema.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/query-params-str-validations.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI, Query
from typing import Union

app = FastAPI()

@app.get("/items/")
async def read_items(
    q_max: Union[str, None] = Query(default=None, max_length=50),
    q_min_max: str = Query(min_length=3, max_length=50)
):
    """
    Example endpoint demonstrating query parameter string validations.
    - q_max: Optional query parameter with a maximum length of 50.
    - q_min_max: Required query parameter with a minimum length of 3 and maximum length of 50.
    """
    return {"q_max": q_max, "q_min_max": q_min_max}
```

----------------------------------------

TITLE: Initializing FastAPI Application
DESCRIPTION: Creates an instance of the FastAPI class, which serves as the main entry point for building the API. This instance is then used to define the API's endpoints and handle incoming requests.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pl/docs/tutorial/first-steps.md#_snippet_2

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()
```

----------------------------------------

TITLE: Declare Field Example using Pydantic Field Arguments
DESCRIPTION: This method allows adding an example to individual fields within a Pydantic model by passing an `example` argument directly to `Field()`. These extra arguments are primarily for documentation purposes and do not add validation rules.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/schema-extra-example.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Union

from pydantic import BaseModel, Field


class Item(BaseModel):
    name: str = Field(example="Foo")
    description: Union[str, None] = Field(default=None, example="A very nice Item")
    price: float = Field(example=35.4)
    tax: Union[float, None] = Field(default=None, example=3.2)
```

----------------------------------------

TITLE: Pydantic BaseSettings for Application Configuration
DESCRIPTION: Pydantic's `BaseSettings` provides a robust way to manage application settings by automatically loading values from environment variables, supporting type validation, and default values. It's ideal for handling both general configuration and sensitive data like API keys.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/advanced/settings.md#_snippet_3

LANGUAGE: APIDOC
CODE:
```
Pydantic BaseSettings:
  Inherit from `pydantic.BaseSettings` to define application settings.
  Automatically loads values from environment variables (case-insensitive matching, e.g., APP_NAME maps to app_name).
  Supports type hints for validation and default values.

  Definition Example:
    from pydantic import BaseSettings, Field

    class Settings(BaseSettings):
        app_name: str = "Awesome API"
        admin_email: str
        items_per_user: int = Field(50, ge=10, le=500)
        api_key: str # Example for sensitive data

  Usage Example:
    settings = Settings()
    # Access settings as attributes:
    # settings.app_name
    # settings.admin_email
    # settings.items_per_user
    # settings.api_key

  Environment Variable Mapping:
    - Fields are mapped from environment variables by name (case-insensitive).
    - E.g., `APP_NAME` environment variable populates `app_name` field.
    - Crucial for sensitive data: `API_KEY` environment variable populates `api_key` field.
```

----------------------------------------

TITLE: Upgrade FastAPI app with Pydantic model and PUT endpoint
DESCRIPTION: This updated FastAPI application demonstrates how to define a Pydantic `BaseModel` for request body validation and how to implement a `PUT` endpoint. The `update_item` function receives an `item_id` path parameter and an `Item` model as the request body, showcasing data validation and serialization capabilities.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/index.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}
```

----------------------------------------

TITLE: List 타입 힌트 예제
DESCRIPTION: `typing` 모듈에서 `List`를 임포트하여 문자열 리스트에 대한 타입 힌트를 선언하는 방법을 보여줍니다. 이를 통해 에디터는 리스트의 아이템을 처리할 때 도움을 줄 수 있습니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/python-types.md#_snippet_5

LANGUAGE: python
CODE:
```
from typing import List
```

LANGUAGE: python
CODE:
```
items: List[str]
```

----------------------------------------

TITLE: Initializing a List with String Type - Python 3.9+
DESCRIPTION: This snippet initializes a list named `items` where each element is a string. It uses the built-in `list` type with type parameters to specify the type of elements within the list.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_6

LANGUAGE: Python
CODE:
```
items: list[str] = ["foo", "bar"]
```

----------------------------------------

TITLE: FastAPI User Data Response Example
DESCRIPTION: Example JSON response for retrieving user data from an authenticated endpoint like `/users/me`. It showcases typical user attributes such as username, email, full name, disabled status, and a placeholder for a hashed password.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/security/simple-oauth2.md#_snippet_7

LANGUAGE: JSON
CODE:
```
{
  "username": "johndoe",
  "email": "johndoe@example.com",
  "full_name": "John Doe",
  "disabled": false,
  "hashed_password": "fakehashedsecret"
}
```

----------------------------------------

TITLE: Add Type Hints to Python Function Parameters
DESCRIPTION: This snippet shows how to add type hints to function parameters using colons (`:`). By specifying `str` for `first_name` and `last_name`, code editors can provide intelligent autocompletion and type checking, significantly improving developer productivity.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/python-types.md#_snippet_1

LANGUAGE: python
CODE:
```
def get_full_name(first_name: str, last_name: str):
    return f"{first_name.title()} {last_name.title()}"
```

----------------------------------------

TITLE: Creating a Data Model with Pydantic
DESCRIPTION: This code snippet shows how to define a data model using Pydantic's `BaseModel`. The model defines the structure of the expected JSON request body, including data types and optional fields. Default values can be assigned to make fields optional.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/body.md#_snippet_1

LANGUAGE: python
CODE:
```
class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None
```

----------------------------------------

TITLE: Query Parameter with Default Value and Minimum Length
DESCRIPTION: This snippet defines a query parameter `q` with a default value and a minimum length validation. The `Query` class is used to specify both the default value and the `min_length` constraint.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/query-params-str-validations.md#_snippet_5

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI, Query

app = FastAPI()


@app.get("/items/")
async def read_items(q: str = Query("fixedquery", min_length=3)):
    return {"q": q}
```

----------------------------------------

TITLE: Defining Base and Inherited Pydantic Models in FastAPI
DESCRIPTION: This code defines a base Pydantic model `UserBase` and inherits from it to create `UserCreate`, `UserUpdate`, and `User` models. This approach reduces code duplication by sharing common attributes and validations among related models. The `User` model includes an `id` field, while `UserCreate` and `UserUpdate` handle password variations.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/extra-models.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel


class UserBase(BaseModel):
    email: str
    first_name: str
    last_name: str
    is_active: bool = True


class UserCreate(UserBase):
    password: str


class UserUpdate(UserBase):
    password: Optional[str] = None


class User(UserBase):
    id: int
```

----------------------------------------

TITLE: FastAPI: Using Generic `list` for Query Parameters
DESCRIPTION: Illustrates using the generic `list` type hint for query parameters instead of `typing.List[str]`. While simpler, FastAPI won't perform type checking on the list's contents with this approach.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/query-params-str-validations.md#_snippet_8

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import FastAPI, Query

app = FastAPI()


@app.get("/items/")
async def read_items(q: list = Query(default=[])):
    query_items = {"q": q}
    return query_items
```

----------------------------------------

TITLE: Declaring a Dictionary (Python 3.9+)
DESCRIPTION: This snippet demonstrates how to declare a dictionary with string keys and float values using Python 3.9+ syntax. The type hint `dict[str, float]` specifies that the keys are strings and the values are floats.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_9

LANGUAGE: Python
CODE:
```
prices: dict[str, float] = {"apple": 1.5, "banana": 0.75}
```

----------------------------------------

TITLE: Define a Pydantic Data Model for Request Body
DESCRIPTION: Defines a Pydantic `BaseModel` class named `Item` that specifies the expected structure and types for an incoming JSON request body. Attributes like `description` and `tax` are marked as optional using `None` as their default value, demonstrating how to handle optional fields.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body.md#_snippet_1

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None
```

----------------------------------------

TITLE: Check String Prefix with Tuple using startswith()
DESCRIPTION: Illustrates a Python string method startswith()'s capability to accept a tuple of prefixes. This allows checking if a string begins with any of the provided prefixes in a single, concise call, improving readability and efficiency for multiple prefix checks.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params-str-validations.md#_snippet_21

LANGUAGE: Python
CODE:
```
# Example within a validation function:
# v is the string to validate
if not v.startswith(("isbn-", "imdb-")):
    # Handle validation error
    pass
```

----------------------------------------

TITLE: Declare Multiple Request Body Examples using FastAPI Body
DESCRIPTION: This method shows how to provide multiple examples for a request body using FastAPI's `Body()` dependency. Each example is defined as a dictionary with `summary`, `description`, `value`, and optionally `externalValue` fields, enhancing the OpenAPI documentation with various scenarios.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/schema-extra-example.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI, Body
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


app = FastAPI()


@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item = Body(
        examples={
            "normal": {
                "summary": "A normal example",
                "description": "A **normal** item working just fine.",
                "value": {
                    "name": "Foo",
                    "description": "A very nice Item",
                    "price": 35.4,
                    "tax": 3.2,
                },
            },
            "bad_name": {
                "summary": "Bad name example",
                "description": "An item with a **bad name**.",
                "value": {
                    "name": "Foobar",
                    "price": 35.4,
                },
            },
            "long_description": {
                "summary": "Long description example",
                "description": "This item has a **long description**.",
                "value": {
                    "name": "Bar",
                    "price": 35.4,
                    "description": "The King of the Foo",
                    "tax": 3.2,
                },
            },
        },
    ),
):
    results = {"item_id": item_id, "item": item}
    return results
```

----------------------------------------

TITLE: Request Body with Multiple Examples
DESCRIPTION: Demonstrates how to pass multiple examples for the expected data in a request body using the `Body()` function. This allows for providing multiple example datasets for the request body, which are then included in the generated JSON Schema.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/schema-extra-example.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import Body, FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item = Body(
        examples=[
            {
                "name": "Foo",
                "description": "A very nice Item",
                "price": 35.4,
                "tax": 3.2,
            },
            {
                "name": "Bar",
                "price": 99.99,
                "description": "The best item there is",
            },
        ],
    ),
):
    results = {"item_id": item_id, "item": item}
    return results
```

----------------------------------------

TITLE: Declare Query Parameters with Pydantic Models in FastAPI
DESCRIPTION: This snippet demonstrates how to define complex query parameters using a Pydantic `BaseModel`. It allows for structured validation, default values, and type annotations for multiple query parameters, enhancing API robustness and clarity. The `Field` function is used for advanced validation like `gt` (greater than) and `le` (less than or equal to).

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_0

LANGUAGE: python
CODE:
```
from typing import Annotated, Literal

from fastapi import FastAPI, Query
from pydantic import BaseModel, Field

app = FastAPI()


class FilterParams(BaseModel):
    limit: int = Field(100, gt=0, le=100)
    offset: int = Field(0, ge=0)
    order_by: Literal["created_at", "updated_at"] = "created_at"
    tags: list[str] = []


@app.get("/items/")
async def read_items(filter_query: Annotated[FilterParams, Query()]):
    return filter_query
```

----------------------------------------

TITLE: Including General Utilities and CLI Framework (Python)
DESCRIPTION: Specifies common utility libraries like PyYAML for data serialization and Typer for building command-line interfaces.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/requirements-docs.txt#_snippet_2

LANGUAGE: Python
CODE:
```
typer == 0.15.3
pyyaml >=5.3.1,<7.0.0
```

----------------------------------------

TITLE: Defining Python Types with Pydantic for Data Models
DESCRIPTION: This snippet demonstrates how to define standard Python types, including a Pydantic BaseModel, for data modeling. It shows a function parameter with a type hint and a Pydantic class `User` with typed attributes like `id` (int), `name` (str), and `joined` (date), enabling editor support and data validation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/features.md#_snippet_0

LANGUAGE: python
CODE:
```
from datetime import date

from pydantic import BaseModel

# Declare a variable as a str
# and get editor support inside the function
def main(user_id: str):
    return user_id


# A Pydantic model
class User(BaseModel):
    id: int
    name: str
    joined: date
```

----------------------------------------

TITLE: Upgrade FastAPI app with Pydantic model and PUT endpoint
DESCRIPTION: This updated FastAPI application demonstrates how to define a Pydantic `BaseModel` for request body validation and how to implement a `PUT` endpoint. The `update_item` function receives an `item_id` path parameter and an `Item` model as the request body, showcasing data validation and serialization capabilities.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/README.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}
```

----------------------------------------

TITLE: Example JSON response from FastAPI GET endpoint
DESCRIPTION: This snippet shows the expected JSON response when accessing the `/items/{item_id}` endpoint with a path parameter and an optional query parameter.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/README.md#_snippet_3

LANGUAGE: JSON
CODE:
```
{"item_id": 5, "q": "somequery"}
```

----------------------------------------

TITLE: Example JSON Response
DESCRIPTION: Example JSON response from the /items/{item_id} endpoint with a query parameter.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/index.md#_snippet_5

LANGUAGE: JSON
CODE:
```
{"item_id": 5, "q": "somequery"}
```

----------------------------------------

TITLE: Initializing FastAPI Application
DESCRIPTION: Creates an instance of the FastAPI class, which serves as the entry point for building the API. The `app` variable is used to define and interact with the API.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/first-steps.md#_snippet_2

LANGUAGE: Python
CODE:
```
app = FastAPI()
```

----------------------------------------

TITLE: Initializing a List with String Type - Python 3.8+
DESCRIPTION: This snippet initializes a list named `items` where each element is a string. It uses the `List` type from the `typing` module to specify the type of elements within the list.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_5

LANGUAGE: Python
CODE:
```
from typing import List

items: List[str] = ["foo", "bar"]
```

----------------------------------------

TITLE: Update main.py to accept PUT request body - Python
DESCRIPTION: This code snippet updates the `main.py` file to handle a PUT request to the `/items/{item_id}` endpoint. It defines a request body using a Pydantic model `Item` and updates the `update_item` function to accept an `item` of type `Item`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/he/docs/index.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}
```

----------------------------------------

TITLE: FastAPI Main App File
DESCRIPTION: This is an example of a FastAPI application defined in main.py. It defines a simple GET endpoint that returns a JSON response.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/testing.md#_snippet_2

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_main():
    return {"msg": "Hello World"}
```

----------------------------------------

TITLE: FastAPI Application with Pydantic Model and PUT Request
DESCRIPTION: Updated FastAPI application demonstrating how to define a Pydantic `BaseModel` for request body validation and how to implement a `PUT` endpoint that accepts a structured request body, enhancing API data handling.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/index.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}
```

----------------------------------------

TITLE: Python Type Hints for List of Pydantic Models
DESCRIPTION: These Python snippets demonstrate how to declare a function parameter that expects a JSON array as its outermost element. FastAPI leverages these type hints to automatically parse and validate a list of Pydantic model instances. The `List[Image]` syntax is for older Python versions, while `list[Image]` is for Python 3.9 and above.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/body-nested-models.md#_snippet_1

LANGUAGE: Python
CODE:
```
images: List[Image]
```

LANGUAGE: Python
CODE:
```
images: list[Image]
```

----------------------------------------

TITLE: Handling Exceptions and Cleanup in FastAPI Dependencies with Yield
DESCRIPTION: This section illustrates patterns for managing resources and exceptions within FastAPI dependencies that utilize `yield`. The first example shows how a dependency can catch and re-raise `HTTPException` while ensuring session rollback and closure. The second example demonstrates a general `try/finally` pattern to guarantee cleanup operations are executed, irrespective of exceptions occurring after `yield`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_26

LANGUAGE: Python
CODE:
```
async def get_database():
    with Session() as session:
        try:
            yield session
        except HTTPException:
            session.rollback()
            raise
        finally:
            session.close()
```

LANGUAGE: Python
CODE:
```
async def do_something():
    try:
        yield something
    finally:
        some_cleanup()
```

----------------------------------------

TITLE: Markdown Admonition Syntax Example (Spanish Translation)
DESCRIPTION: Shows how a 'tip' admonition block is translated into Spanish, maintaining the original 'tip' keyword.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/management-tasks.md#_snippet_2

LANGUAGE: Markdown
CODE:
```
/// tip

Esto es un consejo.

///
```

----------------------------------------

TITLE: Install FastAPI with Standard Dependencies and Run CLI
DESCRIPTION: This snippet demonstrates the new way to install FastAPI with its standard dependencies using `pip install "fastapi[standard]"` and how to invoke the FastAPI CLI directly via `python -m fastapi`. This change simplifies dependency management and provides a direct entry point for CLI operations.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_6

LANGUAGE: bash
CODE:
```
pip install "fastapi[standard]"
```

LANGUAGE: bash
CODE:
```
python -m fastapi
```

----------------------------------------

TITLE: Define Pydantic BaseSettings class for application settings
DESCRIPTION: Examples of defining a `Settings` class using Pydantic's `BaseSettings` to manage application configuration from environment variables. This includes declaring variables with type annotations and optional default values, demonstrating both Pydantic v1 and v2 import paths.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/settings.md#_snippet_2

LANGUAGE: python
CODE:
```
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    app_name: str = "Awesome API"
    admin_email: str
    items_per_user: int = 50
```

LANGUAGE: python
CODE:
```
from pydantic import BaseSettings

class Settings(BaseSettings):
    app_name: str = "Awesome API"
    admin_email: str
    items_per_user: int = 50
```

----------------------------------------

TITLE: Multiple Body and Query Parameters in FastAPI
DESCRIPTION: Demonstrates how to declare multiple body parameters along with query parameters in a FastAPI endpoint.  Scalar values are interpreted as query parameters by default.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/body-multiple-params.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI, Body

from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


class User(BaseModel):
    username: str
    full_name: Union[str, None] = None


app = FastAPI()


@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item,
    user: User,
    importance: int = Body(),
    q: Union[str, None] = None,
):
    results = {"item_id": item_id}
    if q:
        results.update({"q": q})
    results.update({"item": item, "user": user, "importance": importance})
    return results
```

----------------------------------------

TITLE: Install FastAPI with Standard Dependencies
DESCRIPTION: This command installs FastAPI along with its standard dependencies, which typically include `uvicorn` for running the server and `python-multipart` for form parsing. It's crucial to put `"fastapi[standard]"` in quotes to ensure it works correctly across different terminal environments.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/README.md#_snippet_0

LANGUAGE: Shell
CODE:
```
$ pip install "fastapi[standard]"
```

----------------------------------------

TITLE: Mixing Path, Query, and Body Parameters in FastAPI
DESCRIPTION: Demonstrates how to declare optional body parameters by assigning a default value of None. This example shows how to define an endpoint that accepts an optional Item model in the request body.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/body-multiple-params.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI, Body

from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


app = FastAPI()


@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Union[Item, None] = Body(default=None),
    q: Union[str, None] = None,
):
    results = {"item_id": item_id}
    if q:
        results.update({"q": q})
    if item:
        results.update({"item": item})
    return results
```

----------------------------------------

TITLE: Creating a Background Task Function
DESCRIPTION: This code snippet shows how to define a standard function to be executed as a background task. The function can receive parameters and perform operations such as writing to a file.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/background-tasks.md#_snippet_1

LANGUAGE: Python
CODE:
```
def write_notification(email: str, message=""):
    with open("log.txt", mode="w") as f:
        f.write(f"notification for {email}: {message}")
```

----------------------------------------

TITLE: FastAPI Endpoint JSON Response Example
DESCRIPTION: This JSON snippet illustrates the typical response structure returned by the `/items/{item_id}` endpoint in the FastAPI application. It shows how path and query parameters are reflected in the JSON output.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/id/docs/index.md#_snippet_3

LANGUAGE: JSON
CODE:
```
{"item_id": 5, "q": "somequery"}
```

----------------------------------------

TITLE: Function with Type Hints and Error
DESCRIPTION: This function demonstrates how type hints can help catch errors. The `age` parameter is incorrectly used as a string, leading to a type error that an editor can detect.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_2

LANGUAGE: Python
CODE:
```
def get_name_with_age(name: str, age: int):
    return name + " is " + age
```

----------------------------------------

TITLE: Run FastAPI Application with Uvicorn
DESCRIPTION: This console command initiates the Uvicorn server to host the FastAPI application. `main:app` specifies the Python module (`main.py`) and the FastAPI instance (`app`). The `--reload` flag enables automatic server restarts upon code changes, which is highly beneficial during development.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/first-steps.md#_snippet_1

LANGUAGE: console
CODE:
```
uvicorn main:app --reload
```

----------------------------------------

TITLE: Path, Query, and Request Body Parameters in FastAPI
DESCRIPTION: Illustrates how to declare path, query, and request body parameters simultaneously in a FastAPI endpoint. FastAPI intelligently determines the source of each parameter based on its type annotation and presence in the path.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body.md#_snippet_5

LANGUAGE: Python
CODE:
```
{* ../../docs_src/body/tutorial004.py hl[18] *}
```

----------------------------------------

TITLE: Define Path Operation Decorator
DESCRIPTION: The @app.get("/") decorator tells FastAPI that the function below is in charge of handling requests that go to: the path / using a get operation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/first-steps.md#_snippet_4

LANGUAGE: Python
CODE:
```
@app.get("/")
```

----------------------------------------

TITLE: Combining Required, Default, and Optional Query Parameters
DESCRIPTION: This code snippet demonstrates how to define a combination of required, default, and optional query parameters in a FastAPI endpoint. 'needy' is required, 'skip' has a default value of 0, and 'limit' is optional.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/query-params.md#_snippet_7

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/items/{item_id}")
async def read_item(
    item_id: str, needy: str, skip: int = 0, limit: Union[int, None] = None
):
    item = {"item_id": item_id, "needy": needy, "skip": skip, "limit": limit}
    return item
```

----------------------------------------

TITLE: FastAPI Dependency Hierarchy Diagram
DESCRIPTION: A Mermaid graph illustrating the hierarchical dependency injection structure in FastAPI, showing how different API endpoints (`/items/public/`, `/items/private/`, `/users/{user_id}/activate`, `/items/pro/`) can depend on various user types (current_user, active_user, admin_user, paying_user) through a chain of dependencies.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/dependencies/index.md#_snippet_4

LANGUAGE: mermaid
CODE:
```
graph TB

current_user(["current_user"])
active_user(["active_user"])
admin_user(["admin_user"])
paying_user(["paying_user"])

public["/items/public/"]
private["/items/private/"]
activate_user["/users/{user_id}/activate"]
pro_items["/items/pro/"]

current_user --> active_user
active_user --> admin_user
active_user --> paying_user

current_user --> public
active_user --> private
admin_user --> activate_user
paying_user --> pro_items
```

----------------------------------------

TITLE: Example JSON response from FastAPI GET endpoint
DESCRIPTION: This snippet shows the expected JSON response when accessing the `/items/{item_id}` endpoint with a path parameter and an optional query parameter.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/index.md#_snippet_3

LANGUAGE: JSON
CODE:
```
{"item_id": 5, "q": "somequery"}
```

----------------------------------------

TITLE: Install FastAPI with Standard Dependencies
DESCRIPTION: This command installs FastAPI along with its standard dependencies, which typically include `uvicorn` for running the server and `python-multipart` for form parsing. It's crucial to put `"fastapi[standard]"` in quotes to ensure it works correctly across different terminal environments.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/index.md#_snippet_0

LANGUAGE: Shell
CODE:
```
$ pip install "fastapi[standard]"
```

----------------------------------------

TITLE: Declaring String Variable with Editor Support in Python
DESCRIPTION: This code snippet demonstrates how to declare a string variable with type hints in Python, enabling editor support for autocompletion and type checking. It defines a simple function `main` that takes a string `user_id` as input and returns it.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh-hant/docs/features.md#_snippet_0

LANGUAGE: python
CODE:
```
from datetime import date

from pydantic import BaseModel

# 宣告一個變數為 string
# 並在函式中獲得 editor support
def main(user_id: str):
    return user_id
```

----------------------------------------

TITLE: Creating an async FastAPI application
DESCRIPTION: This Python code defines a simple FastAPI application with two asynchronous endpoints: `/` which returns a greeting, and `/items/{item_id}` which returns the item ID and an optional query parameter. It imports FastAPI, creates an app instance, and defines the endpoints using `async def`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pl/docs/index.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Example JSON Structure for Nested Pydantic Model
DESCRIPTION: This JSON snippet provides an example of the expected data structure when a Pydantic model includes a nested submodel. It shows how the `image` field contains its own set of properties, reflecting the defined `Image` submodel.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/body-nested-models.md#_snippet_8

LANGUAGE: JSON
CODE:
```
{
    "name": "Foo",
    "description": "The pretender",
    "price": 42.0,
    "tax": 3.2,
    "tags": ["rock", "metal", "bar"],
    "image": {
        "url": "http://example.com/baz.jpg",
        "name": "The Foo live"
    }
}
```

----------------------------------------

TITLE: Import Path and Annotated for FastAPI Path Parameters
DESCRIPTION: This snippet demonstrates the necessary imports for defining path parameters with validation and metadata in FastAPI. It imports `Annotated` from `typing` and `FastAPI`, `Path` from `fastapi`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/path-params-numeric-validations.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Annotated
from fastapi import FastAPI, Path

app = FastAPI()
```

----------------------------------------

TITLE: Function Parameter with Optional Type
DESCRIPTION: Illustrates a function parameter defined as `Optional[str]`, which means it can accept either a string or `None` as a value.  The parameter is still required if no default value is provided.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_15

LANGUAGE: Python
CODE:
```
from typing import Optional

def say_hi(name: Optional[str]):
    if name:
        print(f"Hi {name}")
    else:
        print("Hello World")
```

----------------------------------------

TITLE: Declare OpenAPI-Specific Examples in FastAPI
DESCRIPTION: Explains how to use the `openapi_examples` parameter with FastAPI dependencies like `Body()` to provide multiple, rich examples that are displayed in the Swagger UI. This leverages OpenAPI's specific `examples` field, which supports additional metadata like `summary` and `description` for each example.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/schema-extra-example.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Annotated

from fastapi import FastAPI, Body
from pydantic import BaseModel

app = FastAPI()

class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None

@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Annotated[
        Item,
        Body(
            openapi_examples={
                "normal": {
                    "summary": "A normal example",
                    "description": "A **normal** item working correctly.",
                    "value": {
                        "name": "Foo",
                        "description": "A very nice Item",
                        "price": 35.4,
                        "tax": 3.2
                    }
                },
                "bad_tax": {
                    "summary": "A bad tax example",
                    "description": "Tax can't be more than price.",
                    "value": {
                        "name": "Bar",
                        "price": 35.4,
                        "tax": 35.41
                    }
                }
            }
        )
    ]
):
    results = {"item_id": item_id, "item": item}
    return results
```

----------------------------------------

TITLE: Install FastAPI with Standard Dependencies
DESCRIPTION: This command demonstrates the current recommended way to install FastAPI, explicitly including its standard optional dependencies. Previously, these dependencies were installed by default, but now they require explicit inclusion using the `[standard]` extra. This change addresses user feedback regarding unwanted default dependencies and provides more control over the installation footprint.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_7

LANGUAGE: Shell
CODE:
```
pip install "fastapi[standard]"
```

LANGUAGE: Shell
CODE:
```
pip install fastapi
```

----------------------------------------

TITLE: Example Initial Request Body to FastAPI
DESCRIPTION: A sample JSON payload sent by an external user to the FastAPI application. This body contains an invoice ID, customer details, and total, which can be referenced in callback path expressions.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/openapi-callbacks.md#_snippet_3

LANGUAGE: JSON
CODE:
```
{
    "id": "2expen51ve",
    "customer": "Mr. Richie Rich",
    "total": "9999"
}
```

----------------------------------------

TITLE: Define a reusable dependency function in FastAPI
DESCRIPTION: This Python function, `common_parameters`, serves as a dependency. It accepts optional query parameters `q` (string), `skip` (integer, default 0), and `limit` (integer, default 100), similar to a path operation function. It processes these parameters and returns them as a dictionary, demonstrating how dependencies can encapsulate shared logic and provide data to other parts of the application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/dependencies/index.md#_snippet_0

LANGUAGE: Python
CODE:
```
async def common_parameters(q: str | None = None, skip: int = 0, limit: int = 100):
    return {"q": q, "skip": skip, "limit": limit}
```

----------------------------------------

TITLE: FastAPI: Declare Required Parameters by Omitting Default Value
DESCRIPTION: This example illustrates the new FastAPI feature allowing required path, query, cookie, and header parameters to be declared by simply omitting their default value. This aligns with Pydantic's behavior for required fields, making parameter declaration more concise and intuitive.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_24

LANGUAGE: Python
CODE:
```
from fastapi import Cookie, FastAPI, Header, Path, Query

app = FastAPI()


@app.get("/items/{item_id}")
def main(
    item_id: int = Path(gt=0),
    query: str = Query(max_length=10),
    session: str = Cookie(min_length=3),
    x_trace: str = Header(title="Tracing header"),
):
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: 타입 힌트 추가 예제
DESCRIPTION: 이 함수는 `first_name`과 `last_name` 매개변수에 타입 힌트를 추가하여 문자열임을 명시합니다. 이를 통해 에디터에서 자동 완성 및 오류 검사를 지원받을 수 있습니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/python-types.md#_snippet_1

LANGUAGE: python
CODE:
```
def get_full_name(first_name: str, last_name: str):
    full_name = first_name.title() + " " + last_name.title()
    return full_name
```

----------------------------------------

TITLE: FastAPI Required and Optional Query Parameters
DESCRIPTION: Explains how to declare query parameters as required or optional in FastAPI. It covers simple required parameters, optional parameters with a `None` default, and how to make a parameter required even if it can accept `None` as a valid value, forcing the client to send it, with examples including references to external files.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params-str-validations.md#_snippet_6

LANGUAGE: Python
CODE:
```
q: str
```

LANGUAGE: Python
CODE:
```
q: str | None = None
```

LANGUAGE: Python
CODE:
```
q: Annotated[str | None, Query(min_length=3)] = None
```

LANGUAGE: Python
CODE:
```
{* ../../docs_src/query_params_str_validations/tutorial006_an_py39.py hl[9] *}
```

LANGUAGE: Python
CODE:
```
{* ../../docs_src/query_params_str_validations/tutorial006c_an_py310.py hl[9] *}
```

----------------------------------------

TITLE: Fixing Type Error with str()
DESCRIPTION: This code fixes the type error by converting the integer `age` to a string using `str(age)`. This ensures that the function concatenates strings correctly.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_3

LANGUAGE: Python
CODE:
```
def get_name_with_age(name: str, age: int):
    return name + " is " + str(age)
```

----------------------------------------

TITLE: 클래스 타입 힌트 예제
DESCRIPTION: 변수의 타입으로 클래스를 선언하는 방법을 보여줍니다. `Person` 클래스를 정의하고 변수를 `Person` 타입으로 선언하여 에디터의 도움을 받을 수 있습니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/python-types.md#_snippet_9

LANGUAGE: python
CODE:
```
class Person:
    def __init__(self, name: str):
        self.name = name
```

LANGUAGE: python
CODE:
```
first_person: Person
```

----------------------------------------

TITLE: FastAPI Security Dependencies for Active User Authentication
DESCRIPTION: Demonstrates how to create FastAPI dependencies (`get_current_user`, `get_current_active_user`) to retrieve and validate the current authenticated user. These dependencies raise `HTTPException` for unauthenticated or inactive users, ensuring secure access to protected endpoints.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/security/simple-oauth2.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from typing import Annotated, Optional

# Assume UserInDB and fake_users_db are defined as in the previous snippet
class UserInDB:
    def __init__(self, username: str, hashed_password: str, email: Optional[str] = None, full_name: Optional[str] = None, disabled: Optional[bool] = None):
        self.username = username
        self.hashed_password = hashed_password
        self.email = email
        self.full_name = full_name
        self.disabled = disabled

fake_users_db = {
    "johndoe": UserInDB(username="johndoe", hashed_password="secret", full_name="John Doe", disabled=False),
    "janedoe": UserInDB(username="janedoe", hashed_password="anothersecret", full_name="Jane Doe", disabled=True),
}

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

async def get_current_user(token: Annotated[str, Depends(oauth2_scheme)]):
    # In a real app, decode JWT or validate token securely
    user = fake_users_db.get(token) # Simplified: token is just username here
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return user

async def get_current_active_user(
    current_user: Annotated[UserInDB, Depends(get_current_user)]
):
    if current_user.disabled:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Inactive user")
    return current_user

# Example of a protected endpoint
# @router.get("/users/me/")
# async def read_users_me(current_user: Annotated[UserInDB, Depends(get_current_active_user)]):
#     return current_user
```

----------------------------------------

TITLE: FastAPI HTTP Update Operations: PUT and PATCH
DESCRIPTION: This section details the usage and behavior of HTTP PUT and PATCH methods for updating resources in FastAPI applications. It outlines their distinct purposes, common pitfalls, and recommended Pydantic techniques for handling data updates effectively.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-updates.md#_snippet_5

LANGUAGE: APIDOC
CODE:
```
HTTP PUT Method:
  Purpose: Used for full replacement of a resource.
  Behavior:
    - Replaces the entire resource with the data provided in the request body.
    - If fields are omitted from the request body, they will be replaced by their default values (if defined in the Pydantic model) or removed if no default is specified.
    - Example: Updating an item with a PUT request that omits the 'tax' field will cause 'tax' to revert to its default value (e.g., 10.5) if it was previously stored with a different value (e.g., 20.2).
  FastAPI Implementation:
    - Use `@app.put("/path/{item_id}")` decorator.
    - Employ `fastapi.encoders.jsonable_encoder` to convert Pydantic models to JSON-compatible dictionaries before storing.

HTTP PATCH Method:
  Purpose: Used for partial updates of a resource.
  Behavior:
    - Applies incremental modifications to a resource, updating only the fields provided in the request body.
    - Fields not included in the request body remain unchanged.
  FastAPI Implementation:
    - Use `@app.patch("/path/{item_id}")` decorator.
    - Recommended Pydantic techniques for partial updates:
      - `item.model_dump(exclude_unset=True)`: Generates a dictionary containing only the fields explicitly set in the incoming request, ignoring default values. (Pydantic v1: `.dict(exclude_unset=True)`)
      - `stored_item_model.model_copy(update=update_data)`: Creates a new model instance by copying an existing one and applying the partial `update_data` dictionary. (Pydantic v1: `.copy(update=update_data)`)
    - Workflow: Retrieve stored data -> Load into Pydantic model -> Generate update dict with `exclude_unset` -> Apply updates with `model_copy` -> Encode and save.
```

----------------------------------------

TITLE: Request Body, Path, and Query Parameters in FastAPI
DESCRIPTION: Illustrates how to declare request body, path parameters, and query parameters simultaneously in a FastAPI endpoint. FastAPI automatically infers the source of each parameter based on its type and declaration.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/body.md#_snippet_5

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


app = FastAPI()


@app.put("/items/{item_id}")
async def create_item(item_id: int, item: Item, q: Union[str, None] = None):
    results = {"item_id": item_id, **item.dict()}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: Example requirements.txt file
DESCRIPTION: This is an example of a requirements.txt file. It lists the packages and their versions that are required for the project.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/vi/docs/virtual-environments.md#_snippet_16

LANGUAGE: txt
CODE:
```
fastapi[standard]==0.113.0
pydantic==2.8.0
```

----------------------------------------

TITLE: Define a Pydantic Model with a Typed List Field (List[str])
DESCRIPTION: Shows how to explicitly declare a Pydantic model field as a list of a specific type (e.g., `List[str]`) using `typing.List`. This ensures strict type validation for list elements and provides better documentation. Includes an example of a standalone typed list declaration.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body-nested-models.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import List
```

LANGUAGE: Python
CODE:
```
from typing import List

my_list: List[str]
```

LANGUAGE: Python
CODE:
```
from typing import List
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    tags: List[str]
```

----------------------------------------

TITLE: Demonstrate Type Hinting for Error Detection
DESCRIPTION: This example illustrates how type hints enable static analysis tools and IDEs to detect potential type-related errors before runtime. The function expects an integer for `age`, and if `age` were used directly in string concatenation without conversion, a type error would be flagged by a type checker.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/python-types.md#_snippet_2

LANGUAGE: python
CODE:
```
def get_name_and_age(name: str, age: int):
    # This function expects 'age' to be an integer.
    # If 'age' were used directly in string concatenation without conversion,
    # a type error would be flagged by a type checker.
    return f"Hello, {name}. You are {age} years old."
```

----------------------------------------

TITLE: Defining a Set Field
DESCRIPTION: Demonstrates how to define a set field in a Pydantic model. Sets are used to store unique elements. The `tags` attribute is defined as a set of strings.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body-nested-models.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: set[str] = set()
```

----------------------------------------

TITLE: Base Model for User Data
DESCRIPTION: Defines a base Pydantic model UserBase with common fields and then creates specialized models UserIn, User, and UserInDB inheriting from it. This reduces code duplication and ensures consistency across different user models.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/extra-models.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel


class UserBase(BaseModel):
    username: str
    email: str
    full_name: Optional[str] = None


class UserIn(UserBase):
    password: str


class User(UserBase):
    pass


class UserInDB(UserBase):
    hashed_password: str
```

----------------------------------------

TITLE: JSON Response Example
DESCRIPTION: This JSON snippet shows an example response from the /items/{item_id} endpoint, including the item_id and the query parameter q.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/bn/docs/index.md#_snippet_5

LANGUAGE: JSON
CODE:
```
{"item_id": 5, "q": "somequery"}
```

----------------------------------------

TITLE: Declaring a Dictionary (Python 3.8+)
DESCRIPTION: This snippet demonstrates how to declare a dictionary with string keys and float values using the `typing` module in Python 3.8+. The type hint `Dict[str, float]` specifies that the keys are strings and the values are floats.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_10

LANGUAGE: Python
CODE:
```
from typing import Dict

prices: Dict[str, float] = {"apple": 1.5, "banana": 0.75}
```

----------------------------------------

TITLE: Importing Path from FastAPI
DESCRIPTION: This code snippet shows how to import the `Path` class from the `fastapi` library. This is necessary to declare path parameters with validations and metadata.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/path-params-numeric-validations.md#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import FastAPI, Path
```

----------------------------------------

TITLE: Function Parameter with Optional Type (Python 3.10+)
DESCRIPTION: Illustrates a function parameter defined using the `|` operator in Python 3.10+, indicating it can accept either a string or `None`. The parameter is still required if no default value is provided.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_16

LANGUAGE: Python
CODE:
```
def say_hi(name: str | None):
    if name:
        print(f"Hi {name}")
    else:
        print("Hello World")
```

----------------------------------------

TITLE: FastAPI Query Parameter List with Default Values
DESCRIPTION: Demonstrates how to provide a default list of values for a query parameter when no values are supplied in the URL. This example uses Python 3.9+ type hints (`List[str]`). It includes the Python path operation and an example JSON response showing the default list being used.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params-str-validations.md#_snippet_8

LANGUAGE: Python
CODE:
```
from typing import List
from fastapi import FastAPI, Query

app = FastAPI()

@app.get("/items/")
async def read_items(q: List[str] = Query(default=["foo", "bar"])):
    return {"q": q}
```

LANGUAGE: JSON
CODE:
```
{
  "q": [
    "foo",
    "bar"
  ]
}
```

----------------------------------------

TITLE: FastAPI Application Initialization
DESCRIPTION: Demonstrates the initial steps to set up a FastAPI application: importing the `FastAPI` class and creating an instance of it. This instance serves as the main entry point for defining API routes and functionalities.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/first-steps.md#_snippet_4

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()
```

----------------------------------------

TITLE: Import Query and Annotated for Parameter Validation
DESCRIPTION: Imports necessary components for advanced parameter validation in FastAPI. `Query` is imported from `fastapi` to define query parameter specific validations, and `Annotated` is imported from `typing` (for Python 3.10+) or `typing_extensions` (for Python 3.8+) to add metadata to type hints.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/query-params-str-validations.md#_snippet_1

LANGUAGE: Python 3.10+
CODE:
```
from typing import Annotated
from fastapi import FastAPI, Query
```

LANGUAGE: Python 3.8+
CODE:
```
from fastapi import FastAPI, Query
from typing_extensions import Annotated
```

----------------------------------------

TITLE: Importing List from typing
DESCRIPTION: Shows how to import the `List` type from the `typing` module in Python versions prior to 3.9. This is necessary for declaring lists with specific element types.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body-nested-models.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import List
```

----------------------------------------

TITLE: Import Query for Parameter Validations
DESCRIPTION: To apply advanced validations and metadata to query parameters in FastAPI, the `Query` class must be imported from the `fastapi` module. This class is essential for defining validation rules like length constraints or regular expressions.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/query-params-str-validations.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import Query
```

----------------------------------------

TITLE: FastAPI Query Parameter Definition: `Annotated` vs. Direct Default
DESCRIPTION: Compares the recommended `Annotated` approach for defining FastAPI query parameters with the older method of using `Query` directly as a function parameter's default. It highlights the clarity and benefits of `Annotated` for type checking and tool support, showing both correct and incorrect usage patterns.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/query-params-str-validations.md#_snippet_2

LANGUAGE: Python
CODE:
```
q: Annotated[str, Query(default="rick")] = "morty"
```

LANGUAGE: Python
CODE:
```
q: Annotated[str, Query()] = "rick"
```

LANGUAGE: Python
CODE:
```
q: str = Query(default="rick")
```

----------------------------------------

TITLE: Initializing FastAPI Application with Async
DESCRIPTION: This code initializes a FastAPI application with asynchronous route handlers using `async def`. It includes two GET endpoints: one for the root path ('/') and another for retrieving items by ID ('/items/{item_id}'). It demonstrates how to define path parameters and optional query parameters in an asynchronous context.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/index.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Type Hinting Example in Python
DESCRIPTION: This code demonstrates the use of type hints in Python for function parameters and return values. It shows how to declare a variable as a string with editor autocompletion support.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/features.md#_snippet_0

LANGUAGE: Python
CODE:
```
from datetime import date
from pydantic import BaseModel

# Оголошення змінної як str
# з підтримкою автодоповнення у редакторі
def main(user_id: str):
    return user_id

# Модель Pydantic
class User(BaseModel):
    id: int
    name: str
    joined: date
```

----------------------------------------

TITLE: Multiple Body and Query Parameters
DESCRIPTION: Illustrates how to combine body parameters with query parameters in a FastAPI endpoint. Query parameters are automatically inferred if they are simple types and not explicitly defined as Body parameters.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body-multiple-params.md#_snippet_3

LANGUAGE: Python
CODE:
```
@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item,
    user: User,
    importance: int = Body(..., gt=0),
    q: Union[str, None] = None
):
    results = {"item_id": item_id, "item": item, "user": user, "importance": importance}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: FastAPI Standard Response Classes (File, HTML, JSON, PlainText, Redirect, Base, Streaming)
DESCRIPTION: This API documentation details the standard response classes available in FastAPI, which are largely inherited from Starlette. These classes offer diverse ways to construct and return HTTP responses, including serving files, HTML content, JSON data, plain text, handling redirects, and streaming data. Most classes share common attributes for status, media type, headers, and cookie management, with `StreamingResponse` uniquely utilizing a `body_iterator` for its content.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/reference/responses.md#_snippet_2

LANGUAGE: APIDOC
CODE:
```
fastapi.responses.FileResponse:
  Description: Response class for serving files.
  Members:
    - chunk_size: Size of chunks to read from the file.
    - charset: Character set for the response.
    - status_code: HTTP status code.
    - media_type: Media type (Content-Type header).
    - body: The response body content.
    - background: Background task to run after sending the response.
    - raw_headers: Raw HTTP headers as a list of byte tuples.
    - render: Method to render the response body.
    - init_headers: Method to initialize response headers.
    - headers: Response headers dictionary.
    - set_cookie: Method to set a cookie in the response.
    - delete_cookie: Method to delete a cookie from the response.

fastapi.responses.HTMLResponse:
  Description: Response class for serving HTML content.
  Members:
    - charset: Character set for the response.
    - status_code: HTTP status code.
    - media_type: Media type (Content-Type header).
    - body: The response body content.
    - background: Background task to run after sending the response.
    - raw_headers: Raw HTTP headers as a list of byte tuples.
    - render: Method to render the response body.
    - init_headers: Method to initialize response headers.
    - headers: Response headers dictionary.
    - set_cookie: Method to set a cookie in the response.
    - delete_cookie: Method to delete a cookie from the response.

fastapi.responses.JSONResponse:
  Description: Response class for serving JSON data.
  Members:
    - charset: Character set for the response.
    - status_code: HTTP status code.
    - media_type: Media type (Content-Type header).
    - body: The response body content.
    - background: Background task to run after sending the response.
    - raw_headers: Raw HTTP headers as a list of byte tuples.
    - render: Method to render the response body.
    - init_headers: Method to initialize response headers.
    - headers: Response headers dictionary.
    - set_cookie: Method to set a cookie in the response.
    - delete_cookie: Method to delete a cookie from the response.

fastapi.responses.PlainTextResponse:
  Description: Response class for serving plain text.
  Members:
    - charset: Character set for the response.
    - status_code: HTTP status code.
    - media_type: Media type (Content-Type header).
    - body: The response body content.
    - background: Background task to run after sending the response.
    - raw_headers: Raw HTTP headers as a list of byte tuples.
    - render: Method to render the response body.
    - init_headers: Method to initialize response headers.
    - headers: Response headers dictionary.
    - set_cookie: Method to set a cookie in the response.
    - delete_cookie: Method to delete a cookie from the response.

fastapi.responses.RedirectResponse:
  Description: Response class for HTTP redirects.
  Members:
    - charset: Character set for the response.
    - status_code: HTTP status code.
    - media_type: Media type (Content-Type header).
    - body: The response body content.
    - background: Background task to run after sending the response.
    - raw_headers: Raw HTTP headers as a list of byte tuples.
    - render: Method to render the response body.
    - init_headers: Method to initialize response headers.
    - headers: Response headers dictionary.
    - set_cookie: Method to set a cookie in the response.
    - delete_cookie: Method to delete a cookie from the response.

fastapi.responses.Response:
  Description: Base response class for custom responses.
  Members:
    - charset: Character set for the response.
    - status_code: HTTP status code.
    - media_type: Media type (Content-Type header).
    - body: The response body content.
    - background: Background task to run after sending the response.
    - raw_headers: Raw HTTP headers as a list of byte tuples.
    - render: Method to render the response body.
    - init_headers: Method to initialize response headers.
    - headers: Response headers dictionary.
    - set_cookie: Method to set a cookie in the response.
    - delete_cookie: Method to delete a cookie from the response.

fastapi.responses.StreamingResponse:
  Description: Response class for streaming data.
  Members:
    - body_iterator: An async iterator for the response body.
    - charset: Character set for the response.
    - status_code: HTTP status code.
    - media_type: Media type (Content-Type header).
    - body: The response body content.
    - background: Background task to run after sending the response.
    - raw_headers: Raw HTTP headers as a list of byte tuples.
    - render: Method to render the response body.
    - init_headers: Method to initialize response headers.
    - headers: Response headers dictionary.
    - set_cookie: Method to set a cookie in the response.
    - delete_cookie: Method to delete a cookie from the response.
```

----------------------------------------

TITLE: 타입 힌트를 이용한 오류 수정 예제
DESCRIPTION: 이 함수는 `name`과 `age`를 입력받아 문자열을 반환합니다. `age`를 문자열로 변환하여 타입 오류를 수정합니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/python-types.md#_snippet_3

LANGUAGE: python
CODE:
```
def create_item(name: str, age: int):
    return {"name": name, "age": str(age)}
```

----------------------------------------

TITLE: Implement Dependency Injection in FastAPI Path Operation
DESCRIPTION: Demonstrates how to integrate the `common_parameters` dependency into a FastAPI path operation. By using `common: dict = Depends(common_parameters)`, FastAPI ensures that the `common_parameters` function is executed and its return value is injected into the `common` argument of the `read_items` path operation function, promoting code reusability and modularity.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/dependencies/index.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Optional
from fastapi import FastAPI, Depends

app = FastAPI()

# This function serves as a dependency
def common_parameters(q: Optional[str] = None, skip: int = 0, limit: int = 100):
    return {"q": q, "skip": skip, "limit": limit}

@app.get("/items/")
async def read_items(common: dict = Depends(common_parameters)):
    """
    Reads items using common parameters injected via dependency.
    """
    return common
```

----------------------------------------

TITLE: Define Synchronous GET Path Operation for Root
DESCRIPTION: As an alternative to asynchronous functions, this snippet illustrates defining a synchronous GET endpoint for the root path ('/') using a regular `def` function. This approach is suitable for operations that do not involve I/O-bound tasks.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/first-steps.md#_snippet_3

LANGUAGE: Python
CODE:
```
@app.get("/")
def root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Declaring Examples with Pydantic Field
DESCRIPTION: Illustrates how to add `examples` directly to individual fields within a Pydantic model using the `Field()` function. These examples are included in the generated JSON Schema for the respective field.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/schema-extra-example.md#_snippet_1

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel, Field

class Item(BaseModel):
    name: str = Field(examples=["Foo"])
    description: str | None = Field(
        default=None, examples=["A very nice Item"]
    )
    price: float = Field(examples=[35.4, 40.2])
    tax: float | None = Field(default=None, examples=[3.2, 3.5])
```

----------------------------------------

TITLE: Creating a Data Model with Pydantic
DESCRIPTION: Defines a data model named `Item` by inheriting from `BaseModel`. It includes fields like `name`, `description`, `price`, and `tax`, with type annotations and default values to specify data types and optional fields.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body.md#_snippet_1

LANGUAGE: Python
CODE:
```
class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None
```

----------------------------------------

TITLE: Mixing Path, Query, and Body Parameters
DESCRIPTION: Demonstrates how to mix Path, Query, and body parameters in a FastAPI route. It also shows how to declare body parameters as optional by setting a default value of None.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body-multiple-params.md#_snippet_0

LANGUAGE: Python
CODE:
```
@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Union[Item, None] = None,
    q: Union[str, None] = None
):
    results = {"item_id": item_id}
    if item:
        results.update({"item": item})
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: FastAPI Core Features and Design Principles
DESCRIPTION: This section details the fundamental design principles and key features of the FastAPI framework. It covers its adherence to open standards, automatic documentation generation, reliance on Python type hints for data validation and editor support, robust security mechanisms, and a powerful dependency injection system.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/features.md#_snippet_2

LANGUAGE: APIDOC
CODE:
```
FastAPI Core Features:

1.  Based on Open Standards:
    -   Utilizes OpenAPI Specification for API definition, including endpoints, HTTP methods, parameters, responses, and security.
    -   Leverages JSON Schema for automatic data validation and documentation, as OpenAPI is built on JSON Schema.
    -   Enables automatic client code generation in many languages.

2.  Automatic Documentation:
    -   Provides interactive API documentation with Swagger UI, allowing direct testing and interaction with API endpoints from the browser.
    -   Offers alternative API documentation with ReDoc for a more concise and readable format.

3.  Standard Python Type Hints:
    -   Built entirely on standard Python 3.6+ type hints (PEP 484).
    -   No new syntax to learn; uses standard Python features.
    -   Integrates seamlessly with Pydantic for data validation and serialization.

4.  Editor Support:
    -   Provides excellent editor support (e.g., VS Code, PyCharm) for autocompletion, type checking, and error detection.
    -   Helps catch errors early and improves developer productivity by suggesting valid parameters and attributes.

5.  Data Validation:
    -   Automatically validates all data, including JSON, path parameters, query parameters, and headers.
    -   Supports complex data types like dictionaries, lists, and nested models.
    -   Validates specific formats (e.g., email, URL, UUID) and constraints (e.g., string length, number ranges).
    -   Powered by Pydantic for robust and efficient data validation.

6.  Security and Authentication:
    -   Supports various security schemes defined in OpenAPI.
    -   Includes HTTP Basic authentication.
    -   Integrates with OAuth2 (including JWT tokens) for advanced authentication.
    -   Supports API Keys (in headers, query parameters, cookies).
    -   Leverages Starlette's security utilities (e.g., session cookies).
    -   Provides reusable tools for integrating with databases, external APIs, and cloud services.

7.  Dependency Injection System:
    -   Features a highly advanced and powerful dependency injection system.
    -   Dependencies can have their own dependencies, forming a dependency graph.
    -   Handles all dependencies automatically, including extracting data from requests and injecting it into path operation functions.
    -   Automatically validates path operation function parameters based on their type hints.
    -   Supports creating database connections, security dependencies, and more.
    -   Prevents common errors related to resource management (e.g., database connections, web sockets).

8.  Limitless "Plug-in" Support:
    -   Designed to be highly extensible without imposing specific structures.
    -   Allows developers to write "plug-ins" for their applications by leveraging the dependency injection system and standard Python features.

9.  100% Coverage:
    -   Achieves 100% test coverage for its codebase.
    -   Maintains 100% type annotation coverage, ensuring robust type checking and editor support.
    -   Used in production applications.
```

----------------------------------------

TITLE: Using BackgroundTasks with FastAPI Dependency Injection
DESCRIPTION: Demonstrates the integration of `BackgroundTasks` with FastAPI's dependency injection system. Tasks can be added from within dependencies or the path operation function itself, and FastAPI ensures all registered tasks are merged and executed after the response. This example shows tasks added from both a dependency and the main route, illustrating a robust pattern for complex background operations.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/background-tasks.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Annotated

from fastapi import BackgroundTasks, Depends, FastAPI

app = FastAPI()

def write_log(message: str):
    with open("log.txt", mode="a") as log:
        log.write(message)

def get_query_background_tasks(background_tasks: BackgroundTasks, q: str | None = None):
    if q:
        background_tasks.add_task(write_log, f"query: {q}\n")
    return q

@app.post("/send-notification/{email}")
async def send_notification(
    email: str,
    background_tasks: BackgroundTasks,
    q: Annotated[str | None, Depends(get_query_background_tasks)] = None,
):
    background_tasks.add_task(write_log, f"message for {email}\n")
    return {"message": "Notification sent in the background"}
```

----------------------------------------

TITLE: Mixing Path, Query, and Body Parameters in FastAPI
DESCRIPTION: This example shows how to mix `Path`, `Query`, and request body parameters in a FastAPI path operation function. It also demonstrates how to make a body parameter optional by setting its default value to `None`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/body-multiple-params.md#_snippet_0

LANGUAGE: Python
CODE:
```
@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Union[Item, None] = None,
    q: Union[str, None] = None
):
    results = {"item_id": item_id}
    if item:
        results.update(item.model_dump())
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: Query Parameter with Min and Max Length Validation
DESCRIPTION: This snippet defines a query parameter `q` with both minimum and maximum length validations using the `Query` class. The `min_length` and `max_length` parameters enforce the length constraints.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/query-params-str-validations.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import FastAPI, Query

app = FastAPI()


@app.get("/items/")
async def read_items(q: Optional[str] = Query(None, min_length=3, max_length=50)):
    return {"q": q}
```

----------------------------------------

TITLE: Return Data from Path Operation
DESCRIPTION: You can return a dict, list, singular values like str, int, etc. You can also return Pydantic models. There are many other objects and models that will be automatically converted to JSON.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/first-steps.md#_snippet_7

LANGUAGE: Python
CODE:
```
return {"message": "Hello World"}
```

----------------------------------------

TITLE: FastAPI Endpoint to Read Multiple Heroes
DESCRIPTION: Defines a GET endpoint `/heroes/` to retrieve a list of heroes from the database. It supports optional `offset` and `limit` query parameters for pagination, allowing clients to fetch a subset of heroes. The `limit` is capped at 100 to prevent excessively large responses.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/sql-databases.md#_snippet_7

LANGUAGE: python
CODE:
```
from typing import List, Optional
from fastapi import APIRouter
from sqlmodel import select, Field
from .tutorial001_an_py310 import Hero, SessionDep # Assuming Hero and SessionDep are from the same file

router = APIRouter()

@router.get("/heroes/", response_model=List[Hero])
def read_heroes(
    offset: int = 0,
    limit: Optional[int] = Field(default=None, le=100),
    session: SessionDep
):
    heroes = session.exec(select(Hero).offset(offset).limit(limit)).all()
    return heroes
```

----------------------------------------

TITLE: 타입 힌트를 이용한 오류 검출 예제
DESCRIPTION: 이 함수는 `name`과 `age`를 입력받아 문자열을 반환합니다. `age`에 타입 힌트가 적용되어 있어 편집기에서 오류를 확인할 수 있습니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/python-types.md#_snippet_2

LANGUAGE: python
CODE:
```
def create_item(name: str, age: int):
    return {"name": name, "age": age}
```

----------------------------------------

TITLE: Import FastAPI Request Parameter Functions
DESCRIPTION: Demonstrates how to import the various request parameter functions (Body, Cookie, File, Form, Header, Path, Query) directly from the `fastapi` library. These functions are essential for defining how data is extracted from different parts of an HTTP request.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/reference/parameters.md#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import Body, Cookie, File, Form, Header, Path, Query
```

----------------------------------------

TITLE: FastAPI Query Parameter Validation (Legacy Query as Default)
DESCRIPTION: Demonstrates the older method of defining optional query parameters and applying string validations (e.g., `max_length`) in FastAPI by using `Query` directly as the parameter's default value.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params-str-validations.md#_snippet_2

LANGUAGE: Python
CODE:
```
q: str | None = Query(default=None)
```

LANGUAGE: Python
CODE:
```
q: str | None = Query(default=None, max_length=50)
```

----------------------------------------

TITLE: Importing FastAPI
DESCRIPTION: This code snippet demonstrates how to import the FastAPI class, which provides the core functionality for building APIs.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/first-steps.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
```

----------------------------------------

TITLE: Initializing FastAPI App with Async Endpoints
DESCRIPTION: Creates a FastAPI application instance and defines two asynchronous GET endpoints: one for the root path ('/') and another for '/items/{item_id}' with a path parameter and an optional query parameter. It uses the FastAPI library and returns JSON responses using async def.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/index.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Inheriting Models with FastAPI and Pydantic
DESCRIPTION: Demonstrates how to inherit from Pydantic models to create more complex data structures in FastAPI. This allows for code reuse and easier management of related data models.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/body-nested-models.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import FastAPI
from pydantic import BaseModel, HttpUrl

app = FastAPI()


class Image(BaseModel):
    url: HttpUrl
    name: str


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: list[str] = []
    image: Optional[Image] = None


class Offer(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    items: list[Item]


@app.post("/offers/")
async def create_offer(offer: Offer):
    return offer
```

----------------------------------------

TITLE: FastAPI PATCH Endpoint for Partial Item Updates
DESCRIPTION: A comprehensive FastAPI endpoint demonstrating how to perform partial updates using the HTTP PATCH method. It involves retrieving existing data, creating a Pydantic model from it, generating an update dictionary with `exclude_unset`, merging updates with `model_copy`, and finally encoding the updated model for storage.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-updates.md#_snippet_4

LANGUAGE: Python
CODE:
```
@app.patch("/items/{item_id}")
async def update_item_partial(item_id: str, item: Item):
    if item_id not in items:
        raise HTTPException(status_code=404, detail="Item not found")
    stored_item_data = items[item_id]
    stored_item_model = Item(**stored_item_data)
    update_data = item.model_dump(exclude_unset=True)
    updated_item = stored_item_model.model_copy(update=update_data)
    items[item_id] = jsonable_encoder(updated_item)
    return updated_item
```

----------------------------------------

TITLE: Import Security from FastAPI
DESCRIPTION: This code snippet demonstrates how to import the `Security` function from the `fastapi` library. `Security` is used in scenarios where you need to handle dependencies that also involve declaring OAuth2 scopes for authorization and authentication.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/reference/dependencies.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import Security
```

----------------------------------------

TITLE: Declare Pydantic Model Attributes with Field Validation
DESCRIPTION: This code illustrates how to define attributes within a Pydantic `BaseModel` class using `Field` to apply validation rules and include metadata. Each attribute is assigned a type, an optional default value, and a `Field` instance to specify constraints such as minimum length, maximum length, or value ranges, enhancing data integrity.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-fields.md#_snippet_1

LANGUAGE: Python
CODE:
```
class Item(BaseModel):
    name: str = Field(min_length=3)
    description: str | None = Field(default=None, max_length=300)
    price: float = Field(gt=0)
```

----------------------------------------

TITLE: Install Python Multipart Package for FastAPI
DESCRIPTION: Installs the `python-multipart` package, which is essential for FastAPI to handle 'form data' used by OAuth2 for sending username and password. While included with `fastapi[standard]`, it requires manual installation if only `fastapi` is installed.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/security/first-steps.md#_snippet_0

LANGUAGE: console
CODE:
```
pip install python-multipart
```

----------------------------------------

TITLE: Query Parameter List with Default Values
DESCRIPTION: This snippet shows how to define a query parameter that accepts a list of values and also provides a default list if no values are provided in the request.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/query-params-str-validations.md#_snippet_8

LANGUAGE: Python
CODE:
```
from typing import List, Optional

from fastapi import FastAPI, Query

app = FastAPI()


@app.get("/items/")
async def read_items(q: List[str] = Query(["foo", "bar"])):
    return {"q": q}
```

----------------------------------------

TITLE: Declaring Variables with Type Hints in Python
DESCRIPTION: This code demonstrates how to declare a variable with a type hint in Python using standard Python syntax. It shows how to define a function that accepts a string as input and returns a string, leveraging editor support for type checking and autocompletion.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fa/docs/features.md#_snippet_0

LANGUAGE: Python
CODE:
```
from datetime import date

from pydantic import BaseModel

# Declare a variable as a str
# and get editor support inside the function
def main(user_id: str):
    return user_id
```

----------------------------------------

TITLE: FastAPI Application File Structure with Explanations
DESCRIPTION: This snippet provides the same file structure as the previous example, but with inline comments explaining the role of each file and directory within the context of Python packages and modules, clarifying their import paths.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/bigger-applications.md#_snippet_1

LANGUAGE: text
CODE:
```
.
├── app                  # "app" is a Python package
│   ├── __init__.py      # this file makes "app" a "Python package"
│   ├── main.py          # "main" module, e.g. import app.main
│   ├── dependencies.py  # "dependencies" module, e.g. import app.dependencies
│   └── routers          # "routers" is a "Python subpackage"
│   │   ├── __init__.py  # makes "routers" a "Python subpackage"
│   │   ├── items.py     # "items" submodule, e.g. import app.routers.items
│   │   └── users.py     # "users" submodule, e.g. import app.routers.users
│   └── internal         # "internal" is a "Python subpackage"
│       ├── __init__.py  # makes "internal" a "Python subpackage"
│       └── admin.py     # "admin" submodule, e.g. import app.internal.admin
```

----------------------------------------

TITLE: Define a Reusable FastAPI Dependency Function
DESCRIPTION: This Python function, `common_parameters`, serves as a reusable dependency. It accepts optional query parameters `q`, `skip`, and `limit`, and returns them as a dictionary. FastAPI will automatically resolve and inject these parameters when this dependency is used in a path operation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/dependencies/index.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Optional

def common_parameters(q: Optional[str] = None, skip: int = 0, limit: int = 100):
    return {"q": q, "skip": skip, "limit": limit}
```

----------------------------------------

TITLE: FastAPI Endpoint Using Pydantic Model as Output
DESCRIPTION: Illustrates a FastAPI `GET` endpoint (`/items/{item_id}`) that uses the `Item` Pydantic model as its `response_model`. This demonstrates how fields with default values, like `description`, are considered mandatory in the output schema because they will always have a value (even if `null`), leading to a separate OpenAPI output schema.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/how-to/separate-openapi-schemas.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


app = FastAPI()


@app.get("/items/{item_id}", response_model=Item)
async def read_item(item_id: str):
    return {"name": "Foo", "price": 42}
```

----------------------------------------

TITLE: Defining Pydantic BaseSettings for Application Configuration
DESCRIPTION: Illustrates how to define a settings class using Pydantic's `BaseSettings`, allowing for type-hinted configuration variables with default values and automatic environment variable loading.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/advanced/settings.md#_snippet_4

LANGUAGE: python
CODE:
```
from pydantic import BaseSettings

class Settings(BaseSettings):
    app_name: str = "Awesome API"
    admin_email: str
    items_per_user: int = 50
```

----------------------------------------

TITLE: Initializing FastAPI Instance
DESCRIPTION: Creates an instance of the FastAPI class, which serves as the core of the API application. This instance is used to define API endpoints and handle requests.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/vi/docs/tutorial/first-steps.md#_snippet_2

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()
```

----------------------------------------

TITLE: Pydantic Field with Examples
DESCRIPTION: Demonstrates how to declare examples for a Pydantic field using the `Field` function. This allows for providing example data directly within the field definition, which is then included in the generated JSON Schema and used in API documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/schema-extra-example.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel, Field

app = FastAPI()


class Item(BaseModel):
    name: str = Field(examples=["Foo", "Bar"])
    description: Union[str, None] = Field(default=None, examples=["A very good item", "A great item"])
    price: float = Field(examples=[35.4, 99.99])
    tax: Union[float, None] = Field(default=None, examples=[3.2, 4.2])


@app.post("/items/")
async def create_item(item: Item):
    return item
```

----------------------------------------

TITLE: Optional 타입 힌트 예제
DESCRIPTION: `Optional`을 사용하여 변수가 특정 타입이거나 `None`일 수 있음을 나타내는 방법을 보여줍니다. 이를 통해 에디터는 값이 `None`일 수 있는 경우에 대한 오류를 찾을 수 있습니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/python-types.md#_snippet_8

LANGUAGE: python
CODE:
```
from typing import Optional

name: Optional[str] = None
```

----------------------------------------

TITLE: Installing httpx for testing
DESCRIPTION: Shows how to install the httpx library, which is required for using TestClient.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/testing.md#_snippet_0

LANGUAGE: Shell
CODE:
```
$ pip install httpx
```

----------------------------------------

TITLE: FastAPI OpenAPI-Specific Examples Structure
DESCRIPTION: Defines the structure and properties of the `openapi_examples` parameter used in FastAPI for `Path()`, `Query()`, `Header()`, `Cookie()`, `Body()`, `Form()`, and `File()` dependencies. These examples are specifically for OpenAPI and are used by tools like Swagger UI to display multiple rich examples for path operations.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/schema-extra-example.md#_snippet_5

LANGUAGE: APIDOC
CODE:
```
Parameter: openapi_examples
  Type: dict
  Description: A dictionary where keys identify each example and values are dictionaries defining the example.
  Each example dictionary can contain:
    - summary: string (Short description for the example)
    - description: string (A long description that can contain Markdown text)
    - value: any (The actual example data, e.g., a dict)
    - externalValue: string (URL pointing to the example, alternative to 'value')
  Applicable to: Path(), Query(), Header(), Cookie(), Body(), Form(), File()
```

----------------------------------------

TITLE: Python Type Hinting and Pydantic Model Usage
DESCRIPTION: This snippet demonstrates how to define a Pydantic `BaseModel` for structured data validation and serialization, along with a simple Python function utilizing type hints for improved code clarity and editor support. It then shows how to instantiate this Pydantic model using both direct keyword arguments and dictionary unpacking.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/features.md#_snippet_0

LANGUAGE: Python
CODE:
```
from datetime import date

from pydantic import BaseModel

# Declare a variable as a str
# and get editor support inside the function
def main(user_id: str):
    return user_id


# A Pydantic model
class User(BaseModel):
    id: int
    name: str
    joined: date
```

LANGUAGE: Python
CODE:
```
my_user: User = User(id=3, name="John Doe", joined="2018-07-19")

second_user_data = {
    "id": 4,
    "name": "Mary",
    "joined": "2018-11-30"
}

my_second_user: User = User(**second_user_data)
```

----------------------------------------

TITLE: FastAPI Endpoint to Create Hero
DESCRIPTION: Defines a POST endpoint `/heroes/` to create a new `Hero` entry in the database. It accepts a `Hero` object in the request body, adds it to the database session, commits the transaction, and refreshes the object to retrieve any database-generated values (like the `id`) before returning the created hero.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/sql-databases.md#_snippet_6

LANGUAGE: python
CODE:
```
from fastapi import APIRouter
from sqlmodel import Session
from .tutorial001_an_py310 import Hero, SessionDep # Assuming Hero and SessionDep are from the same file

router = APIRouter()

@router.post("/heroes/", response_model=Hero)
def create_hero(hero: Hero, session: SessionDep):
    session.add(hero)
    session.commit()
    session.refresh(hero)
    return hero
```

----------------------------------------

TITLE: Example JSON Request Body for Nested Pydantic Models
DESCRIPTION: This JSON object illustrates a complex request body structure for a FastAPI application, demonstrating how Pydantic models handle nested data. It includes a list of 'images' objects, each with 'url' and 'name' fields, and a 'tags' array, showcasing the ability to parse and validate structured arrays of child models.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/body-nested-models.md#_snippet_0

LANGUAGE: JSON
CODE:
```
{
    "name": "Foo",
    "description": "The pretender",
    "price": 42.0,
    "tax": 3.2,
    "tags": [
        "rock",
        "metal",
        "bar"
    ],
    "images": [
        {
            "url": "http://example.com/baz.jpg",
            "name": "The Foo live"
        },
        {
            "url": "http://example.com/dave.jpg",
            "name": "The Baz"
        }
    ]
}
```

----------------------------------------

TITLE: Custom Plain Text Error Response Example
DESCRIPTION: This snippet shows an example of a simplified, plain text error message that can be returned after overriding FastAPI's default exception handlers for validation errors. It provides a more concise output compared to the default JSON.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/handling-errors.md#_snippet_8

LANGUAGE: text
CODE:
```
1 validation error
path -> item_id
  value is not a valid integer (type=type_error.integer)
```

----------------------------------------

TITLE: Declare Query Parameters with Defaults in FastAPI
DESCRIPTION: Demonstrates how FastAPI automatically interprets function parameters not defined as path parameters as query parameters. This example shows how to define integer query parameters `skip` and `limit` with default values, allowing them to be optional in the URL and providing fallback values if not specified.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/items/")
async def read_items(skip: int = 0, limit: int = 10):
    return {"skip": skip, "limit": limit}
```

----------------------------------------

TITLE: Path, Query, and Request Body Parameters in FastAPI
DESCRIPTION: This code snippet demonstrates how to declare a request body, path parameters, and query parameters within the same path operation in FastAPI. FastAPI automatically recognizes each of them and retrieves the correct data from the appropriate location.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/body.md#_snippet_5

LANGUAGE: Python
CODE:
```
from typing import Optional, Union

from fastapi import FastAPI
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


app = FastAPI()


@app.put("/items/{item_id}")
async def create_item(item_id: int, item: Item, q: Optional[str] = None):
    results = {"item_id": item_id, **item.dict()}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: Request Body and Path Parameters in FastAPI
DESCRIPTION: Shows how to declare both path parameters and a request body in a FastAPI endpoint. FastAPI automatically recognizes that function parameters matching path parameters should be taken from the path, while Pydantic models are taken from the request body.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/body.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


app = FastAPI()


@app.put("/items/{item_id}")
async def create_item(item_id: int, item: Item):
    return {"item_id": item_id, **item.dict()}
```

----------------------------------------

TITLE: Example FastAPI Application File Structure
DESCRIPTION: This snippet illustrates a typical directory layout for a larger FastAPI application, showcasing how files are organized into packages and subpackages to promote modularity.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/bigger-applications.md#_snippet_0

LANGUAGE: text
CODE:
```
.
├── app
│   ├── __init__.py
│   ├── main.py
│   ├── dependencies.py
│   └── routers
│   │   ├── __init__.py
│   │   ├── items.py
│   │   └── users.py
│   └── internal
│       ├── __init__.py
│       └── admin.py
```

----------------------------------------

TITLE: 이름 결합 함수 예제
DESCRIPTION: 이 함수는 `first_name`과 `last_name`을 입력받아 각 단어의 첫 글자를 대문자로 변환한 후 공백으로 연결하여 반환합니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/python-types.md#_snippet_0

LANGUAGE: python
CODE:
```
def get_full_name(first_name, last_name):
    full_name = first_name.title() + " " + last_name.title()
    return full_name

print(get_full_name("john", "doe"))
```

----------------------------------------

TITLE: Example JSON Response from FastAPI GET Endpoint
DESCRIPTION: This JSON object represents a typical response from a FastAPI GET endpoint, specifically '/items/{item_id}?q=somequery'. It demonstrates how path parameters (item_id) and query parameters (q) are reflected in the API's output.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/index.md#_snippet_2

LANGUAGE: json
CODE:
```
{"item_id": 5, "q": "somequery"}
```

----------------------------------------

TITLE: Define Pydantic Data Model for Request Body
DESCRIPTION: Defines a Pydantic `Item` model by inheriting from `BaseModel`. This model specifies the expected structure and data types for incoming JSON request bodies. Fields like `description` and `tax` are marked as optional by assigning `None` as their default value.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body.md#_snippet_1

LANGUAGE: Python
CODE:
```
class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None
```

----------------------------------------

TITLE: Tuple 및 Set 타입 힌트 예제
DESCRIPTION: 이 예제는 `tuple`과 `set`에 대한 타입 힌트를 선언하는 방법을 보여줍니다. `typing` 모듈을 사용하여 각 요소의 타입을 지정할 수 있습니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/python-types.md#_snippet_6

LANGUAGE: python
CODE:
```
from typing import Tuple, Set
```

LANGUAGE: python
CODE:
```
items_t: Tuple[int, int, str]
items_s: Set[bytes]
```

----------------------------------------

TITLE: Налаштування метаданих API у FastAPI
DESCRIPTION: Приклад налаштування метаданих API, таких як title, summary, description, version, terms_of_service, contact, та license_info у додатку FastAPI.  Він показує, як використовувати ці параметри для налаштування специфікації OpenAPI та автоматично згенерованих інтерфейсів документації API.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/metadata.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI(
    title="Fancy API",
    summary="This is a fancy API for managing users and items.",
    description="""
This API is a **very fancy** one.

It does _everything_.

Trust me.
""",
    version="0.1.0",
    terms_of_service="http://example.com/terms/",
    contact={
        "name": "Deadpoolio the Amazing",
        "url": "http://example.com/contact/",
        "email": "dp@example.com",
    },
    license_info={
        "name": "Apache 2.0",
        "url": "https://www.apache.org/licenses/LICENSE-2.0.html",
    },
)


@app.get("/items/{item_id}")
async def read_item(item_id: str):
    return {"item_id": item_id}
```

----------------------------------------

TITLE: Example requirements.txt content
DESCRIPTION: An example of a `requirements.txt` file, specifying Python packages and their exact versions required for a project. This file ensures consistent dependency installation across different environments.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/virtual-environments.md#_snippet_10

LANGUAGE: requirements.txt
CODE:
```
fastapi[standard]==0.113.0
pydantic==2.8.0
```

----------------------------------------

TITLE: Initializing FastAPI Application
DESCRIPTION: This code snippet demonstrates how to import the FastAPI class and create an instance of it. The FastAPI class provides all the functionality for defining an API. The 'app' variable will be the main interaction point for creating APIs.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh-hant/docs/tutorial/first-steps.md#_snippet_1

LANGUAGE: python
CODE:
```
from fastapi import FastAPI

app = FastAPI()
```

----------------------------------------

TITLE: Declaring OpenAPI Examples with openapi_examples in FastAPI
DESCRIPTION: This code snippet demonstrates how to declare OpenAPI-specific examples using the `openapi_examples` parameter in FastAPI for the `Item` model's `Body()`. It includes examples with summaries, descriptions, and values to be displayed in the documentation UI.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/schema-extra-example.md#_snippet_5

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import Body, FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item = Body(
        openapi_examples={
            "normal": {
                "summary": "A normal example",
                "description": "A **normal** item works correctly.",
                "value": {
                    "name": "Foo",
                    "description": "A very nice Item",
                    "price": 35.4,
                    "tax": 3.2,
                },
            },
            "invalid": {
                "summary": "Invalid data",
                "description": "Data that doesn't pass validation.",
                "value": {
                    "name": "Bar",
                    "price": "Twenty",
                    "tax": None,
                },
            },
        },
    ),
):
    results = {"item_id": item_id, "item": item}
    return results
```

----------------------------------------

TITLE: Python Dictionary Unpacking for Class Instantiation
DESCRIPTION: Illustrates how the `**user_dict` syntax in Python unpacks a dictionary's key-value pairs into keyword arguments when instantiating a class or calling a function, providing a concise way to pass multiple arguments from a dictionary.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/security/simple-oauth2.md#_snippet_4

LANGUAGE: Python
CODE:
```
UserInDB(
    username = user_dict["username"],
    email = user_dict["email"],
    full_name = user_dict["full_name"],
    disabled = user_dict["disabled"],
    hashed_password = user_dict["hashed_password"]
)
```

----------------------------------------

TITLE: Declaring Request Body Examples (OpenAPI-Specific)
DESCRIPTION: Demonstrates how to use the `openapi_examples` parameter with FastAPI's `Body()` function to provide multiple named examples. These examples are directly embedded in the OpenAPI specification for the path operation and are typically rendered by documentation UIs like Swagger UI.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/schema-extra-example.md#_snippet_3

LANGUAGE: Python
CODE:
```
from fastapi import Body, FastAPI
from pydantic import BaseModel

app = FastAPI()

class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None

@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item = Body(
        openapi_examples={
            "normal": {
                "summary": "A normal example",
                "description": "A **normal** item working just fine.",
                "value": {
                    "name": "Foo",
                    "description": "A very nice Item",
                    "price": 35.4,
                    "tax": 3.2,
                },
            },
            "bad_tax": {
                "summary": "A bad tax example",
                "description": "When the tax is too high, it's a bad example.",
                "value": {
                    "name": "Bar",
                    "price": 42.0,
                    "tax": 200.0,
                },
            },
        }
    ),
):
    results = {"item_id": item_id, "item": item}
    return results
```

----------------------------------------

TITLE: Example JavaScript Code from ReDoc
DESCRIPTION: This is an example of the JavaScript code that might be served by ReDoc. It shows the beginning of the bundled JavaScript file.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/how-to/custom-docs-ui-assets.md#_snippet_7

LANGUAGE: JavaScript
CODE:
```
/*! For license information please see redoc.standalone.js.LICENSE.txt */
!function(e,t){"object"==typeof exports&&"object"==typeof module?module.exports=t(require("null")):... 
```

----------------------------------------

TITLE: Combining Path, Query, and Body Parameters
DESCRIPTION: Demonstrates how to combine Path, Query, and request body parameters in a FastAPI endpoint. The `item` parameter is taken from the request body and is optional.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body-multiple-params.md#_snippet_0

LANGUAGE: Python
CODE:
```
@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Union[Item, None] = None,
    q: Union[str, None] = None
):
    results = {"item_id": item_id}
    if item:
        results.update({"item": item})
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: FastAPI Path Parameter Ordering Trick with `*` and Annotated
DESCRIPTION: This example demonstrates a Python trick using `*` to force subsequent parameters to be keyword-only, allowing flexible ordering of required parameters without `Annotated`. It also shows how `Annotated` simplifies this, making the `*` trick unnecessary by not relying on function parameter default values.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/path-params-numeric-validations.md#_snippet_3

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI, Path, Query

app = FastAPI()

@app.get("/items/{item_id}")
async def read_items(
    *,
    item_id: Path(title="The ID of the item to get"),
    q: str
):
    results = {"item_id": item_id}
    if q:
        results.update({"q": q})
    return results
```

LANGUAGE: Python
CODE:
```
from typing import Annotated
from fastapi import FastAPI, Path, Query

app = FastAPI()

@app.get("/items/{item_id}")
async def read_items(
    item_id: Annotated[int, Path(title="The ID of the item to get")],
    q: str
):
    results = {"item_id": item_id}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: Importing Routers in FastAPI Main Application
DESCRIPTION: A conceptual example demonstrating how a main application file might import a router module from a subpackage, highlighting the standard Python import mechanism for modular code organization.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/bigger-applications.md#_snippet_2

LANGUAGE: python
CODE:
```
from app.routers import items
```

----------------------------------------

TITLE: Declaring a List of Strings (Python 3.9+)
DESCRIPTION: This snippet demonstrates how to declare a variable as a list of strings using the built-in `list` type hint in Python 3.9 and later. It utilizes the `list[str]` syntax to specify that the variable `items` is a list where each element is a string.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_5

LANGUAGE: Python
CODE:
```
items: list[str] = ["foo", "bar"]
```

----------------------------------------

TITLE: Returning a Dictionary with Item Price
DESCRIPTION: This code snippet demonstrates how to return a dictionary containing the item price. It shows how to access the `price` attribute of an `item` object and include it in the returned dictionary.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/he/docs/index.md#_snippet_8

LANGUAGE: Python
CODE:
```
... "item_name": item.name ...
```

LANGUAGE: Python
CODE:
```
... "item_price": item.price ...
```

----------------------------------------

TITLE: Adding Specialized Tools for Search, Image Processing, and Formatting (Python)
DESCRIPTION: Includes packages for specific functionalities such as Chinese text segmentation (Jieba), image manipulation (Pillow, CairoSVG), and code formatting (Black). These are often used in conjunction with documentation generation or content processing.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/requirements-docs.txt#_snippet_3

LANGUAGE: Python
CODE:
```
# For Material for MkDocs, Chinese search
jieba==0.42.1
# For image processing by Material for MkDocs
pillow==11.1.0
# For image processing by Material for MkDocs
cairosvg==2.7.1
# For griffe, it formats with black
black==25.1.0
```

----------------------------------------

TITLE: Importing FastAPI
DESCRIPTION: This code snippet shows how to import the FastAPI class from the fastapi package. The FastAPI class provides all the functionality needed to create an API.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/id/docs/tutorial/first-steps.md#_snippet_2

LANGUAGE: Python
CODE:
```
FastAPI
```

----------------------------------------

TITLE: Define a Nested Pydantic Submodel (`Image`)
DESCRIPTION: This snippet illustrates the definition of a simple Pydantic submodel named `Image` with `url` and `name` fields. This submodel can then be used as a type for fields in other Pydantic models, enabling the creation of complex, nested data structures.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/body-nested-models.md#_snippet_6

LANGUAGE: Python
CODE:
```
class Image(BaseModel):
    url: str
    name: str
```

----------------------------------------

TITLE: Pydantic Model Copy with Update Parameter
DESCRIPTION: Illustrates how to create a new Pydantic model instance by copying an existing one and applying updates from a dictionary using `.model_copy(update=update_data)` (or `.copy(update=update_data)` for Pydantic v1). This method efficiently merges new data into an existing model.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-updates.md#_snippet_3

LANGUAGE: Python
CODE:
```
stored_item_model.model_copy(update=update_data)
```

----------------------------------------

TITLE: Correct Markdown Admonition Keyword Translation with Pipe
DESCRIPTION: Provides the correct method for translating admonition keywords by using a pipe (`|`) to include the translated term while retaining the original keyword for styling.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/management-tasks.md#_snippet_4

LANGUAGE: Markdown
CODE:
```
/// tip | consejo

Esto es un consejo.

///
```

----------------------------------------

TITLE: Import FastAPI Class
DESCRIPTION: Demonstrates the standard way to import the `FastAPI` class from the `fastapi` library, which is the first step in creating a FastAPI application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/reference/fastapi.md#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
```

----------------------------------------

TITLE: Creating main.py with security features
DESCRIPTION: This code snippet demonstrates how to create a FastAPI application with OAuth2 password flow for user authentication. It includes defining an endpoint to receive username and password, and generating a token upon successful authentication.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/security/first-steps.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import Depends, FastAPI
from fastapi.security import OAuth2PasswordBearer

app = FastAPI()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


@app.get("/items/")
async def read_items(token: str = Depends(oauth2_scheme)):
    return {"token": token}
```

----------------------------------------

TITLE: Declare List with Type Parameter (Python 3.9+)
DESCRIPTION: Illustrates the modern Python 3.9+ syntax for declaring a list with a specific type parameter, such as a list of strings.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-nested-models.md#_snippet_2

LANGUAGE: Python
CODE:
```
my_list: list[str]
```

----------------------------------------

TITLE: Defining a FastAPI dependency class with __init__ parameters
DESCRIPTION: This snippet defines `CommonQueryParams`, a Python class designed to be a FastAPI dependency. FastAPI inspects the `__init__` method's parameters (`q`, `skip`, `limit`) to resolve query parameters, providing type validation and improved editor support over dictionary-based dependencies.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/dependencies/classes-as-dependencies.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Optional

class CommonQueryParams:
    def __init__(self, q: Optional[str] = None, skip: int = 0, limit: int = 100):
        self.q = q
        self.skip = skip
        self.limit = limit
```

----------------------------------------

TITLE: Creating a FastAPI Instance
DESCRIPTION: This code snippet shows how to create an instance of the FastAPI class, which serves as the main entry point for defining API endpoints.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/first-steps.md#_snippet_2

LANGUAGE: Python
CODE:
```
app = FastAPI()
```

----------------------------------------

TITLE: Defining a Required Query Parameter in FastAPI
DESCRIPTION: This code snippet demonstrates how to define a required query parameter named 'needy' of type string in a FastAPI endpoint. If the 'needy' parameter is not provided in the request, FastAPI will return an error.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/tr/docs/tutorial/query-params.md#_snippet_4

LANGUAGE: Python
CODE:
```
@app.get("/items/{item_id}")
async def read_items(item_id: str, needy: str):
    return {"item_id": item_id, "needy": needy}
```

----------------------------------------

TITLE: Pydantic Models for User Data
DESCRIPTION: Defines Pydantic models for user input, database representation, and output, including handling password hashing. The UserIn model takes username, password, and email. The UserInDB model includes a hashed_password field. The User model excludes the password field.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/extra-models.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel


class UserIn(BaseModel):
    username: str
    password: str
    email: str
    full_name: Optional[str] = None


class User(BaseModel):
    username: str
    email: str
    full_name: Optional[str] = None


class UserInDB(BaseModel):
    username: str
    email: str
    full_name: Optional[str] = None
    hashed_password: str
```

----------------------------------------

TITLE: FastAPI Request Flow with Yield and Exception Handling
DESCRIPTION: Illustrates the sequence of operations in a FastAPI request, showing the roles of the client, exception handler, dependency with yield, path operation, and background tasks. It highlights the points at which exceptions can be raised and the implications for response modification, especially after the response has been sent.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/dependencies/dependencies-with-yield.md#_snippet_0

LANGUAGE: mermaid
CODE:
```
sequenceDiagram

participant client as Client
participant handler as Exception handler
participant dep as Dep with yield
participant operation as Path Operation
participant tasks as Background tasks

    Note over client,tasks: Can raise exception for dependency, handled after response is sent
    Note over client,operation: Can raise HTTPException and can change the response
    client ->> dep: Start request
    Note over dep: Run code up to yield
    opt raise
        dep -->> handler: Raise HTTPException
        handler -->> client: HTTP error response
        dep -->> dep: Raise other exception
    end
    dep ->> operation: Run dependency, e.g. DB session
    opt raise
        operation -->> dep: Raise HTTPException
        dep -->> handler: Auto forward exception
        handler -->> client: HTTP error response
        operation -->> dep: Raise other exception
        dep -->> handler: Auto forward exception
    end
    operation ->> client: Return response to client
    Note over client,operation: Response is already sent, can't change it anymore
    opt Tasks
        operation -->> tasks: Send background tasks
    end
    opt Raise other exception
        tasks -->> dep: Raise other exception
    end
    Note over dep: After yield
    opt Handle other exception
        dep -->> dep: Handle exception, can't change response. E.g. close DB session.
    end
```

----------------------------------------

TITLE: FastAPI: List Query Parameters with Default Values
DESCRIPTION: Shows how to provide a default list of values for a query parameter when it's not explicitly provided in the URL. If `q` is omitted, it will default to `['foo', 'bar']`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/query-params-str-validations.md#_snippet_7

LANGUAGE: Python
CODE:
```
from typing import List, Optional

from fastapi import FastAPI, Query

app = FastAPI()


@app.get("/items/")
async def read_items(q: List[str] = Query(default=["foo", "bar"])):
    query_items = {"q": q}
    return query_items
```

----------------------------------------

TITLE: Define a Pydantic Model with a List of Submodels
DESCRIPTION: Shows how to define a Pydantic model field as a list containing instances of another Pydantic sub-model (e.g., `List[Image]`). This allows for complex JSON arrays of structured objects, providing full validation, conversion, and documentation for each item in the list.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body-nested-models.md#_snippet_5

LANGUAGE: Python
CODE:
```
from typing import List, Optional
from pydantic import BaseModel, HttpUrl

class Image(BaseModel):
    url: HttpUrl
    name: str

class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: List[str] = []
    images: List[Image]
```

LANGUAGE: JSON
CODE:
```
{
    "name": "Foo",
    "description": "The pretender",
    "price": 42.0,
    "tax": 3.2,
    "tags": [
        "rock",
        "metal",
        "bar"
    ],
    "images": [
        {
            "url": "http://example.com/baz.jpg",
            "name": "The Foo live"
        },
        {
            "url": "http://example.com/dave.jpg",
            "name": "The Baz"
        }
    ]
}
```

----------------------------------------

TITLE: JSON Schema Examples in Pydantic Models (v1)
DESCRIPTION: Declares examples for a Pydantic model using the `Config` inner class and `schema_extra` to add to the generated JSON schema. This allows including examples in the API documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/schema-extra-example.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None

    class Config:
        schema_extra = {
            "examples": [
                {
                    "name": "Foo",
                    "description": "A very nice Item",
                    "price": 50.2,
                    "tax": 3.2,
                }
            ]
        }
```

----------------------------------------

TITLE: Required Query Parameter using Ellipsis
DESCRIPTION: This snippet defines a required query parameter `q` using the `Query` class and the ellipsis (`...`) as the default value. This indicates that the parameter is mandatory and must be provided in the request.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/query-params-str-validations.md#_snippet_6

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI, Query

app = FastAPI()


@app.get("/items/")
async def read_items(q: str = Query(..., min_length=3)):
    return {"q": q}
```

----------------------------------------

TITLE: Defining a List Field
DESCRIPTION: Demonstrates defining a list field in a Pydantic model without specifying the type of elements within the list. The `tags` attribute will be converted to a list.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body-nested-models.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: list = []
```

----------------------------------------

TITLE: Define a Pydantic Model with a Set Field (Set[str])
DESCRIPTION: Illustrates how to define a Pydantic model field as a `set` of a specific type (e.g., `Set[str]`) using `typing.Set`. This ensures that the field only accepts unique items, automatically handling duplicates upon data conversion and providing accurate documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body-nested-models.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Set
```

LANGUAGE: Python
CODE:
```
from typing import Set
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    tags: Set[str]
```

----------------------------------------

TITLE: Install Uvicorn with standard dependencies
DESCRIPTION: Command to install Uvicorn, the ASGI server, with its standard dependencies. Uvicorn is commonly used to run FastAPI applications in both development and production environments.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/index.md#_snippet_3

LANGUAGE: Shell
CODE:
```
pip install "uvicorn[standard]"
```

----------------------------------------

TITLE: Returning a Dictionary
DESCRIPTION: This snippet demonstrates how to return a dictionary containing item information in FastAPI. It shows how to access item attributes and include them in the response.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pl/docs/index.md#_snippet_9

LANGUAGE: Python
CODE:
```
return {"item_name": item.name, "item_id": item_id}
```

----------------------------------------

TITLE: Declare Integer Type for FastAPI Parameter
DESCRIPTION: Example of declaring a simple integer type for a function parameter in FastAPI, demonstrating how standard Python type hints are used for automatic validation and documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/README.md#_snippet_5

LANGUAGE: Python
CODE:
```
item_id: int
```

----------------------------------------

TITLE: FastAPI Request Body Type Hint for List (Python 3.9+)
DESCRIPTION: This Python snippet illustrates the modern Python 3.9+ syntax for type hinting a FastAPI request body as a list of Pydantic models. This concise syntax achieves the same result as `typing.List` for environments running Python 3.9 and newer.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-nested-models.md#_snippet_12

LANGUAGE: Python
CODE:
```
images: list[Image]
```

----------------------------------------

TITLE: Declare Query Parameters with Pydantic Model in FastAPI
DESCRIPTION: This example demonstrates how to define a Pydantic `BaseModel` to structure and validate query parameters in a FastAPI application. The model is then used with `Annotated` and `Query()` to automatically parse and validate incoming query string data, providing type hints and default values.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-param-models.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Annotated
from fastapi import FastAPI, Query
from pydantic import BaseModel

class ItemQuery(BaseModel):
    limit: int = 10
    offset: int = 0

app = FastAPI()

@app.get("/items/")
async def read_items(query: Annotated[ItemQuery, Query()]):
    return {"limit": query.limit, "offset": query.offset}
```

----------------------------------------

TITLE: FastAPI Dependency Execution Flow (Pre-0.106.0)
DESCRIPTION: Illustrates the sequence of execution for FastAPI dependencies with `yield` and background tasks *before* version 0.106.0. This diagram shows when exceptions were handled, when responses were sent, and the interaction between client, exception handler, dependency, path operation, and background tasks.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_12

LANGUAGE: Mermaid
CODE:
```
sequenceDiagram

participant client as Client
participant handler as Exception handler
participant dep as Dep with yield
participant operation as Path Operation
participant tasks as Background tasks

    Note over client,tasks: Can raise exception for dependency, handled after response is sent
    Note over client,operation: Can raise HTTPException and can change the response
    client ->> dep: Start request
    Note over dep: Run code up to yield
    opt raise
        dep -->> handler: Raise HTTPException
        handler -->> client: HTTP error response
        dep -->> dep: Raise other exception
    end
    dep ->> operation: Run dependency, e.g. DB session
    opt raise
        operation -->> dep: Raise HTTPException
        dep -->> handler: Auto forward exception
        handler -->> client: HTTP error response
        operation -->> dep: Raise other exception
        dep -->> handler: Auto forward exception
    end
    operation ->> client: Return response to client
    Note over client,operation: Response is already sent, can't change it anymore
    opt Tasks
        operation -->> tasks: Send background tasks
    end
    opt Raise other exception
        tasks -->> dep: Raise other exception
    end
    Note over dep: After yield
    opt Handle other exception
        dep -->> dep: Handle exception, can't change response. E.g. close DB session.
    end
```

----------------------------------------

TITLE: Using HttpUrl for Validation
DESCRIPTION: Demonstrates using the `HttpUrl` type from Pydantic for validating that a string is a valid URL. The `url` attribute in the `Image` model is defined as an `HttpUrl`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body-nested-models.md#_snippet_6

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel, HttpUrl


class Image(BaseModel):
    url: HttpUrl
    name: str


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: set[str] = set()
    image: Optional[Image] = None
```

----------------------------------------

TITLE: Initializing FastAPI with API Metadata - Python
DESCRIPTION: Initializes a FastAPI application with metadata such as title, summary, description, version, terms of service, contact information, and license information. The description field supports Markdown formatting.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/metadata.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI(
    title="My Super Project",
    summary="Very nice project with very nice code.",
    description="Very nice project with very nice code.",
    version="0.1.0",
    terms_of_service="http://example.com/terms/",
    contact={
        "name": "Deadpoolio the Amazing",
        "url": "http://example.com/contact/",
        "email": "dp@example.com",
    },
    license_info={
        "name": "Apache 2.0",
        "url": "https://www.apache.org/licenses/LICENSE-2.0.html",
    },
)


@app.get("/items/{item_id}")
async def read_items(item_id: str):
    return {"item_id": item_id}
```

----------------------------------------

TITLE: Singular Values in Body using Body()
DESCRIPTION: Shows how to instruct FastAPI to treat a singular value as part of the request body using the Body parameter. This is useful when you want to include a simple value alongside other body parameters.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body-multiple-params.md#_snippet_2

LANGUAGE: Python
CODE:
```
@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item,
    user: User,
    importance: int = Body(default=None),
    q: Union[str, None] = None
):
    results = {"item_id": item_id, "item": item, "user": user, "importance": importance}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: Returning a Dictionary with Item Name and ID
DESCRIPTION: This snippet shows how to return a dictionary containing the item name and ID. The example is intended to be modified to return the item price instead of the item name.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/index.md#_snippet_5

LANGUAGE: Python
CODE:
```
return {"item_name": item.name, "item_id": item_id}
```

----------------------------------------

TITLE: Import Pydantic's Field for Model Validation
DESCRIPTION: This snippet demonstrates how to import the `Field` function directly from the `pydantic` library. `Field` is essential for defining advanced validation rules and metadata for attributes within Pydantic models, serving a similar purpose to FastAPI's `Query`, `Path`, and `Body` for request parameters.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-fields.md#_snippet_0

LANGUAGE: Python
CODE:
```
from pydantic import Field
```

----------------------------------------

TITLE: Relative Imports in Python Modules
DESCRIPTION: Illustrates different levels of relative imports in Python, showing how `.` and `..` are used to navigate the package structure. This is crucial for importing modules or functions from sibling or parent directories within a larger application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/bigger-applications.md#_snippet_7

LANGUAGE: Python
CODE:
```
from .dependencies import get_token_header
```

LANGUAGE: Python
CODE:
```
from ..dependencies import get_token_header
```

LANGUAGE: Python
CODE:
```
from ...dependencies import get_token_header
```

----------------------------------------

TITLE: Declaring a List of Strings (Python 3.8+)
DESCRIPTION: This snippet demonstrates how to declare a variable as a list of strings using the `List` type hint from the `typing` module in Python 3.8. It imports `List` from `typing` and uses `List[str]` to specify that the variable `items` is a list where each element is a string.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_6

LANGUAGE: Python
CODE:
```
from typing import List

items: List[str] = ["foo", "bar"]
```

----------------------------------------

TITLE: Instantiating Pydantic Model with Data
DESCRIPTION: This code demonstrates how to instantiate a Pydantic model, `User`, with data. It shows two methods: direct instantiation with keyword arguments and instantiation using dictionary unpacking (`**second_user_data`). The latter is useful when data is already in a dictionary format.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fa/docs/features.md#_snippet_2

LANGUAGE: Python
CODE:
```
my_user: User = User(id=3, name="John Doe", joined="2018-07-19")

second_user_data = {
    "id": 4,
    "name": "Mary",
    "joined": "2018-11-30",
}

my_second_user: User = User(**second_user_data)
```

----------------------------------------

TITLE: Enum for Predefined Path Parameter Values
DESCRIPTION: This example demonstrates how to use Python's `Enum` to define a set of valid values for a path parameter.  It imports `Enum` and creates a subclass that inherits from `str` and `Enum`. This allows the API documentation to recognize the values as strings and display them correctly.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/path-params.md#_snippet_4

LANGUAGE: python
CODE:
```
from enum import Enum

from fastapi import FastAPI


class ModelName(str, Enum):
    alexnet = "alexnet"
    resnet = "resnet"
    lenet = "lenet"


app = FastAPI()


@app.get("/models/{model_name}")
async def get_model(model_name: ModelName):
    if model_name is ModelName.alexnet:
        return {"model_name": model_name, "message": "Deep Learning FTW!"}

    if model_name.value == "lenet":
        return {"model_name": model_name, "message": "LeCNN all the images"}

    return {"model_name": model_name, "message": "Have some residuals"}
```

----------------------------------------

TITLE: Example JSON Output with response_model_exclude_unset
DESCRIPTION: Provides a JSON response example when `response_model_exclude_unset=True` is applied. It shows that only fields explicitly provided in the input data (e.g., `name` and `price`) are included, while fields with default values that were not explicitly set are omitted.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/response-model.md#_snippet_11

LANGUAGE: JSON
CODE:
```
{
    "name": "Foo",
    "price": 50.2
}
```

----------------------------------------

TITLE: Optional Type Hinting
DESCRIPTION: Demonstrates how to use `Optional` from the `typing` module to indicate that a variable can be either a string or `None`. This helps editors detect potential errors where a value might be assumed to always be a string.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_13

LANGUAGE: Python
CODE:
```
from typing import Optional

name: Optional[str] = 'Foo'
```

----------------------------------------

TITLE: Enum Definition - FastAPI (Python)
DESCRIPTION: This code snippet shows how to define an Enum in Python using the `Enum` class from the `enum` module. The Enum inherits from both `str` and `Enum` to ensure that the values are strings and that the documentation can correctly display the Enum.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/path-params.md#_snippet_3

LANGUAGE: Python
CODE:
```
from enum import Enum


class ModelName(str, Enum):
    alexnet = "alexnet"
    resnet = "resnet"
    lenet = "lenet"
```

----------------------------------------

TITLE: Create Instance of Parameterized FastAPI Dependency
DESCRIPTION: Demonstrates how to instantiate the `FixedContentQueryChecker` class, passing the desired `fixed_content` value. This instance can then be used directly with FastAPI's `Depends()` function, effectively parameterizing the dependency.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/advanced-dependencies.md#_snippet_1

LANGUAGE: Python
CODE:
```
# Assuming FixedContentQueryChecker class is defined
checker = FixedContentQueryChecker("bar")
```

----------------------------------------

TITLE: FastAPI Endpoint to Read Single Hero by ID
DESCRIPTION: Defines a GET endpoint `/heroes/{hero_id}` to fetch a single hero by their unique ID. It queries the database using `session.get()`. If a hero with the specified ID is not found, it raises an `HTTPException` with a 404 Not Found status.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/sql-databases.md#_snippet_8

LANGUAGE: python
CODE:
```
from fastapi import APIRouter, HTTPException, status
from sqlmodel import Session
from .tutorial001_an_py310 import Hero, SessionDep # Assuming Hero and SessionDep are from the same file

router = APIRouter()

@router.get("/heroes/{hero_id}", response_model=Hero)
def read_hero(hero_id: int, session: SessionDep):
    hero = session.get(Hero, hero_id)
    if not hero:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Hero not found")
    return hero
```

----------------------------------------

TITLE: Making a GET request with Requests
DESCRIPTION: This snippet demonstrates how to make a GET request to a URL using the Requests library in Python. It shows the simplicity and intuitiveness of the library's API.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/alternatives.md#_snippet_0

LANGUAGE: Python
CODE:
```
response = requests.get("http://example.com/some/url")
```

----------------------------------------

TITLE: Type Hinting Example
DESCRIPTION: Demonstrates the use of Python type hints for function parameters. This allows IDEs to provide better autocompletion and error checking.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/features.md#_snippet_0

LANGUAGE: Python
CODE:
```
from datetime import date

from pydantic import BaseModel

# Déclare une variable comme étant une str
# et profitez de l'aide de votre IDE dans cette fonction
def main(user_id: str):
    return user_id
```

----------------------------------------

TITLE: Defining an Asynchronous Path Operation Function
DESCRIPTION: Defines an asynchronous path operation function named `root` that returns a dictionary containing a message. This function is decorated with `@app.get("/")`, making it the handler for GET requests to the root path `/`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pl/docs/tutorial/first-steps.md#_snippet_5

LANGUAGE: Python
CODE:
```
async def root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Define Asynchronous GET Path Operation for Root
DESCRIPTION: This example shows how to define an asynchronous GET endpoint for the root path ('/') using the `@app.get()` decorator. The `async def` function handles incoming requests and returns a dictionary, which FastAPI automatically serializes to JSON.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/first-steps.md#_snippet_2

LANGUAGE: Python
CODE:
```
@app.get("/")
async def root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: FastAPI Query Parameter Response Examples
DESCRIPTION: Provides examples of JSON responses from a FastAPI application when handling query parameters. This includes a validation error response for a missing required parameter and a successful response showing parsed query parameter values.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params.md#_snippet_6

LANGUAGE: APIDOC
CODE:
```
Error Response for Missing Required Parameter:
```json
{
  "detail": [
    {
      "type": "missing",
      "loc": [
        "query",
        "needy"
      ],
      "msg": "Field required",
      "input": null,
      "url": "https://errors.pydantic.dev/2.1/v/missing"
    }
  ]
}
```

Successful Response with Required Parameter:
```json
{
    "item_id": "foo-item",
    "needy": "sooooneedy"
}
```
```

----------------------------------------

TITLE: Declare Cookie Parameters with Pydantic Models in FastAPI
DESCRIPTION: This code shows how to declare and validate multiple cookie parameters using a Pydantic `BaseModel` in FastAPI. It allows for defining required and optional cookies with type annotations, providing a structured way to access and validate incoming cookie data. This method improves code organization and data integrity for cookie handling.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_2

LANGUAGE: python
CODE:
```
from typing import Annotated

from fastapi import Cookie, FastAPI
from pydantic import BaseModel

app = FastAPI()


class Cookies(BaseModel):
    session_id: str
    fatebook_tracker: str | None = None
    googall_tracker: str | None = None


@app.get("/items/")
async def read_items(cookies: Annotated[Cookies, Cookie()]):
    return cookies
```

----------------------------------------

TITLE: Define Optional Query Parameter in FastAPI
DESCRIPTION: Illustrates

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/query-params-str-validations.md#_snippet_0



----------------------------------------

TITLE: 구니콘 워커 클래스 import
DESCRIPTION: 구니콘에서 사용할 수 있는 유비콘 워커 클래스를 import하는 방법을 보여줍니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/deployment/server-workers.md#_snippet_3

LANGUAGE: python
CODE:
```
import uvicorn.workers.UvicornWorker
```

----------------------------------------

TITLE: Serve built documentation for local preview
DESCRIPTION: After successfully building the documentation with the `build-all` command, this command serves the generated `./site/` content locally for preview. It's a simple server intended specifically for previewing translated sites, and not recommended for general development purposes.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/contributing.md#_snippet_11

LANGUAGE: console
CODE:
```
// Use the command "serve" after running "build-all"
$ python ./scripts/docs.py serve

Warning: this is a very simple server. For development, use mkdocs serve instead.
This is here only to preview a site with translations already built.
Make sure you run the build-all command first.
Serving at: http://127.0.0.1:8008
```

----------------------------------------

TITLE: Comparing Requests Client and FastAPI Server GET Endpoints
DESCRIPTION: This snippet illustrates the conceptual similarity between making an HTTP GET request using the `requests` library (as a client) and defining an HTTP GET endpoint in FastAPI (as a server). It highlights how FastAPI's decorator syntax for route definition mirrors the client-side request function, showcasing its intuitive design for API development.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/alternatives.md#_snippet_0

LANGUAGE: Python
CODE:
```
response = requests.get("http://example.com/some/url")
```

LANGUAGE: Python
CODE:
```
@app.get("/some/url")
def read_url():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Multiple Body and Query Parameters in FastAPI
DESCRIPTION: This example demonstrates how to combine multiple body parameters with query parameters in a FastAPI path operation. It shows how to define a query parameter without explicitly using `Query`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/body-multiple-params.md#_snippet_3

LANGUAGE: Python
CODE:
```
@app.post("/items/")
async def create_item(
    item: Item,
    user: User,
    importance: int = Body(gt=0),
    q: str | None = None
):
    results = {"item": item, "user": user, "importance": importance}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: Declare Required Query Parameters in FastAPI
DESCRIPTION: Explains how to define a required query parameter in FastAPI by simply omitting a default value. If the required parameter `needy` is not provided in the URL, FastAPI will automatically return a validation error, ensuring that critical data is always present in requests.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params.md#_snippet_4

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/items/{item_id}")
async def read_user_item(item_id: str, needy: str):
    return {"item_id": item_id, "needy": needy}
```

----------------------------------------

TITLE: Import FastAPI Class
DESCRIPTION: This code imports the FastAPI class from the fastapi module. This class is essential for creating and configuring the API.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/first-steps.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
```

----------------------------------------

TITLE: Defining a GET Path Operation Decorator
DESCRIPTION: Defines a path operation using the `@app.get()` decorator, which tells FastAPI that the function below it is responsible for handling requests to the specified path using the GET method.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/first-steps.md#_snippet_4

LANGUAGE: Python
CODE:
```
@app.get("/")
```

----------------------------------------

TITLE: Install FastAPI with Standard Dependencies
DESCRIPTION: This command installs FastAPI along with a set of standard optional dependencies. These dependencies provide additional features and integrations for FastAPI applications.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/index.md#_snippet_1

LANGUAGE: Shell
CODE:
```
pip install "fastapi[standard]"
```

----------------------------------------

TITLE: Define SQLModel Hero Class
DESCRIPTION: Defines the `Hero` SQLModel class, inheriting from `SQLModel` and marked as a table (`table=True`). It includes fields for `id` (primary key, optional), `name` (indexed string), `secret_name` (indexed string), and `age` (optional, indexed integer). This class serves as both a Pydantic model for data validation and a SQLAlchemy model for database interaction.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/sql-databases.md#_snippet_1

LANGUAGE: python
CODE:
```
from typing import Optional
from sqlmodel import Field, SQLModel

class Hero(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(index=True)
    secret_name: str = Field(index=True)
    age: Optional[int] = Field(default=None, index=True)
```

----------------------------------------

TITLE: Scalar Values in the Body with FastAPI
DESCRIPTION: Illustrates how to include scalar values in the request body using the Body parameter.  This example demonstrates how to explicitly define a scalar value as part of the request body, ensuring FastAPI treats it as such.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/body-multiple-params.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI, Body

from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


class User(BaseModel):
    username: str
    full_name: Union[str, None] = None


app = FastAPI()


@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item,
    user: User,
    importance: int = Body(),
    q: Union[str, None] = None,
):
    results = {"item_id": item_id}
    if q:
        results.update({"q": q})
    results.update({"item": item, "user": user, "importance": importance})
    return results
```

----------------------------------------

TITLE: Add Pydantic Model and PUT Endpoint to FastAPI
DESCRIPTION: This Python code demonstrates how to enhance a FastAPI application by defining a Pydantic `BaseModel` for data validation and adding a `PUT` endpoint. The `PUT /items/{item_id}` endpoint accepts an `Item` object as a request body, ensuring structured data input.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/id/docs/index.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}
```

----------------------------------------

TITLE: Declare Integer Type for FastAPI Parameter
DESCRIPTION: Example of declaring a simple integer type for a function parameter in FastAPI, demonstrating how standard Python type hints are used for automatic validation and documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/index.md#_snippet_5

LANGUAGE: Python
CODE:
```
item_id: int
```

----------------------------------------

TITLE: Defining Pydantic Response Models with Default Values
DESCRIPTION: Demonstrates how to define Pydantic models for FastAPI responses that include fields with default values. These defaults can be `None`, empty lists, or specific literal values, influencing how the data is serialized when not explicitly provided by the source.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/response-model.md#_snippet_9

LANGUAGE: Python
CODE:
```
from typing import List, Optional
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: float = 10.5
    tags: List[str] = []
```

----------------------------------------

TITLE: Declaring a Variable with Type Hints in Python
DESCRIPTION: This code snippet demonstrates how to declare a variable with a type hint in Python using modern Python syntax. It shows how to define a function that accepts a string as input and returns a string, leveraging editor support for type checking and autocompletion.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/features.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import List, Dict
from datetime import date

from pydantic import BaseModel

# Deklarieren Sie eine Variable als ein `str`
# und bekommen Sie Editor-Unterstützung innerhalb der Funktion
def main(user_id: str):
    return user_id


# Ein Pydantic-Modell
class User(BaseModel):
    id: int
    name: str
    joined: date
```

----------------------------------------

TITLE: FastAPI Base Response Class (Response)
DESCRIPTION: Documents the core `Response` class in FastAPI (from Starlette), which all other response types inherit from. It details the essential parameters available for constructing a generic HTTP response, including content, status code, headers, and media type.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/advanced/custom-response.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
Response:
  Description: The base class for all HTTP responses in FastAPI, providing fundamental control over the response.
  Parameters:
    content: str | bytes - The body of the response. Can be a string for text-based content or bytes for binary data.
    status_code: int - The HTTP status code for the response (e.g., 200 for OK, 404 for Not Found).
    headers: dict[str, str] - An optional dictionary of HTTP headers to include in the response.
    media_type: str - The media type (MIME type) of the response, e.g., "text/html", "application/json", "image/png".
  Details:
    FastAPI (Starlette) automatically includes the Content-Length header.
    It also sets the Content-Type header based on the `media_type` and appends encoding for textual types.
```

----------------------------------------

TITLE: Define List of Strings Field in Pydantic Model (Python 3.10+)
DESCRIPTION: This snippet demonstrates how to define a Pydantic model field as a list specifically containing string elements using Python 3.10+ syntax. This enforces that incoming data for `tags` will be validated as a list of strings, providing strong type enforcement.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/body-nested-models.md#_snippet_4

LANGUAGE: Python
CODE:
```
tags: list[str]
```

----------------------------------------

TITLE: FastAPI Path Operation Decorators Reference
DESCRIPTION: Comprehensive documentation for FastAPI's path operation decorators, which link HTTP methods (GET, POST, PUT, DELETE, etc.) to specific URL paths and Python functions. These decorators define how the API responds to different types of requests.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/first-steps.md#_snippet_5

LANGUAGE: APIDOC
CODE:
```
@app.get(path: str, ...)
  - Purpose: Defines an API endpoint that handles HTTP GET requests.
  - Parameters:
    - path (str): The URL path for the endpoint (e.g., "/items/", "/").
    - ... (additional parameters for response models, status codes, etc.)
  - Usage: Typically used for retrieving or reading data from the server.
  - Example: @app.get("/")

@app.post(path: str, ...)
  - Purpose: Defines an API endpoint that handles HTTP POST requests.
  - Parameters:
    - path (str): The URL path for the endpoint.
    - ... (additional parameters)
  - Usage: Typically used for creating new resources or submitting data to the server.

@app.put(path: str, ...)
  - Purpose: Defines an API endpoint that handles HTTP PUT requests.
  - Parameters:
    - path (str): The URL path for the endpoint.
    - ... (additional parameters)
  - Usage: Typically used for updating existing resources completely.

@app.delete(path: str, ...)
  - Purpose: Defines an API endpoint that handles HTTP DELETE requests.
  - Parameters:
    - path (str): The URL path for the endpoint.
    - ... (additional parameters)
  - Usage: Typically used for removing resources from the server.

@app.options(path: str, ...)
@app.head(path: str, ...)
@app.patch(path: str, ...)
@app.trace(path: str, ...)
  - Purpose: Defines API endpoints for less common HTTP methods.
  - Parameters:
    - path (str): The URL path for the endpoint.
    - ... (additional parameters)
  - Usage: Provides flexibility for specific API design patterns or advanced HTTP interactions.
```

----------------------------------------

TITLE: Define Pydantic User Model for FastAPI Security
DESCRIPTION: Defines a Pydantic `BaseModel` to represent the structure of a user, including optional fields like email, full name, and disabled status. This model is crucial for type hinting, data validation, and serialization within FastAPI's dependency injection system.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/security/get-current-user.md#_snippet_1

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel
from typing import Optional

class User(BaseModel):
    username: str
    email: Optional[str] = None
    full_name: Optional[str] = None
    disabled: Optional[bool] = None
```

----------------------------------------

TITLE: Importing FastAPI
DESCRIPTION: This code imports the FastAPI class, which provides the core functionality for building APIs. It is the first step in creating a FastAPI application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/first-steps.md#_snippet_1

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
```

----------------------------------------

TITLE: Instantiate Pydantic Models in Python
DESCRIPTION: Illustrates how to create instances of Pydantic models, both by direct argument passing and by unpacking a dictionary of data, showcasing type annotation for the instantiated objects.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/features.md#_snippet_1

LANGUAGE: Python
CODE:
```
my_user: User = User(id=3, name="John Doe", joined="2018-07-19")

second_user_data = {
    "id": 4,
    "name": "Mary",
    "joined": "2018-11-30"
}

my_second_user: User = User(**second_user_data)
```

----------------------------------------

TITLE: FastAPI: Declaring a Required Query Parameter
DESCRIPTION: Shows how to make a query parameter mandatory by setting its default value to `...` (Ellipsis) when using `Query`. This ensures the `q` parameter must always be provided in the request, otherwise FastAPI returns an error.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/query-params-str-validations.md#_snippet_5

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import FastAPI, Query

app = FastAPI()


@app.get("/items/")
async def read_items(q: str = Query(default=..., min_length=3)):
    results = {"items": [{"item_id": "Foo"}, {"item_id": "Bar"}]}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: Define Pydantic Item Model with Optional Fields
DESCRIPTION: Defines a Pydantic `Item` model with `name` and `price` as required fields, and `description` and `tax` as optional fields with default `None` values. This model is used to demonstrate how Pydantic v2 handles input and output schemas differently based on default values.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/how-to/separate-openapi-schemas.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Union

from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None
```

----------------------------------------

TITLE: FastAPI Dependency Execution Flow Diagram
DESCRIPTION: Illustrates the sequence of execution for FastAPI requests involving clients, exception handlers, dependencies with `yield`, path operations, and background tasks, showing where exceptions can be raised and handled.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/dependencies/dependencies-with-yield.md#_snippet_4

LANGUAGE: mermaid
CODE:
```
sequenceDiagram

participant client as Client
participant handler as Exception handler
participant dep as Dep with yield
participant operation as Path Operation
participant tasks as Background tasks

    Note over client,operation: Can raise exceptions, including HTTPException
    client ->> dep: Start request
    Note over dep: Run code up to yield
    opt raise Exception
        dep -->> handler: Raise Exception
        handler -->> client: HTTP error response
    end
    dep ->> operation: Run dependency, e.g. DB session
    opt raise
        operation -->> dep: Raise Exception (e.g. HTTPException)
        opt handle
            dep -->> dep: Can catch exception, raise a new HTTPException, raise other exception
        end
        handler -->> client: HTTP error response
    end

    operation ->> client: Return response to client
    Note over client,operation: Response is already sent, can't change it anymore
    opt Tasks
        operation -->> tasks: Send background tasks
    end
    opt Raise other exception
        tasks -->> tasks: Handle exceptions in the background task code
    end
```

----------------------------------------

TITLE: Declaring Tuple and Set Type Hints
DESCRIPTION: This example demonstrates how to use type hints for tuples and sets. For tuples, it shows how to specify types for each element, while for sets, it indicates the type of elements contained within the set, covering syntax for Python 3.6+ and 3.9+.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/python-types.md#_snippet_6

LANGUAGE: Python (Python 3.6+)
CODE:
```
{!> ../../docs_src/python_types/tutorial007.py!}
```

LANGUAGE: Python (Python 3.9+)
CODE:
```
{!> ../../docs_src/python_types/tutorial007_py39.py!}
```

----------------------------------------

TITLE: Declaring a Union Type (Python 3.10+)
DESCRIPTION: This snippet demonstrates how to declare a variable that can be either an integer or a string using the union operator `|` in Python 3.10 and later. The type hint `int | str` specifies that the variable `item` can hold either an integer or a string value.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_11

LANGUAGE: Python
CODE:
```
item: int | str = 123
```

----------------------------------------

TITLE: FastAPI Password Hashing and Verification Utilities
DESCRIPTION: Provides a simplified example of password hashing and verification functions (`fake_hash_password` and `fake_verify_password`). These utilities are crucial for securely storing and comparing user passwords without keeping them in plaintext, enhancing the application's security posture.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/security/simple-oauth2.md#_snippet_2

LANGUAGE: Python
CODE:
```
def fake_hash_password(password: str): # pragma: no cover
    return "supersecret" + password

def fake_verify_password(plain_password: str, hashed_password: str): # pragma: no cover
    return fake_hash_password(plain_password) == hashed_password
```

----------------------------------------

TITLE: Instantiating Pydantic Models in Python
DESCRIPTION: This example illustrates two ways to instantiate a Pydantic `User` model. The first method directly passes keyword arguments, while the second uses dictionary unpacking (`**`) to create an instance from a dictionary, showcasing flexible object creation from structured data.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/features.md#_snippet_1

LANGUAGE: python
CODE:
```
my_user: User = User(id=3, name="John Doe", joined="2018-07-19")

second_user_data = {
    "id": 4,
    "name": "Mary",
    "joined": "2018-11-30",
}

my_second_user: User = User(**second_user_data)
```

----------------------------------------

TITLE: Class Definition
DESCRIPTION: Defines a simple `Person` class with a `name` attribute. This class is later used as a type hint.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_17

LANGUAGE: Python
CODE:
```
class Person:
    name: str
```

----------------------------------------

TITLE: Creating a FastAPI Instance
DESCRIPTION: This code snippet shows how to create an instance of the FastAPI class. This instance, typically named 'app', serves as the main entry point for defining all API endpoints and functionality.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/id/docs/tutorial/first-steps.md#_snippet_3

LANGUAGE: Python
CODE:
```
app
```

----------------------------------------

TITLE: Define Request Body with Standard Dataclass
DESCRIPTION: Demonstrates how to use a standard Python `dataclass` to define the structure of a request body in a FastAPI application. FastAPI automatically converts this dataclass using Pydantic for validation and serialization, making it a convenient way to define data models without explicitly using Pydantic's `BaseModel`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/dataclasses.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
from dataclasses import dataclass

app = FastAPI()

@dataclass
class Item:
    name: str
    price: float
    is_offer: bool = False

@app.post("/items/")
async def create_item(item: Item):
    return item
```

----------------------------------------

TITLE: Importing Pydantic Field
DESCRIPTION: This snippet demonstrates the correct way to import the `Field` class, which is essential for defining advanced validation and metadata for attributes within Pydantic models. Note that `Field` is imported from `pydantic`, not `fastapi`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/body-fields.md#_snippet_0

LANGUAGE: Python
CODE:
```
from pydantic import Field
```

----------------------------------------

TITLE: Reading Hero Data from the Database
DESCRIPTION: This snippet demonstrates how to read hero data from the database using the select() function. It includes the use of limit and offset for pagination of results.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/sql-databases.md#_snippet_6

LANGUAGE: Python
CODE:
```
statement = select(Hero).offset(offset).limit(limit)
results = session.exec(statement)
```

----------------------------------------

TITLE: Instantiate Pydantic UserIn Model
DESCRIPTION: Demonstrates how to create an instance of a Pydantic `UserIn` model with sample user data, including username, password, and email, for handling incoming user information.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/extra-models.md#_snippet_0

LANGUAGE: Python
CODE:
```
user_in = UserIn(username="john", password="secret", email="john.doe@example.com")
```

----------------------------------------

TITLE: Defining a Path Operation Decorator
DESCRIPTION: This code snippet demonstrates how to define a path operation decorator using `@app.get("/")`, which associates a function with a specific path and HTTP method (GET in this case).

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/first-steps.md#_snippet_3

LANGUAGE: Python
CODE:
```
@app.get("/")
```

----------------------------------------

TITLE: Example Expected Callback Response Body
DESCRIPTION: A sample JSON payload that the FastAPI application expects as a response from the external callback URL. This body typically indicates the success or failure of the callback operation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/openapi-callbacks.md#_snippet_5

LANGUAGE: JSON
CODE:
```
{
    "ok": true
}
```

----------------------------------------

TITLE: BackgroundTasks with Dependency Injection
DESCRIPTION: This code snippet illustrates how to use BackgroundTasks with FastAPI's dependency injection system.  BackgroundTasks can be declared at different levels (path operation, dependency, sub-dependency), and FastAPI will manage and merge them.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/background-tasks.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import BackgroundTasks, Depends, FastAPI

app = FastAPI()


def write_log(message: str):
    with open("log.txt", mode="a") as f:
        f.write(message)


def get_query(q: Optional[str] = None):
    return q


@app.post("/send-notification/{email}")
async def send_notification(
    email: str,
    background_tasks: BackgroundTasks,
    q: str = Depends(get_query),
):
    background_tasks.add_task(write_log, f"Sent notification to {email}\n")
    if q:
        background_tasks.add_task(write_log, f"Query parameter q is: {q}\n")
    return {"message": "Notification sent in the background"}
```

----------------------------------------

TITLE: Multiple Body and Query Parameters
DESCRIPTION: Demonstrates how to declare both body and query parameters in a FastAPI route. By default, singular values are interpreted as query parameters.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body-multiple-params.md#_snippet_3

LANGUAGE: Python
CODE:
```
@app.put("/items/{item_id}")
async def update_item(
    item_id: str,
    item: Item,
    user: User,
    importance: int = Body(default=None),
    q: str | None = None
):
    results = {"item_id": item_id, "item": item, "user": user, "importance": importance}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: Import Depends from FastAPI
DESCRIPTION: This code snippet shows how to import the `Depends` function directly from the `fastapi` library. `Depends` is a fundamental component for defining and injecting dependencies into path operations and other functions in FastAPI applications.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/reference/dependencies.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import Depends
```

----------------------------------------

TITLE: FastAPI Query Parameter with Generic List Type
DESCRIPTION: Shows how to define a query parameter using the generic `list` type hint (without specifying element type). While functional, FastAPI will not perform type checking on the list's contents nor document the element type in OpenAPI.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params-str-validations.md#_snippet_9

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI, Query

app = FastAPI()

@app.get("/items/")
async def read_items(q: list = Query(default=[])):
    return {"q": q}
```

----------------------------------------

TITLE: Defining a GET Path Operation Decorator
DESCRIPTION: Defines a path operation using the `@app.get()` decorator, associating a function with the `/` path and the HTTP GET method. This tells FastAPI that the function below should handle requests to the specified path using the GET method.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/vi/docs/tutorial/first-steps.md#_snippet_3

LANGUAGE: Python
CODE:
```
@app.get("/")
async def root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Example PATH Variable on Windows
DESCRIPTION: Illustrates a typical `PATH` environment variable string for Windows systems, showing common directories where executables are located, including Python installation paths. Directories are separated by a semicolon.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/environment-variables.md#_snippet_7

LANGUAGE: plaintext
CODE:
```
C:\Program Files\Python312\Scripts;C:\Program Files\Python312;C:\Windows\System32
```

----------------------------------------

TITLE: Defining a Route with GET Operation
DESCRIPTION: This code defines a route for the root path ('/') using the GET operation. The @app.get('/') decorator tells FastAPI that the function below should handle requests to this route using the GET method.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/first-steps.md#_snippet_3

LANGUAGE: python
CODE:
```
@app.get("/")
async def read_root():
    return {"Hello": "World"}
```

----------------------------------------

TITLE: Створення метаданих для тегів у FastAPI
DESCRIPTION: Приклад створення метаданих для тегів `users` та `items` і передачі їх у параметр `openapi_tags` у FastAPI. Він показує, як додати описи, включаючи Markdown, для тегів, які використовуються для групування операцій шляхів.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/metadata.md#_snippet_2

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI(
    openapi_tags=[
        {
            "name": "users",
            "description": "Operations with users. The **login** logic is also here.",
        },
        {
            "name": "items",
            "description": "Manage items. So _fancy_ they have their own docs.",
            "externalDocs": {
                "description": "Items external docs description",
                "url": "https://example.com/items-docs",
            },
        },
    ]
)


@app.get("/users", tags=["users"])
async def read_users():
    return [{"username": "johndoe"}]


@app.get("/items", tags=["items"])
async def read_items():
    return [{"name": "Foo", "price": 50.2}]
```

----------------------------------------

TITLE: FastAPI Generated OpenAPI Specification
DESCRIPTION: Illustrates a partial view of the OpenAPI (formerly Swagger) specification automatically generated by FastAPI. This JSON document describes the API's endpoints, data models, and operations, enabling automated documentation and client generation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/first-steps.md#_snippet_2

LANGUAGE: JSON
CODE:
```
{
    "openapi": "3.0.2",
    "info": {
        "title": "FastAPI",
        "version": "0.1.0"
    },
    "paths": {
        "/items/": {
            "get": {
                "responses": {
                    "200": {
                        "description": "Successful Response",
                        "content": {
                            "application/json": {



...
```

----------------------------------------

TITLE: Demonstrate Python Script Execution with Environment Variables
DESCRIPTION: Shows the interactive execution of a Python script (`main.py`) to illustrate how it behaves when an environment variable is not set (using the default value) and when it is set using `export`. It highlights the dynamic nature of reading environment variables from the shell.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/advanced/settings.md#_snippet_3

LANGUAGE: console
CODE:
```
python main.py

Hello World from Python

export MY_NAME="Wade Wilson"
python main.py

Hello Wade Wilson from Python
```

----------------------------------------

TITLE: Ordering Parameters with Syntax Trick
DESCRIPTION: This code snippet demonstrates a Python syntax trick to order parameters when a query parameter doesn't have a default value or `Query` annotation, while a path parameter uses `Path`. The `*` argument forces subsequent parameters to be keyword arguments.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/path-params-numeric-validations.md#_snippet_3

LANGUAGE: python
CODE:
```
from fastapi import FastAPI, Path

app = FastAPI()


@app.get("/items/{item_id}")
async def read_items(*, item_id: int = Path(), q: str):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: FastAPI 엔드포인트 정의 및 Pydantic 모델 사용
DESCRIPTION: FastAPI를 사용하여 API 엔드포인트를 정의하고 Pydantic을 사용하여 요청 본문을 정의하는 방법을 보여줍니다. `Item` 모델은 `name`, `price`, `is_offer` 속성을 포함합니다. 엔드포인트는 `/`, `/items/{item_id}` (GET), `/items/{item_id}` (PUT) 입니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/index.md#_snippet_5

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}
```

----------------------------------------

TITLE: Define a Nested Pydantic Submodel
DESCRIPTION: Defines a simple Pydantic model `Image` that can be used as a nested component within other models. This allows for structured data within a larger payload.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-nested-models.md#_snippet_4

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel

class Image(BaseModel):
    url: str
    name: str
```

----------------------------------------

TITLE: Read Multiple Heroes with Pagination
DESCRIPTION: Implements a FastAPI GET endpoint to retrieve a list of `Hero` objects from the database. It supports optional `offset` and `limit` query parameters, enabling pagination for efficient data retrieval.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/sql-databases.md#_snippet_7

LANGUAGE: Python
CODE:
```
from typing import List, Optional
from fastapi import APIRouter, Depends
from sqlmodel import Session, select
from typing import Annotated

# Assume Hero model and SessionDep are defined elsewhere
# class Hero(SQLModel, table=True):
#     id: Optional[int] = Field(default=None, primary_key=True)
#     name: str
#     secret_name: str
#     age: Optional[int] = None
# SessionDep = Annotated[Session, Depends(get_session)]

router = APIRouter()

@router.get("/heroes/", response_model=List[Hero])
def read_heroes(
    *, 
    session: SessionDep, 
    offset: int = 0, 
    limit: Optional[int] = None
):
    heroes = session.exec(select(Hero).offset(offset).limit(limit)).all()
    return heroes
```

----------------------------------------

TITLE: Defining a GET Path Operation Decorator
DESCRIPTION: Defines a path operation using the `@app.get("/")` decorator, which tells FastAPI that the function below is responsible for handling requests to the root path `/` using the GET method. This decorator links the function to a specific URL endpoint and HTTP method.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pl/docs/tutorial/first-steps.md#_snippet_4

LANGUAGE: Python
CODE:
```
@app.get("/")
async def root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Pydantic Settings Class for Dependency Injection
DESCRIPTION: Defines the `Settings` class using Pydantic's `BaseSettings` without instantiating it, preparing it for use with FastAPI's dependency injection system.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/advanced/settings.md#_snippet_9

LANGUAGE: python
CODE:
```
from pydantic import BaseSettings

class Settings(BaseSettings):
    app_name: str = "Awesome API"
    admin_email: str
    items_per_user: int = 50
```

----------------------------------------

TITLE: Define and Use Nested Pydantic Models
DESCRIPTION: Explains how to define a Pydantic model as a sub-model and then use it as a field type within another Pydantic model. This enables the creation of deeply nested JSON structures with full data validation, automatic conversion, and comprehensive documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body-nested-models.md#_snippet_3

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel

class Image(BaseModel):
    url: str
    name: str
```

LANGUAGE: Python
CODE:
```
from typing import List, Optional
from pydantic import BaseModel

class Image(BaseModel):
    url: str
    name: str

class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: List[str] = []
    image: Image
```

LANGUAGE: JSON
CODE:
```
{
    "name": "Foo",
    "description": "The pretender",
    "price": 42.0,
    "tax": 3.2,
    "tags": ["rock", "metal", "bar"],
    "image": {
        "url": "http://example.com/baz.jpg",
        "name": "The Foo live"
    }
}
```

----------------------------------------

TITLE: FastAPI PUT Endpoint for Full Item Replacement
DESCRIPTION: Demonstrates a FastAPI endpoint using the HTTP PUT method to fully replace an existing item. It utilizes `jsonable_encoder` to convert the Pydantic model instance into a JSON-compatible dictionary for storage, ensuring data types like `datetime` are handled correctly.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-updates.md#_snippet_0

LANGUAGE: Python
CODE:
```
@app.put("/items/{item_id}")
async def update_item(item_id: str, item: Item):
    update_item_encoded = jsonable_encoder(item)
    items[item_id] = update_item_encoded
    return update_item_encoded
```

----------------------------------------

TITLE: Returning Enum Members
DESCRIPTION: This example demonstrates how to return Enum members from a path operation. FastAPI automatically converts the Enum members to their corresponding values (strings in this case) in the response.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/path-params.md#_snippet_8

LANGUAGE: python
CODE:
```
@app.get("/models/{model_name}")
async def get_model(model_name: ModelName):
    if model_name == ModelName.alexnet:
        return {"model_name": model_name, "message": "Deep Learning FTW!"}

    return {"model_name": model_name, "message": f"Have some residuals? {model_name.value}"}


@app.get("/models/{model_name}/data")
async def get_model_data(model_name: ModelName):
    if model_name.value == "lenet":
        return {"model_name": model_name, "data": 42}
    return {"model_name": model_name, "data": 19}
```

----------------------------------------

TITLE: Declaring OpenAPI Examples with openapi_examples in FastAPI
DESCRIPTION: This code snippet demonstrates how to declare OpenAPI examples using the `openapi_examples` parameter within FastAPI. It showcases the structure of the example dictionary, including keys like `summary`, `description`, and `value`, to provide comprehensive examples for API documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/schema-extra-example.md#_snippet_4

LANGUAGE: python
CODE:
```
from typing import Optional

from fastapi import Body, FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None


@app.post("/items/")
async def create_item(
    item: Item = Body(
        openapi_examples={
            "normal": {
                "summary": "A normal example",
                "description": "A **normal** item works correctly.",
                "value": {
                    "name": "Foo",
                    "description": "A very nice Item",
                    "price": 35.4,
                    "tax": 3.2,
                },
            },
            "invalid": {
                "summary": "Invalid example",
                "description": "An item that doesn't pass validation.",
                "value": {
                    "name": "Bar",
                    "price": "thirty five point four",
                },
            },
        },
    ),
):
    return item
```

----------------------------------------

TITLE: FastAPI User Authentication and Error Handling
DESCRIPTION: Illustrates the initial steps of user authentication in FastAPI, specifically retrieving user data from a mock database based on the provided username. It demonstrates how to raise an `HTTPException` with a 400 status code if the username is not found, ensuring proper error responses for incorrect credentials.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/security/simple-oauth2.md#_snippet_1

LANGUAGE: Python
CODE:
```
    user = fake_users_db.get(form_data.username)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Incorrect username or password",
        )
```

----------------------------------------

TITLE: Install FastAPI with standard extras using uv
DESCRIPTION: This command installs the FastAPI framework with the 'standard' extras using uv.  The 'standard' extras include commonly used dependencies that enhance FastAPI's functionality.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/vi/docs/virtual-environments.md#_snippet_11

LANGUAGE: bash
CODE:
```
uv pip install "fastapi[standard]"
```

----------------------------------------

TITLE: Error Response for Missing Required Query Parameter
DESCRIPTION: This JSON snippet shows the error response returned by FastAPI when a required query parameter (in this case, 'needy') is missing from the request. The response indicates that the 'needy' field is required.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/query-params.md#_snippet_5

LANGUAGE: JSON
CODE:
```
{
    "detail": [
        {
            "loc": [
                "query",
                "needy"
            ],
            "msg": "field required",
            "type": "value_error.missing"
        }
    ]
}
```

----------------------------------------

TITLE: Reading a Single Hero's Data
DESCRIPTION: This snippet shows how to read the data for a single hero from the database, querying by the hero's ID.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/sql-databases.md#_snippet_7

LANGUAGE: Python
CODE:
```
hero = session.get(Hero, hero_id)
```

----------------------------------------

TITLE: FastAPI: Setting a Default Query Parameter Value
DESCRIPTION: Illustrates how to provide a default value for a query parameter using `Query`. If `q` is not provided in the URL, it will default to 'fixedquery' and still adhere to `min_length` validation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/query-params-str-validations.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import FastAPI, Query

app = FastAPI()


@app.get("/items/")
async def read_items(q: str = Query(default="fixedquery", min_length=3)):
    results = {"items": [{"item_id": "Foo"}, {"item_id": "Bar"}]}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: Testing FastAPI with relative imports
DESCRIPTION: Shows how to import the FastAPI app from main.py using relative imports in test_main.py.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/testing.md#_snippet_3

LANGUAGE: Python
CODE:
```
from fastapi.testclient import TestClient

from .main import app


client = TestClient(app)


def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"Hello": "World"}
```

----------------------------------------

TITLE: `lru_cache` Execution Flow Sequence Diagram
DESCRIPTION: This Mermaid sequence diagram visually illustrates the execution flow of a function decorated with `@lru_cache`. It clearly distinguishes between initial calls that execute the function's code and subsequent calls with identical arguments that retrieve results directly from the cache, highlighting the caching mechanism.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/settings.md#_snippet_16

LANGUAGE: Mermaid
CODE:
```
sequenceDiagram

participant code as Code
participant function as say_hi()
participant execute as Execute function

    rect rgba(0, 255, 0, .1)
        code ->> function: say_hi(name="Camila")
        function ->> execute: execute function code
        execute ->> code: return the result
    end

    rect rgba(0, 255, 255, .1)
        code ->> function: say_hi(name="Camila")
        function ->> code: return stored result
    end

    rect rgba(0, 255, 0, .1)
        code ->> function: say_hi(name="Rick")
        function ->> execute: execute function code
        execute ->> code: return the result
    end

    rect rgba(0, 255, 0, .1)
        code ->> function: say_hi(name="Rick", salutation="Mr.")
        function ->> execute: execute function code
        execute ->> code: return the result
    end

    rect rgba(0, 255, 255, .1)
        code ->> function: say_hi(name="Rick")
        function ->> code: return stored result
    end

    rect rgba(0, 255, 255, .1)
        code ->> function: say_hi(name="Camila")
        function ->> code: return stored result
    end
```

----------------------------------------

TITLE: Query Parameters with Defaults in FastAPI
DESCRIPTION: This code snippet demonstrates how to define query parameters with default values in a FastAPI endpoint. The skip and limit parameters are defined as integers with default values of 0 and 10 respectively. These parameters are automatically converted to integers and can be accessed within the function.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/query-params.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/items/")
async def read_items(skip: int = 0, limit: int = 10):
    return {"skip": skip, "limit": limit}
```

----------------------------------------

TITLE: Define optional query parameter with pipe operator type hint (Python 3.10+)
DESCRIPTION: Illustrates the modern Python 3.10+ syntax using the pipe operator (`|`) to define an optional query parameter, allowing it to be either a string or `None`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-multiple-params.md#_snippet_7

LANGUAGE: Python
CODE:
```
q: str | None = None
```

----------------------------------------

TITLE: Update FastAPI app with PUT request body
DESCRIPTION: This code defines a Pydantic model `Item` to represent the request body for a PUT request. It also defines a `PUT` endpoint `/items/{item_id}` that receives an `item_id` and an `Item` object, returning a JSON response.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pl/docs/index.md#_snippet_6

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}
```

----------------------------------------

TITLE: Default PATH Environment Variable Examples
DESCRIPTION: Illustrates typical values for the PATH environment variable on Linux/macOS and Windows operating systems, showing how directories are separated by colons (Linux/macOS) or semicolons (Windows). These paths indicate the default locations where the system searches for executable programs.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/environment-variables.md#_snippet_4

LANGUAGE: plaintext
CODE:
```
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

LANGUAGE: plaintext
CODE:
```
C:\Program Files\Python312\Scripts;C:\Program Files\Python312;C:\Windows\System32
```

----------------------------------------

TITLE: Install FastAPI with all optional dependencies
DESCRIPTION: Command to install FastAPI along with all its optional dependencies, including Uvicorn, which is used to run the application. This is recommended for a complete development setup.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/index.md#_snippet_1

LANGUAGE: Shell
CODE:
```
$ pip install "fastapi[all]"
```

----------------------------------------

TITLE: Defining a Synchronous Path Operation Function
DESCRIPTION: Defines a synchronous path operation function named `root` that returns a dictionary containing a message. This function serves the same purpose as the asynchronous example but is defined without the `async` keyword.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pl/docs/tutorial/first-steps.md#_snippet_6

LANGUAGE: Python
CODE:
```
def root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Depends 불러오기 - Python
DESCRIPTION: FastAPI에서 Depends를 임포트하여 의존성을 명시적으로 선언할 수 있습니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/dependencies/index.md#_snippet_1

LANGUAGE: python
CODE:
```
from typing import Optional

from fastapi import Depends, FastAPI
```

----------------------------------------

TITLE: OpenAPI Schema Example
DESCRIPTION: This is an example of the OpenAPI schema generated by FastAPI. It includes the OpenAPI version, API information (title and version), and paths with their corresponding operations and responses. This schema can be accessed at /openapi.json.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/id/docs/tutorial/first-steps.md#_snippet_1

LANGUAGE: JSON
CODE:
```
{
    "openapi": "3.1.0",
    "info": {
        "title": "FastAPI",
        "version": "0.1.0"
    },
    "paths": {
        "/items/": {
            "get": {
                "responses": {
                    "200": {
                        "description": "Successful Response",
                        "content": {
                            "application/json": {



...

```

----------------------------------------

TITLE: Pydantic Model Dump with exclude_unset for Partial Updates
DESCRIPTION: Shows how to use Pydantic's `.model_dump(exclude_unset=True)` (or `.dict(exclude_unset=True)` for Pydantic v1) to create a dictionary containing only the fields that were explicitly set in the input model, excluding default values. This is crucial for preparing data for partial updates.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-updates.md#_snippet_2

LANGUAGE: Python
CODE:
```
item.model_dump(exclude_unset=True)
```

----------------------------------------

TITLE: Creating a FastAPI Instance
DESCRIPTION: This code snippet shows how to create an instance of the FastAPI class. The app variable will be the main entry point for creating and interacting with the API.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/first-steps.md#_snippet_3

LANGUAGE: Python
CODE:
```
app = FastAPI()
```

----------------------------------------

TITLE: FastAPI: Adding Minimum Length Validation
DESCRIPTION: Extends query parameter validation by adding a `min_length` constraint using `Query`. The `q` parameter must now be between 3 and 50 characters long if provided in the request.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/query-params-str-validations.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import FastAPI, Query

app = FastAPI()


@app.get("/items/")
async def read_items(
    q: Optional[str] = Query(default=None, min_length=3, max_length=50)
):
    results = {"items": [{"item_id": "Foo"}, {"item_id": "Bar"}]}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: JSON Schema Examples in Pydantic Models (v2)
DESCRIPTION: Declares examples for a Pydantic model using the `model_config` attribute and `json_schema_extra` to add to the generated JSON schema. This allows including examples in the API documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/schema-extra-example.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel, ConfigDict


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    model_config = ConfigDict(
        json_schema_extra={
            "examples": [
                {
                    "name": "Foo",
                    "description": "A very nice Item",
                    "price": 50.2,
                    "tax": 3.2,
                }
            ]
        }
    )
```

----------------------------------------

TITLE: Define Pydantic Model Attributes with List and Set Types
DESCRIPTION: Demonstrates how to declare Pydantic model attributes as Python lists or sets, including type parameters for elements. This ensures data validation for collections and handles uniqueness for sets.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-nested-models.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Optional
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: list
```

LANGUAGE: Python
CODE:
```
from typing import List, Optional
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: List[str]
```

LANGUAGE: Python
CODE:
```
from typing import Optional
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: list[str]
```

LANGUAGE: Python
CODE:
```
from typing import Optional
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: set[str]
```

----------------------------------------

TITLE: Example of an actual callback implementation
DESCRIPTION: Illustrates a simple Python implementation of an HTTP callback using the `httpx` library. This code sends a POST request to a specified URL with a JSON payload, demonstrating the action your API would take to notify an external service. This is the operational code, distinct from its documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/openapi-callbacks.md#_snippet_0

LANGUAGE: Python
CODE:
```
callback_url = "https://example.com/api/v1/invoices/events/"
httpx.post(callback_url, json={"description": "Invoice paid", "paid": True})
```

----------------------------------------

TITLE: Request Body, Path, and Query Parameters
DESCRIPTION: This code snippet demonstrates how to use request body parameters (Pydantic model), path parameters, and query parameters all in the same FastAPI endpoint. FastAPI automatically infers the source of each parameter based on its type and declaration.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/body.md#_snippet_5

LANGUAGE: python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


app = FastAPI()


@app.put("/items/{item_id}")
async def create_item(item_id: int, item: Item, q: Union[str, None] = None):
    results = {"item_id": item_id, **item.dict()}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: Import FastAPI Class
DESCRIPTION: This code snippet shows how to import the FastAPI class from the fastapi package. This class is essential for creating and configuring your API.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pl/docs/tutorial/first-steps.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
```

----------------------------------------

TITLE: FastAPI Path Operation with Injected Current User
DESCRIPTION: Shows a concise FastAPI path operation that directly receives the Pydantic `User` object by depending on the `get_current_user` function. This demonstrates how FastAPI's dependency injection simplifies access to authenticated user data within endpoints, allowing for cleaner and more type-safe code.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/security/get-current-user.md#_snippet_3

LANGUAGE: Python
CODE:
```
from fastapi import Depends, FastAPI
from fastapi.security import OAuth2PasswordBearer
from pydantic import BaseModel
from typing import Optional

# Assume oauth2_scheme is defined, e.g.:
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# User model definition (can be imported from a models file)
class User(BaseModel):
    username: str
    email: Optional[str] = None
    full_name: Optional[str] = None
    disabled: Optional[bool] = None

# Placeholder for get_current_user (actual implementation in another snippet)
# In a real application, this would be imported from a dependencies file
async def get_current_user(token: str = Depends(oauth2_scheme)):
    # Simplified for this example; actual logic would decode token and return User
    if token == "valid_token":
        return User(username="testuser", email="test@example.com")
    raise HTTPException(status_code=400, detail="Invalid token")

app = FastAPI()

@app.get("/users/me/")
async def read_users_me(current_user: User = Depends(get_current_user)):
    """
    Returns the current authenticated user's information.
    The 'current_user' object is automatically provided by the dependency system.
    """
    return current_user
```

----------------------------------------

TITLE: Defining a GET route in FastAPI
DESCRIPTION: This snippet shows how to define a GET route in FastAPI using the @app.get decorator. It demonstrates the similarity in syntax to the Requests library and highlights FastAPI's simple and intuitive API.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/alternatives.md#_snippet_1

LANGUAGE: Python
CODE:
```
@app.get("/some/url")
def read_url():
     return {"message": "Hello World"}
```

----------------------------------------

TITLE: Example .env File for Application Settings
DESCRIPTION: This snippet provides an example of a `.env` file, which is used to store environment variables. These variables can be loaded by applications (e.g., using Pydantic Settings) to configure different aspects of the application without hardcoding values directly in the code.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/settings.md#_snippet_11

LANGUAGE: Bash
CODE:
```
ADMIN_EMAIL="deadpool@example.com"
APP_NAME="ChimichangApp"
```

----------------------------------------

TITLE: Importing FastAPI
DESCRIPTION: This code snippet shows how to import the FastAPI class from the fastapi package. This is the first step in creating a FastAPI application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/first-steps.md#_snippet_1

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
```

----------------------------------------

TITLE: Define Pydantic Settings Class for FastAPI Configuration
DESCRIPTION: This Python snippet defines a `Settings` class using Pydantic's `BaseSettings`. It declares configuration fields like `admin_email` and `app_name` with default values. This approach focuses on defining the structure of settings without instantiating a global object, making it suitable for dependency injection.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/advanced/settings.md#_snippet_0

LANGUAGE: Python
CODE:
```
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    admin_email: str
    app_name: str = "Awesome API"
```

----------------------------------------

TITLE: Define Optional Query Parameter Type Hint
DESCRIPTION: Illustrates how to define an optional query parameter `q` that can be a string or `None`, with `None` as its default value, using standard Python type hints for different versions.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params-str-validations.md#_snippet_0

LANGUAGE: Python 3.10+
CODE:
```
q: str | None = None
```

LANGUAGE: Python 3.8+
CODE:
```
q: Union[str, None] = None
```

----------------------------------------

TITLE: Importing List from typing
DESCRIPTION: This code snippet shows how to import the `List` type from the `typing` module in Python versions prior to 3.9. This is necessary for declaring lists with specific element types.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/body-nested-models.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import List
```

----------------------------------------

TITLE: Declare Pydantic v2 Model Examples with model_config
DESCRIPTION: Demonstrates how to add example data to a Pydantic v2 model's JSON Schema using the `model_config` attribute and `json_schema_extra` dictionary. This example data will be reflected in the generated OpenAPI documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/schema-extra-example.md#_snippet_0

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None

    model_config = {
        "json_schema_extra": {
            "examples": [
                {
                    "name": "Foo",
                    "description": "A very nice Item",
                    "price": 35.4,
                    "tax": 3.2
                }
            ]
        }
    }
```

----------------------------------------

TITLE: Using Dependencies in WebSocket Endpoints
DESCRIPTION: This snippet illustrates how to use dependencies, including `Depends`, `Security`, `Cookie`, `Header`, `Path`, and `Query`, within WebSocket endpoints in FastAPI. It shows how to inject dependencies into the WebSocket route to handle authentication, authorization, and data validation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/advanced/websockets.md#_snippet_2

LANGUAGE: Python
CODE:
```
@app.websocket("/items/{item_id}")
async def websocket_endpoint(
    *, websocket: WebSocket, item_id: int, q: str | None = None, cookie: str | None = Cookie(None)
):
    await websocket.accept()
    try:
        while True:
            data = await websocket.receive_text()
            await websocket.send_text(
                f"Session cookie or query value was: {cookie}, {q}, and you said: {data}, item_id: {item_id}"
            )
    except WebSocketDisconnect:
        print("Client disconnected")
```

----------------------------------------

TITLE: 구니콘과 유비콘 설치
DESCRIPTION: pip를 사용하여 uvicorn과 gunicorn을 설치합니다. uvicorn[standard]는 좋은 성능을 위한 추가 패키지입니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/deployment/server-workers.md#_snippet_0

LANGUAGE: bash
CODE:
```
pip install "uvicorn[standard]" gunicorn
```

----------------------------------------

TITLE: FastAPI: Applying Regular Expression Validation
DESCRIPTION: Demonstrates how to enforce a specific pattern for a query parameter using the `regex` argument in `Query`. The `q` parameter must exactly match 'fixedquery' if provided, otherwise a validation error occurs.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/query-params-str-validations.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import FastAPI, Query

app = FastAPI()


@app.get("/items/")
async def read_items(
    q: Optional[str] = Query(
        default=None, min_length=3, max_length=50, regex="^fixedquery$"
    )
):
    results = {"items": [{"item_id": "Foo"}, {"item_id": "Bar"}]}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: Define FastAPI path operation with singular value in body
DESCRIPTION: Illustrates how to include a singular value (e.g., `importance`) directly in the request body alongside Pydantic models, by explicitly using `fastapi.Body()` for that parameter. This ensures it's parsed from the body, not as a query parameter.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-multiple-params.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Union
from fastapi import FastAPI, Body
from pydantic import BaseModel

app = FastAPI()

class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None

class User(BaseModel):
    username: str
    full_name: Union[str, None] = None

@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item,
    user: User,
    importance: int = Body(gt=0)
):
    results = {"item_id": item_id, "item": item.dict(), "user": user.dict(), "importance": importance}
    return results
```

----------------------------------------

TITLE: Import `List` for Type Hinting (Python < 3.9)
DESCRIPTION: For Python versions prior to 3.9, the `List` type must be explicitly imported from the standard `typing` module. This is a necessary step to correctly annotate lists with specific element types, ensuring compatibility with older environments.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/body-nested-models.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import List
```

----------------------------------------

TITLE: Create New Hero with FastAPI and SQLModel
DESCRIPTION: Defines a FastAPI POST endpoint to create a new `Hero` entry in the database. It utilizes the `SessionDep` dependency to manage the database session, adds the new hero, commits the transaction, refreshes the object to get its database-generated ID, and returns the created hero.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/sql-databases.md#_snippet_6

LANGUAGE: Python
CODE:
```
from fastapi import APIRouter, Depends
from sqlmodel import Session
from typing import Annotated

# Assume Hero model and SessionDep are defined elsewhere
# class Hero(SQLModel, table=True):
#     id: Optional[int] = Field(default=None, primary_key=True)
#     name: str
#     secret_name: str
#     age: Optional[int] = None
# SessionDep = Annotated[Session, Depends(get_session)]

router = APIRouter()

@router.post("/heroes/", response_model=Hero)
def create_hero(*, session: SessionDep, hero: Hero):
    session.add(hero)
    session.commit()
    session.refresh(hero)
    return hero
```

----------------------------------------

TITLE: OAuth2 Token Endpoint API Documentation
DESCRIPTION: Defines the API endpoint for obtaining an access token using the OAuth2 password flow. It expects `username` and `password` in the request body and returns an `access_token` and `token_type`. This endpoint is crucial for user authentication.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/security/simple-oauth2.md#_snippet_2

LANGUAGE: APIDOC
CODE:
```
Method: POST
Endpoint: /token

Request Body (Form Data):
  username (string, required): The user's username.
  password (string, required): The user's password.
  scope (string, optional): Space-separated string of requested permissions (e.g., "users:read users:write").
  grant_type (string, optional, default: "password"): OAuth2 grant type. `OAuth2PasswordRequestForm` does not enforce this, but `OAuth2PasswordRequestFormStrict` does.
  client_id (string, optional): Client identifier.
  client_secret (string, optional): Client secret.

Responses:
  200 OK:
    access_token (string): The generated access token.
    token_type (string): The type of token, typically "bearer".
  401 Unauthorized:
    detail (string): "Incorrect username or password" or "Invalid authentication credentials".
    WWW-Authenticate (header): "Bearer"

Dependencies: OAuth2PasswordRequestForm (FastAPI dependency for parsing form data).
Notes: Password hashing should be used for security. The `access_token` in this example is simplified (just the username).
```

----------------------------------------

TITLE: List with Type Parameters as Field
DESCRIPTION: Demonstrates how to declare a list with a specific type parameter (e.g., a list of strings) in a Pydantic model.  This allows for more specific type validation of the list elements.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/body-nested-models.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import List, Optional

from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: List[str] = []
```

----------------------------------------

TITLE: Using Depends in WebSocket endpoint
DESCRIPTION: Demonstrates how to use Depends, Security, Cookie, Header, Path and Query in a WebSocket endpoint. It shows how to inject dependencies into a WebSocket endpoint using FastAPI's dependency injection system.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/advanced/websockets.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import Cookie, Depends, FastAPI, Header, WebSocket, WebSocketException

app = FastAPI()


async def get_cookie_or_token(
    websocket: WebSocket, cookie: Optional[str] = Cookie(None), token: Optional[str] = None
):
    if cookie is None and token is None:
        raise WebSocketException(code=1008, reason="No cookies or token received")
    if cookie:
        return cookie
    return token


@app.websocket("/ws/{client_id}")
async def websocket_endpoint(
    websocket: WebSocket,
    client_id: int,
    q: Optional[str] = None,
    cookie_or_token: str = Depends(get_cookie_or_token),
    last_connection: Optional[str] = Header(None),
):
    await websocket.accept()
    while True:
        try:
            data = await websocket.receive_text()
            await websocket.send_text(
                f"Session cookie or query token value is: {cookie_or_token}"
            )
            await websocket.send_text(
                f"Message text was: {data}, client_id={client_id}, q={q}"
            )
        except WebSocketException:
            break
```

----------------------------------------

TITLE: Defining a Sub-Model
DESCRIPTION: Defines a Pydantic sub-model named `Image` with `url` and `name` attributes. This model can be used as a type for other model attributes, enabling nested data structures.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body-nested-models.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel


class Image(BaseModel):
    url: str
    name: str
```

----------------------------------------

TITLE: PATH Environment Variable Examples
DESCRIPTION: Provides examples of the `PATH` environment variable's structure on Linux/macOS and Windows. It explains how the OS uses this variable, which contains a list of directories, to locate executable programs when a command is entered in the terminal.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/environment-variables.md#_snippet_4

LANGUAGE: plaintext
CODE:
```
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

LANGUAGE: plaintext
CODE:
```
C:\Program Files\Python312\Scripts;C:\Program Files\Python312;C:\Windows\System32
```

----------------------------------------

TITLE: Returning Content from Path Operation
DESCRIPTION: This code snippet demonstrates how to return content from a path operation function. You can return a dict, list, or single values like str or int. FastAPI automatically converts these to JSON.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/first-steps.md#_snippet_6

LANGUAGE: python
CODE:
```
return {"message": "Hello World"}
```

----------------------------------------

TITLE: Declare List with Type Parameter (Python < 3.9)
DESCRIPTION: Shows the syntax for declaring a list with a specific type parameter in Python versions before 3.9, requiring the `List` type from the `typing` module.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-nested-models.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import List

my_list: List[str]
```

----------------------------------------

TITLE: Declare FastAPI Dependency with Simplified Type Hint
DESCRIPTION: Shows alternative ways to declare a FastAPI dependency where the explicit type hint for the parameter is omitted or generalized (e.g., `Any`). While functional, this approach reduces editor assistance for type checking and completion, as the type is inferred solely from the `Depends` function.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/dependencies/classes-as-dependencies.md#_snippet_2

LANGUAGE: Python
CODE:
```
commons: Annotated[Any, Depends(CommonQueryParams)]
```

LANGUAGE: Python
CODE:
```
commons = Depends(CommonQueryParams)
```

----------------------------------------

TITLE: Importing FastAPI
DESCRIPTION: This code snippet shows how to import the FastAPI class from the fastapi package. This is the first step in creating a FastAPI application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/vi/docs/tutorial/first-steps.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
```

----------------------------------------

TITLE: Example FastAPI Application File Structure
DESCRIPTION: Illustrates a typical directory and file organization for a larger FastAPI application, highlighting Python package structure with `__init__.py` files and submodules. This setup allows for better organization and import management.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/bigger-applications.md#_snippet_0

LANGUAGE: text
CODE:
```
.\n├── app                  # "app" is a Python package\n│   ├── __init__.py      # this file makes "app" a "Python package"\n│   ├── main.py          # "main" module, e.g. import app.main\n│   ├── dependencies.py  # "dependencies" module, e.g. import app.dependencies\n│   └── routers          # "routers" is a "Python subpackage"\n│   │   ├── __init__.py  # makes "routers" a "Python subpackage"\n│   │   ├── items.py     # "items" submodule, e.g. import app.routers.items\n│   │   └── users.py     # "users" submodule, e.g. import app.routers.users\n│   └── internal         # "internal" is a "Python subpackage"\n│       ├── __init__.py  # makes "internal" a "Python subpackage"\n│       └── admin.py     # "admin" submodule, e.g. import app.internal.admin
```

----------------------------------------

TITLE: Install PassLib with Bcrypt for Password Hashing
DESCRIPTION: Command to install the `passlib` library along with its `bcrypt` dependency using pip. `passlib` is a comprehensive password hashing framework for Python, and Bcrypt is the recommended secure hashing algorithm for storing user passwords.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/security/oauth2-jwt.md#_snippet_2

LANGUAGE: console
CODE:
```
pip install "passlib[bcrypt]"
```

----------------------------------------

TITLE: Declaring Pydantic Model Examples
DESCRIPTION: Demonstrates how to embed example data directly within Pydantic models for JSON Schema generation. Includes examples for both Pydantic v1 (using `Config.schema_extra`) and Pydantic v2 (using `model_config['json_schema_extra']`). These examples are added to the model's JSON Schema.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/schema-extra-example.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Literal
from pydantic import BaseModel, Field

class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None
    tags: list[str] = []
    status: Literal["active", "inactive"] = "active"

    model_config = {
        "json_schema_extra": {
            "examples": [
                {
                    "name": "Foo",
                    "description": "A very nice Item",
                    "price": 35.4,
                    "tax": 3.2,
                }
            ]
        }
    }
```

LANGUAGE: Python
CODE:
```
from typing import Literal
from pydantic import BaseModel, Field

class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None
    tags: list[str] = []
    status: Literal["active", "inactive"] = "active"

    class Config:
        schema_extra = {
            "examples": [
                {
                    "name": "Foo",
                    "description": "A very nice Item",
                    "price": 35.4,
                    "tax": 3.2,
                }
            ]
        }
```

----------------------------------------

TITLE: Declare Pydantic v1 Model Examples with Config Class
DESCRIPTION: Shows how to include example data in a Pydantic v1 model's JSON Schema by defining an internal `Config` class and setting its `schema_extra` attribute. This example data will be used in the API documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/schema-extra-example.md#_snippet_1

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None

    class Config:
        schema_extra = {
            "examples": [
                {
                    "name": "Foo",
                    "description": "A very nice Item",
                    "price": 35.4,
                    "tax": 3.2
                }
            ]
        }
```

----------------------------------------

TITLE: Defining Custom Dependencies in FastAPI
DESCRIPTION: This snippet illustrates how to define a reusable dependency function in a separate file (e.g., `app/dependencies.py`). This specific dependency checks for an `X-Token` header and raises an `HTTPException` if the token is invalid, providing a modular way to enforce authentication or other requirements.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/bigger-applications.md#_snippet_5

LANGUAGE: python
CODE:
```
from fastapi import Header, HTTPException

async def get_token_header(x_token: str = Header()):
    if x_token != "fake-super-secret-token":
        raise HTTPException(status_code=400, detail="X-Token header invalid")
```

----------------------------------------

TITLE: Install PassLib with Bcrypt for Password Hashing
DESCRIPTION: Command to install the `passlib` library along with its `bcrypt` extension, providing robust password hashing capabilities for Python applications. `passlib` supports various secure hashing algorithms, with Bcrypt being the recommended choice for strong password security.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/security/oauth2-jwt.md#_snippet_2

LANGUAGE: console
CODE:
```
$ pip install "passlib[bcrypt]"
```

----------------------------------------

TITLE: Define FastAPI GET Path Operation Function
DESCRIPTION: This snippet demonstrates how to define a path operation function for a GET request to the root path ('/'). It shows both asynchronous (`async def`) and synchronous (`def`) function definitions, which FastAPI calls when a request matches the path and operation. The choice between async and sync depends on whether the function performs I/O-bound operations.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/first-steps.md#_snippet_6

LANGUAGE: Python
CODE:
```
async def root():
```

LANGUAGE: Python
CODE:
```
def root():
```

----------------------------------------

TITLE: Set Field Declaration
DESCRIPTION: This code snippet demonstrates how to declare a set field in a Pydantic model. The `tags` attribute is defined as a `set` of strings, ensuring that the elements are unique.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/body-nested-models.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: set[str] = set()
```

----------------------------------------

TITLE: Function with Type Hints
DESCRIPTION: This example shows how to add type hints to function parameters.  It demonstrates how type hints enable autocompletion in code editors.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_1

LANGUAGE: Python
CODE:
```
def get_full_name(first_name: str, last_name: str):
    full_name = first_name.title() + " " + last_name.title()
    return full_name

print(get_full_name("john", "doe"))
```

----------------------------------------

TITLE: Deeply Nested Pydantic Models
DESCRIPTION: This code demonstrates deeply nested Pydantic models. The `Image` model is nested within the `Item` model, and the `Item` model is nested within the `Offer` model. This allows for complex data structures to be validated and serialized.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/body-nested-models.md#_snippet_8

LANGUAGE: Python
CODE:
```
from typing import List, Optional

from pydantic import BaseModel


class Image(BaseModel):
    url: str
    name: Optional[str] = None


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: List[str] = []
    images: Optional[List[Image]] = None


class Offer(BaseModel):
    name: str
    items: List[Item]
```

----------------------------------------

TITLE: JSON Response Example
DESCRIPTION: This JSON snippet shows the expected response from the `/users/me/` endpoint after successful authentication. It includes user details such as username, email, full name, and disabled status.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/security/oauth2-jwt.md#_snippet_4

LANGUAGE: JSON
CODE:
```
{
  "username": "johndoe",
  "email": "johndoe@example.com",
  "full_name": "John Doe",
  "disabled": false
}
```

----------------------------------------

TITLE: Import File and Form from FastAPI
DESCRIPTION: To declare parameters for file uploads and form fields in FastAPI path operations, you need to import the `File` and `Form` classes from the `fastapi` module.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/request-forms-and-files.md#_snippet_1

LANGUAGE: python
CODE:
```
from fastapi import File, Form
```

----------------------------------------

TITLE: Example FastAPI API Response
DESCRIPTION: An example JSON response from the FastAPI application, demonstrating the structure of data returned for an item query.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/deployment/docker.md#_snippet_4

LANGUAGE: JSON
CODE:
```
{"item_id": 5, "q": "somequery"}
```

----------------------------------------

TITLE: Example Python Data with Explicitly Set Default Values
DESCRIPTION: Shows a Python dictionary where fields are explicitly set to their default values (e.g., `description: None`, `tax: 10.5`, `tags: []`). FastAPI and Pydantic consider these fields 'set', meaning they will be included in the response even when `response_model_exclude_unset=True` is active.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/response-model.md#_snippet_13



----------------------------------------

TITLE: Declare Typed List (Python < 3.9 Syntax)
DESCRIPTION: For Python versions older than 3.9, this snippet shows how to declare a list with a specific element type using `List` imported from the `typing` module. This ensures type consistency for list elements in older Python environments.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/body-nested-models.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import List

my_list: List[str]
```

----------------------------------------

TITLE: Accessing Pydantic Settings in a FastAPI Application
DESCRIPTION: Demonstrates how to access configuration values from a Pydantic `BaseSettings` object within a FastAPI application's path operation function after instantiating the settings.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/advanced/settings.md#_snippet_5

LANGUAGE: python
CODE:
```
# Assuming 'settings' object is already instantiated from Pydantic BaseSettings
# and 'app' is a FastAPI instance.

@app.get("/info")
async def info():
    return {
        "app_name": settings.app_name,
        "admin_email": settings.admin_email,
        "items_per_user": settings.items_per_user,
    }
```

----------------------------------------

TITLE: Defining a Synchronous Function with `def`
DESCRIPTION: This example shows a standard synchronous function definition using the `def` keyword. Unlike `async def` functions, synchronous functions execute sequentially and block the current thread until their completion, which can lead to performance bottlenecks in I/O-bound scenarios within concurrent applications.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/async.md#_snippet_5

LANGUAGE: Python
CODE:
```
def get_sequential_burgers(number: int):
    # This is not asynchronous
    # Do some sequential stuff to create the burgers
    return burgers
```

----------------------------------------

TITLE: Creating Hero with HeroCreate and Returning HeroPublic
DESCRIPTION: Demonstrates how to create a Hero using the `HeroCreate` model and return the results using the `HeroPublic` model. The `response_model` parameter in the FastAPI route is used to specify the model for validating and serializing the response data.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/sql-databases.md#_snippet_14

LANGUAGE: Python
CODE:
```
@router.post("/", response_model=HeroPublic)
async def create_hero(hero: HeroCreate):
```

----------------------------------------

TITLE: FastAPI CLI Commands: dev and run
DESCRIPTION: Documents the primary FastAPI CLI commands, `fastapi dev` and `fastapi run`, detailing their purpose, default behaviors, and appropriate use cases. It highlights differences in auto-reload, listening IP addresses, and considerations for development versus production environments, noting that both internally use Uvicorn.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/fastapi-cli.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
FastAPI CLI Commands:

fastapi dev [path_to_app]
  - Description: Starts the FastAPI application in development mode.
  - Parameters:
    - path_to_app (string, optional): Path to the Python file containing the FastAPI app (e.g., main.py). The CLI automatically detects the 'app' instance.
  - Behavior:
    - Auto-reload: Enabled by default. Automatically reloads the server on code changes. (Note: Resource-intensive, for development only).
    - Listening IP: 127.0.0.1 (localhost).
  - Internal: Uses Uvicorn.

fastapi run [path_to_app]
  - Description: Starts the FastAPI application in production mode.
  - Parameters:
    - path_to_app (string, optional): Path to the Python file containing the FastAPI app (e.g., main.py). The CLI automatically detects the 'app' instance.
  - Behavior:
    - Auto-reload: Disabled by default.
    - Listening IP: 0.0.0.0 (all available IP addresses), making it publicly accessible.
  - Production Considerations: Typically used with a "termination proxy" handling HTTPS in production environments.
  - Internal: Uses Uvicorn.
```

----------------------------------------

TITLE: Updating Hero Data with HeroUpdate
DESCRIPTION: This snippet demonstrates how to update hero data using the PATCH method and the HeroUpdate model. It retrieves only the data passed by the client, excluding default values, and updates the hero's information in the database.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/sql-databases.md#_snippet_17

LANGUAGE: Python
CODE:
```
@app.patch("/heroes/{hero_id}", response_model=HeroPublic)
async def update_hero(
    hero_id: int, hero: HeroUpdate
):
    with Session(engine) as session:
        hero_db = session.get(Hero, hero_id)
        if not hero_db:
            raise HTTPException(status_code=404, detail="Hero not found")
        hero_data = hero.dict(exclude_unset=True)
        hero_db.sqlmodel_update(hero_data)
        session.add(hero_db)
        session.commit()
        session.refresh(hero_db)
        return hero_db
```

----------------------------------------

TITLE: FastAPI: Declare Optional Parameters with None Default and Union
DESCRIPTION: This example shows how to declare optional path, query, cookie, and header parameters in FastAPI. Parameters are made optional by setting their default value to `None` and using `Union[Type, None]` for type hinting, allowing them to be omitted in requests.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_25

LANGUAGE: Python
CODE:
```
from typing import Union
from fastapi import Cookie, FastAPI, Header, Path, Query

app = FastAPI()


@app.get("/items/{item_id}")
def main(
    item_id: int = Path(gt=0),
    query: Union[str, None] = Query(default=None, max_length=10),
    session: Union[str, None] = Cookie(default=None, min_length=3),
    x_trace: Union[str, None] = Header(default=None, title="Tracing header"),
):
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Enum Value Retrieval - FastAPI (Python)
DESCRIPTION: This code snippet demonstrates how to retrieve the actual value of an Enum member (a string in this case) using the `.value` attribute. This is useful when you need to use the string representation of the Enum member.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/path-params.md#_snippet_6

LANGUAGE: Python
CODE:
```
from enum import Enum

from fastapi import FastAPI

app = FastAPI()


class ModelName(str, Enum):
    alexnet = "alexnet"
    resnet = "resnet"
    lenet = "lenet"


@app.get("/models/{model_name}")
async def get_model(model_name: ModelName):
    if model_name is ModelName.alexnet:
        return {"model_name": model_name, "message": "Deep Learning FTW!"}

    if model_name.value == "lenet":
        return {"model_name": model_name, "message": "LeCNN all the images"}
    return {"model_name": model_name, "message": "Have some residuals"}
```

----------------------------------------

TITLE: Defining a GET Path Operation
DESCRIPTION: This code snippet shows how to define a path operation using the @app.get() decorator. The decorator tells FastAPI that the function below it is responsible for handling requests to the specified path ('/') using the GET method. The function returns a dictionary, which FastAPI automatically converts to JSON.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh-hant/docs/tutorial/first-steps.md#_snippet_2

LANGUAGE: python
CODE:
```
@app.get("/")
async def root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Returning a Dictionary with Item Name and ID
DESCRIPTION: This code snippet demonstrates how to return a dictionary containing the item name and ID in a FastAPI application. It shows how to access the `name` attribute of an `item` object and include it in the returned dictionary.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/he/docs/index.md#_snippet_7

LANGUAGE: Python
CODE:
```
return {"item_name": item.name, "item_id": item_id}
```

----------------------------------------

TITLE: FastAPI Dependency with Yield and Exception Handling
DESCRIPTION: Illustrates how to incorporate `try`, `except`, and `finally` blocks within a `yield`-based dependency. This pattern allows catching exceptions that occur during the dependency's usage (e.g., in a path operation) and ensures that cleanup code in the `finally` block is always executed, regardless of errors.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/dependencies/dependencies-with-yield.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Generator

def dependency_with_error_handling() -> Generator:
    print("Dependency setup phase")
    try:
        yield "some_resource"
    except Exception as e:
        print(f"An exception was caught during dependency usage: {e}")
        # Log the error, perform specific rollback, etc.
    finally:
        print("Cleanup phase (always runs)")
```

----------------------------------------

TITLE: FastAPI: Handling Multiple Query Parameter Values
DESCRIPTION: Demonstrates how to accept multiple values for a single query parameter by declaring its type as `List[str]` with `Query`. For example, a URL like `?q=foo&q=bar` will result in `q` being `['foo', 'bar']` in the function.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/query-params-str-validations.md#_snippet_6

LANGUAGE: Python
CODE:
```
from typing import List, Optional

from fastapi import FastAPI, Query

app = FastAPI()


@app.get("/items/")
async def read_items(q: Optional[List[str]] = Query(default=None)):
    query_items = {"q": q}
    return query_items
```

----------------------------------------

TITLE: Combine Dataclasses with Pydantic and Nested Models
DESCRIPTION: This comprehensive example demonstrates advanced usage of `dataclasses` with FastAPI, including combining standard `dataclasses` with `pydantic.dataclasses` and handling nested data structures. It shows how to use `field` for default factories, define complex response models, and integrate `dataclasses` with both synchronous and asynchronous path operations, leveraging FastAPI's internal Pydantic conversion.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/advanced/dataclasses.md#_snippet_2

LANGUAGE: Python
CODE:
```
from dataclasses import dataclass, field # 1. We import `field` from standard `dataclasses`.

from fastapi import FastAPI
from pydantic import BaseModel
from pydantic.dataclasses import dataclass as pydantic_dataclass # 2. `pydantic.dataclasses` re-exports `dataclasses`.

app = FastAPI()


@pydantic_dataclass # 3. The `Author` dataclass contains a list of `Item` dataclasses.
class Author:
    name: str
    items: list["Item"] = field(default_factory=list)


@dataclass # 4. The `Author` dataclass is used as a `response_model` parameter.
class Item:
    name: str
    price: float
    description: str | None = None


@app.post("/items/", response_model=Item) # 5. You can use the same standard type annotations with dataclasses for incoming data.
async def create_item(item: Item): # In this case, it contains an `Item` dataclass.
    return item


@app.get("/authors/{author_id}", response_model=Author) # 6. Here we return a dict that contains `items` which are dataclasses.
def get_author(author_id: int): # FastAPI will target `serialize` the data to dataclasses.
    return {"name": "John Doe", "items": [{"name": "Book", "price": 10.0}]}


@app.get("/authors_pydantic/{author_id}", response_model=Author) # 7. Here, `response_model` uses a type annotation that contains an `Author` dataclass.
def get_author_pydantic(author_id: int): # Again, you can combine dataclasses with standard type annotations.
    return {"name": "Jane Doe", "items": [{"name": "Pen", "price": 2.0}]} # 8. Notice that this *path operation function* uses plain `def` instead of `async def`.
```

----------------------------------------

TITLE: Example JavaScript Code Snippet
DESCRIPTION: Example JavaScript code snippet showing the beginning of a ReDoc standalone JavaScript file. This is used to verify that static files are being served correctly.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/how-to/custom-docs-ui-assets.md#_snippet_7

LANGUAGE: JavaScript
CODE:
```
/*! For license information please see redoc.standalone.js.LICENSE.txt */
!function(e,t){"object"==typeof exports&&"object"==typeof module?module.exports=t(require("null")):
```

----------------------------------------

TITLE: Use a List of Pydantic Submodels as an Attribute
DESCRIPTION: Shows how to define an attribute that expects a list of Pydantic models (e.g., a list of `Image` objects). This is useful for handling multiple related sub-items.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-nested-models.md#_snippet_8

LANGUAGE: Python
CODE:
```
from typing import Optional
from pydantic import BaseModel

# Assuming Image model is defined
class Image(BaseModel):
    url: str
    name: str

class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: list[str]
    images: list[Image]
```

----------------------------------------

TITLE: Dependencies with yield and HTTPException
DESCRIPTION: This code demonstrates how to use `yield` in dependencies to handle exceptions and perform cleanup after the path operation is executed. It shows how to raise an `HTTPException` within the dependency and how to handle it.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/dependencies/dependencies-with-yield.md#_snippet_5

LANGUAGE: Python
CODE:
```
from typing import Generator

from fastapi import Depends, FastAPI, HTTPException, status


async def dependency_a() -> str:
    yield "dependency_a"


async def dependency_b(dependency_a: str = Depends(dependency_a)) -> str:
    yield "dependency_b"


async def dependency_c(dependency_b: str = Depends(dependency_b)) -> str:
    try:
        yield "dependency_c"
    except Exception:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="From dependency_c")


async def dependency_d(dependency_c: str = Depends(dependency_c)) -> str:
    yield "dependency_d"


app = FastAPI()


@app.get("/items/")
async def read_items(dependency_d: str = Depends(dependency_d)) -> dict[str, str]:
    return {"dependency_d": dependency_d}
```

----------------------------------------

TITLE: FastAPI Lifespan Context Manager for Startup/Shutdown
DESCRIPTION: This example demonstrates the recommended way to manage application lifecycle events using FastAPI's `lifespan` context manager. It shows how to initialize resources (e.g., a database connection) before the application starts and clean them up after it shuts down, ensuring proper resource management.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/advanced/events.md#_snippet_0

LANGUAGE: Python
CODE:
```
from contextlib import asynccontextmanager
from typing import Dict

from fastapi import FastAPI

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Code to run before the app starts
    print("Starting up...")
    app.state.database = {"foo": "bar"}  # Example resource initialization
    yield
    # Code to run after the app shuts down
    print("Shutting down...")
    del app.state.database # Example resource cleanup

app = FastAPI(lifespan=lifespan)
```

----------------------------------------

TITLE: FastAPI: Caching Settings Dependency with lru_cache
DESCRIPTION: This snippet shows how to apply the `@lru_cache` decorator from `functools` to the `get_settings` dependency. This optimization ensures that the `Settings` object is instantiated only once, improving performance by avoiding redundant file reads or object creations on subsequent calls.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/advanced/settings.md#_snippet_8

LANGUAGE: Python
CODE:
```
from functools import lru_cache # Line 1
from config import Settings # Assuming Settings is defined in config.py

@lru_cache # Line 10
def get_settings():
    return Settings()
```

----------------------------------------

TITLE: Install openapi-ts for Frontend Client Generation
DESCRIPTION: This command installs the `@hey-api/openapi-ts` package as a development dependency in a frontend project. This tool is used to generate TypeScript clients from an OpenAPI schema.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/generate-clients.md#_snippet_0

LANGUAGE: Console
CODE:
```
npm install @hey-api/openapi-ts --save-dev
```

----------------------------------------

TITLE: Define .env file content
DESCRIPTION: Example of a `.env` file defining environment variables like `ADMIN_EMAIL` and `APP_NAME` for application configuration.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/advanced/settings.md#_snippet_0

LANGUAGE: bash
CODE:
```
ADMIN_EMAIL="deadpool@example.com"
APP_NAME="ChimichangApp"
```

----------------------------------------

TITLE: Path and Request Body Parameters in FastAPI
DESCRIPTION: This code snippet illustrates how to declare both path parameters and a request body within the same path operation in FastAPI. FastAPI automatically recognizes that function parameters corresponding to path parameters should be retrieved from the path, while parameters declared as Pydantic models should be retrieved from the request body.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/body.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


app = FastAPI()


@app.put("/items/{item_id}")
async def create_item(item_id: int, item: Item):
    return {"item_id": item_id, **item.dict()}
```

----------------------------------------

TITLE: FastAPI Path Parameter Ordering with Query and Path
DESCRIPTION: This snippet illustrates how to handle parameter ordering when mixing required query parameters (without `Query` default) and path parameters (with `Path`). It shows both the traditional Python 3.8 approach where required parameters must come before those with defaults, and the more flexible `Annotated` approach where order is less critical.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/path-params-numeric-validations.md#_snippet_2

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI, Path, Query

app = FastAPI()

@app.get("/items/{item_id}")
async def read_items(q: str, item_id: Path(title="The ID of the item to get")):
    results = {"item_id": item_id}
    if q:
        results.update({"q": q})
    return results
```

LANGUAGE: Python
CODE:
```
from typing import Annotated
from fastapi import FastAPI, Path, Query

app = FastAPI()

@app.get("/items/{item_id}")
async def read_items(
    q: str,
    item_id: Annotated[int, Path(title="The ID of the item to get")]
):
    results = {"item_id": item_id}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: FastAPI Dependency with Yield and HTTPException on Cleanup
DESCRIPTION: Demonstrates how to define a FastAPI dependency using `yield` for resource management. It shows that an `HTTPException` can be raised in the `finally` block (cleanup phase) of the dependency, which FastAPI will then handle and return to the client, providing a structured error response even during resource release.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/dependencies/dependencies-with-yield.md#_snippet_0

LANGUAGE: Python 3.9+
CODE:
```
from typing import Annotated
from fastapi import Depends, FastAPI, HTTPException
from contextlib import asynccontextmanager

app = FastAPI()

@asynccontextmanager
async def get_resource_with_exception():
    print("Acquiring resource...")
    try:
        yield "resource_data"
    finally:
        print("Releasing resource...")
        # Simulate an error during resource cleanup
        raise HTTPException(status_code=500, detail="Error during resource cleanup in dependency")

@app.get("/items/")
async def read_items(
    resource: Annotated[str, Depends(get_resource_with_exception)]
):
    return {"message": f"Using {resource}"}
```

LANGUAGE: Python 3.8+
CODE:
```
from typing import Annotated
from fastapi import Depends, FastAPI, HTTPException
from contextlib import asynccontextmanager

app = FastAPI()

@asynccontextmanager
async def get_resource_with_exception_py38():
    print("Acquiring resource...")
    try:
        yield "resource_data"
    finally:
        print("Releasing resource...")
        # Simulate an error during resource cleanup
        raise HTTPException(status_code=500, detail="Error during resource cleanup in dependency")

@app.get("/items_py38/")
async def read_items_py38(
    resource: Annotated[str, Depends(get_resource_with_exception_py38)]
):
    return {"message": f"Using {resource}"}
```

LANGUAGE: Python 3.8+ (Non-Annotated)
CODE:
```
from fastapi import Depends, FastAPI, HTTPException
from contextlib import asynccontextmanager
from typing import Generator

app = FastAPI()

@asynccontextmanager
async def get_resource_with_exception_non_annotated() -> Generator[str, None, None]:
    print("Acquiring resource...")
    try:
        yield "resource_data"
    finally:
        print("Releasing resource...")
        # Simulate an error during resource cleanup
        raise HTTPException(status_code=500, detail="Error during resource cleanup in dependency")

@app.get("/items_non_annotated/")
async def read_items_non_annotated(
    resource: str = Depends(get_resource_with_exception_non_annotated)
):
    return {"message": f"Using {resource}"}
```

----------------------------------------

TITLE: Example FastAPI OpenAPI JSON Schema
DESCRIPTION: An example of the `openapi.json` file automatically generated by FastAPI, which describes the API's structure, endpoints, and data models using JSON Schema. This schema powers interactive documentation and code generation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/first-steps.md#_snippet_3

LANGUAGE: JSON
CODE:
```
{
    "openapi": "3.1.0",
    "info": {
        "title": "FastAPI",
        "version": "0.1.0"
    },
    "paths": {
        "/items/": {
            "get": {
                "responses": {
                    "200": {
                        "description": "Successful Response",
                        "content": {
                            "application/json": {



...
                            }
                        }
                    }
                }
            }
        }
    }
}
```

----------------------------------------

TITLE: FastAPI Application and Test File Structure
DESCRIPTION: Illustrates a common project structure for larger FastAPI applications, separating the main application file (`main.py`) from its test file (`test_main.py`) within the same Python package. This setup allows for relative imports of the FastAPI application instance, promoting modularity and maintainability.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/testing.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_main():
    return {"msg": "Hello World"}
```

LANGUAGE: Python
CODE:
```
from fastapi.testclient import TestClient
from .main import app # Import app from the main module

client = TestClient(app)

def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"msg": "Hello World"}
```

----------------------------------------

TITLE: Define FastAPI Path Operations with Tags
DESCRIPTION: This example demonstrates how to organize FastAPI path operations using tags. Tags help in grouping related endpoints, which can then be used by client generators to create structured client code, such as separate service classes for different functional areas like 'items' and 'users'.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/generate-clients.md#_snippet_3

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/items/", tags=["items"])
async def read_items():
    return [{"name": "Item 1"}, {"name": "Item 2"}]

@app.post("/items/", tags=["items"])
async def create_item(item: dict):
    return {"message": "Item created", "item": item}

@app.get("/users/", tags=["users"])
async def read_users():
    return [{"name": "User 1"}, {"name": "User 2"}]

@app.post("/users/", tags=["users"])
async def create_user(user: dict):
    return {"message": "User created", "user": user}
```

----------------------------------------

TITLE: Define Pydantic Model with Optional Fields
DESCRIPTION: This Pydantic `BaseModel` defines a data structure for an item, including optional fields like `description` and `tax` with default `None` values. These defaults influence how OpenAPI schemas are generated for input and output by FastAPI, leading to distinct schema requirements.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/how-to/separate-openapi-schemas.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Union
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None
```

----------------------------------------

TITLE: Making FastAPI Query Parameters Optional
DESCRIPTION: Illustrates how to define optional query parameters in FastAPI. It compares setting the parameter's default to `None` with using `Query(default=None)`, demonstrating both `typing.Union` and Python 3.10+ `|` syntax for type hints. The `Query` version explicitly declares the parameter as a query parameter.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/query-params-str-validations.md#_snippet_0

LANGUAGE: Python
CODE:
```
q: Union[str, None] = Query(default=None)
```

LANGUAGE: Python
CODE:
```
q: Union[str, None] = None
```

LANGUAGE: Python
CODE:
```
q: str | None = Query(default=None)
```

LANGUAGE: Python
CODE:
```
q: str | None = None
```

----------------------------------------

TITLE: JSON: Example FastAPI API response for item query
DESCRIPTION: This JSON object represents a typical response from a FastAPI endpoint, specifically for an item query. It demonstrates the structure of the data returned, including an `item_id` (integer) and an optional `q` parameter (string), which would be part of the query parameters.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/deployment/docker.md#_snippet_14

LANGUAGE: JSON
CODE:
```
{"item_id": 5, "q": "somequery"}
```

----------------------------------------

TITLE: FastAPI User Lookup and Authentication Error Handling
DESCRIPTION: This code demonstrates how to retrieve user data from a (pseudo) database and handle cases where the user is not found. It raises an `HTTPException` with a 400 status code and a specific detail message if the username is incorrect, preventing further processing.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/security/simple-oauth2.md#_snippet_1

LANGUAGE: python
CODE:
```
from fastapi import HTTPException, status

# ... (within the login_for_access_token function)
# Assuming fake_users_db is a dictionary-like mock database
user_dict = fake_users_db.get(form_data.username)
if not user_dict:
    raise HTTPException(
        status_code=status.HTTP_400_BAD_REQUEST,
        detail="Incorrect username or password",
    )
```

----------------------------------------

TITLE: Example JSON request body for multiple item and user parameters
DESCRIPTION: Demonstrates the expected JSON structure when a FastAPI path operation accepts multiple Pydantic models (`item` and `user`) as separate body parameters. Each model's data is nested under its corresponding parameter name as a key in the JSON object.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-multiple-params.md#_snippet_3

LANGUAGE: JSON
CODE:
```
{
    "item": {
        "name": "Foo",
        "description": "The pretender",
        "price": 42.0,
        "tax": 3.2
    },
    "user": {
        "username": "dave",
        "full_name": "Dave Grohl"
    }
}
```

----------------------------------------

TITLE: Define a synchronous Python function
DESCRIPTION: This example shows a standard synchronous Python function (`def`). It executes sequentially and returns a value without using asynchronous keywords, making it suitable for CPU-bound or blocking operations.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/async.md#_snippet_0

LANGUAGE: Python
CODE:
```
def get_sequential_burgers(number: int):
    # Do some sequential stuff to create the burgers
    return burgers
```

----------------------------------------

TITLE: Example Callback Request Body from FastAPI
DESCRIPTION: A sample JSON payload that the FastAPI application sends to the external callback URL. This body contains details about a payment celebration, demonstrating the data sent during a callback.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/openapi-callbacks.md#_snippet_4

LANGUAGE: JSON
CODE:
```
{
    "description": "Payment celebration",
    "paid": true
}
```

----------------------------------------

TITLE: Install Passlib with Bcrypt
DESCRIPTION: Installs the Passlib library with Bcrypt support for handling password hashing. Passlib provides a secure way to store and verify user passwords, protecting them from unauthorized access.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/security/oauth2-jwt.md#_snippet_1

LANGUAGE: bash
CODE:
```
pip install "passlib[bcrypt]"
```

----------------------------------------

TITLE: Define a dependency with a sub-dependency and cookie
DESCRIPTION: This function acts as a dependency itself, but also depends on `query_extractor` to get a query value. It additionally checks for a `last_query` cookie if the query is not provided, demonstrating nested dependencies and cookie usage in FastAPI.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/dependencies/sub-dependencies.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Optional
from fastapi import Depends, Cookie

async def query_or_cookie_extractor(
    q: str = Depends(query_extractor),
    last_query: Optional[str] = Cookie(None),
):
    if not q:
        return last_query
    return q
```

----------------------------------------

TITLE: Defining a Path Operation Function (Sync)
DESCRIPTION: This code snippet shows how to define a synchronous path operation function that handles requests to a specific path. It uses `def` to define a standard Python function.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/first-steps.md#_snippet_5

LANGUAGE: Python
CODE:
```
def read_root():
    return {"Hello": "World"}
```

----------------------------------------

TITLE: Untitled
DESCRIPTION: No description

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/bigger-applications.md#_snippet_10



----------------------------------------

TITLE: Run FastAPI Application with Uvicorn
DESCRIPTION: This command starts the FastAPI application using Uvicorn, a lightning-fast ASGI server. The `--reload` flag enables automatic server restarts on code changes, ideal for development.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/first-steps.md#_snippet_0

LANGUAGE: console
CODE:
```
$ uvicorn main:app --reload

<span style="color: green;">INFO</span>:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
<span style="color: green;">INFO</span>:     Started reloader process [28720]
<span style="color: green;">INFO</span>:     Started server process [28722]
<span style="color: green;">INFO</span>:     Waiting for application startup.
<span style="color: green;">INFO</span>:     Application startup complete.
```

----------------------------------------

TITLE: Using Sets for Data Models in FastAPI with Pydantic
DESCRIPTION: Demonstrates how to use Python sets in Pydantic models within a FastAPI application. Sets ensure uniqueness of elements, which is useful for data validation and serialization.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/body-nested-models.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: set[str] = set()


@app.post("/items/")
async def create_item(item: Item):
    return item
```

----------------------------------------

TITLE: FastAPI Dependency with Yield and Explicit Exception Re-raising (New Behavior)
DESCRIPTION: This code demonstrates the updated and required behavior for FastAPI dependencies using `yield`. After catching an exception within the `try...except` block, it is now mandatory to explicitly re-raise the exception. This change ensures proper error propagation and memory management, aligning the dependency behavior with standard Python exception handling practices.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_10

LANGUAGE: Python
CODE:
```
def my_dep():
    try:
        yield
    except SomeException:
        raise
```

----------------------------------------

TITLE: Python Import Equivalents for Gunicorn Arguments
DESCRIPTION: These Python import statements conceptually represent how Gunicorn resolves the application module and the worker class specified in its command-line arguments. They illustrate the underlying Python logic for `main:app` and `--worker-class uvicorn.workers.UvicornWorker`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/deployment/server-workers.md#_snippet_2

LANGUAGE: python
CODE:
```
from main import app
```

LANGUAGE: python
CODE:
```
import uvicorn.workers.UvicornWorker
```

----------------------------------------

TITLE: Multiple Body Parameters
DESCRIPTION: Shows how to declare multiple body parameters in a FastAPI endpoint. FastAPI automatically infers that parameters are part of the request body based on their type hints (Pydantic models).

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body-multiple-params.md#_snippet_1

LANGUAGE: Python
CODE:
```
@app.post("/items/")
async def create_item(item: Item, user: User):
    return {"item": item, "user": user}
```

----------------------------------------

TITLE: Path and Request Body Parameters in FastAPI
DESCRIPTION: Shows how to declare both path parameters and a request body using a Pydantic model in a FastAPI endpoint. FastAPI automatically distinguishes between path parameters (extracted from the URL) and request body parameters (parsed from the request body).

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body.md#_snippet_4

LANGUAGE: Python
CODE:
```
{* ../../docs_src/body/tutorial003.py hl[17:18] *}
```

----------------------------------------

TITLE: Returning an Arbitrary Dictionary in FastAPI
DESCRIPTION: This code demonstrates how to return an arbitrary dictionary as a response, where the types of the keys and values are known, but the specific field names are not. `typing.Dict` is used to specify the response model, indicating that the endpoint will return a dictionary with string keys and integer values. This is useful when the valid field names are not known in advance.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/extra-models.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Dict

from fastapi import FastAPI

app = FastAPI()


@app.get("/index/", response_model=Dict[str, int])
async def index():
    return {
        "foo": 3,
        "bar": 5
    }
```

----------------------------------------

TITLE: FastAPI: Original Dependency Usage with Duplication
DESCRIPTION: This example illustrates the traditional method of defining dependencies in FastAPI. It shows how `Depends(get_current_user)` is repeatedly used across multiple path operation functions, leading to noticeable code duplication, especially in larger codebases.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_15

LANGUAGE: Python
CODE:
```
def get_current_user(token: str):
    # authenticate user
    return User()


@app.get("/items/")
def read_items(user: User = Depends(get_current_user)):
    ...


@app.post("/items/")
def create_item(*, user: User = Depends(get_current_user), item: Item):
    ...


@app.get("/items/{item_id}")
def read_item(*, user: User = Depends(get_current_user), item_id: int):
    ...


@app.delete("/items/{item_id}")
def delete_item(*, user: User = Depends(get_current_user), item_id: int):
    ...
```

----------------------------------------

TITLE: Defining Required Query Parameter in FastAPI
DESCRIPTION: This code snippet shows how to define a required query parameter named 'needy' of type string in a FastAPI endpoint. If the 'needy' parameter is not provided in the request, FastAPI will return an error.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/query-params.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/items/{item_id}")
async def read_item(item_id: str, needy: str):
    return {"item_id": item_id, "needy": needy}
```

----------------------------------------

TITLE: Declaring Model Attributes with Pydantic Field
DESCRIPTION: This example shows how to use `Field` within a Pydantic `BaseModel` to declare attributes with specific validation rules and metadata. It illustrates setting constraints like `max_length` and `gt` (greater than), and providing a `description` for the field, which contributes to the generated OpenAPI schema.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/body-fields.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Optional
from pydantic import BaseModel, Field

class Item(BaseModel):
    name: str = Field(..., max_length=50)
    description: Optional[str] = Field(None, max_length=300, title="Item description")
    price: float = Field(..., gt=0, description="Price of the item")
```

----------------------------------------

TITLE: FastAPI Endpoint to Delete Hero by ID
DESCRIPTION: Defines a DELETE endpoint `/heroes/{hero_id}` to remove a hero from the database based on their ID. It first attempts to retrieve the hero; if found, it deletes the hero from the session and commits the change. If the hero does not exist, it returns an `HTTPException` with a 404 Not Found status.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/sql-databases.md#_snippet_9

LANGUAGE: python
CODE:
```
from fastapi import APIRouter, HTTPException, status
from sqlmodel import Session
from .tutorial001_an_py310 import Hero, SessionDep # Assuming Hero and SessionDep are from the same file

router = APIRouter()

@router.delete("/heroes/{hero_id}")
def delete_hero(hero_id: int, session: SessionDep):
    hero = session.get(Hero, hero_id)
    if not hero:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Hero not found")
    session.delete(hero)
    session.commit()
    return {"ok": True}
```

----------------------------------------

TITLE: Translating Tip Blocks
DESCRIPTION: This snippet shows the translation of a 'tip' block. The original English text is followed by a vertical bar and then the Spanish translation. This pattern is used consistently for all similar blocks.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/llm-prompt.md#_snippet_1

LANGUAGE: Text
CODE:
```
/// tip | Consejo
```

----------------------------------------

TITLE: Annotated Type Hint Example (Python 3.9+)
DESCRIPTION: This example shows how to use `Annotated` to add metadata to type hints in Python 3.9 and later. The first type parameter passed to `Annotated` is the actual type, while the rest is metadata.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_22

LANGUAGE: Python
CODE:
```
{!> ../../docs_src/python_types/tutorial013_py39.py!}
```

----------------------------------------

TITLE: FastAPI Application with GET and PUT Endpoints
DESCRIPTION: This Python code defines a FastAPI application with multiple endpoints. It includes a root GET endpoint, a GET endpoint for items with path and optional query parameters, and a PUT endpoint for updating items. The example demonstrates the use of Pydantic for defining request body models and type hinting for automatic validation and documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/index.md#_snippet_3

LANGUAGE: python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}
```

----------------------------------------

TITLE: Example .env File for Application Configuration
DESCRIPTION: This snippet provides an example of a `.env` file, a common practice for storing environment-specific configurations. It defines key-value pairs like `ADMIN_EMAIL` and `APP_NAME` that can be loaded by applications, particularly useful for managing sensitive or environment-dependent settings outside of source control.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/advanced/settings.md#_snippet_3

LANGUAGE: Bash
CODE:
```
ADMIN_EMAIL="deadpool@example.com"
APP_NAME="ChimichangApp"
```

----------------------------------------

TITLE: Declare and use a dependency in a FastAPI path operation
DESCRIPTION: This example illustrates how to integrate a defined dependency, `common_parameters`, into a FastAPI path operation. By assigning `Depends(common_parameters)` to a parameter (`commons`), FastAPI automatically calls the dependency function and injects its return value, enabling the path operation to utilize shared logic without direct invocation, promoting modularity and testability.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/dependencies/index.md#_snippet_2

LANGUAGE: Python
CODE:
```
@app.get("/items/")
async def read_items(commons: dict = Depends(common_parameters)):
    return commons
```

----------------------------------------

TITLE: Implement FastAPI `get_current_user` Dependency for User Retrieval
DESCRIPTION: Provides the complete implementation of the `get_current_user` dependency. This function takes a raw token, decodes it using a placeholder utility (e.g., `fake_decode_token`), and returns a Pydantic `User` object. It demonstrates how to integrate token validation and user data retrieval into a reusable dependency, raising an `HTTPException` for invalid tokens.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/security/get-current-user.md#_snippet_2

LANGUAGE: Python
CODE:
```
from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer
from pydantic import BaseModel
from typing import Optional

# Assume oauth2_scheme is defined, e.g.:
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# User model definition (can be imported from a models file)
class User(BaseModel):
    username: str
    email: Optional[str] = None
    full_name: Optional[str] = None
    disabled: Optional[bool] = None

# Fake database and token decoding for demonstration purposes
fake_users_db = {
    "john_doe": {
        "username": "john_doe",
        "email": "john@example.com",
        "full_name": "John Doe",
        "disabled": False
    },
    "jane_doe": {
        "username": "jane_doe",
        "email": "jane@example.com",
        "full_name": "Jane Doe",
        "disabled": True
    }
}

def fake_decode_token(token: str):
    """
    Placeholder for actual token decoding logic (e.g., JWT verification).
    In a real application, this would validate the token and fetch user data from a database.
    """
    return fake_users_db.get(token)

async def get_current_user(token: str = Depends(oauth2_scheme)):
    """
    FastAPI dependency to retrieve the current user from a token.
    Raises HTTPException if the token is invalid or user not found.
    """
    user_data = fake_decode_token(token)
    if not user_data:
        raise HTTPException(status_code=400, detail="Invalid token")
    return User(**user_data)
```

----------------------------------------

TITLE: Defining Path Operation Decorator with FastAPI
DESCRIPTION: This code snippet shows how to define a path operation decorator using `@app.get("/")` in FastAPI. It tells FastAPI that the function below handles requests to the `/` path using the HTTP GET method.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/id/docs/tutorial/first-steps.md#_snippet_4

LANGUAGE: Python
CODE:
```
@app.get("/")
```

----------------------------------------

TITLE: Example JSON request body for an embedded single item
DESCRIPTION: Illustrates the expected JSON structure when a single Pydantic model (`Item`) is embedded under a key (`item`) in the request body using `Body(embed=True)` in FastAPI

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-multiple-params.md#_snippet_11



----------------------------------------

TITLE: Convert Query Parameters to Boolean in FastAPI
DESCRIPTION: Shows how FastAPI automatically converts various string representations (e.g., '1', 'True', 'on', 'yes') from query parameters into a Python boolean type. This example defines a `short` boolean query parameter with a default value, simplifying client input for boolean flags.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params.md#_snippet_2

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/items/{item_id}")
async def read_item(item_id: str, short: bool = False):
    if short:
        return {"item_id": item_id, "description": "This is an amazing item that has a short description."}
    return {"item_id": item_id, "description": "This is an amazing item that has a long description."}
```

----------------------------------------

TITLE: Handling Body, Route, and Query Parameters in FastAPI
DESCRIPTION: This code demonstrates FastAPI's ability to manage request body, route parameters, and query parameters concurrently. It showcases how FastAPI automatically infers the source of each parameter based on its type and declaration.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body.md#_snippet_5

LANGUAGE: python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


app = FastAPI()


@app.put("/items/{item_id}")
async def create_item(item_id: int, item: Item, q: Union[str, None] = None):
    results = {"item_id": item_id, **item.dict()}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: OpenAPI Specification for External Callback Endpoint
DESCRIPTION: Defines the expected structure of an external API endpoint that receives callbacks from the main FastAPI application. This OpenAPI specification details the required POST path operation, its request body schema (for invoice payment notifications), and expected responses, enabling external developers to implement compatible APIs that can receive notifications from your service.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/openapi-callbacks.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
paths:
  /api/v1/invoices/events/:
    post:
      summary: Receive invoice payment notification callback
      description: Endpoint for the main API to send notifications about invoice payment status.
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                description:
                  type: string
                  description: A description of the payment event, e.g., "Invoice paid".
                paid:
                  type: boolean
                  description: Indicates whether the invoice was paid (true) or not.
              example:
                description: Invoice paid
                paid: true
      responses:
        '200':
          description: Callback successfully received.
```

----------------------------------------

TITLE: Annotated Dependency Example
DESCRIPTION: Shows how to define a reusable dependency using `Annotated` and `Depends` in FastAPI. The example defines common query parameters and reuses them in multiple path operations, maintaining type hints.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/dependencies/index.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Annotated

from fastapi import Depends, FastAPI

app = FastAPI()


async def common_parameters(q: str | None = None, skip: int = 0, limit: int = 100):
    return {"q": q, "skip": skip, "limit": limit}


CommonsDep = Annotated[dict, Depends(common_parameters)]


@app.get("/items/")
async def read_items(commons: CommonsDep):
    return commons


@app.get("/users/")
async def read_users(commons: CommonsDep):
    return commons
```

----------------------------------------

TITLE: Using Pydantic Special Types (HttpUrl) for Validation
DESCRIPTION: Demonstrates how to use Pydantic's built-in special types, such as `HttpUrl`, for advanced data validation. Declaring a field as `HttpUrl` automatically validates the string as a valid URL and documents it accordingly in the OpenAPI schema, enhancing data integrity.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body-nested-models.md#_snippet_4

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel, HttpUrl

class Image(BaseModel):
    url: HttpUrl
    name: str
```

----------------------------------------

TITLE: Define Set of Strings Field in Pydantic Model (Python 3.10+)
DESCRIPTION: This example shows how to use a Python `set` for a Pydantic model field, specifically for unique string elements. This automatically handles duplicate entries by converting them into a set of unique items, which is useful for tags or categories.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/body-nested-models.md#_snippet_5

LANGUAGE: Python
CODE:
```
tags: set[str]
```

----------------------------------------

TITLE: Using Pydantic Model Attributes in FastAPI
DESCRIPTION: Demonstrates how to access attributes of a Pydantic model directly within a FastAPI function. This allows for easy access to the data validated and parsed by the model.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body.md#_snippet_3

LANGUAGE: Python
CODE:
```
{* ../../docs_src/body/tutorial002.py hl[21] *}
```

----------------------------------------

TITLE: FastAPI Dependency with Yield and Exception Handling
DESCRIPTION: Demonstrates how to use `yield` in FastAPI dependencies to manage resources, including raising `HTTPException` or custom exceptions after `yield`. It shows a dependency that yields a username and a path operation that retrieves an item, validating ownership and raising appropriate exceptions.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_11

LANGUAGE: Python
CODE:
```
from fastapi import Depends, FastAPI, HTTPException
from typing_extensions import Annotated

app = FastAPI()


data = {
    "plumbus": {"description": "Freshly pickled plumbus", "owner": "Morty"},
    "portal-gun": {"description": "Gun to create portals", "owner": "Rick"},
}


class OwnerError(Exception):
    pass


def get_username():
    try:
        yield "Rick"
    except OwnerError as e:
        raise HTTPException(status_code=400, detail=f"Owner error: {e}")


@app.get("/items/{item_id}")
def get_item(item_id: str, username: Annotated[str, Depends(get_username)]):
    if item_id not in data:
        raise HTTPException(status_code=404, detail="Item not found")
    item = data[item_id]
    if item["owner"] != username:
        raise OwnerError(username)
    return item
```

----------------------------------------

TITLE: FastAPI application file
DESCRIPTION: Defines a simple FastAPI application in main.py.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/testing.md#_snippet_2

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root():
    return {"Hello": "World"}
```

----------------------------------------

TITLE: Install FastAPI Standard Dependencies Excluding Cloud CLI
DESCRIPTION: Provides the installation command for FastAPI's standard dependencies while specifically omitting the `fastapi-cloud-cli` package, useful for users who do not require cloud deployment features.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/index.md#_snippet_15

LANGUAGE: Python
CODE:
```
pip install "fastapi[standard-no-fastapi-cloud-cli]"
```

----------------------------------------

TITLE: Environment Variables: Example .env File
DESCRIPTION: This snippet shows a typical `.env` file structure used to define environment variables. Pydantic settings can automatically load values from such files, providing a convenient way to manage configuration outside of code.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/advanced/settings.md#_snippet_6

LANGUAGE: bash
CODE:
```
ADMIN_EMAIL="deadpool@example.com"
APP_NAME="ChimichangApp"
```

----------------------------------------

TITLE: Numeric Validation: Float Values, Greater Than and Less Than
DESCRIPTION: This code snippet shows how numeric validations work with float values. It uses `gt` (greater than) and `lt` (less than) to specify that `item_id` must be greater than 0 and less than 1.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/path-params-numeric-validations.md#_snippet_6

LANGUAGE: python
CODE:
```
from fastapi import FastAPI, Path

app = FastAPI()


@app.get("/items/{item_id}")
async def read_items(item_id: float = Path(gt=0, lt=1)):
    return {"item_id": item_id}
```

----------------------------------------

TITLE: Set Type as Field in Pydantic Model
DESCRIPTION: Defines a Pydantic model with a set as a field, ensuring that the elements are unique. The `tags` attribute is declared as a set of strings.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/body-nested-models.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Optional, Set

from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: Set[str] = set()
```

----------------------------------------

TITLE: Example JSON Response
DESCRIPTION: This JSON response is returned when accessing the /items/{item_id} endpoint with a query parameter. It demonstrates how FastAPI automatically serializes data into JSON format.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pl/docs/index.md#_snippet_5

LANGUAGE: JSON
CODE:
```
{"item_id": 5, "q": "somequery"}
```

----------------------------------------

TITLE: Declare a List with Type Annotation in Python
DESCRIPTION: Demonstrates how to declare a list with type annotations in Python, specifically using the `List` type from the `typing` module for Python versions prior to 3.9.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/body-nested-models.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import List

my_list: List[str]
```

----------------------------------------

TITLE: Obtaining Enum Value
DESCRIPTION: This example shows how to obtain the actual string value of an Enum member using `.value`. This is useful when you need to work with the string representation of the Enum.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/path-params.md#_snippet_7

LANGUAGE: python
CODE:
```
@app.get("/models/{model_name}")
async def get_model(model_name: ModelName):
    if model_name == ModelName.alexnet:
        return {"model_name": model_name, "message": "Deep Learning FTW!"}

    return {"model_name": model_name, "message": f"Have some residuals? {model_name.value}"}
```

----------------------------------------

TITLE: Define Deeply Nested Pydantic Models
DESCRIPTION: Illustrates how to create arbitrarily deeply nested Pydantic models, where models contain lists of other models, which in turn contain optional lists of yet other models. This demonstrates FastAPI's capability to handle complex, multi-level data structures.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-nested-models.md#_snippet_10

LANGUAGE: Python
CODE:
```
from typing import Optional
from pydantic import BaseModel, HttpUrl

class Image(BaseModel):
    url: HttpUrl
    name: str

class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: set[str]
    images: Optional[list[Image]] = None

class Offer(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    items: list[Item]
```

----------------------------------------

TITLE: Accessing Dependency Values in Exit Code
DESCRIPTION: Shows how to access the values of dependencies in the exit code of other dependencies when using `yield`. `dependency_b` needs the value of `dependency_a` and `dependency_c` needs the value of `dependency_b` to execute their exit code.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/dependencies/dependencies-with-yield.md#_snippet_4

LANGUAGE: Python
CODE:
```
async def dependency_a() -> str:
    yield "A"


async def dependency_b(dep_a: str = Depends(dependency_a)) -> str:
    try:
        yield f"B {dep_a}"
    finally:
        print(f"dependency_b got {dep_a=}")


async def dependency_c(dep_b: str = Depends(dependency_b)) -> str:
    try:
        yield f"C {dep_b}"
    finally:
        print(f"dependency_c got {dep_b=}")
```

----------------------------------------

TITLE: Accessing Model Attributes in FastAPI
DESCRIPTION: This code snippet demonstrates how to access attributes of a Pydantic model directly within a FastAPI function. It showcases the ease of use and type safety provided by Pydantic models when handling request bodies.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/body.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


app = FastAPI()


@app.post("/items/")
async def create_item(item: Item):
    return item.name
```

----------------------------------------

TITLE: FastAPI Application for Separate Testing
DESCRIPTION: This code defines a simple FastAPI application with a single GET endpoint. It is designed to be part of a larger project structure where the application logic resides in one file (`main.py`) and tests are written in a separate file, promoting modularity and organization.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/testing.md#_snippet_2

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def read_main():
    return {"msg": "Hello World"}
```

----------------------------------------

TITLE: Import UploadFile from FastAPI
DESCRIPTION: Demonstrates the standard way to import the `UploadFile` class directly from the `fastapi` library, which is essential for defining file upload parameters in FastAPI applications.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/reference/uploadfile.md#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import UploadFile
```

----------------------------------------

TITLE: Declaring Dictionary Type Hints
DESCRIPTION: This snippet illustrates how to declare type hints for dictionaries, specifying the types for both keys and values. It provides examples for both Python 3.6+ (using `typing.Dict`) and Python 3.9+ (using the built-in `dict` type directly), clarifying the structure of dictionary type annotations.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/python-types.md#_snippet_7

LANGUAGE: Python (Python 3.6+)
CODE:
```
{!> ../../docs_src/python_types/tutorial008.py!}
```

LANGUAGE: Python (Python 3.9+)
CODE:
```
{!> ../../docs_src/python_types/tutorial008_py39.py!}
```

----------------------------------------

TITLE: Example JSON Data with Values Matching Defaults
DESCRIPTION: Shows a JSON data structure where some values are explicitly set to be identical to their Pydantic model's default values. FastAPI and Pydantic intelligently include these in the response because they were explicitly provided, rather than being derived from the model's defaults.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/response-model.md#_snippet_16

LANGUAGE: JSON
CODE:
```
{
    "name": "Baz",
    "description": null,
    "price": 50.2,
    "tax": 10.5,
    "tags": []
}
```

----------------------------------------

TITLE: Type hinting in functieparameters
DESCRIPTION: Demonstreert het gebruik van type hints in functieparameters in Python. De functie `main` accepteert een string parameter `user_id` en retourneert deze. Type hints zorgen voor editorondersteuning en typecontrole.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/features.md#_snippet_0

LANGUAGE: Python
CODE:
```
from datetime import date

from pydantic import BaseModel

# Declareer een variabele als een str
# en krijg editorondersteuning in de functie
def main(user_id: str):
    return user_id
```

----------------------------------------

TITLE: Declaring a Union Type - Python 3.10+
DESCRIPTION: This snippet declares a variable `item` that can be either an integer or a string using the union operator `|`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_12

LANGUAGE: Python
CODE:
```
item: int | str = 123
```

----------------------------------------

TITLE: FastAPI Application with Tagged Endpoints
DESCRIPTION: Demonstrates how to organize FastAPI endpoints using `tags`. Tags allow for better categorization and grouping of related operations in the generated OpenAPI documentation, which can lead to more structured client code.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/advanced/generate-clients.md#_snippet_5

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI, Body
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


class User(BaseModel):
    username: str
    email: Union[str, None] = None


app = FastAPI()


@app.post("/items/", tags=["items"])
async def create_item(item: Item = Body(..., embed=True)):
    return item


@app.get("/items/", tags=["items"])
async def read_items():
    return [{"name": "Foo", "price": 42}]


@app.post("/users/", tags=["users"])
async def create_user(user: User = Body(..., embed=True)):
    return user


@app.get("/users/", tags=["users"])
async def read_users():
    return [{"username": "Foo"}, {"username": "Bar"}]
```

----------------------------------------

TITLE: Install FastAPI with Standard Dependencies
DESCRIPTION: An example command to install the FastAPI library along with its standard extra dependencies using `pip`. This illustrates a common package installation process, typically performed within a virtual environment.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh-hant/docs/virtual-environments.md#_snippet_4

LANGUAGE: Shell
CODE:
```
pip install "fastapi[standard]"
```

----------------------------------------

TITLE: Hero Public Data Model Definition
DESCRIPTION: Defines the `HeroPublic` model, which is used for returning Hero data to API clients. It includes the same fields as `HeroBase` (name, age) and an `id` field, but excludes the `secret_name` to protect sensitive information.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/sql-databases.md#_snippet_11

LANGUAGE: Python
CODE:
```
class HeroPublic(HeroBase):
    id: int
```

----------------------------------------

TITLE: Import TestClient for FastAPI testing
DESCRIPTION: This snippet demonstrates how to import the `TestClient` class from the `fastapi.testclient` module. This class is crucial for writing unit and integration tests for FastAPI applications, allowing direct interaction with the application's routes and logic.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/reference/testclient.md#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi.testclient import TestClient
```

----------------------------------------

TITLE: Declaring a Union Type (Python 3.8+)
DESCRIPTION: This snippet demonstrates how to declare a variable that can be either an integer or a string using the `Union` type from the `typing` module in Python 3.8+. The type hint `Union[int, str]` specifies that the variable `item` can hold either an integer or a string value.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_12

LANGUAGE: Python
CODE:
```
from typing import Union

item: Union[int, str] = 123
```

----------------------------------------

TITLE: FastAPI Application-Level Dependencies
DESCRIPTION: This snippet demonstrates how to set top-level dependencies for a FastAPI application by passing a list of `Depends` objects to the `FastAPI` constructor. This allows applying global authentication or other dependencies to all path operations in the application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_28

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI, Depends


async def some_dependency():
    return


app = FastAPI(dependencies=[Depends(some_dependency)])
```

----------------------------------------

TITLE: OpenAPI 3.1.0 Webhook Definition for New Subscription Event
DESCRIPTION: This APIDOC entry describes the structure of a webhook definition as generated by FastAPI in the OpenAPI 3.1.0 schema. It details the 'new-subscription' webhook, including its HTTP POST method, the expected request body schema (`NewSubscription`), and the response, providing a comprehensive reference for consumers to implement their webhook receivers.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/openapi-webhooks.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
{
  "webhooks": {
    "new-subscription": {
      "post": {
        "summary": "This webhook is triggered when a new user subscribes.",
        "description": "It receives details about the new subscription.",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/NewSubscription"
              }
            }
          },
          "required": true
        },
        "responses": {
          "200": {
            "description": "Webhook processed successfully"
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "NewSubscription": {
        "title": "NewSubscription",
        "required": [
          "email",
          "plan",
          "amount"
        ],
        "type": "object",
        "properties": {
          "email": {
            "title": "Email",
            "type": "string"
          },
          "plan": {
            "title": "Plan",
            "type": "string"
          },
          "amount": {
            "title": "Amount",
            "type": "number"
          }
        }
      }
    }
  }
}
```

----------------------------------------

TITLE: Import Starlette HTTPException with Alias
DESCRIPTION: This Python snippet demonstrates how to import Starlette's `HTTPException` class and assign it an alias (`StarletteHTTPException`). This is crucial when registering exception handlers to differentiate it from FastAPI's `HTTPException` and ensure broader error handling coverage.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/handling-errors.md#_snippet_11

LANGUAGE: Python
CODE:
```
from starlette.exceptions import HTTPException as StarletteHTTPException
```

----------------------------------------

TITLE: Import Header Class from FastAPI
DESCRIPTION: Demonstrates the essential import statement to bring the `Header` class into your FastAPI application, enabling the definition of HTTP header parameters.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/header-params.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI, Header

app = FastAPI()
```

----------------------------------------

TITLE: FastAPI: Using Aliases for Query Parameters
DESCRIPTION: Explains how to use the `alias` argument in `Query` to map an invalid Python variable name (e.g., `item-query`) from the URL to a valid Python parameter name (`q`). This allows flexible URL parameter naming while maintaining valid Python code.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/query-params-str-validations.md#_snippet_11

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import FastAPI, Query

app = FastAPI()


@app.get("/items/")
async def read_items(q: Optional[str] = Query(default=None, alias="item-query")):
    results = {"items": [{"item_id": "Foo"}, {"item_id": "Bar"}]}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: Example requirements.txt
DESCRIPTION: Shows the format of a requirements.txt file, which lists the packages and their versions required for a project.  This file is used with pip install -r requirements.txt.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/virtual-environments.md#_snippet_14

LANGUAGE: requirements.txt
CODE:
```
fastapi[standard]==0.113.0
pydantic==2.8.0
```

----------------------------------------

TITLE: Hero Update Model Definition
DESCRIPTION: Defines the `HeroUpdate` model, used for updating existing Hero data. All fields in this model are optional, allowing clients to update only the fields that need to be changed. It includes fields for `name`, `age`, and `secret_name`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/sql-databases.md#_snippet_13

LANGUAGE: Python
CODE:
```
class HeroUpdate(HeroBase):
    name: Optional[str] = None
    age: Optional[int] = None
    secret_name: Optional[str] = None
```

----------------------------------------

TITLE: Using HttpUrl for URL Validation
DESCRIPTION: Demonstrates how to use Pydantic's `HttpUrl` type for validating that a string is a valid URL.  This ensures that the `url` field in the `Image` model contains a valid HTTP URL.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/body-nested-models.md#_snippet_6

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel, HttpUrl


class Image(BaseModel):
    url: HttpUrl
    name: str


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: list[str] = []
    image: Optional[Image] = None
```

----------------------------------------

TITLE: Defining a GET Path Operation with Decorator in FastAPI
DESCRIPTION: This code snippet shows how to define a GET path operation for the root path ('/') using the `@app.get()` decorator in FastAPI. The function decorated with `@app.get("/")` will handle requests to the `/` path using the GET method.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/first-steps.md#_snippet_4

LANGUAGE: python
CODE:
```
@app.get("/")
```

----------------------------------------

TITLE: Prepare Optional Query Parameter with Annotated
DESCRIPTION: Shows how to wrap an optional string type hint for parameter `q` with `Annotated`, preparing it for additional metadata like validation rules in FastAPI, for different Python versions.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params-str-validations.md#_snippet_1

LANGUAGE: Python 3.10+
CODE:
```
q: Annotated[str | None] = None
```

LANGUAGE: Python 3.8+
CODE:
```
q: Annotated[Union[str, None]] = None
```

----------------------------------------

TITLE: Alternative JSON Body without Embedding
DESCRIPTION: This JSON snippet shows the structure of the request body when the `embed` parameter is not used. The `Item` model's data is directly in the body.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/body-multiple-params.md#_snippet_6

LANGUAGE: JSON
CODE:
```
{
    "name": "Foo",
    "description": "The pretender",
    "price": 42.0,
    "tax": 3.2
}
```

----------------------------------------

TITLE: Single Values in Request Body
DESCRIPTION: Demonstrates how to use `Body` to explicitly define a single value as part of the request body. This is useful when you need to include simple data types in the request body alongside Pydantic models.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body-multiple-params.md#_snippet_2

LANGUAGE: Python
CODE:
```
@app.post("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item,
    user: User,
    importance: int = Body(..., gt=0),
    q: Union[str, None] = None
):
    results = {"item_id": item_id, "item": item, "user": user, "importance": importance}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: 패스워드 해싱 및 검증 유틸리티 함수 생성 (passlib)
DESCRIPTION: passlib에서 필요한 도구를 가져오고, 패스워드를 해싱하고 검증하는 데 사용되는 PassLib "컨텍스트"를 생성합니다. 사용자로부터 받은 패스워드를 해싱하는 유틸리티 함수와 저장된 해시와 일치하는지 검증하는 함수를 생성합니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/security/oauth2-jwt.md#_snippet_0

LANGUAGE: python
CODE:
```
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def get_password_hash(password):
    return pwd_context.hash(password)

def verify_password(password, hashed_password):
    return pwd_context.verify(password, hashed_password)
```

----------------------------------------

TITLE: Dict with Specific Key and Value Types
DESCRIPTION: This code defines a request body as a dictionary with integer keys and float values. The `weights` parameter is annotated as `dict[int, float]`, indicating that the request body should be a JSON object where the keys are integers and the values are floats. Pydantic automatically converts string keys to integers.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/body-nested-models.md#_snippet_10

LANGUAGE: Python
CODE:
```
from typing import Dict

from pydantic import BaseModel


async def update_weights(weights: Dict[int, float]):
    return weights
```

----------------------------------------

TITLE: Hero Creation Model Definition
DESCRIPTION: Defines the `HeroCreate` model, used for validating data received from clients when creating a new Hero. It includes fields for `name`, `age`, and `secret_name`, allowing clients to provide the secret name during creation, which is then stored in the database but not returned in API responses.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/sql-databases.md#_snippet_12

LANGUAGE: Python
CODE:
```
class HeroCreate(HeroBase):
    secret_name: str
```

----------------------------------------

TITLE: Declaring a Union Type - Python 3.8+
DESCRIPTION: This snippet declares a variable `item` that can be either an integer or a string using the `Union` type from the `typing` module.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_11

LANGUAGE: Python
CODE:
```
from typing import Union

item: Union[int, str] = 123
```

----------------------------------------

TITLE: Run FastAPI Development Server
DESCRIPTION: This command starts the FastAPI development server, watching for changes in `main.py` and automatically reloading the application. It provides a local URL for accessing the API and its interactive documentation. This mode is suitable for development, while `fastapi run` is recommended for production.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/index.md#_snippet_0

LANGUAGE: Shell
CODE:
```
$ fastapi dev main.py
```

----------------------------------------

TITLE: FastAPI OpenAPI Component Schemas for Pydantic Models
DESCRIPTION: This API documentation snippet illustrates the 'components/schemas' section of the OpenAPI specification, where Pydantic models are defined as reusable JSON schemas. Models like 'Message', 'Item', 'ValidationError', and 'HTTPValidationError' are detailed with their properties, types, and required fields. These definitions are then referenced from other parts of the OpenAPI document, promoting reusability and consistency.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/additional-responses.md#_snippet_1

LANGUAGE: JSON
CODE:
```
{
    "components": {
        "schemas": {
            "Message": {
                "title": "Message",
                "required": [
                    "message"
                ],
                "type": "object",
                "properties": {
                    "message": {
                        "title": "Message",
                        "type": "string"
                    }
                }
            },
            "Item": {
                "title": "Item",
                "required": [
                    "id",
                    "value"
                ],
                "type": "object",
                "properties": {
                    "id": {
                        "title": "Id",
                        "type": "string"
                    },
                    "value": {
                        "title": "Value",
                        "type": "string"
                    }
                }
            },
            "ValidationError": {
                "title": "ValidationError",
                "required": [
                    "loc",
                    "msg",
                    "type"
                ],
                "type": "object",
                "properties": {
                    "loc": {
                        "title": "Location",
                        "type": "array",
                        "items": {
                            "type": "string"
                        }
                    },
                    "msg": {
                        "title": "Message",
                        "type": "string"
                    },
                    "type": {
                        "title": "Error Type",
                        "type": "string"
                    }
                }
            },
            "HTTPValidationError": {
                "title": "HTTPValidationError",
                "type": "object",
                "properties": {
                    "detail": {
                        "title": "Detail",
                        "type": "array",
                        "items": {
                            "$ref": "#/components/schemas/ValidationError"
                        }
                    }
                }
            }
        }
    }
}
```

----------------------------------------

TITLE: Example JSON request body for a single item
DESCRIPTION: Illustrates the expected JSON structure when a FastAPI path operation expects a single Pydantic model as the request body without any embedding. The model's attributes are directly at the root level of the JSON object.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-multiple-params.md#_snippet_1

LANGUAGE: JSON
CODE:
```
{
    "name": "Foo",
    "description": "The pretender",
    "price": 42.0,
    "tax": 3.2
}
```

----------------------------------------

TITLE: Python 3.10 Union Type Annotation Syntax
DESCRIPTION: This snippet demonstrates the modern Python 3.10 syntax for defining type unions using the vertical bar `|` operator. This concise syntax can be used for direct type annotations, offering an alternative to `typing.Union` in many contexts. However, when passing types as arguments (e.g., to FastAPI's `response_model`), `typing.Union` is still required.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/extra-models.md#_snippet_0

LANGUAGE: Python
CODE:
```
some_variable: PlaneItem | CarItem
```

----------------------------------------

TITLE: Importing and Using BackgroundTasks in FastAPI
DESCRIPTION: This code snippet demonstrates how to import BackgroundTasks and define it as a parameter in a path operation function. FastAPI will automatically create and pass the BackgroundTasks object.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/background-tasks.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import BackgroundTasks, FastAPI

app = FastAPI()


@app.post("/send-notification/{email}")
async def send_notification(email: str, background_tasks: BackgroundTasks):
    return {"message": "Notification sent in the background"}
```

----------------------------------------

TITLE: Define optional query parameter with Union type hint
DESCRIPTION: Demonstrates how to define an optional query parameter using `Union[str, None]` for Python versions prior to 3.10, allowing the parameter to be either a string or `None`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-multiple-params.md#_snippet_6

LANGUAGE: Python
CODE:
```
q: Union[str, None] = None
```

----------------------------------------

TITLE: Get Enum Value
DESCRIPTION: This example demonstrates how to get the string value of an Enum member using `.value`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/path-params.md#_snippet_6

LANGUAGE: python
CODE:
```
    return {"model_name": model_name, "message": "Have some residuals": model_name.value}
```

----------------------------------------

TITLE: FastAPI Internal Handling of Async vs. Sync Functions
DESCRIPTION: This documentation outlines how FastAPI processes different types of functions (path operations, dependencies, utility functions) based on whether they are defined with `def` (synchronous) or `async def` (asynchronous). Understanding these behaviors is key to optimizing application performance and preventing blocking operations in a concurrent environment.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/async.md#_snippet_8

LANGUAGE: APIDOC
CODE:
```
FastAPI Function Type Handling:

Path Operation Functions:
  - `def` (synchronous):
    - Execution: Runs in a separate thread from the threadpool.
    - Use Case: Suitable for CPU-bound tasks or blocking I/O operations (e.g., traditional database calls).
    - Performance Note: FastAPI ensures these don't block the main event loop.
  - `async def` (asynchronous):
    - Execution: Runs directly in the main event loop.
    - Use Case: Ideal for I/O-bound operations that can `await` (e.g., network requests, async database drivers).
    - Performance Note: Maximizes concurrency by yielding control during I/O waits.

Dependencies:
  - `def` (synchronous):
    - Execution: Runs in a separate thread.
    - Behavior: Similar to synchronous path operations, preventing blocking of the event loop.
  - `async def` (asynchronous):
    - Execution: Runs directly in the event loop.
    - Behavior: Similar to asynchronous path operations, allowing for non-blocking I/O within dependencies.

Sub-dependencies:
  - Behavior: Can mix `def` and `async def` dependencies. Synchronous sub-dependencies will be run in a threadpool.

Other Utility Functions (called by your code):
  - `def` (synchronous):
    - Execution: Called directly by your code. Does not run in a separate thread unless explicitly managed by you.
    - Behavior: If blocking, it will block the calling function/thread.
  - `async def` (asynchronous):
    - Execution: Must be `await`ed by your code when called.
    - Behavior: If not awaited, it returns a coroutine object. Allows for non-blocking operations when properly awaited.
```

----------------------------------------

TITLE: Access Attributes of Request Body Model
DESCRIPTION: Demonstrates how to access individual attributes of the validated `item` object (an instance of the `Item` Pydantic model) directly within the FastAPI path operation function. This allows for easy manipulation and use of the received data with full type hints.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body.md#_snippet_4

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None

app = FastAPI()

@app.post("/items/")
async def create_item(item: Item):
    print(f"Received item name: {item.name}")
    print(f"Received item price: {item.price}")
    # You can access all attributes directly
    return {"message": "Item received", "item_name": item.name, "item_price": item.price}
```

----------------------------------------

TITLE: Example HTTP Request with Forbidden Query Parameter
DESCRIPTION: This HTTP request demonstrates an attempt to send an extra, undefined query parameter (`tool=plumbus`) to an endpoint configured to forbid extra fields. This request is expected to trigger an error response from the FastAPI application, showcasing the effect of the `extra='forbid'` configuration.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-param-models.md#_snippet_2

LANGUAGE: HTTP
CODE:
```
https://example.com/items/?limit=10&tool=plumbus
```

----------------------------------------

TITLE: Declare Header Parameters with Pydantic Model in FastAPI
DESCRIPTION: Demonstrates how to define a Pydantic `BaseModel` to group related HTTP header parameters and then inject this model into a FastAPI path operation using `fastapi.Header`. This approach allows for centralized validation, documentation, and reusability of header definitions.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/header-param-models.md#_snippet_0

LANGUAGE: python
CODE:
```
from typing import Annotated
from fastapi import FastAPI, Header
from pydantic import BaseModel

app = FastAPI()

class CommonHeaders(BaseModel):
    x_token: str
    x_api_key: Annotated[str | None, Header(alias="X-API-Key")] = None

@app.get("/items/")
async def read_items(headers: Annotated[CommonHeaders, Header()]):
    return {"headers": headers.model_dump()}
```

----------------------------------------

TITLE: Install FastAPI with Standard Dependencies
DESCRIPTION: This command installs FastAPI along with a comprehensive set of standard optional dependencies. These include 'email-validator' for Pydantic, 'httpx', 'jinja2', 'python-multipart' for Starlette, and 'uvicorn' with 'fastapi-cli[standard]' for FastAPI's server and command-line interface.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/README.md#_snippet_9

LANGUAGE: Shell
CODE:
```
pip install "fastapi[standard]"
```

----------------------------------------

TITLE: FastAPI Optional Dependency Reference
DESCRIPTION: Comprehensive reference for various optional dependencies available for FastAPI, categorized by their primary use and the features they enable, including those part of the 'standard' group and additional ones.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/index.md#_snippet_16

LANGUAGE: APIDOC
CODE:
```
FastAPI Optional Dependencies:

Standard Dependencies (included with "fastapi[standard]"):
  email-validator:
    Purpose: For email validation in Pydantic models.
    Source: Used by Pydantic.
  httpx:
    Purpose: Required for using the TestClient.
    Source: Used by Starlette.
  jinja2:
    Purpose: Required for using the default template configuration.
    Source: Used by Starlette.
  python-multipart:
    Purpose: Required for form parsing with request.form().
    Source: Used by Starlette.
  uvicorn:
    Purpose: Server for loading and serving the application. Includes uvicorn[standard] for high performance.
    Source: Used by FastAPI.
  fastapi-cli[standard]:
    Purpose: Provides the 'fastapi' command.
    Source: Used by FastAPI.
  fastapi-cloud-cli:
    Purpose: Allows deployment to FastAPI Cloud.
    Source: Included with fastapi-cli[standard].

Additional Optional Dependencies:
  Pydantic-related:
    pydantic-settings:
      Purpose: For settings management.
    pydantic-extra-types:
      Purpose: For extra types to be used with Pydantic.
  FastAPI-specific:
    orjson:
      Purpose: Required for using ORJSONResponse (faster JSON serialization).
    ujson:
      Purpose: Required for using UJSONResponse (alternative faster JSON serialization).
```

----------------------------------------

TITLE: Run FastAPI development server
DESCRIPTION: This command starts the FastAPI development server in development mode, watching for changes in the specified application file. It provides detailed logs including server startup information, URLs for the application, and its interactive documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/first-steps.md#_snippet_0

LANGUAGE: console
CODE:
```
$ fastapi dev main.py

  FastAPI   Starting development server 🚀

             Searching for package file structure from directories
             with __init__.py files
             Importing from /home/user/code/awesomeapp

    module   🐍 main.py

      code   Importing the FastAPI app object from the module with
             the following code:

             from main import app

       app   Using import string: main:app

    server   Server started at http://127.0.0.1:8000
    server   Documentation at http://127.0.0.1:8000/docs

       tip   Running in development mode, for production use:
             fastapi run

             Logs:

      INFO   Will watch for changes in these directories:
             ['/home/user/code/awesomeapp']
      INFO   Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C
             to quit)
      INFO   Started reloader process [383138] using WatchFiles
      INFO   Started server process [383153]
      INFO   Waiting for application startup.
      INFO   Application startup complete.
```

----------------------------------------

TITLE: Define FastAPI Application Lifespan Events with `lifespan`
DESCRIPTION: This example demonstrates the recommended way to manage application startup and shutdown logic in FastAPI using the `lifespan` parameter with an `asynccontextmanager`. It shows how to initialize resources like a machine learning model before the application starts processing requests and clean them up upon shutdown, ensuring efficient resource management.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/advanced/events.md#_snippet_0

LANGUAGE: Python
CODE:
```
from contextlib import asynccontextmanager
from fastapi import FastAPI

models = {} # Simulate a shared resource

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup logic: Load resources
    print("Loading ML model...")
    models["my_model"] = {"status": "loaded"} # Placeholder for actual model
    yield # Application starts processing requests
    # Shutdown logic: Unload resources
    print("Unloading ML model...")
    models.clear()

app = FastAPI(lifespan=lifespan)

@app.get("/")
async def read_root():
    return {"message": "Hello World", "model_status": "loaded" if "my_model" in models else "not loaded"}
```

----------------------------------------

TITLE: FastAPI Dependency with Yield: Catching but Not Re-raising Exceptions
DESCRIPTION: Illustrates a FastAPI dependency using `yield` where an exception is caught within the `try...except` block but *not* re-raised. This leads to a generic 500 Internal Server Error for the client without proper server-side logging or indication of the original error, making debugging difficult.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/dependencies/dependencies-with-yield.md#_snippet_1

LANGUAGE: Python 3.9+
CODE:
```
from typing import Annotated
from fastapi import Depends, FastAPI

app = FastAPI()

async def get_resource_no_reraise():
    try:
        print("Acquiring resource...")
        yield "resource_data"
    except Exception as e:
        print(f"Caught exception but not re-raising: {e}")
        # No 'raise' here
    finally:
        print("Releasing resource...")

@app.get("/data/")
async def get_data(
    res: Annotated[str, Depends(get_resource_no_reraise)]
):
    # This error will be caught by the dependency but not re-raised
    raise ValueError("Simulated error in route processing")
```

----------------------------------------

TITLE: Install email-validator for Pydantic EmailStr
DESCRIPTION: Commands to install the `email-validator` library, which is required for Pydantic's `EmailStr` type. It provides options for installing directly or via Pydantic's extra dependencies.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/response-model.md#_snippet_4

LANGUAGE: bash
CODE:
```
pip install email-validator
pip install "pydantic[email]"
```

----------------------------------------

TITLE: Format Pull Request Title for Translations
DESCRIPTION: Example of how to format a Pull Request title specifically for translations. It includes the use of the 'globe with meridians' gitmoji (🌐) and the full path to the translated file, adhering to the imperative verb structure required for automated release notes generation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/management-tasks.md#_snippet_0

LANGUAGE: Markdown
CODE:
```
🌐 Add Spanish translation for `docs/es/docs/teleporting.md`
```

----------------------------------------

TITLE: Complex Dependency Chain Visualization in FastAPI
DESCRIPTION: This Mermaid diagram illustrates a more intricate dependency graph, demonstrating how dependencies can be nested or chained. It shows how a `current_user` dependency can lead to `active_user`, which then branches into `admin_user` and `paying_user`, each enabling access to specific API endpoints, showcasing advanced dependency management.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/dependencies/index.md#_snippet_4

LANGUAGE: mermaid
CODE:
```
graph TB

current_user(["current_user"])
active_user(["active_user"])
admin_user(["admin_user"])
paying_user(["paying_user"])

public["/items/public/"]
private["/items/private/"]
activate_user["/users/{user_id}/activate"]
pro_items["/items/pro/"]

current_user --> active_user
active_user --> admin_user
active_user --> paying_user

current_user --> public
active_user --> private
admin_user --> activate_user
paying_user --> pro_items
```

----------------------------------------

TITLE: Pydantic model definitie
DESCRIPTION: Definieert een Pydantic model `User` met type hints voor de attributen `id` (int), `name` (str) en `joined` (date). Pydantic gebruikt deze type declaraties voor data validatie en serialisatie.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/features.md#_snippet_1

LANGUAGE: Python
CODE:
```
# Een Pydantic model
class User(BaseModel):
    id: int
    name: str
    joined: date
```

----------------------------------------

TITLE: Accessing Model Attributes in FastAPI
DESCRIPTION: Demonstrates how to access attributes of a Pydantic model within a FastAPI function. The item object, an instance of the Item model, is passed as a parameter, and its attributes (name, description, price, tax) are accessed directly.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/body.md#_snippet_3

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


app = FastAPI()


@app.post("/items/")
async def create_item(item: Item):
    return item
```

----------------------------------------

TITLE: Annotated Type Hint Example (Python 3.8+)
DESCRIPTION: This example shows how to use `Annotated` to add metadata to type hints in Python versions lower than 3.9.  `Annotated` is imported from `typing_extensions`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/python-types.md#_snippet_23

LANGUAGE: Python
CODE:
```
{!> ../../docs_src/python_types/tutorial013.py!}
```

----------------------------------------

TITLE: Define SQLModel Hero Class
DESCRIPTION: Defines a SQLModel 'Hero' class that represents a table in the SQL database. It includes fields like 'id' (primary key), 'name' (indexed), 'secret_name', and 'age' (indexed), demonstrating how to map Python types to SQL column types and define constraints.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/sql-databases.md#_snippet_1

LANGUAGE: python
CODE:
```
from typing import Optional

from sqlmodel import Field, SQLModel


class Hero(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(index=True)
    secret_name: str
    age: Optional[int] = Field(default=None, index=True)
```

----------------------------------------

TITLE: List Field Declaration
DESCRIPTION: This code snippet demonstrates how to declare a list field in a Pydantic model. The `tags` attribute is defined as a `list`, but the type of elements within the list is not specified.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/body-nested-models.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: list = []
```

----------------------------------------

TITLE: Example JSON request body with multiple models and singular value
DESCRIPTION: Shows the expected JSON structure for a FastAPI path operation that combines multiple Pydantic models (`item`, `user`) with an additional singular value (`importance`) directly within the same request body.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-multiple-params.md#_snippet_5

LANGUAGE: JSON
CODE:
```
{
    "item": {
        "name": "Foo",
        "description": "The pretender",
        "price": 42.0,
        "tax": 3.2
    },
    "user": {
        "username": "dave",
        "full_name": "Dave Grohl"
    },
    "importance": 5
}
```

----------------------------------------

TITLE: FastAPI Query Parameter Default Value with Annotated
DESCRIPTION: Illustrates the correct and incorrect ways to define default values for query parameters when using `Annotated` with `Query`. It highlights that the function parameter's default value should be used, not `Query`'s `default` argument, to avoid ambiguity. Also shows the older style without `Annotated`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params-str-validations.md#_snippet_3

LANGUAGE: Python
CODE:
```
q: Annotated[str, Query(default="rick")] = "morty"
```

LANGUAGE: Python
CODE:
```
q: Annotated[str, Query()] = "rick"
```

LANGUAGE: Python
CODE:
```
q: str = Query(default="rick")
```

----------------------------------------

TITLE: Creating an Enum Class for Path Parameters in FastAPI
DESCRIPTION: This code snippet demonstrates how to create an Enum class in Python to define a set of valid string values for a path parameter in a FastAPI application.  It inherits from both `str` and `Enum` to ensure the values are strings and part of the enumeration. The `Enum` is used to restrict the possible values of a path parameter.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/id/docs/tutorial/path-params.md#_snippet_4

LANGUAGE: python
CODE:
```
from enum import Enum


class ModelName(str, Enum):
    alexnet = "alexnet"
    resnet = "resnet"
    lenet = "lenet"
```

----------------------------------------

TITLE: Python Import Equivalent for Uvicorn Command
DESCRIPTION: Illustrates the Python import statement equivalent to how Uvicorn locates the FastAPI application object (`app`) within the `main.py` module. This clarifies the `main:app` syntax used in the Uvicorn command-line interface.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/deployment/manually.md#_snippet_3

LANGUAGE: Python
CODE:
```
from main import app
```

----------------------------------------

TITLE: Understanding Single-Dot Relative Import
DESCRIPTION: Illustrates the use of a single dot (`.`) in Python relative imports, indicating a module within the same package. This example shows an attempt to import `get_token_header` from a `dependencies` module expected in the same directory as the current file.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/bigger-applications.md#_snippet_1

LANGUAGE: Python
CODE:
```
from .dependencies import get_token_header
```

----------------------------------------

TITLE: FastAPI Application with Tags
DESCRIPTION: This example demonstrates a FastAPI application that uses tags to separate different groups of path operations, specifically for 'items' and 'users'. It shows how to define tags in the FastAPI application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/advanced/generate-clients.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/items/{item_id}", tags=["items"])
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.post("/items/", tags=["items"])
async def create_item(name: str, price: float):
    return {"name": name, "price": price}


@app.get("/users/{user_id}", tags=["users"])
async def read_user(user_id: int, q: Union[str, None] = None):
    return {"user_id": user_id, "q": q}


@app.post("/users/", tags=["users"])
async def create_user(name: str, age: int):
    return {"name": name, "age": age}
```

----------------------------------------

TITLE: Define Pydantic Model with HttpUrl Type
DESCRIPTION: Illustrates the use of Pydantic's `HttpUrl` type for an attribute, which automatically validates if the input string is a valid URL and provides appropriate documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-nested-models.md#_snippet_7

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel, HttpUrl

class Image(BaseModel):
    url: HttpUrl
    name: str
```

----------------------------------------

TITLE: Define PUT Request with Pydantic Model in FastAPI
DESCRIPTION: This code defines a PUT endpoint `/items/{item_id}` in a FastAPI application that accepts a request body of type `Item`, which is a Pydantic model. The `Item` model defines the expected structure of the request body, including fields like `name`, `price`, and `is_offer`. The function `update_item` handles the PUT request and returns a dictionary containing the item's name and ID.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/index.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}
```

----------------------------------------

TITLE: Defining a Pydantic Model in Python
DESCRIPTION: This code defines a Pydantic model named `User` with type annotations for its attributes (id, name, joined). Pydantic uses these type hints to perform data validation and serialization. The example demonstrates how to create instances of the `User` model using both direct instantiation and dictionary unpacking.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fa/docs/features.md#_snippet_1

LANGUAGE: Python
CODE:
```
# A Pydantic model
class User(BaseModel):
    id: int
    name: str
    joined: date
```

----------------------------------------

TITLE: Testing FastAPI App in test_main.py
DESCRIPTION: This snippet demonstrates how to test a FastAPI application when the app is defined in a separate `main.py` file. It imports the `app` instance using relative imports and then uses TestClient to send a request and assert the response.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/testing.md#_snippet_3

LANGUAGE: Python
CODE:
```
from fastapi.testclient import TestClient

from .main import app


client = TestClient(app)


def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"Hello": "World"}
```

----------------------------------------

TITLE: FastAPI Endpoint Using Pydantic Model as Input
DESCRIPTION: Demonstrates a FastAPI `POST` endpoint (`/items/`) that accepts an `Item` Pydantic model as input. This example highlights how the `description` field, having a default `None` value, is considered optional for input, affecting the generated OpenAPI schema.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/how-to/separate-openapi-schemas.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


app = FastAPI()


@app.post("/items/")
async def create_item(item: Item):
    return item
```

----------------------------------------

TITLE: Using Depends in WebSocket Endpoints
DESCRIPTION: Demonstrates how to use the `Depends` function to inject dependencies into a WebSocket endpoint.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/advanced/websockets.md#_snippet_6

LANGUAGE: Python
CODE:
```
async def get_cookie_or_token(websocket: WebSocket, cookie: Optional[str] = Cookie(None), token: Optional[str] = None):
    if cookie is None and token is None:
        raise WebSocketException(code=1008, reason="No cookies or token received")
    if cookie:
        return cookie
    return token

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket, q: Optional[str] = None, cookie_or_token: str = Depends(get_cookie_or_token)):
    ...
```

----------------------------------------

TITLE: Illustrating Python class instantiation as a callable
DESCRIPTION: This example demonstrates that a Python class itself is a callable, as its instantiation (`Cat(name="Mr Fluffy")`) uses function-like call syntax. This property allows FastAPI to treat classes as dependencies, processing their `__init__` parameters.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/dependencies/classes-as-dependencies.md#_snippet_1

LANGUAGE: Python
CODE:
```
class Cat:
    def __init__(self, name: str):
        self.name = name


fluffy = Cat(name="Mr Fluffy")
```

----------------------------------------

TITLE: List Field with Type Parameter
DESCRIPTION: This code snippet demonstrates how to declare a list field with a specific type parameter (string) in a Pydantic model. The `tags` attribute is defined as a `list` of strings.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/body-nested-models.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: list[str] = []
```

----------------------------------------

TITLE: 의존성 (디펜더블) 생성하기 - Python
DESCRIPTION: 경로 작동 함수가 가질 수 있는 모든 매개변수를 갖는 단순한 함수를 의존성으로 정의합니다. 이 함수는 선택적인 쿼리 매개변수 q, skip, limit을 받아들이고, 이들을 포함하는 dict를 반환합니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/dependencies/index.md#_snippet_0

LANGUAGE: python
CODE:
```
from typing import Optional

from fastapi import Depends, FastAPI

app = FastAPI()


def common_parameters(q: Optional[str] = None, skip: int = 0, limit: int = 100):
    return {"q": q, "skip": skip, "limit": limit}
```

----------------------------------------

TITLE: Declare Request Body Parameter in FastAPI Path Operation
DESCRIPTION: Shows how to integrate the Pydantic `Item` model into a FastAPI path operation function. By type-hinting a function parameter (e.g., `item`) with the `Item` model, FastAPI automatically reads the request body as JSON, validates it against the model's schema, and provides it as a Python object for use within the function.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body.md#_snippet_4

LANGUAGE: Python
CODE:
```
async def create_item(item: Item):
```

----------------------------------------

TITLE: Create a Path Operation for Testing
DESCRIPTION: This snippet creates a simple path operation to test if the custom documentation setup is working correctly. It defines a GET endpoint at the root path that returns a dictionary with a message.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/how-to/custom-docs-ui-assets.md#_snippet_2

LANGUAGE: Python
CODE:
```
@app.get("/")
async def read_root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Declare Dependencies in FastAPI Path Operations
DESCRIPTION: These examples demonstrate how to integrate a dependency function (`common_parameters`) into FastAPI path operations using `Depends`. By assigning `Depends(common_parameters)` to a parameter, FastAPI automatically resolves and injects the result of `common_parameters` into `read_items` and `read_users` functions, promoting code reuse.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/dependencies/index.md#_snippet_2

LANGUAGE: python
CODE:
```
from fastapi import FastAPI, Depends

app = FastAPI()

def common_parameters(q: str | None = None, skip: int = 0, limit: int = 100):
    return {"q": q, "skip": skip, "limit": limit}

@app.get("/items/")
async def read_items(commons: dict = Depends(common_parameters)):
    return commons

@app.get("/users/")
async def read_users(commons: dict = Depends(common_parameters)):
    return commons
```

----------------------------------------

TITLE: Declaring a Class as a Type
DESCRIPTION: Demonstrates how to declare a class as a type for a variable in Python. This allows for editor support and type checking when working with instances of the class.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_16

LANGUAGE: Python
CODE:
```
class Person:
    def __init__(self, name: str):
        self.name = name
```

----------------------------------------

TITLE: Declare Single Body Parameter with Key
DESCRIPTION: Illustrates how to use the `embed` parameter of `Body` to specify that a single body parameter should be expected within a JSON with a specific key. This is similar to how multiple body parameters are handled.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/body-multiple-params.md#_snippet_4

LANGUAGE: Python
CODE:
```
@app.put("/items/{item_id}")
async def update_item(
    item_id: int,
    item: Item = Body(embed=True),
):
    results = {"item_id": item_id, "item": item}
    return results
```

----------------------------------------

TITLE: Type Hints for Function Return Values and Static Analysis
DESCRIPTION: This example illustrates the use of type hints for function return values, enabling static analysis tools to detect potential type mismatches. It shows how a tool can flag an error when an integer is incorrectly concatenated with a string.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/python-types.md#_snippet_2

LANGUAGE: Python
CODE:
```
{!../../docs_src/python_types/tutorial003.py!}
```

----------------------------------------

TITLE: Python: Example Usage of functools.lru_cache
DESCRIPTION: This simple Python function demonstrates the behavior of `@lru_cache`. When applied to a function, `lru_cache` caches the results of function calls based on their arguments. Subsequent calls with the same arguments return the cached result without re-executing the function body.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/advanced/settings.md#_snippet_9

LANGUAGE: Python
CODE:
```
from functools import lru_cache

@lru_cache
def say_hi(name: str, salutation: str = "Ms."):
    return f"Hello {salutation} {name}"
```

----------------------------------------

TITLE: Define a Synchronous Function in Python
DESCRIPTION: Shows a standard synchronous function definition using `def`. This type of function executes sequentially and blocks the program's execution until it completes, unlike asynchronous functions.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh-hant/docs/async.md#_snippet_2

LANGUAGE: Python
CODE:
```
# This is not asynchronous
def get_sequential_burgers(number: int):
    # Do some sequential stuff to create the burgers
    return burgers
```

----------------------------------------

TITLE: Declaring a Complex Object Type
DESCRIPTION: This snippet shows how to declare a more complex object type, such as an `Item`, in FastAPI. This allows FastAPI to validate and convert data for complex JSON structures.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pl/docs/index.md#_snippet_8

LANGUAGE: Python
CODE:
```
item: Item
```

----------------------------------------

TITLE: Importing FastAPI Class in Python
DESCRIPTION: This code snippet demonstrates how to import the FastAPI class from the fastapi library. The FastAPI class provides all the necessary functionality for building an API.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/first-steps.md#_snippet_2

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
```

----------------------------------------

TITLE: Install FastAPI without Optional Dependencies
DESCRIPTION: Shows the command to install FastAPI with only its core dependencies, excluding any optional packages for a minimal setup.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/index.md#_snippet_14

LANGUAGE: Python
CODE:
```
pip install fastapi
```

----------------------------------------

TITLE: Declaring an Optional Type - Python 3.10+
DESCRIPTION: This snippet declares a variable `name` that can be either a string or None using the union operator `|`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_15

LANGUAGE: Python
CODE:
```
name: str | None = "Guido"
```

----------------------------------------

TITLE: Run FastAPI Development Server with Auto-Reload
DESCRIPTION: This console command initiates the FastAPI development server using `fastapi dev main.py`. It automatically detects changes in `main.py` and reloads the application, providing a convenient workflow for local development. The output shows the server's local address and links to the API documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/id/docs/index.md#_snippet_2

LANGUAGE: Console
CODE:
```
$ fastapi dev main.py

 ╭────────── FastAPI CLI - Development mode ───────────╮
 │                                                     │
 │  Serving at: http://127.0.0.1:8000                  │
 │                                                     │
 │  API docs: http://127.0.0.1:8000/docs               │
 │                                                     │
 │  Running in development mode, for production use:   │
 │                                                     │
 │  fastapi run                                        │
 │                                                     │
 ╰─────────────────────────────────────────────────────╯

INFO:     Will watch for changes in these directories: ['/home/user/code/awesomeapp']
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process [2248755] using WatchFiles
INFO:     Started server process [2248757]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

----------------------------------------

TITLE: FastAPI/Starlette TrustedHostMiddleware API
DESCRIPTION: API documentation for `TrustedHostMiddleware`, which protects against HTTP Host Header attacks by validating the `Host` header against a list of allowed domains. This middleware is crucial for securing applications against certain types of web vulnerabilities.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/middleware.md#_snippet_5

LANGUAGE: APIDOC
CODE:
```
TrustedHostMiddleware:
  __init__(app: ASGIApp, allowed_hosts: List[str])
    app: The ASGI application instance.
    allowed_hosts: A list of domain names that should be allowed as hostnames. Wildcard domains such as "*.example.com" are supported for matching subdomains. To allow any hostname, use allowed_hosts=["*"] or omit the middleware.
  Behavior:
    - If an incoming request does not validate correctly, a 400 Bad Request response will be sent.
```

----------------------------------------

TITLE: Query Parameters with Defaults in FastAPI (Python)
DESCRIPTION: This code snippet demonstrates how to define query parameters with default values in a FastAPI endpoint. The `skip` parameter defaults to 0 and the `limit` parameter defaults to 10.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/tr/docs/tutorial/query-params.md#_snippet_0

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/items/")
async def read_items(skip: int = 0, limit: int = 10):
    return {"skip": skip, "limit": limit}
```

----------------------------------------

TITLE: Example Python Data with Non-Default Values
DESCRIPTION: Presents a Python dictionary representing data where some fields (`description`, `tax`) have values different from their Pydantic model defaults. This demonstrates that such fields will always be included in the response, even with `response_model_exclude_unset=True`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/response-model.md#_snippet_12

LANGUAGE: Python
CODE:
```
{
    "name": "Bar",
    "description": "The bartenders",
    "price": 62,
    "tax": 20.2
}
```

----------------------------------------

TITLE: Define Path Operation Function (Sync)
DESCRIPTION: This is a path operation function defined as a regular Python function instead of an async function. FastAPI will call it every time it receives a request to the URL / using a GET operation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/first-steps.md#_snippet_6

LANGUAGE: Python
CODE:
```
def root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Install passlib with bcrypt
DESCRIPTION: Installs the passlib library with the bcrypt extra, which is used for handling password hashing securely in Python. Bcrypt is the recommended algorithm.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/security/oauth2-jwt.md#_snippet_1

LANGUAGE: console
CODE:
```
$ pip install passlib[bcrypt]

---> 100%
```

----------------------------------------

TITLE: Expected JSON Body with Embedded Item
DESCRIPTION: This JSON snippet shows the expected structure of the request body when the `embed` parameter is set to `True`. The `Item` model's data is nested under the 'item' key.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/tutorial/body-multiple-params.md#_snippet_5

LANGUAGE: JSON
CODE:
```
{
    "item": {
        "name": "Foo",
        "description": "The pretender",
        "price": 42.0,
        "tax": 3.2
    }
}
```

----------------------------------------

TITLE: Install FastAPI with Standard Dependencies
DESCRIPTION: This command installs FastAPI along with a comprehensive set of standard optional dependencies. These include 'email-validator' for Pydantic, 'httpx', 'jinja2', 'python-multipart' for Starlette, and 'uvicorn' with 'fastapi-cli[standard]' for FastAPI's server and command-line interface.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/index.md#_snippet_9

LANGUAGE: Shell
CODE:
```
pip install "fastapi[standard]"
```

----------------------------------------

TITLE: Defining a Sub-Model
DESCRIPTION: This code snippet defines a Pydantic sub-model named `Image` with `url` and `name` attributes. This model can be used as a type for other model attributes, enabling nested data structures.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/body-nested-models.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel


class Image(BaseModel):
    url: str
    name: str
```

----------------------------------------

TITLE: Dependency with yield and try/finally
DESCRIPTION: Illustrates how to use `try` and `finally` blocks within a dependency that uses `yield` to handle exceptions and ensure that cleanup code is always executed, regardless of whether an exception occurs.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/dependencies/dependencies-with-yield.md#_snippet_1

LANGUAGE: python
CODE:
```
db = DBSession()
try:
    yield db
except SomeException:
    db.rollback()
finally:
    db.close()
```

----------------------------------------

TITLE: Creating a FastAPI Instance
DESCRIPTION: This code snippet shows how to create an instance of the FastAPI class. This instance is used to define the API endpoints.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/first-steps.md#_snippet_2

LANGUAGE: python
CODE:
```
app = FastAPI()
```

----------------------------------------

TITLE: Pydantic model instantiering
DESCRIPTION: Demonstreert hoe een Pydantic model `User` wordt geïnstantieerd met data. De eerste instantie gebruikt keyword argumenten, de tweede gebruikt een dictionary die wordt uitgepakt met `**` om de argumenten door te geven.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/nl/docs/features.md#_snippet_2

LANGUAGE: Python
CODE:
```
my_user: User = User(id=3, name="John Doe", joined="2018-07-19")

second_user_data = {
    "id": 4,
    "name": "Mary",
    "joined": "2018-11-30",
}

my_second_user: User = User(**second_user_data)
```

----------------------------------------

TITLE: Install and Run FastAPI Development Server with CLI
DESCRIPTION: Demonstrates how to install FastAPI and use the new `fastapi dev` command to start a development server. The output shows the server address, API documentation URL, and notes about development mode versus production (`fastapi run`).

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_8

LANGUAGE: Shell
CODE:
```
$ pip install --upgrade fastapi

$ fastapi dev main.py


 ╭────────── FastAPI CLI - Development mode ───────────╮
 │                                                     │
 │  Serving at: http://127.0.0.1:8000                  │
 │                                                     │
 │  API docs: http://127.0.0.1:8000/docs               │
 │                                                     │
 │  Running in development mode, for production use:   │
 │                                                     │
 │  fastapi run                                        │
 │                                                     │
 ╰─────────────────────────────────────────────────────╯

INFO:     Will watch for changes in these directories: ['/home/user/code/awesomeapp']
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process [2248755] using WatchFiles
INFO:     Started server process [2248757]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

----------------------------------------

TITLE: FastAPI Dependency Shorthand with `Depends()`
DESCRIPTION: Explains and demonstrates the shorthand syntax for `Depends()`. When the dependency type is already specified in the type hint (e.g., `commons: CommonQueryParams`), `Depends()` can be used without explicitly passing the class, making the code more concise and readable.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/dependencies/classes-as-dependencies.md#_snippet_4

LANGUAGE: Python
CODE:
```
commons: CommonQueryParams = Depends(CommonQueryParams)
```

LANGUAGE: Python
CODE:
```
commons = Depends(CommonQueryParams)
```

LANGUAGE: Python
CODE:
```
commons: CommonQueryParams = Depends()
```

LANGUAGE: Python
CODE:
```
@app.get("/items/")
async def read_items(commons: CommonQueryParams = Depends()):
    return {"q": commons.q, "skip": commons.skip, "limit": commons.limit}
```

----------------------------------------

TITLE: Conceptual Example: Adding Third-Party ASGI Middleware
DESCRIPTION: Illustrates the general pattern for integrating a third-party ASGI middleware, where the middleware class wraps an existing ASGI application. This is a conceptual example showing how such middlewares are typically designed to receive an ASGI app as their first argument.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/middleware.md#_snippet_0

LANGUAGE: Python
CODE:
```
from unicorn import UnicornMiddleware

app = SomeASGIApp()

new_app = UnicornMiddleware(app, some_config="rainbow")
```

----------------------------------------

TITLE: Configure FastAPI APIRouter with Shared Settings
DESCRIPTION: This snippet demonstrates how to initialize an `APIRouter` instance with common settings like a `prefix`, `tags`, `responses`, and `dependencies`. This approach centralizes configuration for a group of routes, reducing boilerplate and ensuring consistency across related endpoints.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/bigger-applications.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import APIRouter, Depends, HTTPException, status
from app.dependencies import get_x_token

router = APIRouter(
    prefix="/items",
    tags=["items"],
    responses={404: {"description": "Not found"}},
    dependencies=[Depends(get_x_token)],
)

@router.get("/")
async def read_items():
    return ["Portal gun", "Plumbus"]

@router.get("/{item_id}")
async def read_item(item_id: str):
    return {"item_id": item_id}
```

----------------------------------------

TITLE: Single Values in Body with FastAPI
DESCRIPTION: This example shows how to include a single value in the request body alongside Pydantic models using the `Body` parameter. FastAPI will expect a JSON body containing the item, user, and importance.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/body-multiple-params.md#_snippet_2

LANGUAGE: Python
CODE:
```
@app.post("/items/")
async def create_item(
    item: Item,
    user: User,
    importance: int = Body(gt=0),
):
    return {"item": item, "user": user, "importance": importance}
```

----------------------------------------

TITLE: Dict 타입 힌트 예제
DESCRIPTION: 이 예제는 `dict`에 대한 타입 힌트를 선언하는 방법을 보여줍니다. `typing` 모듈을 사용하여 키와 값의 타입을 지정할 수 있습니다.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/python-types.md#_snippet_7

LANGUAGE: python
CODE:
```
from typing import Dict
```

LANGUAGE: python
CODE:
```
prices: Dict[str, float]
```

----------------------------------------

TITLE: WebSocket Endpoint with Dependencies
DESCRIPTION: Shows how to use dependencies, security, and other FastAPI features within a WebSocket endpoint. Includes examples of using `Depends` and raising `WebSocketException`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/advanced/websockets.md#_snippet_5

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import Cookie, Depends, FastAPI, Header, WebSocket, WebSocketException

app = FastAPI()

async def get_cookie_or_token(websocket: WebSocket, cookie: Optional[str] = Cookie(None), token: Optional[str] = None):
    if cookie is None and token is None:
        raise WebSocketException(code=1008, reason="No cookies or token received")
    if cookie:
        return cookie
    return token

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket, q: Optional[str] = None, cookie_or_token: str = Depends(get_cookie_or_token)):
    await websocket.accept()
    while True:
        data = await websocket.receive_text()
        await websocket.send_text(f"Message text was: {data}, query parameter q is: {q}, cookie_or_token is: {cookie_or_token}")
```

----------------------------------------

TITLE: Initializing FastAPI with Global Dependencies
DESCRIPTION: Shows how to initialize the main `FastAPI` application instance and declare global dependencies that apply to all path operations across the application, including those defined in included `APIRouter` instances. This ensures consistent dependency injection.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/bigger-applications.md#_snippet_5

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI, Depends
from .dependencies import get_query_token # Example global dependency

app = FastAPI(dependencies=[Depends(get_query_token)])
```

----------------------------------------

TITLE: Defining a Request Body with Pydantic and Adding a PUT Route
DESCRIPTION: This code defines a Pydantic model `Item` to represent the request body for a PUT request. It then adds a PUT route '/items/{item_id}' that accepts an item_id and an Item object in the request body. The function returns the item name and item ID.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/az/docs/index.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}
```

----------------------------------------

TITLE: Defining a Path Operation Function (Sync)
DESCRIPTION: This code snippet shows how to define a synchronous path operation function. This function will be called whenever FastAPI receives a GET request to the `/` URL. It returns a dictionary that will be converted to JSON.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/first-steps.md#_snippet_5

LANGUAGE: python
CODE:
```
def root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Python File Handling with `with` Statement
DESCRIPTION: Demonstrates the use of Python's `with` statement for safe file handling. The `open()` function returns a context manager, ensuring that the file is automatically closed upon exiting the `with` block, even if errors occur.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/dependencies/dependencies-with-yield.md#_snippet_1

LANGUAGE: python
CODE:
```
with open("./somefile.txt") as f:
    contents = f.read()
    print(contents)
```

----------------------------------------

TITLE: Import HTTPException in FastAPI
DESCRIPTION: This snippet shows how to import the `HTTPException` class from the `fastapi` library, which is the primary tool for raising HTTP errors in your application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/handling-errors.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import HTTPException
```

----------------------------------------

TITLE: JSON Response Example
DESCRIPTION: Example JSON response from the /items/{item_id} endpoint with a query parameter.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/deployment/docker.md#_snippet_4

LANGUAGE: JSON
CODE:
```
{"item_id": 5, "q": "somequery"}
```

----------------------------------------

TITLE: Python File Handling with Context Manager
DESCRIPTION: This snippet demonstrates the use of a Python `with` statement to open and read a file. The `with` statement ensures that the file is automatically closed after the block is exited, even if exceptions occur, showcasing a fundamental application of context managers.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/dependencies/dependencies-with-yield.md#_snippet_5

LANGUAGE: Python
CODE:
```
with open("./somefile.txt") as f:
    contents = f.read()
    print(contents)
```

----------------------------------------

TITLE: Using a Sub-Model as a Type
DESCRIPTION: This code snippet demonstrates how to use the `Image` sub-model as a type for an attribute in another Pydantic model (`Item`). This allows for nested JSON objects with specific attribute names, types, and validations.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/body-nested-models.md#_snippet_5

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel


class Image(BaseModel):
    url: str
    name: str


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: list[str] = []
    image: Optional[Image] = None
```

----------------------------------------

TITLE: FastAPI Dependency Declaration: Explicit Class Reference
DESCRIPTION: This snippet shows the standard method for declaring a class-based dependency in FastAPI. It requires explicitly passing the dependency class (e.g., `CommonQueryParams`) to `Depends()`, leading to some code repetition. Both `Annotated` and non-`Annotated` syntax are provided.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/dependencies/classes-as-dependencies.md#_snippet_7

LANGUAGE: Python
CODE:
```
commons: Annotated[CommonQueryParams, Depends(CommonQueryParams)]
```

LANGUAGE: Python
CODE:
```
commons: CommonQueryParams = Depends(CommonQueryParams)
```

----------------------------------------

TITLE: FastAPI Test File
DESCRIPTION: This example shows how to create a test file (test_main.py) to test the FastAPI application defined in main.py. It imports the app object from main.py using relative imports.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/testing.md#_snippet_3

LANGUAGE: Python
CODE:
```
from fastapi.testclient import TestClient

from .main import app


client = TestClient(app)


def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"msg": "Hello World"}
```

----------------------------------------

TITLE: Using a Nested Model as a Type
DESCRIPTION: Shows how to use the `Image` model as a type for the `image` attribute in the `Item` model. This allows for nested JSON objects with specific attribute names, types, and validation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/body-nested-models.md#_snippet_5

LANGUAGE: Python
CODE:
```
from typing import Optional

from pydantic import BaseModel


class Image(BaseModel):
    url: str
    name: str


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None
    tags: set[str] = set()
    image: Optional[Image] = None
```

----------------------------------------

TITLE: Dependency with yield and raise
DESCRIPTION: Demonstrates how to properly re-raise an exception caught in the `except` block of a dependency using `yield`. This ensures that FastAPI is aware of the error and can handle it appropriately.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/dependencies/dependencies-with-yield.md#_snippet_5

LANGUAGE: python
CODE:
```
async def dependency_a():
    try:
        yield
    except InternalError:
        raise
```

----------------------------------------

TITLE: Understanding Triple-Dot Relative Import (Invalid Example)
DESCRIPTION: Demonstrates an invalid use of triple dots (`...`) in Python relative imports. This attempts to import from a grandparent package, which is not applicable in the given FastAPI application structure, leading to an import error as the target package does not exist.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/bigger-applications.md#_snippet_3

LANGUAGE: Python
CODE:
```
from ...dependencies import get_token_header
```

----------------------------------------

TITLE: Ordering Path and Query Parameters
DESCRIPTION: This code snippet shows how to order path and query parameters in a FastAPI function. It demonstrates that FastAPI can detect parameters by their names, types, and default definitions, regardless of their order.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/path-params-numeric-validations.md#_snippet_2

LANGUAGE: python
CODE:
```
from fastapi import FastAPI

app = FastAPI()


@app.get("/items/{item_id}")
async def read_items(item_id: int, q: str):
    return {"item_id": item_id, "q": q}
```

----------------------------------------

TITLE: Initialize FastAPI Application and Include Routers
DESCRIPTION: Shows the main application file (`main.py`) where the `FastAPI` instance is created and `APIRouter` instances from different modules (e.g., `items`, `users`) are included using `app.include_router()`. This demonstrates how to aggregate routes from various parts of a larger application into a single main application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/bigger-applications.md#_snippet_8

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

from .routers import items, users

app = FastAPI()

app.include_router(items.router)
app.include_router(users.router)
```

----------------------------------------

TITLE: Return Content from FastAPI Route
DESCRIPTION: Demonstrates returning a dictionary from a FastAPI route function. FastAPI automatically converts dictionaries, lists, and singular values to JSON responses.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/first-steps.md#_snippet_6

LANGUAGE: Python
CODE:
```
return {"message": "Hello World"}
```

----------------------------------------

TITLE: Declare typed path parameters in FastAPI
DESCRIPTION: Illustrates how to add type annotations to path parameters in FastAPI. This enables automatic data conversion (e.g., string to integer) and provides enhanced editor support, including error checking and code completion, improving development efficiency.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/path-params.md#_snippet_2

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/items/{item_id}")
async def read_item(item_id: int):
    return {"item_id": item_id}
```

----------------------------------------

TITLE: Importing HTTPException in FastAPI
DESCRIPTION: This code snippet demonstrates how to import the HTTPException class from the fastapi module. HTTPException is used to raise HTTP exceptions within FastAPI applications.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/handling-errors.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi import HTTPException
```

----------------------------------------

TITLE: FastAPI Asynchronous Function Handling
DESCRIPTION: This section details how FastAPI processes different types of functions (path operations, dependencies, sub-dependencies, and other utility functions) based on whether they are defined with `async def` or `def`. It explains the performance implications and FastAPI's internal mechanisms, such as using a thread pool for synchronous functions to prevent blocking the main event loop.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/async.md#_snippet_2

LANGUAGE: APIDOC
CODE:
```
FastAPI Function Handling:

Path Operation Functions:
  - async def: Runs directly in the event loop. Ideal for I/O-bound operations (e.g., database queries, network requests).
  - def: Runs in a separate thread pool. Use for CPU-bound operations or blocking I/O to avoid blocking the main event loop.

Dependencies:
  - async def: Runs directly in the event loop.
  - def: Runs in a separate thread pool.

Sub-dependencies:
  - Can mix async def and def. def sub-dependencies will be executed in a thread pool.

Other Utility Functions:
  - def: Called directly by your code; no threading is applied by FastAPI.
  - async def: Must be explicitly `await`ed by your calling code.
```

----------------------------------------

TITLE: Expected JSON Payload for Nested Model
DESCRIPTION: An example of the JSON structure that FastAPI expects when a Pydantic model includes another Pydantic model as a nested attribute.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-nested-models.md#_snippet_6

LANGUAGE: JSON
CODE:
```
{
    "name": "Foo",
    "description": "The pretender",
    "price": 42.0,
    "tax": 3.2,
    "tags": ["rock", "metal", "bar"],
    "image": {
        "url": "http://example.com/baz.jpg",
        "name": "The Foo live"
    }
}
```

----------------------------------------

TITLE: Declaring a Complex Item Model in FastAPI
DESCRIPTION: This code snippet shows how to declare a more complex item model in FastAPI using Python type hints. The `item: Item` syntax indicates that the `item` parameter should be an instance of the `Item` class.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/he/docs/index.md#_snippet_6

LANGUAGE: Python
CODE:
```
item: Item
```

----------------------------------------

TITLE: Declaring Variables with Type Hints in Python
DESCRIPTION: This code demonstrates how to declare a variable with a type hint in Python using standard Python type declarations. It allows for editor support inside the function.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/features.md#_snippet_0

LANGUAGE: Python
CODE:
```
from datetime import date

from pydantic import BaseModel

# Declare a variable as a str
# and get editor support inside the function
def main(user_id: str):
    return user_id


# A Pydantic model
class User(BaseModel):
    id: int
    name: str
    joined: date
```

----------------------------------------

TITLE: FastAPI Dependency with Yield and Implicit Exception Handling (Old Behavior)
DESCRIPTION: This code demonstrates the previous behavior of FastAPI dependencies using `yield` where exceptions caught within a `try...except` block were not required to be re-raised. This pattern, while seemingly convenient, could lead to unhandled memory issues if exceptions were silently consumed.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_9

LANGUAGE: Python
CODE:
```
def my_dep():
    try:
        yield
    except SomeException:
        pass
```

----------------------------------------

TITLE: Define Path Operation Function (Async)
DESCRIPTION: This is a path operation function. FastAPI will call it every time it receives a request to the URL / using a GET operation. This example uses an async function.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/first-steps.md#_snippet_5

LANGUAGE: Python
CODE:
```
async def root():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Getting Enum Value in FastAPI (Python)
DESCRIPTION: This snippet shows how to retrieve the actual value (a string in this case) from an Enum member using `.value`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/path-params.md#_snippet_7

LANGUAGE: Python
CODE:
```
return {"model_name": model_name, "message": "Have some residuals", "value": model_name.value}
```

----------------------------------------

TITLE: FastAPI Path Parameter Numeric Validation: Floats with Greater Than and Less Than
DESCRIPTION: This snippet illustrates applying numeric validations to a `float` path parameter. It uses 'greater than' (`gt`) and 'less than' (`lt`) to ensure the `item_id` is a float strictly between 0 and 1 (e.g., 0.5 is valid, but 0.0 or 1.0 are not).

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/path-params-numeric-validations.md#_snippet_6

LANGUAGE: Python
CODE:
```
from typing import Annotated
from fastapi import FastAPI, Path

app = FastAPI()

@app.get("/items/{item_id}")
async def read_items(
    item_id: Annotated[float, Path(title="The ID of the item to get", gt=0, lt=1)]
):
    return {"item_id": item_id}
```

----------------------------------------

TITLE: Translating Warning Blocks
DESCRIPTION: This snippet demonstrates the translation of a 'warning' block. The English term 'warning' is translated to 'Advertencia' in Spanish, separated by a vertical bar.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/llm-prompt.md#_snippet_3

LANGUAGE: Text
CODE:
```
/// warning | Advertencia
```

----------------------------------------

TITLE: PATH Variable Example (Linux, macOS)
DESCRIPTION: This is an example of how the PATH environment variable might look on Linux and macOS systems. It consists of a series of directories separated by colons.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/environment-variables.md#_snippet_6

LANGUAGE: plaintext
CODE:
```
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

----------------------------------------

TITLE: Import FastAPI Response Class
DESCRIPTION: This snippet demonstrates the standard way to import the `Response` class from the `fastapi` library, enabling its use for custom HTTP response handling within FastAPI applications.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/reference/response.md#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi import Response
```

----------------------------------------

TITLE: FastAPI Query Parameter List and Multiple Values
DESCRIPTION: Illustrates how to define a query parameter (`q`) that accepts multiple values from the URL, which FastAPI automatically collects into a Python list. This example uses Python 3.10+ type hints (`list[str] | None`). It also includes an example JSON response demonstrating the collected list.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params-str-validations.md#_snippet_7

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI, Query

app = FastAPI()

@app.get("/items/")
async def read_items(q: list[str] | None = Query(default=None)):
    return {"q": q}
```

LANGUAGE: JSON
CODE:
```
{
  "q": [
    "foo",
    "bar"
  ]
}
```

----------------------------------------

TITLE: Compare HTTP GET operations: Requests client vs. FastAPI server
DESCRIPTION: This snippet demonstrates the design philosophy shared between the 'requests' library for making HTTP requests (client-side) and FastAPI for defining API endpoints (server-side). Both aim for an intuitive API where HTTP method names are directly used for operations, showcasing a parallel in their approach to handling GET requests.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/alternatives.md#_snippet_0

LANGUAGE: Python
CODE:
```
response = requests.get("http://example.com/some/url")
```

LANGUAGE: Python
CODE:
```
@app.get("/some/url")
def read_url():
    return {"message": "Hello World"}
```

----------------------------------------

TITLE: Variable of Type Class
DESCRIPTION: Shows how to declare a variable with the type of a previously defined class. This enables type hinting and editor support for the variable.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/python-types.md#_snippet_17

LANGUAGE: Python
CODE:
```
some_person: Person = Person(name="John")
```

----------------------------------------

TITLE: FastAPI Built-in Response Classes Reference
DESCRIPTION: Comprehensive documentation for various built-in `Response` classes available in FastAPI (mostly from Starlette). This includes the base `Response` class and its parameters, `HTMLResponse`, `PlainTextResponse`, `JSONResponse`, and `ORJSONResponse`, detailing their purpose and usage.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/advanced/custom-response.md#_snippet_6

LANGUAGE: APIDOC
CODE:
```
Response:
  __init__(content: Union[str, bytes], status_code: int = 200, headers: Optional[Dict[str, str]] = None, media_type: Optional[str] = None)
    - Base class for all responses.
    - Parameters:
      - content: The response body, as a string or bytes.
      - status_code: The HTTP status code (e.g., 200, 404).
      - headers: A dictionary of HTTP headers.
      - media_type: The media type (Content-Type) of the response, e.g., "text/html", "application/json".
    - FastAPI (Starlette) automatically adds Content-Length and Content-Type (with charset for text types).

HTMLResponse:
  __init__(content: Union[str, bytes], status_code: int = 200, headers: Optional[Dict[str, str]] = None)
    - Returns an HTML response with 'text/html' media type.
    - Inherits parameters from Response.

PlainTextResponse:
  __init__(content: Union[str, bytes], status_code: int = 200, headers: Optional[Dict[str, str]] = None)
    - Returns a plain text response with 'text/plain' media type.
    - Inherits parameters from Response.

JSONResponse:
  __init__(content: Any, status_code: int = 200, headers: Optional[Dict[str, str]] = None, media_type: Optional[str] = None)
    - Returns a JSON response with 'application/json' media type.
    - This is the default response type in FastAPI.
    - 'content' is automatically serialized to JSON.

ORJSONResponse:
  __init__(content: Any, status_code: int = 200, headers: Optional[Dict[str, str]] = None, media_type: Optional[str] = None)
    - A faster alternative to JSONResponse using the 'orjson' library.
    - Requires 'orjson' to be installed (`pip install orjson`).
    - Returns a JSON response with 'application/json' media type.
    - 'content' is automatically serialized to JSON using orjson.
```

----------------------------------------

TITLE: Example JSON Data with Explicitly Set Default Values
DESCRIPTION: Illustrates a JSON data structure where fields that also have default values in the Pydantic model are explicitly provided. FastAPI and Pydantic are designed to include these in the response even if they match defaults, as they were explicitly set by the client or application logic.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/response-model.md#_snippet_15

LANGUAGE: JSON
CODE:
```
{
    "name": "Bar",
    "description": "The bartenders",
    "price": 62,
    "tax": 20.2
}
```

----------------------------------------

TITLE: Import StaticFiles class from FastAPI
DESCRIPTION: This snippet demonstrates how to import the `StaticFiles` class from the `fastapi.staticfiles` module. This class is essential for configuring and serving static files like CSS, JavaScript, and images within a FastAPI application.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/reference/staticfiles.md#_snippet_0

LANGUAGE: Python
CODE:
```
from fastapi.staticfiles import StaticFiles
```

----------------------------------------

TITLE: Install passlib for password hashing
DESCRIPTION: Installs the `passlib` library with bcrypt support, a comprehensive password hashing framework for Python. This library enables secure storage and verification of user passwords by supporting various hashing algorithms like bcrypt.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/security/oauth2-jwt.md#_snippet_1

LANGUAGE: console
CODE:
```
pip install "passlib[bcrypt]"
```

----------------------------------------

TITLE: Returning a Dictionary with Item Price and ID
DESCRIPTION: This snippet shows the modified version of the return statement, where the item's price is returned instead of the item's name. This change demonstrates IDE auto-completion capabilities.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/index.md#_snippet_6

LANGUAGE: Python
CODE:
```
        ... "item_price": item.price ...
```

----------------------------------------

TITLE: Calling Function with Explicit None for Optional-Typed Parameter
DESCRIPTION: Shows how to correctly call a function where a parameter is type-hinted as `Optional[str]` and is required. Passing `name=None` explicitly is valid, as `None` is allowed by the `Optional` type hint.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/python-types.md#_snippet_8

LANGUAGE: Python
CODE:
```
say_hi(name=None)  # This works, None is valid 🎉
```

----------------------------------------

TITLE: Declare Pydantic Model Example using schema_extra
DESCRIPTION: This method allows adding an example to a Pydantic model's JSON Schema using the `Config` class and `schema_extra` dictionary. This information is then used in the API documentation generated by FastAPI.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/schema-extra-example.md#_snippet_0

LANGUAGE: Python
CODE:
```
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None

    class Config:
        schema_extra = {
            "example": {
                "name": "Foo",
                "description": "A very nice Item",
                "price": 35.4,
                "tax": 3.2
            }
        }
```

----------------------------------------

TITLE: FastAPI: Reusing Annotated Dependencies in Path Operations
DESCRIPTION: This example showcases the benefits of using `Annotated` for dependencies in FastAPI. After defining `CurrentUser` with `Annotated`, it can be directly used as a type hint in path operation functions, eliminating code duplication and maintaining full type information for editor support and runtime validation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_17

LANGUAGE: Python
CODE:
```
CurrentUser = Annotated[User, Depends(get_current_user)]


@app.get("/items/")
def read_items(user: CurrentUser):
    ...


@app.post("/items/")
def create_item(user: CurrentUser, item: Item):
    ...


@app.get("/items/{item_id}")
def read_item(user: CurrentUser, item_id: int):
    ...


@app.delete("/items/{item_id}")
def delete_item(user: CurrentUser, item_id: int):
    ...
```

----------------------------------------

TITLE: Accessing Dependency Values in Cleanup
DESCRIPTION: Shows how a dependency can access the value yielded by another dependency in its cleanup code, ensuring that necessary data is available for cleanup operations.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/dependencies/dependencies-with-yield.md#_snippet_5

LANGUAGE: Python
CODE:
```
async def dependency_b(dep_a=Depends(dependency_a)):
    dep_b = generate_dep_b()
    try:
        yield dep_b
    finally:
        await perform_cleanup_dep_b(dep_b, dep_a)
```

----------------------------------------

TITLE: Example JSON response for typed path parameter
DESCRIPTION: Displays the JSON output when a typed path parameter is used, demonstrating that FastAPI automatically converts the input string from the URL to the specified Python type (e.g., integer) before passing it to the function.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/path-params.md#_snippet_3

LANGUAGE: JSON
CODE:
```
{"item_id":3}
```

----------------------------------------

TITLE: Python 3.10 Union type annotation vs. value
DESCRIPTION: This snippet illustrates the Python 3.10 vertical bar `|` syntax for type annotations. It highlights that while `PlaneItem | CarItem` works for type hints, it cannot be directly assigned as a value to parameters like `response_model` in FastAPI, where `typing.Union` must still be used to avoid invalid operations.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/extra-models.md#_snippet_11

LANGUAGE: Python
CODE:
```
some_variable: PlaneItem | CarItem
```

----------------------------------------

TITLE: Using the Base Response Class in FastAPI
DESCRIPTION: Demonstrates the fundamental usage of the `Response` base class in FastAPI. It allows setting custom content, status code, headers, and media type, providing granular control over the HTTP response.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/advanced/custom-response.md#_snippet_4

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI, Response

app = FastAPI()

@app.get("/custom-response")
async def custom_response():
    content = "This is a custom response."
    return Response(content=content, media_type="text/plain", status_code=200)
```

----------------------------------------

TITLE: FastAPI: Importing Query and Setting Max Length
DESCRIPTION: Shows how to import `Query` from `fastapi` to enable advanced parameter validation. This example demonstrates setting a `max_length` constraint of 50 characters for the optional query parameter `q`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/query-params-str-validations.md#_snippet_1

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import FastAPI, Query

app = FastAPI()


@app.get("/items/")
async def read_items(q: Optional[str] = Query(default=None, max_length=50)):
    results = {"items": [{"item_id": "Foo"}, {"item_id": "Bar"}]}
    if q:
        results.update({"q": q})
    return results
```

----------------------------------------

TITLE: Nested Dependencies with yield
DESCRIPTION: Demonstrates how to use nested dependencies with `yield` in FastAPI, ensuring that exit code in each dependency is executed in the correct order. `dependency_c` depends on `dependency_b`, and `dependency_b` depends on `dependency_a`, and all of them use `yield`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/de/docs/tutorial/dependencies/dependencies-with-yield.md#_snippet_3

LANGUAGE: Python
CODE:
```
async def dependency_a() -> str:
    yield "A"


async def dependency_b(dep_a: str = Depends(dependency_a)) -> str:
    yield f"B {dep_a}"


async def dependency_c(dep_b: str = Depends(dependency_b)) -> str:
    yield f"C {dep_b}"
```

----------------------------------------

TITLE: Pydantic Model Usage Example
DESCRIPTION: This code shows how to create and use a Pydantic model in Python. It demonstrates initializing a model with keyword arguments and from a dictionary using the ** operator.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/features.md#_snippet_1

LANGUAGE: Python
CODE:
```
my_user: User = User(id=3, name="John Doe", joined="2018-07-19")

second_user_data = {
    "id": 4,
    "name": "Mary",
    "joined": "2018-11-30",
}

my_second_user: User = User(**second_user_data)
```

----------------------------------------

TITLE: Define Custom String Validator with Pydantic AfterValidator
DESCRIPTION: Demonstrates how to create a custom validation function using Pydantic's `AfterValidator` and `Annotated` for FastAPI query parameters. This validator checks if a string value starts with one of several predefined prefixes (e.g., 'isbn-' or 'imdb-'), raising a `ValueError` if the condition is not met. This allows for advanced data validation beyond standard type checks.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/query-params-str-validations.md#_snippet_15

LANGUAGE: Python
CODE:
```
from typing import Annotated
from pydantic import AfterValidator

def validate_item_id(v: str) -> str:
    if not v.startswith(("isbn-", "imdb-")):
        raise ValueError("Item ID must start with 'isbn-' or 'imdb-'")
    return v

ItemId = Annotated[str, AfterValidator(validate_item_id)]
```

----------------------------------------

TITLE: JSON Response Example
DESCRIPTION: This JSON snippet shows the expected response from the `/users/me/` endpoint after successful authentication. It includes user details such as username, email, full name, and disabled status.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ja/docs/tutorial/security/oauth2-jwt.md#_snippet_6

LANGUAGE: JSON
CODE:
```
{
  "username": "johndoe",
  "email": "johndoe@example.com",
  "full_name": "John Doe",
  "disabled": false
}
```

----------------------------------------

TITLE: Import Form from FastAPI
DESCRIPTION: To declare form parameters in FastAPI, import the `Form` class from the `fastapi` module. This allows FastAPI to correctly interpret and parse form-encoded data from incoming requests.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/request-forms.md#_snippet_1

LANGUAGE: python
CODE:
```
from fastapi import FastAPI, Form
```

----------------------------------------

TITLE: Python Dict Unpacking Example
DESCRIPTION: Illustrates how to unpack dictionaries in Python to merge them.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/advanced/additional-responses.md#_snippet_6

LANGUAGE: Python
CODE:
```
old_dict = {
    "old key": "old value",
    "second old key": "second old value",
}
new_dict = {**old_dict, "new key": "new value"}
```

LANGUAGE: Python
CODE:
```
{
    "old key": "old value",
    "second old key": "second old value",
    "new key": "new value",
}
```

----------------------------------------

TITLE: Hero Table Model Definition
DESCRIPTION: Defines the `Hero` table model with fields like `id` and `secret_name`, inheriting from `HeroBase`. This model represents the complete structure of the Hero table in the database.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/sql-databases.md#_snippet_10

LANGUAGE: Python
CODE:
```
class Hero(HeroBase, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    secret_name: str
```

----------------------------------------

TITLE: Example User Profile API Response
DESCRIPTION: An example JSON response body for the `/users/me/` endpoint in a FastAPI application, illustrating the typical structure of a user profile object returned after successful authentication and data retrieval.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/security/oauth2-jwt.md#_snippet_4

LANGUAGE: JSON
CODE:
```
{
  "username": "johndoe",
  "email": "johndoe@example.com",
  "full_name": "John Doe",
  "disabled": false
}
```

----------------------------------------

TITLE: FastAPI Request Body Type Hint for List of Pydantic Models
DESCRIPTION: This Python snippet demonstrates how to declare a function parameter in FastAPI to accept a request body that is a JSON array (Python list) of Pydantic models. It uses the `typing.List` generic type for compatibility across Python versions.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/body-nested-models.md#_snippet_11

LANGUAGE: Python
CODE:
```
images: List[Image]
```

----------------------------------------

TITLE: FastAPI User Profile Retrieval Endpoint (`GET /users/me`)
DESCRIPTION: Documents the `/users/me` API endpoint, which allows authenticated users to retrieve their own profile data. It details the successful response structure and common error scenarios for unauthenticated or inactive users, including HTTP status codes, `WWW-Authenticate` header, and error messages.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/security/simple-oauth2.md#_snippet_6

LANGUAGE: APIDOC
CODE:
```
GET /users/me
  Description: Retrieves the profile data for the currently authenticated user.
  Authentication: Bearer Token (required)
  Responses:
    200 OK:
      Description: User data successfully retrieved.
      Body:
        {
          "username": "johndoe",
          "email": "johndoe@example.com",
          "full_name": "John Doe",
          "disabled": false,
          "hashed_password": "fakehashedsecret"
        }
    401 Unauthorized:
      Description: User is not authenticated.
      Body:
        {
          "detail": "Not authenticated"
        }
      Headers:
        WWW-Authenticate: Bearer
    400 Bad Request:
      Description: User is authenticated but inactive.
      Body:
        {
          "detail": "Inactive user"
        }
```

----------------------------------------

TITLE: Import FastAPI Middleware Classes
DESCRIPTION: Demonstrates how to import various middleware classes provided by FastAPI, including CORSMiddleware, GZipMiddleware, HTTPSRedirectMiddleware, TrustedHostMiddleware, and WSGIMiddleware, for use in a FastAPI application. These imports are essential for configuring application-wide behaviors.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/reference/middleware.md#_snippet_0

LANGUAGE: python
CODE:
```
from fastapi.middleware.cors import CORSMiddleware
```

LANGUAGE: python
CODE:
```
from fastapi.middleware.gzip import GZipMiddleware
```

LANGUAGE: python
CODE:
```
from fastapi.middleware.httpsredirect import HTTPSRedirectMiddleware
```

LANGUAGE: python
CODE:
```
from fastapi.middleware.trustedhost import TrustedHostMiddleware
```

LANGUAGE: python
CODE:
```
from fastapi.middleware.wsgi import WSGIMiddleware
```

----------------------------------------

TITLE: Correcting Type Mismatch Using Type Hints
DESCRIPTION: Building on the previous example, this snippet provides the corrected version of the function. It demonstrates how to resolve a type error identified by static analysis by explicitly converting an integer to a string before concatenation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/python-types.md#_snippet_3

LANGUAGE: Python
CODE:
```
{!../../docs_src/python_types/tutorial004.py!}
```

----------------------------------------

TITLE: FastAPI HTTP Path Operation Decorators
DESCRIPTION: This section lists the available HTTP method decorators in FastAPI for defining path operations. Each decorator corresponds to a specific HTTP verb and is used to associate a function with a particular URL path and method, allowing FastAPI to route incoming requests to the correct handler.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/em/docs/tutorial/first-steps.md#_snippet_6

LANGUAGE: APIDOC
CODE:
```
@app.get(path: str)
  - Defines a path operation that handles HTTP GET requests.
@app.post(path: str)
  - Defines a path operation that handles HTTP POST requests.
@app.put(path: str)
  - Defines a path operation that handles HTTP PUT requests.
@app.delete(path: str)
  - Defines a path operation that handles HTTP DELETE requests.
@app.options(path: str)
  - Defines a path operation that handles HTTP OPTIONS requests.
@app.head(path: str)
  - Defines a path operation that handles HTTP HEAD requests.
@app.patch(path: str)
  - Defines a path operation that handles HTTP PATCH requests.
@app.trace(path: str)
  - Defines a path operation that handles HTTP TRACE requests.
```

----------------------------------------

TITLE: FastAPI: Declare Form Fields with Pydantic Models
DESCRIPTION: Illustrates how to declare form fields using Pydantic models in FastAPI. This allows for automatic data validation, parsing, and documentation of form data, simplifying the handling of complex form submissions and ensuring type safety.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/release-notes.md#_snippet_5

LANGUAGE: python
CODE:
```
from typing import Annotated

from fastapi import FastAPI, Form
from pydantic import BaseModel

app = FastAPI()


class FormData(BaseModel):
    username: str
    password: str


@app.post("/login/")
async def login(data: Annotated[FormData, Form()]):
    return data
```

----------------------------------------

TITLE: Query Parameter with Title and Description
DESCRIPTION: This snippet adds both a title and a description to the query parameter using the `title` and `description` parameters of the `Query` class. These metadata elements are included in the generated OpenAPI documentation.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ko/docs/tutorial/query-params-str-validations.md#_snippet_11

LANGUAGE: Python
CODE:
```
from typing import Optional

from fastapi import FastAPI, Query

app = FastAPI()


@app.get("/items/")
async def read_items(
    q: Optional[str] = Query(
        None, title="Query string", description="Query description"
    )
):
    return {"q": q}
```

----------------------------------------

TITLE: Compare Enum Members
DESCRIPTION: This example shows how to compare the path parameter (which is an Enum member) with the Enum members defined in the `ModelName` Enum.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/tutorial/path-params.md#_snippet_5

LANGUAGE: python
CODE:
```
    if model_name is ModelName.alexnet:
        return {"model_name": model_name, "message": "Deep Learning FTW!"}
```

----------------------------------------

TITLE: Defining a Request Body with Pydantic and Handling PUT Requests
DESCRIPTION: This code extends the FastAPI application to include a Pydantic model (`Item`) for defining a request body. It also defines a PUT route ('/items/{item_id}') that accepts an `item_id` path parameter and an `Item` object in the request body.  The `update_item` function then processes the received data.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/tr/docs/index.md#_snippet_4

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}
```

----------------------------------------

TITLE: Modified Return Data
DESCRIPTION: This code snippet shows the modified version of the return data, where `item.name` is replaced with `item.price`. This change reflects a modification in the data being returned by the API.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh-hant/docs/index.md#_snippet_7

LANGUAGE: Python
CODE:
```
        ... "item_name": item.name ...
```

----------------------------------------

TITLE: Define GET Path Operation Decorator in FastAPI
DESCRIPTION: This code snippet shows how to define a path operation decorator using `@app.get("/")` to handle GET requests to the root path `/` in FastAPI. The decorator tells FastAPI that the function below it should handle requests to the specified path and HTTP method.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/first-steps.md#_snippet_1

LANGUAGE: python
CODE:
```
@app.get("/")
```

----------------------------------------

TITLE: Request Body and Path Parameters
DESCRIPTION: This code snippet shows how to combine request body parameters (using a Pydantic model) with path parameters in a FastAPI endpoint. FastAPI automatically distinguishes between them based on the function parameter type.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/body.md#_snippet_4

LANGUAGE: python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel


class Item(BaseModel):
    name: str
    description: Union[str, None] = None
    price: float
    tax: Union[float, None] = None


app = FastAPI()


@app.put("/items/{item_id}")
async def create_item(item_id: int, item: Item):
    return {"item_id": item_id, **item.dict()}
```

----------------------------------------

TITLE: Adding Generic ASGI Middleware in FastAPI
DESCRIPTION: Demonstrates the recommended way to add a generic ASGI middleware to a FastAPI application using `app.add_middleware()`. This method ensures proper integration, allowing internal middlewares to handle server errors and custom exception handlers correctly.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/middleware.md#_snippet_1

LANGUAGE: Python
CODE:
```
from fastapi import FastAPI
from unicorn import UnicornMiddleware

app = FastAPI()

app.add_middleware(UnicornMiddleware, some_config="rainbow")
```

----------------------------------------

TITLE: Using Centralized Settings in FastAPI main.py
DESCRIPTION: Demonstrates how to import and use the pre-instantiated `settings` object from a `config.py` module within a FastAPI application's `main.py` file.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/advanced/settings.md#_snippet_8

LANGUAGE: python
CODE:
```
from fastapi import FastAPI
from .config import settings

app = FastAPI()

@app.get("/info")
async def info():
    return {
        "app_name": settings.app_name,
        "admin_email": settings.admin_email,
        "items_per_user": settings.items_per_user,
    }
```

----------------------------------------

TITLE: Updating Items with PUT Request and Pydantic Model
DESCRIPTION: This code snippet demonstrates how to handle a PUT request to update an item using a Pydantic model to define the request body. It defines an Item model with name, price, and is_offer fields, and uses it in the update_item function to receive and process the request body.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/fr/docs/index.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}
```

----------------------------------------

TITLE: Import Starlette HTTPException for Handling
DESCRIPTION: Demonstrates how to import and rename Starlette's `HTTPException` to avoid naming conflicts with FastAPI's `HTTPException`, ensuring that exception handlers can catch both.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/tutorial/handling-errors.md#_snippet_14

LANGUAGE: Python
CODE:
```
from starlette.exceptions import HTTPException as StarletteHTTPException
```

----------------------------------------

TITLE: Boolean Query Parameter Conversion in FastAPI (Python)
DESCRIPTION: This code snippet demonstrates how FastAPI automatically converts query parameters to boolean values.  The `short` parameter is defined as a `bool`.

SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/tr/docs/tutorial/query-params.md#_snippet_2

LANGUAGE: Python
CODE:
```
from typing import Union

from fastapi import FastAPI

app = FastAPI()


@app.get("/items/{item_id}")
async def read_item(item_id: str, q: Union[str, None] = None, short: bool = False):
    item = {"item_id": item_id}
    if q:
        item.update({"q": q})
    if not short:
        item.update(
            {"description": "This is an amazing item that has a long description"}
        )
    return item
```

========================
QUESTIONS AND ANSWERS
========================
TOPIC: 
Q: How can specialized Pydantic types, like `HttpUrl`, be utilized within FastAPI models?
A: Specialized Pydantic types, such as `HttpUrl`, can be used as field types within FastAPI models to enforce more specific validation rules beyond basic types like `str`. This ensures data integrity, like checking for valid URLs, and is reflected in the generated JSON Schema and OpenAPI documentation.


SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/zh/docs/tutorial/body-nested-models.md#_qa_4

----------------------------------------

TOPIC: 
Q: What common fields are typically included in a `HeroBase` class?
A: A `HeroBase` class typically includes common fields that are shared across various hero-related models, such as `name` and `age`. This base class serves as a foundation for more specific hero models.


SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/ru/docs/tutorial/sql-databases.md#_qa_13

----------------------------------------

TOPIC: HTTP Basic Auth in FastAPI
Q: What is the purpose of the `WWW-Authenticate` header in the context of HTTP Basic Auth?
A: The `WWW-Authenticate` header, typically with a value of `Basic` and an optional `realm` parameter, instructs the browser to show an integrated prompt for a username and password. Once the user enters these details, the browser automatically sends them in the header for subsequent requests.


SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/security/http-basic-auth.md#_qa_1

----------------------------------------

TOPIC: HTTP Basic Auth in FastAPI
Q: How should a FastAPI application respond when HTTP Basic Auth credentials are found to be incorrect?
A: When HTTP Basic Auth credentials are incorrect, a FastAPI application should return an `HTTPException` with a status code of 401, indicating "Unauthorized." It is also crucial to include the `WWW-Authenticate` header in the response to prompt the browser to display the login dialog again for the user to re-enter credentials.


SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/security/http-basic-auth.md#_qa_5

----------------------------------------

TOPIC: 
Q: How do you provide a single example for a request body using Body()?
A: To provide a single example for a request body, you pass the `examples` argument to `Body()`. This argument should be a dictionary where keys are example names and values are dictionaries containing the `value` of the example data.


SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/uk/docs/tutorial/schema-extra-example.md#_qa_6

----------------------------------------

TOPIC: HTTP Basic Auth in FastAPI
Q: What is HTTP Basic Auth and how does it function in a web application?
A: HTTP Basic Auth is an authentication method where the application expects a header containing a username and password. If these credentials are not provided, it returns an HTTP 401 "Unauthorized" error along with a `WWW-Authenticate` header. This header prompts the browser to display an integrated login dialog for the user to enter their credentials.


SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/en/docs/advanced/security/http-basic-auth.md#_qa_0

----------------------------------------

TOPIC: 
Q: ¿Cuál es la práctica recomendada con respecto a example versus examples?
A: Se recomienda migrar del uso de la palabra clave singular `example` a `examples`. `examples` es parte del estándar de JSON Schema y es soportado por OpenAPI 3.1.0, mientras que `example` está obsoleto.


SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/schema-extra-example.md#_qa_8

----------------------------------------

TOPIC: 
Q: ¿Qué funciones de FastAPI soportan la declaración de ejemplos para parámetros de request?
A: Funciones como `Path()`, `Query()`, `Header()`, `Cookie()`, `Body()`, `Form()` y `File()` soportan la declaración de un grupo de `examples` con información adicional que se añade a sus JSON Schemas dentro de OpenAPI.


SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/schema-extra-example.md#_qa_4

----------------------------------------

TOPIC: 
Q: What are some key deployment concepts to consider beyond basic server execution?
A: Beyond basic server execution, key deployment concepts include security (HTTPS), ensuring the application runs on startup, handling restarts, replication (managing multiple processes), memory management, and executing necessary steps before the application starts.


SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/pt/docs/deployment/manually.md#_qa_6

----------------------------------------

TOPIC: 
Q: ¿Se pueden declarar ejemplos usando Field() en modelos de Pydantic?
A: Sí, al usar `Field()` con modelos de Pydantic, también puedes declarar `examples` adicionales directamente dentro de la llamada a la función `Field()`.


SOURCE: https://github.com/tiangolo/fastapi/blob/master/docs/es/docs/tutorial/schema-extra-example.md#_qa_3