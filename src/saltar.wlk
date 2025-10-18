import wollok.game.*
import tpIntegrador.*

object pollito {
    var posicion = new Position(x=20, y=0)
    var enElAire = false
    var ultimaAlturaSegura = 0

    method image() = "pollitoPdep.png"

    method position() = posicion

    // Salto
    method saltar(bloqueEnJuego) {
        if (!enElAire) { // solo puede saltar si está en el suelo o sobre un bloque
            enElAire = true
            self.subir(6, bloqueEnJuego) // altura del salto (4 celdas, podés ajustarlo)
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

    // Caer
    method caer(bloqueEnJuego) {
        // Antes de bajar, verificamos si ya debería quedarse arriba del bloque o del suelo
        if (self.deberiaSeguirCayendo(bloqueEnJuego)) {
            posicion = posicion.down(1)
            game.schedule(60, { self.caer(bloqueEnJuego) })
        } else {
            enElAire = false
            // Alinear exactamente con el bloque o el suelo
            if (self.estaSobreBloque(bloqueEnJuego)) {
                posicion = new Position(x = posicion.x(), y = bloqueEnJuego.position().y() + 2) // no se porque no me deja poner lo de alto, queda levitando
                ultimaAlturaSegura = bloqueEnJuego.position().y() + 2
                bloqueEnJuego.detener()

            } else {
                posicion = new Position(x = posicion.x(), y = ultimaAlturaSegura)
            }
        }
    }

    method deberiaSeguirCayendo(bloqueEnJuego) {
        if (posicion.y() <= ultimaAlturaSegura) return false
        if (self.estaSobreBloque(bloqueEnJuego)) return false
        return true
    }

    method estaSobreBloque(bloqueEnJuego) {
        var bloqueX = bloqueEnJuego.position().x()
        var bloqueY = bloqueEnJuego.position().y()
        var bloqueAncho = 200  // ajustar según tamaño real del bloque

        return self.entre(self.position().x(), bloqueX, bloqueX + bloqueAncho)
            && posicion.y() <= bloqueY + bloqueEnJuego.alto()
            && posicion.y() >= bloqueY
    }

    method entre(valor, min, max) {
        return valor >= min && valor <= max
    }

}


//*****************************************************//

class Bloque {
    var property position // Cambia 'posicion' por 'position'
    var property pollitoEnBloque = false

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

    method detener(){
        pollitoEnBloque = true
    }

    method alto(){
        return 3 // Como hacemos para ver el tamaño del bloque???
    }

}