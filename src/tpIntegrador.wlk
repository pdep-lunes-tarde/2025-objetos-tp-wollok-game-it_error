// Aca va el comportamiento del juego, que pasa si toca cada cosa
import src.saltar.*
import wollok.game.*

object juegoSaltar {
    const intervaloDeTiempoInicial = 70 // tiempo en que pasan los bloques
    var intervaloDeTiempo = intervaloDeTiempoInicial
    var ultimaAltura = 0
    var bloqueEnJuego = null
    var property bloques = []
    var primeraVez = true // para la parte de configurar y que se pueda reiniciar
    var tiempoDeAparicionInicial = 4000
    var tiempoDeAparicion = tiempoDeAparicionInicial

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
        ultimaAltura = 0
        bloqueEnJuego = null
        bloques = []

        pollito.ultimaAlturaSegura(0)


        game.addVisual(pollito)
        game.addVisual(puntaje)

        game.onCollideDo(pollito, { otro =>
            otro.chocasteConPollito(pollito)
        })
        
        game.onTick(tiempoDeAparicion, "apareceBloque", {
            if(!bloques.isEmpty()) ultimaAltura = bloques.last().posicion().y() + bloques.last().alto()
            const nuevoBloque = new Bloque(posicion=new Position( x=0, y=ultimaAltura)) 
            
            game.addVisual(nuevoBloque)

            bloqueEnJuego = nuevoBloque
            bloques.add(nuevoBloque)

            game.onTick(intervaloDeTiempo, "moverBloque" + ultimaAltura, { 
                nuevoBloque.analizarJuego(ultimaAltura, bloques)
            })

            if(bloques.size().even() && bloques.size() <= 20){
                intervaloDeTiempo -= 2
                tiempoDeAparicion -= 150
            }
        })   

        keyboard.space().onPressDo {
            pollito.saltar(bloqueEnJuego)
        }

    }

    method restart() {
        game.clear()
        game.addVisual(mensajePerdiste)
        pollito.reiniciar()
        puntaje.reiniciar()
        bloques = []
        intervaloDeTiempo = intervaloDeTiempoInicial
        tiempoDeAparicion = tiempoDeAparicionInicial
        camara.moverA(0)

        keyboard.space().onPressDo {
            game.clear()
            self.configurar()
           
        }
    }

    method jugar() {
        self.configurar()

        game.start()
    }

}