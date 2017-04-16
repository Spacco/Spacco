package org.protelis2

import com.google.inject.Guice
import com.google.inject.Provider
import com.google.inject.TypeLiteral
import org.protelis2.core.AggregateProgram
import org.protelis2.core.AggregateSupport
import org.protelis2.core.Comm
import org.protelis2.core.DeviceUID
import org.protelis2.core.Environment
import org.protelis2.core.impl.Context
import org.protelis2.core.impl.MapBackedEnvironment
import org.protelis2.core.impl.NoCommunication
import org.protelis2.core.impl.NullDevice
import java.lang.reflect.Constructor
import java.lang.reflect.Modifier
import java.util.LinkedHashMap
import java.util.LinkedHashSet
import java.util.List
import java.util.Map
import java.util.Set
import org.eclipse.xtext.xbase.lib.Functions.Function0
import org.protelis2.core.impl.SimpleStack
import org.protelis2.core.Stack
import org.reflections.Reflections
import org.apache.commons.math3.random.RandomGenerator
import it.unimi.dsi.util.XoRoShiRo128PlusRandomGenerator
import org.protelis2.lib.Alignment
import org.protelis2.lib.Standard
import org.protelis2.lib.State
import org.protelis2.lib.Time
import org.protelis2.lib.Spreading
import org.protelis2.sensors.DistanceSensor
import org.protelis2.sensors.impl.EuclideanDistanceSensor
import org.protelis2.sensors.PositionSensor
import org.protelis2.sensors.impl.ZeroPositionSensor

final class VM<T> {

	val Map<TypeLiteral<?>, TypeLiteral<?>> classBindings
	val Map<TypeLiteral<?>, Constructor<?>> constructorBindings
	val Map<TypeLiteral<?>, Object> instanceBindings
	val Map<TypeLiteral<?>, Provider<?>> providerBindings
	val Set<TypeLiteral<?>> concreteTypes
	
	private new(Map<TypeLiteral<?>, TypeLiteral<?>> classBindings,
				Map<TypeLiteral<?>, Constructor<?>> constructorBindings,
				Map<TypeLiteral<?>, Object> instanceBindings,
				Map<TypeLiteral<?>, Provider<?>> providerBindings,
				Set<TypeLiteral<?>> concreteTypes) {
		this.classBindings = classBindings
		this.constructorBindings = constructorBindings
		this.instanceBindings = instanceBindings
		this.providerBindings = providerBindings
		this.concreteTypes = concreteTypes
	}

	def <P extends Function0<T>, T> AggregateProgram<P, T> makeProgram(Class<P> target) {
		val injector = Guice.createInjector[
			classBindings.forEach[k, v | bind(k as TypeLiteral<Object>).to(v)]
			constructorBindings.forEach[k, v | bind(k as TypeLiteral<Object>).toConstructor(v)]
			instanceBindings.forEach[k, v | bind(k as TypeLiteral<Object>).toInstance(v)]
			providerBindings.forEach[k, v | bind(k as TypeLiteral<Object>).toProvider(v)]
			concreteTypes.forEach[k | bind(k as TypeLiteral<Object>)]
		]
		val instance = injector.getInstance(target)
		val AggregateSupport context = injector.getInstance(typeof(AggregateSupport))
		new AggregateProgram<P, T>() {
			override getProgram() { instance }
			override apply() {context.cycle(program)}
		}
	}
	
	def static void main(String... a) {
		println(new Reflections().getSubTypesOf(typeof(Stack)))
	}
	
	static class Builder<T> {
		val Set<TypeLiteral<?>> registered = new LinkedHashSet
		val Set<TypeLiteral<?>> concreteTypes = new LinkedHashSet
		val Map<TypeLiteral<?>, TypeLiteral<?>> classBindings = new LinkedHashMap
		val Map<TypeLiteral<?>, Constructor<?>> constructorBindings = new LinkedHashMap
		val Map<TypeLiteral<?>, Object> instanceBindings = new LinkedHashMap
		val Map<TypeLiteral<?>, Provider<?>> providerBindings = new LinkedHashMap
		val List<Map<?,?>> allBindings = #[classBindings, constructorBindings, instanceBindings, providerBindings]

