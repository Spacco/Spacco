package it.unibo.caterva.lib

import org.eclipse.xtend.lib.annotations.Data
import com.google.inject.Singleton
import it.unibo.caterva.core.AggregateSupport
import java.util.Set
import it.unibo.caterva.core.Field

@Singleton @Data class Alignment {
	
	val AggregateSupport fc
	
    def <O> O branch(boolean b, ()=>O then, ()=>O otherwise) {
    	fc.restrictedOn(b, [(if (it) then else otherwise).apply()])
    }
    def <I, O, K> alignedForEach(Iterable<I> target, (I, int)=>K key, (I, int, K)=>Object fun) {
    	target.forEach[v, i | fc.restrictedOn(key.apply(v, i), [fun.apply(v, i, it)])]
    }
    def <I, O> alignedForEach(Iterable<I> target, (I, int)=>Object fun) {
    	target.forEach[v, i | fc.restrictedOn(i, [fun])]
    }
    def <I, O> alignedForEach(Iterable<I> target, (I)=>Object fun) {
    	target.forEach[v, i | fc.restrictedOn(i, [fun])]
    }
    def <I, O> Iterable<O> alignedMap(Set<I> target, (I)=>O mapper) {
    	target.map[fc.restrictedOn(it, mapper)]
    }
    def <I, K, O> Iterable<O> alignedMap(Iterable<I> target, (I)=>K keygen, (I, K)=>O mapper) {
    	target.map[v | fc.restrictedOn(keygen.apply(v), [mapper.apply(v, it)])]
    }
    def <I, K, O> Field<O> alignedMap(Field<I> target, (I)=>K keygen, (I, K)=>O mapper) {
    	target.map[v | fc.restrictedOn(keygen.apply(v), [mapper.apply(v, it)])]
    }
    
}