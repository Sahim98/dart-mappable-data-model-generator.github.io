# Deployment Guide for GitHub Pages

This guide will help you deploy your Flutter web app to GitHub Pages.

## Automatic Deployment (Recommended)

The repository is now configured with GitHub Actions for automatic deployment.

### Steps to Enable GitHub Pages:

1. **Push your code to GitHub:**
   ```bash
   git add .
   git commit -m "Add GitHub Actions workflow for deployment"
   git push origin feat/create-entity
   ```

2. **Enable GitHub Pages in your repository:**
   - Go to your GitHub repository: https://github.com/Sahim98/dart-mappable-data-model-generator
   - Click on **Settings** (top menu)
   - Scroll down and click on **Pages** (left sidebar)
   - Under "Build and deployment":
     - **Source**: Select "GitHub Actions"
   - Click **Save**

3. **Trigger the deployment:**
   - The workflow will automatically run when you push to `main` or `feat/create-entity` branches
   - Or manually trigger it from the **Actions** tab → **Deploy to GitHub Pages** → **Run workflow**

4. **Access your deployed app:**
   - After deployment completes (check the Actions tab), your app will be available at:
   - **https://sahim98.github.io/quick_parse/**

## Manual Deployment (Alternative)

If you prefer to deploy manually:

1. **Build the web app:**
   ```bash
   flutter build web --release --base-href "/quick_parse/"
   ```

2. **Deploy using gh-pages:**
   ```bash
   # Install gh-pages (if not already installed)
   npm install -g gh-pages
   
   # Deploy
   gh-pages -d build/web
   ```

## Updating the Deployment

Every time you push to the configured branches, GitHub Actions will automatically rebuild and redeploy your app.

## Important Notes

- Make sure the `--base-href` matches your repository name: `/quick_parse/`
- If you rename your repository, update the `--base-href` in both:
  - `.github/workflows/deploy.yml`
  - Manual build commands
- The first deployment may take a few minutes to propagate

## Troubleshooting

- **404 Error**: Check that GitHub Pages is enabled and the source is set to "GitHub Actions"
- **Blank Page**: Verify the `--base-href` matches your repository name
- **Build Fails**: Check the Actions tab for error logs
- **Assets Not Loading**: Ensure all assets are properly declared in `pubspec.yaml`

## Local Testing

To test the production build locally before deploying:

```bash
flutter build web --release
cd build/web
python3 -m http.server 8000
# Visit http://localhost:8000
```