		private new() { }

		def static <T extends Function0<?>> Builder<T> empty() {
			new Builder()
		}

		def static <T extends Function0<?>> Builder<T> withDefault() {
			val builder = empty()
				.map(typeof(AggregateSupport), typeof(Context))
				.map(typeof(Comm), typeof(NoCommunication))
				.map(typeof(DeviceUID), typeof(NullDevice))
				.map(typeof(Environment), typeof(MapBackedEnvironment))
				.map(typeof(Stack), typeof(SimpleStack))
				.map(typeof(RandomGenerator), typeof(XoRoShiRo128PlusRandomGenerator))
				.registerConstructor(typeof(Alignment))
				.registerConstructor(typeof(Standard))
				.registerConstructor(typeof(State))
				.registerConstructor(typeof(Time))
				.registerConstructor(typeof(Spreading))
				.map(typeof(DistanceSensor), typeof(EuclideanDistanceSensor))
				.map(typeof(PositionSensor), typeof(ZeroPositionSensor))
				.registerConstructor(typeof(EuclideanDistanceSensor))
				.registerConstructor(typeof(ZeroPositionSensor))
			builder
		}
	
		private def cleanIfNeeded(TypeLiteral<?> type) {
			if (registered.contains(type)) {
				allBindings.forEach[it.remove(type)]
				registered.remove(type)
			}
		}
	
		private def <Y> map(Map<TypeLiteral<?>, Y> map, TypeLiteral<?> type, Y to) {
			cleanIfNeeded(type)
			map.put(type, to)
			this
		}

		def <X> register(TypeLiteral<X> type) {
			if (Modifier.isAbstract(type.rawType.modifiers)) {
				throw new IllegalArgumentException('''Could not register abstract type «type»''')
			}
			cleanIfNeeded(type)
			concreteTypes.add(type)
			registered.add(type)
			this
		}
		def <X> register(Class<X> type) { register(TypeLiteral.get(type)) }
		def <X> registerConstructor(Class<X> type) { 
			if (Modifier.isAbstract(type.modifiers)) {
				throw new IllegalArgumentException(type + " must be concrete")
			}
			val constructors = type.constructors
			if (constructors.length != 1) {
				throw new IllegalArgumentException(type + " must have a single constructor")
			}
			map(type, constructors.get(0) as Constructor<X>)
			this
		}
		def <X> map(TypeLiteral<X> type, TypeLiteral<? extends X> to) { map(classBindings, type, to); this }
		def <X> map(TypeLiteral<X> type, Constructor<? extends X> to) { map(constructorBindings, type, to); this }
		def <X> map(TypeLiteral<X> type, Provider<? extends X> to) { map(providerBindings, type, to); this }
		def <X, Y extends X> map(TypeLiteral<X> type, Y to) { map(instanceBindings, type, to); this }

		def <X> map(Class<X> type, Class<? extends X> to) { map(type, TypeLiteral.get(to)) }
		def <X> map(TypeLiteral<X> type, Class<? extends X> to) { map(type, TypeLiteral.get(to)) }
		def <X> map(Class<X> type, TypeLiteral<? extends X> to) { map(TypeLiteral.get(type), to) }
		def <X> map(Class<X> type, Constructor<? extends X> to) { map(TypeLiteral.get(type), to) }
		def <X> map(Class<X> type, Provider<? extends X> to) { map(TypeLiteral.get(type), to) }
		def <X, Y extends X> map(Class<X> type, Y to) { map(TypeLiteral.get(type), to) }
		
		def build() {
			new VM(classBindings, constructorBindings, instanceBindings, providerBindings, concreteTypes)
		}
	}
	
	
}