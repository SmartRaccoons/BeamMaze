
update = -> document.getElementById('actual-map').value = window.GAME.get_map()
window.GAME.bind 'rotation-stop', update
setTimeout update, 1000
