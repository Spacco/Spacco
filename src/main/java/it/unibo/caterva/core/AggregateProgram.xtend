package it.unibo.caterva.core

interface AggregateProgram {

    def <I, O> O restrictedOn(I x, (I)=>O fun);
    def <K> Field<K> neighbor(K x);
    def <X> X stateful(X x, (X)=>X f);
    def Device self();
}