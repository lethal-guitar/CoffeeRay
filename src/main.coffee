$(document).ready -> 
    canvas = document.getElementById('screen')
    coffeeRay = new CoffeeRay(canvas)
    coffeeRay.render()
