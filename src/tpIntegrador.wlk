// Aca va el comportamiento del juego, que pasa si toca cada cosa
import src.saltar.*
import wollok.game.*

object juegoSaltar {
    const intervaloDeTiempoInicial = 70 // tiempo en que pasan los bloques
    var intervaloDeTiempo = intervaloDeTiempoInicial
    var ultimaAltura = 0
    var bloqueEnJuego = null
    var bloques = []
    var primeraVez = true // para la parte de configurar y que se pueda reiniciar
    var bloquesSaltados = 0
    var tiempoDeAparicionInicial = 4000
    var tiempoDeAparicion = tiempoDeAparicionInicial
    const property alturaCamara = 5  // cuando el pollito pasa esta altura, el mundo baja
    var property offsetCamara = 0

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

        game.onCollideDo(pollito, { otro =>
            otro.chocasteConPollito(pollito)
        })
        
        game.onTick(tiempoDeAparicion, "apareceBloque", {
            if(!bloques.isEmpty()) ultimaAltura = bloques.last().position().y() + bloques.last().alto()
            const nuevoBloque = new Bloque(posicion=new Position( x=0, y=ultimaAltura)) // cambiar el 3 a una varibale 
            
            game.addVisual(nuevoBloque)

            bloqueEnJuego = nuevoBloque
            bloques.add(nuevoBloque)

            game.onTick(intervaloDeTiempo, "moverBloque" + ultimaAltura, { 
                if(!nuevoBloque.pollitoEnBloque() && !nuevoBloque.seFueDePantalla()){
                    nuevoBloque.move()
                }

                if(nuevoBloque.chocandoPollito(pollito)){
                    nuevoBloque.chocasteConPollito(pollito)
                    game.removeVisual(nuevoBloque)
                }

                if(nuevoBloque.seFueDePantalla()){ // si salto uno entero
                    bloques.remove(nuevoBloque)
                }

            })

            bloquesSaltados += 1

            if(bloquesSaltados.even() && bloquesSaltados <= 20){
                intervaloDeTiempo -= 5
                tiempoDeAparicion -= 150
            }
        })   

        keyboard.space().onPressDo {
            pollito.saltar(bloqueEnJuego)
        }

        keyboard.up().onPressDo{
            self.restart()
            game.start()
        }
    }

    method restart() {
        game.clear()
        game.addVisual(mensajePerdiste)
        pollito.reiniciar()
        bloquesSaltados = 0
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

    method actualizarCamara() {
        const alturaPollito = pollito.posicion().y()
        if (alturaPollito > offsetCamara + alturaCamara) {
            const delta = alturaPollito - (offsetCamara + alturaCamara)
            offsetCamara += delta
            bloques.forEach({ b => b.posicion(new Position(x = b.posicion().x(), y = b.posicion().y() - delta ))})
            pollito.posicion(new Position(x = pollito.posicion().x(), y = pollito.posicion().y() - delta)) 
        }
    }
}