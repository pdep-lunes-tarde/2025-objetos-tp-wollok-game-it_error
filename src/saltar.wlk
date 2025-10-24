import wollok.game.*
import tpIntegrador.*

object pollito {
    var property posicion = new Position(x=15, y=0)
    var property enElAire = false
    var property ultimaAlturaSegura = 0
    const alturaSalto = 6
    var property velocidadSalto = 75

    method image() = "pollitoPdep.png"

    method position() = new Position(x=posicion.x(), y=camara.aplicar(posicion.y())) // devuelve la posicion acomodada a la camara
    
    // Salto
    method saltar(bloqueEnJuego) {
        if (!enElAire) { // solo puede saltar si está en el suelo o sobre un bloque
            enElAire = true
            self.subir(alturaSalto, bloqueEnJuego)
            game.schedule(velocidadSalto * alturaSalto, { self.caer(bloqueEnJuego) })
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
                posicion = new Position(x = posicion.x(), y = bloqueEnJuego.position().y() + bloqueEnJuego.alto())
                ultimaAlturaSegura = bloqueEnJuego.position().y() + bloqueEnJuego.alto()
                bloqueEnJuego.detener()

                // Actualizar cámara SOLO al aterrizar sobre bloque
                if (posicion.y() > camara.offsetY() + juegoSaltar.alturaCamara()) {
                    juegoSaltar.actualizarCamara()
                }
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

    method entre(valor, min, max) = valor >= min && valor <= max

    method reiniciar(){
        posicion = new Position(x = 15, y = 0)
        enElAire = false
        ultimaAlturaSegura = 0
    }

}

//*****************************************************//

class Bloque {
    var property posicion
    var property pollitoEnBloque = false
    var moviendose = true

    method image() =  "bloque.jpg"
    
    method position() = new Position(x=posicion.x(), y=camara.aplicar(posicion.y())) // devuelve la posicion acomodada para la pantalla
    
    method chocasteConPollito(unPollito) {
        self.detener()
        juegoSaltar.restart()
    }
    
    method move(){
        if (moviendose) {
            posicion = posicion.right(1)
        }
    }

    method detener(){
        pollitoEnBloque = true
        moviendose = false
    }

    method seFueDePantalla() = self.position().x() > game.width()

    method fueraDeLaPantalla() {
      return self.position().x() > juegoSaltar.ancho()
    }

    method alto() = 3

    method ancho() = 6
    
    method chocandoPollito(unPollito){
        const bx = self.position().x()
        const by = self.position().y()
        const ancho = self.ancho()
        const alto = self.alto()

        const px = unPollito.position().x()
        const py = unPollito.position().y()

        const dentroX = (px >= bx) && (px < bx + ancho)
        const dentroY = (py >= by - alto - 1) && (py <= by)
        
        return dentroX && dentroY
    }

    method entre(valor, min, max) = valor >= min && valor <= max

}

//*****************************************************//

object mensajePerdiste {
    method position() {
        return game.at(10, game.height()/2)
    }

    method image() = "Game_Over2.png" 
    
}

//*****************************************************//

object camara {
    var property offsetY = 0

    method moverA(y) {
        offsetY = y
    }

    method aplicar(yMundo) {
        return yMundo - offsetY
    }
}

object puntaje {
    var property puntos = 0 

    method text() = "Puntuacion: " + puntos.toString()

    method position() = game.at(1, game.height() - 2)

    method reiniciar(){
        puntos = -1  // reinicia a -1 porque toma el piso como saltado
    }

    method sumar() {
        puntos += 1
    } 
    
    method restar(){
        puntos -= 1
    }
}
