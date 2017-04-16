package org.protelis2.lib

import org.protelis2.core.Field
import org.eclipse.xtend.lib.annotations.Data
import com.google.inject.Singleton

@Data @Singleton final class Standard {
	
    def static <K extends Comparable<K>> K minHoodWithSelf(Field<K> f) {
        f.reduceWithSelf[if ($0 < $1) $0 else $1]
    }

    def static <K extends Comparable<K>> K minHood(Field<K> f, K defVal) {
        f.reduce[if ($0 < $1) $0 else $1].or(defVal)
    }
    
    def static <K> K mux(boolean condition, K then, K otherwise) {
    	if (condition) then else otherwise
    }
    
    def static <K extends Comparable<K>> min(K v1, K v2) {
    	if (v1 < v2) v1 else v2
    }

    def static <K extends Comparable<K>> max(K v1, K v2) {
    	if (v1 > v2) v1 else v2
    }
    
}