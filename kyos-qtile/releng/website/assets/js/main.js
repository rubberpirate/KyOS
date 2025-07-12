// Initialize Feather icons
feather.replace();

// Mobile navigation toggle
const navToggle = document.getElementById('nav-toggle');
const navMenu = document.getElementById('nav-menu');

if (navToggle && navMenu) {
    navToggle.addEventListener('click', () => {
        navMenu.classList.toggle('nav-menu-active');
        navToggle.classList.toggle('nav-toggle-active');
    });
}

// Smooth scrolling for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            const offsetTop = target.offsetTop - 80; // Account for fixed navbar
            window.scrollTo({
                top: offsetTop,
                behavior: 'smooth'
            });
        }
    });
});

// Navbar scroll effect
window.addEventListener('scroll', () => {
    const navbar = document.querySelector('.navbar');
    if (window.scrollY > 50) {
        navbar.classList.add('navbar-scrolled');
    } else {
        navbar.classList.remove('navbar-scrolled');
    }
});

// Terminal animation
function typeText(element, text, speed = 50) {
    let i = 0;
    element.textContent = '';
    
    function typeChar() {
        if (i < text.length) {
            element.textContent += text.charAt(i);
            i++;
            setTimeout(typeChar, speed);
        }
    }
    
    typeChar();
}

// Animate terminal when hero section is in view
const observerOptions = {
    threshold: 0.5,
    rootMargin: '0px 0px -100px 0px'
};

const heroObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            const commandElement = entry.target.querySelector('.command');
            if (commandElement && !commandElement.classList.contains('animated')) {
                commandElement.classList.add('animated');
                setTimeout(() => {
                    typeText(commandElement, 'kyosinstall', 100);
                }, 1000);
            }
        }
    });
}, observerOptions);

const heroSection = document.querySelector('.hero');
if (heroSection) {
    heroObserver.observe(heroSection);
}

// Animate feature cards on scroll
const cardObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('animate-in');
        }
    });
}, {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
});

// Observe feature cards
document.querySelectorAll('.feature-card, .doc-card, .gallery-item').forEach(card => {
    cardObserver.observe(card);
});

// Download button click tracking
document.querySelectorAll('.btn-primary').forEach(button => {
    button.addEventListener('click', (e) => {
        if (button.href === '#' || button.href === '') {
            e.preventDefault();
            showDownloadModal();
        }
    });
});

// Show download modal (placeholder)
function showDownloadModal() {
    alert('Download functionality will be available when KyOS ISO is ready!');
}

// Add scroll-triggered animations
const animateOnScroll = () => {
    const elements = document.querySelectorAll('.feature-card, .doc-card, .gallery-item');
    
    elements.forEach(element => {
        const elementTop = element.getBoundingClientRect().top;
        const elementVisible = 150;
        
        if (elementTop < window.innerHeight - elementVisible) {
            element.classList.add('animate-fade-in-up');
        }
    });
};

// Throttle scroll events for performance
let ticking = false;
function updateAnimations() {
    animateOnScroll();
    ticking = false;
}

window.addEventListener('scroll', () => {
    if (!ticking) {
        requestAnimationFrame(updateAnimations);
        ticking = true;
    }
});

// Initialize animations on load
window.addEventListener('load', () => {
    animateOnScroll();
    
    // Add loading animation to hero
    const heroContent = document.querySelector('.hero-content');
    if (heroContent) {
        heroContent.classList.add('hero-loaded');
    }
});

// Copy verification code to clipboard
const verificationCode = document.querySelector('.verification-code');
if (verificationCode) {
    verificationCode.addEventListener('click', () => {
        navigator.clipboard.writeText(verificationCode.textContent.trim()).then(() => {
            // Show feedback
            const originalText = verificationCode.textContent;
            verificationCode.textContent = 'Copied to clipboard!';
            verificationCode.style.background = 'var(--success-color)';
            
            setTimeout(() => {
                verificationCode.textContent = originalText;
                verificationCode.style.background = 'var(--bg-primary)';
            }, 2000);
        });
    });
}

// Add hover effects to terminal window
const terminalWindow = document.querySelector('.terminal-window');
if (terminalWindow) {
    terminalWindow.addEventListener('mouseenter', () => {
        const cursor = terminalWindow.querySelector('.terminal-cursor');
        if (cursor) {
            cursor.style.animationDuration = '0.5s';
        }
    });
    
    terminalWindow.addEventListener('mouseleave', () => {
        const cursor = terminalWindow.querySelector('.terminal-cursor');
        if (cursor) {
            cursor.style.animationDuration = '1s';
        }
    });
}

// Parallax effect for hero background
window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    const heroBackground = document.querySelector('.hero-bg');
    
    if (heroBackground) {
        const rate = scrolled * -0.5;
        heroBackground.style.transform = `translateY(${rate}px)`;
    }
});

// Add CSS animations dynamically
const style = document.createElement('style');
style.textContent = `
    .animate-fade-in-up {
        animation: fadeInUp 0.6s ease-out forwards;
    }
    
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .hero-loaded {
        animation: heroFadeIn 1s ease-out forwards;
    }
    
    @keyframes heroFadeIn {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .navbar-scrolled {
        background: rgba(15, 15, 35, 0.98) !important;
        box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
    }
    
    .nav-menu-active {
        display: flex !important;
        flex-direction: column;
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        background: var(--bg-card);
        border: 1px solid var(--border-color);
        border-radius: var(--radius-md);
        padding: var(--spacing-lg);
        margin-top: var(--spacing-md);
        box-shadow: var(--shadow-lg);
    }
    
    .nav-toggle-active span:nth-child(1) {
        transform: rotate(45deg) translate(5px, 5px);
    }
    
    .nav-toggle-active span:nth-child(2) {
        opacity: 0;
    }
    
    .nav-toggle-active span:nth-child(3) {
        transform: rotate(-45deg) translate(7px, -6px);
    }
    
    @media (max-width: 768px) {
        .nav-menu {
            display: none;
        }
    }
`;

document.head.appendChild(style);

// Initialize everything when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    // Re-initialize Feather icons for any dynamically added content
    feather.replace();
    
    console.log('KyOS website loaded successfully!');
});

// Add keyboard navigation
document.addEventListener('keydown', (e) => {
    // Escape key closes mobile menu
    if (e.key === 'Escape' && navMenu.classList.contains('nav-menu-active')) {
        navMenu.classList.remove('nav-menu-active');
        navToggle.classList.remove('nav-toggle-active');
    }
});

// Performance optimization: Preload critical images
const preloadImages = [
    'assets/images/kyos-logo.svg'
];

preloadImages.forEach(src => {
    const img = new Image();
    img.src = src;
});

// Add error handling for missing images
document.querySelectorAll('img').forEach(img => {
    img.addEventListener('error', () => {
        img.style.opacity = '0.5';
        img.alt = 'Image not available';
    });
});
