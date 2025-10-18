// Aca va el comportamiento del juego, que pasa si toca cada cosa
import src.saltar.*
import wollok.game.*

object juegoSaltar {
    const intervaloDeTiempoInicial = 100 // tiempo en que pasan los bloques
    var intervaloDeTiempo = intervaloDeTiempoInicial
    var ultimaAltura = 0
    var bloqueEnJuego = 0

    method intervaloDeTiempo() {
        return intervaloDeTiempo
    }

    method ancho() {
        return 40
    }
    method alto() {
        return 60
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
            ultimaAltura = ultimaAltura + nuevoBloque.alto()
            game.addVisual(nuevoBloque)

            bloqueEnJuego = nuevoBloque

            
            game.onTick(50, "moverBloque" + ultimaAltura, { 
                if(!nuevoBloque.pollitoEnBloque()){
                    nuevoBloque.move()
                }
            })
            
        })

        keyboard.space().onPressDo {
            pollito.saltar(bloqueEnJuego)
        }

        keyboard.up().onPressDo{
            juegoSaltar.restart()
            game.start()
        }
    }

    method restart() {
        intervaloDeTiempo = intervaloDeTiempoInicial
        game.clear()
        //self.configurar()
        game.start()
    }

    method jugar() {
        self.configurar()

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