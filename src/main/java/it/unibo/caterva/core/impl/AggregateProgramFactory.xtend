package it.unibo.caterva.core.impl

import com.google.inject.Guice
import it.unibo.caterva.core.AggregateSupport
import it.unibo.caterva.core.impl.Context
import java.util.Map
import java.lang.reflect.Constructor
import it.unibo.caterva.core.DeviceUID
import it.unibo.caterva.core.impl.NullDevice
import it.unibo.caterva.core.Comm
import it.unibo.caterva.core.impl.NoCommunication
import it.unibo.caterva.core.AggregateProgram
import org.eclipse.xtext.xbase.lib.Functions.Function0
import it.unibo.caterva.core.CodePointGenerator
import it.unibo.caterva.lib.Time
import it.unibo.caterva.lib.Standard
import it.unibo.caterva.lib.Alignment

final class AggregateProgramFactory {
	def static <P extends Function0<X>, X, A> AggregateProgram<P, X> createProgram(
		Class<P> programClass,
		Map<Class<?>, Class<?>> bindings
	) {
		val injector = Guice.createInjector[
			val bindIfAbsent = [Class<?> target, Class<?> implementation  |
				if (!bindings.containsKey(target)) {
					val constructors = implementation.constructors as Constructor<A>[]
					if (constructors.length != 1) {
						throw new IllegalStateException('''«target»'s implementation «implementation» must have a single constructor''')
					}
					bind(target as Class<A>).toConstructor(constructors.get(0))
				}
			]
			bindIfAbsent.apply(typeof(AggregateSupport), typeof(Context))
			bindIfAbsent.apply(typeof(Standard), typeof(Standard))
			bindIfAbsent.apply(typeof(DeviceUID), typeof(NullDevice))
			bindIfAbsent.apply(typeof(Comm), typeof(NoCommunication))
			bindIfAbsent.apply(typeof(Time), typeof(Time))
			bindIfAbsent.apply(typeof(CodePointGenerator), typeof(SimpleStack))
			bindIfAbsent.apply(typeof(Alignment), typeof(Alignment))
			bindings.forEach[k, v| bind(k as Class<A>).to(v as Class<? extends A>)]
		]
		val P programInstance = injector.getInstance(programClass)
		val AggregateSupport context = injector.getInstance(typeof(AggregateSupport))
		new AggregateProgram<P, X>() {
			override getProgram() { programInstance }
			override apply() {context.cycle(program)}
		}
	}
}