package it.unibo.caterva.core

interface AggregateSupport {

    def <I, O> O restrictedOn(I x, (I)=>O fun)
    def <K> Field<K> neighbor(K x)
    def <X> X stateful(X init, (X)=>X f)
    def DeviceUID self()
    def <X> X cycle(=>X program)

}