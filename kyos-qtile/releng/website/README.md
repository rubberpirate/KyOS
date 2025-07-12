# KyOS Website

This directory contains the official KyOS website, showcasing the features, desktop environment, TUI installer, and providing documentation for users.

## Structure

```
website/
├── index.html              # Main landing page
├── assets/
│   ├── css/
│   │   └── style.css       # Main stylesheet with modern design
│   ├── js/
│   │   └── main.js         # Interactive features and animations
│   └── images/
│       ├── kyos-logo.svg   # KyOS logo
│       └── favicon.svg     # Website favicon (copy of logo)
├── docs/
│   └── installation-guide.html  # Comprehensive installation guide
└── README.md               # This file
```

## Features

### Design
- **Modern Dark Theme**: Beautiful dark color scheme with purple/blue gradients
- **Responsive Design**: Works perfectly on desktop, tablet, and mobile devices
- **Smooth Animations**: Scroll-triggered animations and interactive elements
- **Terminal Showcase**: Animated terminal window showing installer in action

### Sections
1. **Hero Section**: Eye-catching introduction with animated terminal
2. **Features**: Grid showcasing KyOS key features
3. **Installer Showcase**: Detailed look at the TUI installer capabilities
4. **Desktop Gallery**: Screenshots and demos of the Qtile desktop environment
5. **Download Section**: Download links, system requirements, and verification
6. **Documentation**: Links to guides and community resources
7. **Footer**: Additional links and social media

### Interactive Elements
- Smooth scrolling navigation
- Mobile-friendly hamburger menu
- Animated terminal with typing effect
- Hover effects on cards and buttons
- Copy-to-clipboard for verification codes
- Parallax scrolling effects

## Technology Stack

- **HTML5**: Semantic markup with accessibility features
- **CSS3**: Modern CSS with custom properties, grid, flexbox, and animations
- **Vanilla JavaScript**: No frameworks, optimized for performance
- **Feather Icons**: Beautiful iconography
- **Google Fonts**: Inter (primary) and Fira Code (monospace)

## Key Design Elements

### Color Palette
- **Primary**: `#6366f1` (Indigo)
- **Secondary**: `#8b5cf6` (Purple)
- **Accent**: `#06b6d4` (Cyan)
- **Success**: `#10b981` (Emerald)
- **Warning**: `#f59e0b` (Amber)

### Typography
- **Headings**: Inter (600-700 weight)
- **Body**: Inter (400-500 weight)
- **Code**: Fira Code (400-500 weight)

### Layout
- **Container**: Max-width 1200px, centered
- **Grid**: CSS Grid for complex layouts
- **Flexbox**: For component-level alignment
- **Spacing**: Consistent scale using CSS custom properties

## Development

### Local Development
1. Serve the website using any HTTP server:
   ```bash
   # Using Python
   python -m http.server 8000
   
   # Using Node.js (if you have live-server)
   npx live-server
   
   # Using PHP
   php -S localhost:8000
   ```

2. Open `http://localhost:8000` in your browser

### Adding Content

#### New Documentation Pages
1. Create HTML file in `docs/` directory
2. Use the same structure as `installation-guide.html`
3. Update navigation in `index.html` and other relevant pages

#### Adding Images
1. Place images in `assets/images/`
2. Optimize images for web (WebP format recommended)
3. Update references in HTML and CSS files

#### Styling Updates
1. Edit `assets/css/style.css`
2. Use CSS custom properties for consistency
3. Follow mobile-first responsive design principles

### Performance Considerations
- Images are lazy-loaded where possible
- CSS and JS are minified for production
- Critical fonts are preloaded
- Scroll events are throttled for smooth performance

## Browser Support
- Chrome/Chromium 80+
- Firefox 75+
- Safari 13+
- Edge 80+

## Accessibility
- Semantic HTML structure
- Proper heading hierarchy
- Alt text for images
- Keyboard navigation support
- High contrast ratios
- Screen reader friendly

## Todo / Future Enhancements

### Content
- [ ] Add real desktop screenshots
- [ ] Create more documentation pages (FAQ, Configuration, etc.)
- [ ] Add changelog/release notes
- [ ] Create blog section for news and updates

### Features
- [ ] Search functionality for documentation
- [ ] Multi-language support
- [ ] Contact form
- [ ] Community integration (Discord widget, forum links)
- [ ] Download statistics
- [ ] User testimonials section

### Technical
- [ ] Add favicon.ico for older browsers
- [ ] Implement service worker for offline functionality
- [ ] Add analytics (privacy-focused)
- [ ] Set up automated deployment
- [ ] Add sitemap.xml and robots.txt

## Deployment

### Static Hosting
The website is designed to work with any static hosting service:
- GitHub Pages
- Netlify
- Vercel
- GitLab Pages
- Firebase Hosting

### Custom Domain
Update the following for custom domain:
1. DNS configuration
2. SSL certificate setup
3. Update any hardcoded URLs

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test across different browsers and devices
5. Submit a pull request

## License

This website design and code is licensed under MIT License. The KyOS branding and logos are property of the KyOS project.
