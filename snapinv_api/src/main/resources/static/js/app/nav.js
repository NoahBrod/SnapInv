$(() => {
    const navLinks = document.querySelectorAll('#sidebar .nav-link');
    // Add click event to each link
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Remove active class from all links
            navLinks.forEach(l => l.classList.remove('active'));
            
            // Add active class to clicked link
            this.classList.add('active');
            
            // Close mobile menu after clicking (if on mobile)
            const sidebar = document.getElementById('sidebar');
            const bsCollapse = bootstrap.Collapse.getInstance(sidebar);
            if (bsCollapse && window.innerWidth < 768) {
                bsCollapse.hide();
            }
            
            // Load content based on which link was clicked
            const page = this.getAttribute('data-page');
            loadContent(page);
        });
    });
});

// Function to load different content
function loadContent(page) {
    const contentDiv = document.getElementById('content');
    
    switch(page) {
        case 'dashboard':
            contentDiv.innerHTML = '<h1>Dashboard</h1><p>Dashboard content here...</p>';
            break;
        case 'inventory':
            contentDiv.innerHTML = '<h1>Inventory</h1><p>Inventory content here...</p>';
            break;
        case 'reports':
            contentDiv.innerHTML = '<h1>Reports</h1><p>Reports content here...</p>';
            break;
        case 'settings':
            contentDiv.innerHTML = '<h1>Settings</h1><p>Settings content here...</p>';
            break;
    }
}