
g = new window.Game({
  path: window.location.pathname.substr(0,window.location.pathname.lastIndexOf('/')) + '/d'
})
g.render()