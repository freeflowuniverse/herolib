```bash
unpm install @uppy/react
```

## Components

Pre-composed, plug-and-play components:

<Dashboard /> renders @uppy/dashboard
<DashboardModal /> renders @uppy/dashboard as a modal
<DragDrop /> renders @uppy/drag-drop
<ProgressBar /> renders @uppy/progress-bar
<StatusBar /> renders @uppy/status-bar

more info see https://uppy.io/docs/react


we use tus server for the upload support

npm install @uppy/tus

e.g.

import Uppy from '@uppy/core';
import Dashboard from '@uppy/dashboard';
import Tus from '@uppy/tus';

import '@uppy/core/dist/style.min.css';
import '@uppy/dashboard/dist/style.min.css';

new Uppy()
	.use(Dashboard, { inline: true, target: 'body' })



========================
CODE SNIPPETS
========================

TITLE: React Dashboard Modal Example with TUS
DESCRIPTION: Demonstrates how to use the DashboardModal component from @uppy/react with the Tus plugin for resumable uploads.
LANGUAGE: jsx
CODE:
```
/** @jsx React */
import React from 'react'
import Uppy from '@uppy/core'
import { DashboardModal } from '@uppy/react'
import Tus from '@uppy/tus'

const uppy = new Uppy({ debug: true, autoProceed: false })
  .use(Tus, { endpoint: 'https://tusd.tusdemo.net/files/' })

class Example extends React.Component {
  state = { open: false }

  render() {
    const { open } = this.state
    return (
      <DashboardModal
        uppy={uppy}
        open={open}
        onRequestClose={this.handleClose}
      />
    )
  }
  // ..snip..
}
```

----------------------------------------

TITLE: Installation using npm for @uppy/react
DESCRIPTION: Provides the command to install the @uppy/react package using npm.
LANGUAGE: bash
CODE:
```
$ npm install @uppy/react @uppy/core @uppy/dashboard @uppy/tus
```

----------------------------------------

TITLE: Uppy Dashboard and Tus Integration Example (HTML & JavaScript)
DESCRIPTION: This snippet demonstrates how to initialize Uppy with the Dashboard and Tus plugins, configure them, and handle upload success events.
LANGUAGE: html
CODE:
```
<html>
  <head>
    <link rel="stylesheet" href="https://releases.transloadit.com/uppy/v4.18.0/uppy.min.css" />
  </head>

  <body>
    <div class="DashboardContainer"></div>
    <button class="UppyModalOpenerBtn">Upload</button>
    <div class="uploaded-files">
      <h5>Uploaded files:</h5>
      <ol></ol>
    </div>
  </body>

  <script type="module">
    import { Uppy, Dashboard, Tus } from 'https://releases.transloadit.com/uppy/v4.18.0/uppy.min.mjs'
    var uppy = new Uppy({
      debug: true,
      autoProceed: false,
    })
      .use(Dashboard, {
        browserBackButtonClose: false,
        height: 470,
        inline: false,
        replaceTargetContent: true,
        showProgressDetails: true,
        target: '.DashboardContainer',
        trigger: '.UppyModalOpenerBtn',
      })
      .use(Tus, { endpoint: 'https://tusd.tusdemo.net/files/' })
      .on('upload-success', function (file, response) {
        var url = response.uploadURL
        var fileName = file.name

        document.querySelector('.uploaded-files ol').innerHTML += 
          '<li><a href="' + url + '" target="_blank">' + fileName + '</a></li>'
      })
  </script>
</html>
```

----------------------------------------

TITLE: Initialize Uppy with Tus Plugin (JavaScript)
DESCRIPTION: Demonstrates how to initialize Uppy and configure the Tus plugin for resumable uploads.
LANGUAGE: js
CODE:
```
import Uppy from '@uppy/core'
import Tus from '@uppy/tus'

const uppy = new Uppy()
uppy.use(Tus, {
  endpoint: 'https://tusd.tusdemo.net/files/', // use your tus endpoint here
  resume: true,
  retryDelays: [0, 1000, 3000, 5000],
})
```

----------------------------------------

TITLE: Uppy Core Initialization and Plugin Usage (JavaScript)
DESCRIPTION: This example demonstrates how to initialize Uppy with core functionality and integrate the Tus plugin. It also shows how to listen for upload completion events.
LANGUAGE: javascript
CODE:
```
import Uppy from '@uppy/core'
import Dashboard from '@uppy/dashboard'
import Tus from '@uppy/tus'

const uppy = new Uppy()
  .use(Dashboard, { trigger: '#select-files' })
  .use(Tus, { endpoint: 'https://tusd.tusdemo.net/files/' })
  .on('complete', (result) => {
    console.log('Upload result:', result)
  })
```

----------------------------------------

TITLE: Uppy XHRUpload Configuration (JavaScript)
DESCRIPTION: This snippet shows the basic JavaScript configuration for Uppy, initializing it with the XHRUpload plugin to send files to a specified endpoint.
LANGUAGE: javascript
CODE:
```
import Uppy from '@uppy/core';
import XHRUpload from '@uppy/xhr-upload';

const uppy = new Uppy({
  debug: true,
  autoProceed: false,
  restrictions: {
    maxFileSize: 100000000,
    maxNumberOfFiles: 10,
    allowedFileTypes: ['image/*', 'video/*']
  }
});

uppy.use(XHRUpload, {
  endpoint: 'YOUR_UPLOAD_ENDPOINT_URL',
  fieldName: 'files[]',
  method: 'post'
});

uppy.on('complete', (result) => {
  console.log('Upload complete:', result);
});

uppy.on('error', (error) => {
  console.error('Upload error:', error);
});
```

----------------------------------------

TITLE: Install Uppy Core Packages for TUS
DESCRIPTION: Installs the core Uppy package along with the Dashboard and Tus plugins using npm.
LANGUAGE: bash
CODE:
```
npm install @uppy/core @uppy/dashboard @uppy/tus @uppy/xhr-upload
```

========================
QUESTIONS AND ANSWERS
========================

TOPIC: Uppy React Components
Q: What is the purpose of the @uppy/react package?
A: The @uppy/react package provides React component wrappers for Uppy's officially maintained UI plugins. It allows developers to easily integrate Uppy's file uploading capabilities into their React applications.

----------------------------------------

TOPIC: Uppy React Components
Q: How can @uppy/react be installed in a project?
A: The @uppy/react package can be installed using npm with the command '$ npm install @uppy/react'.

----------------------------------------

TOPIC: Uppy React Components
Q: Where can I find more detailed documentation for the @uppy/react plugin?
A: More detailed documentation for the @uppy/react plugin is available on the Uppy website at https://uppy.io/docs/react.