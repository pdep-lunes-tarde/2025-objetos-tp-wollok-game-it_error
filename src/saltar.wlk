import wollok.game.*
import tpIntegrador.*

object pollito {
    var property posicion = new Position(x=15, y=0)
    var enElAire = false
    var property ultimaAlturaSegura = 0
    const alturaSalto = 6
    var property velocidadSalto = 60

    method image() = "pollitoPdep.png"

    method position() = posicion

    // Salto
    method saltar(bloqueEnJuego) {
        if (!enElAire) { // solo puede saltar si está en el suelo o sobre un bloque
            enElAire = true
            self.subir(alturaSalto, bloqueEnJuego)
        }
    }

    method subir(pasos, bloqueEnJuego) {
        if (pasos > 0) {
            posicion = posicion.up(1)
            game.schedule(velocidadSalto, { self.subir(pasos - 1, bloqueEnJuego) })
        } else {
            self.caer(bloqueEnJuego)
        }
    }

    // Caer
    method caer(bloqueEnJuego) {
        if (self.deberiaSeguirCayendo(bloqueEnJuego)) {
            posicion = posicion.down(1)
            game.schedule(velocidadSalto, { self.caer(bloqueEnJuego) })
        } else {
            enElAire = false
            if (bloqueEnJuego != null && self.estaSobreBloque(bloqueEnJuego)) {
                // Alineo al tope del bloque
                posicion = new Position(x = posicion.x(), y = bloqueEnJuego.position().y() + bloqueEnJuego.alto() - 1)
                ultimaAlturaSegura = bloqueEnJuego.position().y() + bloqueEnJuego.alto() - 1
                bloqueEnJuego.detener()
            } else {
                posicion = new Position(x = posicion.x(), y = ultimaAlturaSegura)
            }
        }
    }

    method deberiaSeguirCayendo(bloqueEnJuego) {
        if (posicion.y() <= ultimaAlturaSegura) return false
        if (bloqueEnJuego != null && self.estaSobreBloque(bloqueEnJuego)) return false
        return true
    }

    method estaSobreBloque(bloqueEnJuego) {
        if (bloqueEnJuego == null) return false
        const bloqueX = bloqueEnJuego.position().x()
        const bloqueY = bloqueEnJuego.position().y()
        const bloqueAncho = bloqueEnJuego.ancho()
        
        return self.entre(self.position().x(), bloqueX, bloqueX + bloqueAncho)
            && posicion.y() >= bloqueY + bloqueEnJuego.alto()
            
    }

    method entre(valor, min, max) {
        return valor >= min && valor <= max
    }

    method reiniciar(){
        posicion = new Position(x = 15, y = 0)
        enElAire = false
        ultimaAlturaSegura = 0
    }

}


//*****************************************************//

class Bloque {
    var property position
    var property pollitoEnBloque = false
    var moviendose = true
    var apilado = false
    var yaGenero = false

    method image() {
        return "bloque.jpg"
    }
    method position() {
        return position
    }
    
    method chocasteConPollito(unPollito) {
        self.detener()
        juegoSaltar.restart()
    }
    
    method move(){
        if (moviendose) {
            position = position.right(1)
        }
    }

    method detener(){
        pollitoEnBloque = true
        moviendose = false
        apilado = true
        // yaGenero queda false hasta que el juego genere el bloque superior
    }

    method seFueDePantalla() = self.position().x() > game.width()

    method fueraDeLaPantalla() {
      return self.position().x() > juegoSaltar.ancho()
    }

    method alto(){ 
        return 3
    }

    method ancho(){
        return 2
    }
    
    method chocandoPollito(unPollito){
        const bx = self.position().x()
        const by = self.position().y()
        const ancho = self.ancho()
        const alto = self.alto()

        const px = unPollito.position().x()
        const py = unPollito.position().y()

        const dentroX = (px >= bx) && (px < bx + ancho)
        const dentroY = (py >= by - alto) && (py <= by)
        return dentroX && dentroY
    }

    method entre(valor, min, max) {
        return valor >= min && valor <= max
    }

}

object mensajePerdiste {
    method position() {
        return game.at(15, game.height()/2)
    }

    method image() {
        return "Game_Over2.png" 
    }
}