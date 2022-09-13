---
title: Accessing Private Properties in PHP without Reflection
date: 2022-09-13 08:52:15
modified: 2022-09-13T09:41:50-0500
published: true
description: Closures give us a great way to access private properties without using Reflection
tags:
    - programming
    - webdev
    - php
# cover_image: 
---

I was discussing this technique during a code review recently, and I realized this cool technique might not be well known. I discovered it quite by accident a few years ago.

Sometimes, *strictly for testing purposes*, we might need to access a private or protected property or method. Our usual inclination is to use Reflection to do this. Reflection is a bit cumbersome, though, because there’s a lot of extra boilerplate to set it up.

But closures actually provide us with a cool way to do that much more easily. If you’ve ever used JavaScript’s [`bind`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind) method, we can do the same thing in PHP.

Let's start with a sample class:

```php
class Person
{
    public string $name = 'Dan';
    protected int $age  = 40;
    private bool $cool  = true;
    
    protected static string $species = 'homo sapien';
    
    protected static function evolve(): void
    {
        static::$species = 'homo superior';
    }
    
    protected function birthday(): void
    {
        $this->age++;
    }
    
    public function howOldAmI(): int
    {
        return $this->age;
    }
}

$me = new Person();
```

## Non-static properties

We know how to read and change `$me->name`. It's public, so there's no problem there.

Now, what if we need, somewhere in a test, to set the exact age. That's a protected property, so we can't just directly change it, but Closures can give us a way around that.

```php
(fn (int $newAge) => $this->age = $newAge)->call($me, 30); // Changes $me->age to 30
```

So, what did we do here? Let's break it down a bit.

```php
$changeAge = (fn (int $newAge) => $this->age = $newAge);
```

First, we create a closure that changes `$this->age` to whatever is passed to it. If we tried to do `$changeAge(30)`, we'd get an error, though, because we defined this outside of the class. `$this` doesn't actually exist here, or, if we put this code in a unit test, `$this` would refer to the unit test class itself.

That's where `call` comes in. [`Closure::call`](https://www.php.net/manual/en/closure.call.php) binds a closure to a new object, and calls it with whatever args you passed to it. In other words, the first argument passed to `call` become the `$this` within the closure. Any other arguments are passed to the function itself.

```php
$changeAge->call($me, 30);
```

We can also simply access the `$age` and `$cool` properties without changing them. So, I can do:

```php
$amICool = (fn () => $this->cool)->call($me); // true
$myAge   = (fn () => $this->age)->call($me);
```

## Static properties

That works great for the non-static properties or methods. What about the static ones?

```php
$mySpecies = (fn () => static::$species)->bindTo(null, Person::class)(); // homo sapien
(fn () => static::evolve())->bindTo(null, Person::class)(); // Changes to homo superior
(fn (string $newSpecies) => static::$species = $newSpecies)->bindTo(null, Person::class)('homo erectus'); // devolve to homo erectus
```

So, this is a little different. First, we're using [`Closure::bindTo`](https://www.php.net/manual/en/closure.bindto.php) which returns a new closure, which has been re-bound to the specified object or class. With `bindTo`, you can pass an object (like `call`), or you can leave that null and pass a class instead, which changes the static binding. That's what we've done here. And since it returns a new closure, you then have to call it, which is why we have an extra `()` after.

So, let's break this down step-by-step as well.

```php
$getSpecies = (fn () => static::$species);
```

A closure which returns that `$species` of the current scope.

```php
$boundGetSpecies = $getSpecies->bindTo(null, Person::class);
```

A new closure, which changes the scope to `Person`, meaning any references to `static` refer to `Person`.

```php
$mySpecies = $boundGetSpecies();
```

Or, if we to change the species to an arbitrary value, as we did in the third one:

```php
// Create species changing closure, initially bound to the current scope
$changeSpecies = (fn (string $newSpecies) => static::$species = $newSpecies);
// Create a new Closure, bound to the Person scope
$changePersonSpecies = $changeSpecies->bindTo(null, Person::class);
// Change it to whatever
$changePersonSpecies('homo erectus');
```

## Using `bindTo` with an object

You can use `bindTo` in a similar way to `call`.

```php
(fn () => $this->birthday())->bindTo($me)();
```

Let's break it down.

```php
$haveABirthday = (fn () => $this->birthday());
```

Closure which calls `birthday()` on the object within the current scope.

```php
$haveMyBirthday = $haveABirthday->bindTo($me);
```

Create a new closure with `$me` as the scope. This way, any reference to `$this` refers to `$me`.

```php
$haveMyBirthday();
```

Since `$haveMyBirthday` is a closure, we have to actually call it.

## Conclusion

Sure, we can use [`ReflectionClass`](https://www.php.net/manual/en/class.reflectionclass.php) and [`ReflectionObject`](https://www.php.net/manual/en/class.reflectionobject.php) to do all of this, but this technique greatly simplifies it, since calling a single private method is a single line of code.

I actually use this in a [package I recently wrote](https://packagist.org/packages/danjones000/object-spy) that should make this even easier.

And to reiterate, I do not recommend doing this in production code. There's a reason visibility exists. We shouldn't circumvent it like this in code on our server. But, if we need to fiddle around with some objects for testing, this technique can simplify that for us.
