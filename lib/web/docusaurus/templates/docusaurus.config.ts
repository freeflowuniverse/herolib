import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: '${title}',
  tagline: '${tagline}',
  favicon: '${favicon}',

  // Set the production url of your site here
  url: '${url}',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '${base_url}',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'freeflowuniverse', // Usually your GitHub org/user name.
  projectName: '${projectName}', // Usually your repo name.

  onBrokenLinks: 'warn',
  onBrokenMarkdownLinks: 'warn',

  // Enable for i18n
  // i18n: {
  //   defaultLocale: 'en',
  //   locales: ['en'],
  // },

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
    navbar: {
      title: '${navbarTitle}',
      items: [
        @for item in navbar_items {
        {
          label: '${item.label}',
          href: '${item.href}',
          position: '${item.position}'
        },
        }
      ],
    },
    footer: {
      style: '${footerStyle}',
      links: [
        @for link_group in footer_links {
        {
          title: '${link_group.title}',
          items: [
            @for item in link_group.items {
            {
              label: '${item.label}',
              @if item.href != '' {
              href: '${item.href}'
              } @else if item.to != '' {
              to: '${item.to}'
              } @else {
              to: '/docs'
              }
            },
            }
          ]
        },
        }
      ],
      copyright: '${copyright}',
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;