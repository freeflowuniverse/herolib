import { themes as prismThemes } from 'prism-react-renderer';
import type { Configuration } from '@@docusaurus/types';
import type * as Preset from '@@docusaurus/preset-classic';


const config: Configuration = {
  title: '@{config.main.title}',
  tagline: '@{config.main.tagline}',
  favicon: '@{config.main.favicon}',

  // Set the production url of your site here
  url: '@{config.main.url}',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '@{config.main.base_url}',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'freeflowuniverse', // Usually your GitHub org/user name.
  projectName: '@{config.main.name}', // Usually your repo name.

  onBrokenLinks: 'warn',
  onBrokenMarkdownLinks: 'warn',

  // Enable for i18n
  // i18n: {
  //   defaultLocale: 'en',
  //   locales: ['en'],
  // },

  themes: ["@@docusaurus/theme-mermaid"],

  markdown: {
    mermaid: true,
  },
  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    // Replace with your project's social card
    image: 'img/docusaurus-social-card.jpg',
    colorMode: {
      defaultMode: 'dark',
    },
    navbar: {
      title: '@{config.navbar.title}',
      items: [
        @for item in config.navbar.items 
        {
  label: '@{item.label}',
    href: '@{item.href}',
      position: '@{item.position}'
},
@end
      ],
    },
footer: {
  style: '@{config.footer.style}',
    links: [
      @for link_group in config.footer.links
        {
    title: '@{link_group.title}',
      items: [
        @for item in link_group.items 
            {
      label: '@{item.label}',
        @if item.href != ''
                href: '@{item.href}'
      @else if item.to != ''
                to: '@{item.to}'
      @else
      to: '/docs'
      @end
    },
    @end
          ]
  },
  @end
      ],
  copyright: '@{config.main.copyright}',
    },
prism: {
  theme: prismThemes.github,
    darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;