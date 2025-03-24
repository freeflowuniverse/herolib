## Environment Variables

```v
import freeflowuniverse.herolib.osal

// Get environment variable
value := osal.env_get('PATH')!

// Set environment variable
osal.env_set('MY_VAR', 'value')!

// Check if environment variable exists
exists := osal.env_exists('MY_VAR')
```