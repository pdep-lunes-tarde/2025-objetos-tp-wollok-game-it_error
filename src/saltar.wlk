import wollok.game.*
import tpIntegrador.*

object pollito {
    var position = new Position(x=5, y=0) // Cambia 'posicion' por 'position'

    method image() {
        return "pollito.png"
    }

    method position() {
        return position
    }

    method move() {
        position = position.up(2)
    }
}

//*****************************************************//

class Bloque {
    var property position // Cambia 'posicion' por 'position'

    method image() {
        return "bloque.png"
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