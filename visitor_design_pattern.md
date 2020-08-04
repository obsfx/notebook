# Visitor Design Pattern
Refs:

[Crafting Interpreters: Representing Code](https://craftinginterpreters.com/representing-code.html#the-visitor-pattern)

[Wikipedia - Visitor Pattern](https://en.wikipedia.org/wiki/Visitor_pattern)

In object oriented programming, visitor design pattern provides a way of seperating 
the operation logic from the class structure. If we hove to add new operation logics
very often, with visitor pattern we can do that without touching the exist class 
structure. And also, with this way we are not mixing unrelated code with the class
structure.

#### Implementation Example in TypeScript

We need an interface that will be implemented by every new Visitor implemented. Since 
the return type can be different for each individual Visitor implementation, This 
interface has generic return type.

```typescript
interface Visitor<R> {
    visitA(obj: A): R;
    visitB(obj: B): R;
    visitC(obj: C): R;
}
```

Every object that we will perform operation with the Visitor will be derrived from the
our 'Alphabet' abstract class and override their own accept method that calls related
visitor method from the passed Visitor implementation.

```typescript
abstract class Alphabet {
    abstract accept<R>(visitor: Visitor<R>): R;
}
```

Only thing we should do in objects is just overriding accept method with the 
new version of it that calls the operation we want to perform.

```typescript
class A extends Alphabet {
    constructor(...args) {
        super();
	    ...
    }

    accept<R>(visitor: Visitor<R>): R {
        return visitor.visitA(this);
    }
}
		
class B extends Alphabet {
    ...

    accept<R>(visitor: Visitor<R>): R {
        ...
    }
}
...
```
