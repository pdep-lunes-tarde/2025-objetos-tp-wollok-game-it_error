import wollok.game.*
import tpIntegrador.*

object pollito {
    var posicion = new Position(x=15, y=0)
    var enElAire = false
    var ultimaAlturaSegura = 0

    method image() = "pollitoPdep.png"

    method position() = posicion

    // Salto
    method saltar(bloqueEnJuego) {
        if (!enElAire) { // solo puede saltar si está en el suelo o sobre un bloque
            enElAire = true
            self.subir(6, bloqueEnJuego)
        }
    }

    method subir(pasos, bloqueEnJuego) {
        if (pasos > 0) {
            posicion = posicion.up(1)
            game.schedule(60, { self.subir(pasos - 1, bloqueEnJuego) })
        } else {
            self.caer(bloqueEnJuego)
        }
    }

    // Caer
    method caer(bloqueEnJuego) {
        if (self.deberiaSeguirCayendo(bloqueEnJuego)) {
            posicion = posicion.down(1)
            game.schedule(60, { self.caer(bloqueEnJuego) })
        } else {
            enElAire = false
            if (bloqueEnJuego != null && self.estaSobreBloque(bloqueEnJuego)) {
                // Alineo al tope del bloque
                posicion = new Position(x = posicion.x(), y = bloqueEnJuego.position().y() - 1)
                ultimaAlturaSegura = posicion.y()
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
        var bloqueX = bloqueEnJuego.position().x()
        var bloqueY = bloqueEnJuego.position().y()
        var bloqueAncho = bloqueEnJuego.ancho()
        return self.entre(self.position().x(), bloqueX, bloqueX + bloqueAncho)
            && posicion.y() <= bloqueY && posicion.y() >= bloqueY - bloqueEnJuego.alto()
    }

    method entre(valor, min, max) {
        return valor >= min && valor <= max
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

    method pollitoEnBloque() {
        return pollitoEnBloque
    }
    
    method chocasteConPollito(unPollito) {
        // Si el pollito viene desde arriba: aterriza y se apila.
        if (unPollito.position().y() <= self.position().y()) {
            self.detener()
        } else {
            juegoSaltar.restart()
        }
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
        var bloqueX = self.position().x()
        var bloqueY = self.position().y()
        var bloqueAncho = self.ancho()
        var bloqueAlto = self.alto()
        
        var pollitoX = unPollito.position().x()
        var pollitoY = unPollito.position().y()
        
        var dentroX = self.entre(pollitoX, bloqueX, bloqueX + bloqueAncho)
        var dentroY = self.entre(pollitoY, bloqueY - bloqueAlto, bloqueY)
        
        return dentroX && dentroY
    }

    method entre(valor, min, max) {
        return valor >= min && valor <= max
    }

}