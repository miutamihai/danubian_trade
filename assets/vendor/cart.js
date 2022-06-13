const cart = document.getElementById('cart')

const cartButton = document.getElementById('cart_button')

const dropdown = document.getElementById('dropdown');

cartButton?.addEventListener('click', () => {
    const hidden = window.getComputedStyle(cart).getPropertyValue('display') === 'none'

    if (hidden) {
        dropdown.style.display = 'none'
        cart.style.display = 'block'
    } else {
        cart.style.display = 'none'
    }
})