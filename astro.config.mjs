import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';

export default defineConfig({
  site: 'https://pixelotes.github.io',
  base: '/opsdeck',
  output: 'static',
  integrations: [tailwind()],
});
