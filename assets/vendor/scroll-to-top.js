const getScrollToTopButton = () => document.getElementById('scroll-to-top')

const scroll = () => {
    const scrollButton = getScrollToTopButton()

    if (scrollButton) {
        if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
            scrollButton.style.display = 'block'
        } else {
            scrollButton.style.display = 'none'
        }
    }
}

window.onscroll = scroll