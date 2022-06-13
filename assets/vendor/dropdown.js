const dropdown = document.getElementById('dropdown');

const menuButton = document.getElementById('user-menu-button')

menuButton?.addEventListener('click', () => {
    const hidden = window.getComputedStyle(dropdown).getPropertyValue('display') === 'none'

    if (hidden) {
        dropdown.style.display = 'block'
    } else {
        dropdown.style.display = 'none'
    }
})