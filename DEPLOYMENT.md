## Manual Deployment 

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

