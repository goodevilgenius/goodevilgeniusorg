---
title: 'golang: Understanding the difference between nil pointers and nil interfaces'
date: 2024-06-24 10:44:59
modified: 2024-06-25T11:30:02-0500
published: true
description: An explanation of the difference between nil interfaces and nil pointers in go
tags:
    - programming
    - webdev
    - go
    - golang
cover_image: https://dev-to-uploads.s3.amazonaws.com/uploads/articles/v5y3c9rhfkcy68ylgywd.jpg
---
I was thinking a bit about the different ways in which nil works in go, and how sometimes, something can be both nil and not nil at the same time.

[Here](https://go.dev/play/p/wgMSKWFjtvv) is a little example of something that can be a nil pointer, but not a nil interface. Let's walk through what that means.

## Interfaces

First, go has a concept of interfaces, which are similar, but not quite the same as interfaces in some object-oriented languages (go is not OOP by most definitions). In go, an interface is a type that defines functions that another type must implement to satisfy the interface. This allows us to have multiple concrete types that can satisfy an interface in different ways.

For example, `error` is a built-in interface that has a single method. It looks like this:

```go
type error interface {
    Error() string
}
```

Any type that wants to be used as an error must have a method called `Error` which returns a string. For example, the following code could be used:

```go
type ErrorMessage string

func (em ErrorMessage) Error() string {
    return string(em)
}

func DoSomething() error {
    // Try to do something, and it fails.
    if somethingFailed {
        var err ErrorMessage = "This failed"
        return err
    }
    return nil
}

func main() {
    err := DoSomething()
    if err != nil {
        panic(err)
    }
}
```

Notice in this example that `DoSomething` returns an `error` if something goes wrong. We can use our `ErrorMessage` type, because it has the `Error` function, which returns a string, and therefore implements the `error` interface.
If no error occurred, we returned nil.

## Pointers

In go, pointers point to a value, but they can also point to no value, in which case the pointer is nil. For example:

```go
var i *int = nil

func main() {
    if i == nil {
        j := 5
        i = &j
    }
    fmt.Println("i is", *i)
}
```

In this case, the `i` variable is a pointer to an int. It starts out as a nil pointer, until we create an int, and point it to that.

## Pointers and interfaces

Since user-defined types can have functions (methods) attached, we can also have functions for pointers to types. This is a very common practice in go. This also means that pointers can also implement interfaces. In this way, we could have a value that is a non-nil interface, but still a nil pointer. Consider the following code:

```go
type TruthGetter interface {
    IsTrue() bool
}

func PrintIfTrue(tg TruthGetter) {
    if tg == nil {
        fmt.Println("I can't tell if it's true")
        return
    }
    if tg.IsTrue() {
        fmt.Println("It's true")
    } else {
        fmt.Println("It's not true")
    }
}
```

Any type that has an `IsTrue() bool` method can be passed to `PrintIfTrue`, but so can `nil`. So, we can do `PrintIfTrue(nil)` and it will print "I can't tell if it's true".

We can also do something simple like this:

```go
type Truthy bool

func (ty Truthy) IsTrue() bool {
    return bool(ty)
}

func main() {
    var ty Truthy = true
    PrintIfTrue(ty)
}
```

This will print "It's true".

Or, we can do something more complicated, like:

```go
type TruthyNumber int

func (tn TruthyNumber) IsTrue() bool {
    return tn > 0
}

func main() {
    var tn TruthyNumber = -4
    PrintIfTrue(tn)
}
```

That will print "It's not true". Neither of these examples are pointers, and so there's no chance for a nil with either of these types, but consider this:

```go
type TruthyPerson struct {
    FirstName string
    LastName string
}

func (tp *TruthyPerson) IsTrue() bool {
    return tp.FirstName != "" && tp.LastName != ""
}
```

In this case `TruthyPerson` does not implement `TruthGetter`, but `*TruthyPerson` does. So, this should work:

```go
func main() {
    tp := &TruthyPerson{"Jon", "Grady"}
    PrintIfTrue(tp)
}
```

This works because `tp` is a pointer to a `TruthyPerson`. However, if the pointer is nil, we'll get a panic.

```go
func main() {
    var tp *TruthyPerson
    PrintIfTrue(tp)
}
```

This will panic. However, the panic doesn't happen in `PrintIfTrue`. You would think it's fine, because `PrintIfTrue` checks for nil. But, here's the issue. It's checking nil against a `TruthGetter`. In other words, it's checking for a nil interface, but not a nil pointer. And in `func (tp *TruthyPerson) IsTrue() bool`, we don't check for a nil. In go, we can still call methods on a nil pointer, so the panic happens there. The fix is actually pretty easy.

```go
func (tp *TruthyPerson) IsTrue() bool {
    if tp == nil {
        return false
    }
    return tp.FirstName != "" && tp.LastName != ""
}
```

Now, we're checking for a nil interface in `PrintIfTrue` and for a nil pointer in `func (tp *TruthyPerson) IsTrue() bool`. And it will now print "It's not true". We can see all this code [working here](https://go.dev/play/p/IihhiSXMm-q).

## Bonus: Check for both nils at once with reflection

With reflection, we can make a small change to `PrintIfTrue` so that it can check for both nil interfaces and nil pointers. Here's the code:

```go
func PrintIfTrue(tg TruthGetter) {
	if tg == nil {
		fmt.Println("I can't tell if it's true")
		return
	}

	val := reflect.ValueOf(tg)
	k := val.Kind()
	if (k == reflect.Pointer || k == reflect.Chan || k == reflect.Func || k == reflect.Map || k == reflect.Slice) && val.IsNil() {
		fmt.Println("I can't tell if it's true")
		return
	}

	if tg.IsTrue() {
		fmt.Println("It's true")
	} else {
		fmt.Println("It's not true")
	}
}
```

Here, we check for the nil interface first, as before. Next, we use reflection to get the type. `chan`, `func`, `map`, and `slice` can also be nil, in addition to pointers, so we check if the value is one of those types, and if so, check if it's nil. And if it is, we also return the "I can't tell if it's true" message. This may or may not be exactly what you want, but it's an option. With this change, we can do this:

```go
func main() {
    var tp *TruthyPerson
    PrintIfTrue(tp)
}
```

You might sometimes see a suggestion to something simpler, like:

```go
// Don't do this
if tg == nil && reflect.ValueOf(tg).IsNil() {
    fmt.Println("I can't tell if it's true")
    return
}
```

There are two reasons this doesn't work well. First, is that there is a performance overhead when using reflection. If you can avoid using reflection, you probably should. If we check for the nil interface first, we don't have to use reflection if it's a nil interface.

The second reason is the `reflect.Value.IsNil()` will panic if the type of the value isn't a type that can be nil. That's why we add in the check for the kind. If we hadn't checked the Kind, then we would've gotten a panic on the `Truthy` and `TruthyNumber` types.


So, as long as we ensure we check the kind first, this will now print "I can't tell if it's true", instead of "It's not true". Depending on your perspective, this may be an improvement. [Here](https://go.dev/play/p/mL048k4C1be) is the complete code with this change.
