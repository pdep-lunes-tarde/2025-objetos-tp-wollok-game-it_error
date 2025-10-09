import wollok.game.*
import tpIntegrador.*

object pollito {
    var posicion = new Position(x=20, y=0)
    var enElAire = false

    method image() = "pollitoPdep.png"

    method position() = posicion

    // 🔹 Salto
    method saltar(bloqueEnJuego) {
        if (!enElAire) { // solo puede saltar si está en el suelo o sobre un bloque
            enElAire = true
            self.subir(10, bloqueEnJuego) // altura del salto (4 celdas, podés ajustarlo)
        }
    }

    method subir(pasos, bloqueEnJuego) {
        if (pasos > 0) {
            posicion = posicion.up(1)
            game.schedule(60, { self.subir(pasos - 1, bloqueEnJuego) }) // sube de a 1 cada 60ms
        } else {
            self.caer(bloqueEnJuego) // cuando termina de subir, empieza a caer
        }
    }

    method caer(bloqueEnJuego) {
        if (self.estaEnElAire(bloqueEnJuego)) {
            posicion = posicion.down(1)
            //algun punto de x del bloque coincide con algun punto de x del pollito
            if (self.entre(self.position().x(), bloqueEnJuego.position().x(), bloqueEnJuego.position().x() + 200)) {
                // pollito dentro del rango horizontal del bloque
                if (posicion.y() <= bloqueEnJuego.position().y() + 1) {
                // Ajusta la altura para que quede justo arriba del bloque
                    posicion = new Position(x = posicion.x(), y = bloqueEnJuego.position().y() + 1)
                    enElAire = false
                }
            }
            game.schedule(60, { self.caer(bloqueEnJuego) })

        } else {
            enElAire = false
        }
    }

    // 🔹 Detecta si está sobre el suelo (y=0) o sobre un bloque
    method estaEnElAire(bloqueEnJuego) {
        return posicion.y() > 0 && (posicion.y() > bloqueEnJuego.position().y() + 1 || !self.entre(self.position().x(), bloqueEnJuego.position().x(), bloqueEnJuego.position().x() + 200))
    }

    method entre(valor, min, max) {
        return valor >= min && valor <= max
    }

}


//*****************************************************//

class Bloque {
    var property position // Cambia 'posicion' por 'position'

    method image() {
        return "bloque.jpg"
    }
    method position() {
        return position
    }
    method chocasteConPollito(unPollito) {
        // perder
        juegoSaltar.restart()
    }
    method move(){
        position = position.right(1)
    }
}