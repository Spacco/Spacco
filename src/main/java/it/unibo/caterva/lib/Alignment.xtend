package it.unibo.caterva.lib

import org.eclipse.xtend.lib.annotations.Data
import com.google.inject.Singleton
import it.unibo.caterva.core.AggregateSupport

@Singleton @Data class Alignment {
	
	val AggregateSupport fc
	
    def <O> O branch(boolean b, ()=>O then, ()=>O otherwise) {
    	fc.restrictedOn(b, [(if (it) then else otherwise).apply()])
    }
    def <I, O, K> forEach(Iterable<I> target, (I, int)=>K key, (I, int, K)=>Object fun) {
    	target.forEach[v, i | fc.restrictedOn(key.apply(v, i), [fun.apply(v, i, it)])]
    }
    
}