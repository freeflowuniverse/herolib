## Docusaurus Module with HeroLib

This module allows you to build and manage Docusaurus websites using a generic configuration layer provided by `lib/web/site`.

### Workflow

1.  **Configure Your Site**: Define your site's metadata, navigation, footer, pages, and content sources using `!!site.*` actions in a `.heroscript` file. This creates a generic site definition.
2.  **Define Docusaurus Build**: Use `!!docusaurus.define` to specify build paths and other factory-level settings.
3.  **Link Site to Docusaurus**: Use `!!docusaurus.add` to link your generic site configuration to the Docusaurus factory. This tells HeroLib to build this specific site using Docusaurus.
4.  **Run Actions**: Use actions like `!!docusaurus.dev` or `!!docusaurus.build` to generate and serve your site.

### Example HeroScript

```heroscript
# 1. Define the Docusaurus build environment
!!docusaurus.define
	path_build: "/tmp/docusaurus_build"
	path_publish: "/tmp/docusaurus_publish"
	reset: true
	install: true

# 2. Configure the site using the generic 'site' module
# This part is handled by lib/web/site
!!site.config
    name: "my_site"
    title: "My Awesome Docs"
    tagline: "The best docs ever"
    url: "https://docs.example.com"
    base_url: "/"
    copyright: "Example Corp"

!!site.menu_item
    label: "Homepage"
    href: "https://example.com"
    position: "right"

# ... add footer, pages, etc. using !!site.* actions ...

# 3. Add the generic site to the Docusaurus factory for building
# The 'path' points to your local source directory with static assets etc.
!!docusaurus.add site:"my_site" path:"./path/to/my/site/source"

# 4. Run the development server
!!docusaurus.dev site:"my_site" open:true watch_changes:true
```

### Heroscript Actions

-   `!!docusaurus.define`: Configures a Docusaurus factory instance.
    -   `name` (string): Name of the factory (default: `default`).
    -   `path_build` (string): Path to build the site.
    -   `path_publish` (string): Path to publish the final build.
    -   `reset` (bool): If `true`, clean the build directory before starting.
    -   `template_update` (bool): If `true`, update the Docusaurus template.
    -   `install` (bool): If `true`, run `bun install`.

-   `!!docusaurus.add`: Links a configured site to the Docusaurus factory.
    -   `site` (string, required): The name of the site defined in `!!site.config`.
    -   `path` (string, required): The local filesystem path to the site's source directory (e.g., for `static/` folder).

-   `!!docusaurus.dev`: Runs the Docusaurus development server.
    -   `site` (string, required): The name of the site to run.
    -   `host` (string): Host to bind to (default: `localhost`).
    -   `port` (int): Port to use (default: `3000`).
	-	`open` (bool): Open the site in a browser.
	-	`watch_changes` (bool): Watch for source file changes and auto-reload.

-   `!!docusaurus.build`: Builds the static site for production.
    -   `site` (string, required): The name of the site to build.