// Aca va el comportamiento del juego, que pasa si toca cada cosa
import src.saltar.*
import wollok.game.*

object juegoSaltar {
    const intervaloDeTiempoInicial = 100 // tiempo en que pasan los bloques
    var intervaloDeTiempo = intervaloDeTiempoInicial
    var ultimaAltura = -2
    var bloqueEnJuego = null
    var bloques = []
    var primeraVez = true // para la parte de configurar y que se pueda reiniciar

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
        if(primeraVez){
            game.width(self.ancho())
            game.height(self.alto())
            game.cellSize(32)
            primeraVez = false
        }

        //reiniciar variables para la segunda vuelta
        intervaloDeTiempo = intervaloDeTiempoInicial
        ultimaAltura = -2
        bloqueEnJuego = null
        bloques = []


        game.addVisual(pollito)

        game.onCollideDo(pollito, { otro =>
            otro.chocasteConPollito(pollito)
        })
        
        game.onTick(4000, "apareceBloque", {
            const nuevoBloque = new Bloque(position=new Position( x=0, y=ultimaAltura + 3))
            ultimaAltura = ultimaAltura + nuevoBloque.alto()
            game.addVisual(nuevoBloque)

            bloqueEnJuego = nuevoBloque

            
            game.onTick(50, "moverBloque" + ultimaAltura, { 
                if(!nuevoBloque.pollitoEnBloque()){
                    nuevoBloque.move()
                }

                if(nuevoBloque.chocandoPollito(pollito)){
                    nuevoBloque.chocasteConPollito(pollito)
                    game.removeVisual(nuevoBloque)
                }

                if(nuevoBloque.position().x() > game.width()){
                    self.restart()
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
        game.clear()
        game.addVisual(mensajePerdiste)
        pollito.reiniciar()
        //game.stop()
        keyboard.space().onPressDo {
            game.clear()
            self.configurar()
           
        }
        //self.configurar()
        //game.start()
    }

    method jugar() {
        self.configurar()

        game.start()
    }

}