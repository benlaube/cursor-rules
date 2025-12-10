# Command: setup-docusaurus

**Version:** 1.0.1  
**Created:** 12-05-2025  
**Last Updated:** 12-05-2025 17:19:08 EST  
**Description:** Sets up a Docusaurus documentation site for the project, configured to read from the existing `docs/` directory with proper navigation, Mermaid support, and deployment configuration.

---

## When to Use

Use this command when:
- Setting up a new Docusaurus documentation site
- Migrating from plain markdown to a documentation site
- Adding documentation site to an existing project
- Need searchable, navigable documentation with Mermaid diagram support

---

## What This Command Does

1. **Creates Docusaurus Site Structure:**
   - Creates `docs-site/` directory
   - Initializes npm package
   - Installs required Docusaurus dependencies

2. **Configures Docusaurus:**
   - Sets up `docusaurus.config.js` to read from `../docs`
   - Configures Mermaid diagram support
   - Sets up proper routing and base URLs

3. **Creates Navigation:**
   - Analyzes existing `docs/` directory structure
   - Generates `sidebars.js` with organized navigation
   - Includes documentation index and quick start guides

4. **Sets Up Deployment:**
   - Creates `DEPLOYMENT.md` with platform-specific guides
   - Configures `.gitignore` for build artifacts
   - Sets up package.json scripts

5. **Provides Documentation:**
   - Creates `README.md` with setup instructions
   - Documents structure and usage

---

## Prerequisites

- Node.js >= 18.0 installed
- npm or yarn package manager
- Existing `docs/` directory with markdown files
- Project root access

---

## Usage

```bash
# Run the command (via Cursor or manually follow steps)
setup-docusaurus
```

**Manual Steps (if not using Cursor):**

1. Create `docs-site/` directory
2. Initialize npm: `npm init -y`
3. Install Docusaurus: `npm install --save-dev @docusaurus/core @docusaurus/preset-classic @docusaurus/theme-mermaid`
4. Create configuration files (see examples below)
5. Update `package.json` scripts
6. Create documentation files

---

## Step-by-Step Implementation

### Step 1: Create Directory Structure

```bash
mkdir -p docs-site/src/css docs-site/static/img
cd docs-site
npm init -y
```

### Step 2: Install Dependencies

```bash
npm install --save-dev @docusaurus/core@latest @docusaurus/preset-classic@latest @docusaurus/theme-mermaid@latest
npm install --save @mdx-js/react clsx prism-react-renderer react react-dom
```

### Step 3: Create Configuration Files

**Create `docusaurus.config.js`:**
- Point `docs.path` to `../docs`
- Set `docs.routeBasePath` to `'/'`
- Exclude archive/audit folders
- Configure Mermaid theme
- Set up navbar and footer

**Create `sidebars.js`:**
- Analyze `docs/` directory structure
- Create organized navigation categories
- Include documentation index
- Match existing folder structure

**Create `package.json` scripts:**
- `start`: Development server (with unique port: `--port 3001`)
- `build`: Production build
- `serve`: Serve production build
- `deploy`: Build and deploy

### Step 4: Create Supporting Files

**Create `README.md`:**
- Quick start instructions
- Development commands
- Structure overview
- Configuration notes

**Create `DEPLOYMENT.md`:**
- GitHub Pages deployment
- Netlify deployment
- Vercel deployment
- Custom domain setup
- Troubleshooting

**Create `.gitignore`:**
- Exclude `node_modules/`
- Exclude `build/`
- Exclude `.docusaurus/`
- Exclude cache files

**Create `src/css/custom.css`:**
- Custom styling
- Mermaid diagram styling
- Code block styling

### Step 5: Update Project Documentation

**Update main `README.md`:**
- Add link to documentation site
- Mention Docusaurus setup
- Include development instructions

---

## Configuration Examples

### docusaurus.config.js

```js
const config = {
  title: 'Project Documentation',
  tagline: 'Project description',
  url: 'https://your-docs-site.com',
  baseUrl: '/',
  
  presets: [
    [
      'classic',
      {
        docs: {
          routeBasePath: '/',
          path: '../docs',
          sidebarPath: require.resolve('./sidebars.js'),
          exclude: [
            '**/archive/**',
            '**/audit/**',
            '**/*.json',
            '**/INDEX.md',
          ],
        },
        blog: false,
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],

  themes: [
    [
      '@docusaurus/theme-mermaid',
      {
        mermaid: {
          theme: { light: 'default', dark: 'dark' },
        },
      },
    ],
  ],

  markdown: {
    mermaid: true,
  },
};
```

