# How to Embed the PeopleHR Login Widget

You can easily embed this Flutter application into your existing marketing website (peopleshr.com) using an `iframe`.

## Step 1: Publish the App
1. Use the **Publish** button in the top-right corner of the editor.
2. Select **Web** as the target platform.
3. Wait for the cloud build to complete.
4. Once published, you will get a URL for your hosted application (e.g., `https://your-project-id.web.app` or similar).

## Step 2: Embed in Your Website
Copy and paste the following HTML code into your website's HTML where you want the login widget to appear:

```html
<iframe 
  src="https://YOUR_PUBLISHED_APP_URL_HERE" 
  width="100%" 
  height="600px" 
  style="border: none; border-radius: 12px; overflow: hidden;"
  title="PeopleHR Login Lookup">
</iframe>
```

### Customization Tips:
- **Height**: Adjust `height="600px"` to fit the content perfectly on your page.
- **Width**: The widget is responsive. You can set `width="100%"` to fill the container or a fixed pixel value like `width="500px"`.
- **Styling**: The `style` attribute removes the default iframe border and adds rounded corners.

## Important Note on Redirection
The app is configured to open the company login page in a **new tab** when the user clicks "Continue". This is the standard behavior for embedded widgets to ensure security and proper navigation flow.
