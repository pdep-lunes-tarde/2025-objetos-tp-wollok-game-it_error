// Aca va el comportamiento del juego, que pasa si toca cada cosa
import src.saltar.*
import wollok.game.*

object juegoSaltar {
    const intervaloDeTiempoInicial = 100 // tiempo en que pasan los bloques
    var intervaloDeTiempo = intervaloDeTiempoInicial
    var ultimaAltura = 0

    method intervaloDeTiempo() {
        return intervaloDeTiempo
    }

    method ancho() {
        return 50
    }
    method alto() {
        return 100
    }

    method configurar() {
        game.width(self.ancho())
        game.height(self.alto())
        game.cellSize(32)

        game.addVisual(pollito)

        game.onCollideDo(pollito, { otro =>
            otro.chocasteConPollito(pollito)
        })

        game.onTick(4000, "apareceBloque", {
            const nuevoBloque = new Bloque(position=new Position( x=0, y=ultimaAltura + 2))
            ultimaAltura = ultimaAltura + 2
            game.addVisual(nuevoBloque)

            game.onTick(10, "moverBloque" + ultimaAltura, { 
                nuevoBloque.move()

                if (nuevoBloque.position().x() >= self.ancho()) {
                    self.restart()
                }
            })
        })

        keyboard.space().onPressDo {
            pollito.move()
        }
    }

    method restart() {
        intervaloDeTiempo = intervaloDeTiempoInicial
        game.clear()
        self.configurar()
    }

    method jugar() {
        // self.configurar()

        game.start()
    }

}


// //obs
// si pasa dde largo choca al pollo

//Ideas de como complejizarlo 
// Distintos bloques
// ** que vayan aumentando la velocidad los bloques
// ** que se vayan haciendo mas angostos los bloques
// ** poder apilar infinitos bloques