### sidebars.js

```js
const sidebars = {
  docsSidebar: [
    {
      type: 'doc',
      id: 'INDEX',
      label: 'Documentation Index',
    },
    {
      type: 'category',
      label: 'Quick Start',
      items: [
        { type: 'doc', id: 'overview/PROJECT_SUMMARY' },
      ],
    },
    {
      type: 'category',
      label: 'Architecture',
      items: [
        { type: 'doc', id: 'architecture/ARCHITECTURE' },
      ],
    },
  ],
};
```

---

## Validation

After setup, verify:

- [ ] `docs-site/` directory exists
- [ ] `npm install` completes without errors
- [ ] `npm start` launches development server
- [ ] Documentation renders correctly
- [ ] Mermaid diagrams display properly
- [ ] Navigation sidebar works
- [ ] Search functionality works
- [ ] Build completes: `npm run build`

---

## Troubleshooting

### Build Errors

**Issue:** Build fails with module errors
**Solution:** 
- Clear cache: `npm run clear`
- Reinstall: `rm -rf node_modules && npm install`
- Check Node.js version: `node --version` (requires >= 18.0)

### Mermaid Not Rendering

**Issue:** Mermaid diagrams don't display
**Solution:**
- Verify `@docusaurus/theme-mermaid` is installed
- Check `docusaurus.config.js` has Mermaid theme configured
- Ensure markdown files use proper Mermaid code blocks

### Navigation Issues

**Issue:** Documents not appearing in sidebar
**Solution:**
- Check `sidebars.js` has correct document IDs
- Verify documents exist in `docs/` directory
- Check document IDs match file paths (without extension)

### 404 Errors

**Issue:** Pages return 404
**Solution:**
- Verify `baseUrl` in `docusaurus.config.js` matches deployment path
- Check document IDs in `sidebars.js` match actual file paths
- Ensure files are not excluded in `docs.exclude`

---

## Next Steps

After setup:

1. **Customize Configuration:**
   - Update `title`, `tagline`, `url` in `docusaurus.config.js`
   - Add logo and favicon to `static/img/`
   - Customize navbar and footer

2. **Refine Navigation:**
   - Review and adjust `sidebars.js` structure
   - Add/remove categories as needed
   - Organize documents logically

3. **Deploy:**
   - Choose deployment platform (GitHub Pages, Netlify, Vercel)
   - Follow `DEPLOYMENT.md` guide
   - Configure custom domain (optional)

4. **Update Project:**
   - Add link to docs site in main `README.md`
   - Update CI/CD to build docs site
   - Add docs site to project documentation

---

## Related Files

- **Rules:**
  - [docusaurus-setup.mdc](../rules/documentation/docusaurus-setup.mdc) - Docusaurus setup and maintenance rule
- **Standards:**
  - [documentation-standards.md](../../standards/project-planning/documentation-standards.md) - Documentation structure standards
  - [documentation-management.md](../../standards/project-planning/documentation-management.md) - Documentation management standards

---

## Examples

### Example 1: Basic Setup

```bash
# Run command
setup-docusaurus

# Start development server (runs on port 3001)
cd docs-site && npm start

# Build for production
npm run build
```

**Note:** The development server runs on port **3001** by default to avoid conflicts with other services.

### Example 2: Custom Configuration

After setup, customize:
- Update `docusaurus.config.js` with project-specific settings
- Adjust `sidebars.js` to match your documentation structure
- Add custom CSS in `src/css/custom.css`
- Configure deployment in `DEPLOYMENT.md`

---

## Notes

- **Source Docs:** Documentation source files remain in `docs/` directory (read-only from Docusaurus)
- **Build Output:** Built site is in `docs-site/build/` (excluded from git)
- **Development:** Use `npm start` for local development with hot reload
- **Production:** Use `npm run build` then `npm run serve` to test production build
- **Deployment:** Follow `DEPLOYMENT.md` for platform-specific instructions

---

*This command sets up a production-ready Docusaurus documentation site that reads from your existing `docs/` directory with proper navigation, Mermaid support, and deployment configuration.*
