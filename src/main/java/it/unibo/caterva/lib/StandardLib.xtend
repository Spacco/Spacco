package it.unibo.caterva.lib

import it.unibo.caterva.core.Field
import org.eclipse.xtend.lib.annotations.Data

@Data class StandardLib {

    def <K extends Comparable<K>> K minHoodWithSelf(Field<K> f) {
        f.reduceWithSelf[if ($0 < $1) $0 else $1]
    }

    def <K extends Comparable<K>> K minHood(Field<K> f, K defVal) {
        f.reduce[if ($0 < $1) $0 else $1].or(defVal)
    }

}