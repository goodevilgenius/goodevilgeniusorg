---
title: Use Laravel Events like Wordpress Hooks
date: 2022-06-21 10:02:36
modified: 2022-06-21T14:25:53-0500
tags:
    - programming
    - webdev
    - wordpress
    - laravel
---
Many web developers have worked with Wordpress at least somewhat. If you've done
any plugin or theme development, there's a good chance you've used
[Wordpress hooks][hooks] at some point.

If you've called `add_action` or `add_filter`, you've used a Wordpress hook. If
you've called `do_action` or `appy_filters`, you've created your own hook.

If you've spent some time working with Wordpress, and are now working with
Laravel, you might be wondering if Laravel has a hook system as well. You're in
luck, using Laravel's [event system][events], you can do the same sort of things
that Wordpress's hook system can do, and we're going go over how to do that with
a few code samples.

First off, lets talk about hooks in Wordpress.

## Wordpress hooks

In Wordpress, [hooks][] are a system that allow the developer to *hook* into an
event, and add some functionality. Hooks come in two varieties: actions, and
filters. Both types do essentially the same thing: when something happens in the
system (or is about to happen), the action/filter is called. A developer
building a plugin or theme can add functions that run on these events.

The difference between these two types of hooks have to do with the data is
passed to the function, and the data that is returned from the function.


An action, is a function that returns nothing. In fact, if you add an action
that returns a value, that value is ignored, and nothing happens with it.

A common example of an action is the built-in `init` action. This action is run
early on in the request lifecycle. One possible use is by theme developers when
registering custom post types.

This might look like this:

```php
add_action( 'init', function () {
    register_post_type( 'book', [ 'public' => true ] );
} );
```

A filter is a function that returns a value that is intended to modify whatever
value is passed to it.

A good example of a filter is the `body_class` filter. The function is passed an
array of classes that are to be used in the `<body class>` attribute. The
filter function should add to, or remove classes in the array, and then return
the array.

This might look like this:

```php
add_filter( 'body_class', function ( array $classes ) {
    $classes[] = 'i-love-hooks';
    
    return $classes;
} );
```

Now that we've got a refresher on Wordpress hooks, let's look at Laravel Events.

## Laravel Events

In Laravel, [Events][events] serve the same purpose as Wordpress hooks: when
something happens, an event is triggered, and the developer can respond to that
event by performing some action. One important difference to remember between
Wordpress hooks and Laravel Events are that in Wordpress, a hook has a name, and
that's how you add your function to that hook, is by using the name. In Laravel,
an event is an actual object which is instantiated. When you listen for that
event (i.e., when you hook into it), you listen for events of a particular
classname. In this way, Laravel is using more object-oriented programming.

Laravel has a number of built-in events, and any developer can create their own
custom events. Let's look at how one might be used.

One event provided by Laravel is the `QueryExecuted` event. This event is
executed whenever a database query is made. The event contains the query, and
the amount of time (in milliseconds) that the query took to execute.

In Wordpress, you would add your hook listener during you plugin init function,
or in your theme's `functions.php` file, usually. In Laravel, normally, you
register an event listener in a [service provider][]. You can use any service
provider, by adding the following to the `boot` method:

```php
use Illuminate\Database\Events\QueryExecuted;
use Illuminate\Support\Facades\Event;
use App\Listeners\LogQueries;

public function boot() {
    Event::listen(QueryExecuted::class, LogQueries::class);
}
```

In this example, `LogQueries` is a listener class that contains a method called
either `handle` or `__invoke`. This method will get an instance of the
`QueryExecuted` class. It might look something like this:

```php
use Illuminate\Database\Events\QueryExecuted;
use Illuminate\Support\Facades\Log;

class LogQueries {
    public function handle(QueryExecuted $evt) {
        Log::debug("Executed {$evt->sql} in {$evt->time}ms");
    }
}
```

You can also listen using a Closure, similar to the Wordpress examples I gave
before. Something like this could be done in the service provider:

```php
use Illuminate\Database\Events\QueryExecuted;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Log;

public function boot() {
    Event::listen(function (QueryExecuted $evt) {
        Log::debug("Executed {$evt->sql} in {$evt->time}ms");
    });
}
```

There are other variations on how to do this. We won't be going into detail in
these. Feel free to consult the [official documentation][events].

## Real-life (sort of) examples

For our examples, we're going to imagine we're building an e-book store using
Laravel. So, first, lets establish a few models that we'll be using.

```php
namespace App\Models;

class Customer {
    // ...
}

class Book {
    // ...
}

class Checkout {
    public function customer(): HasOne
    {
        return $this->hasOne(Customer::class);
    }
    
    public function books(): BelongsToMany
    {
        return $this->belongsToMany(Book::class);
    }
}
```

We have customers, books, and for when they are making a purchase, checkouts.
The checkout has a [relationship][] to the customer and the books in the cart.

### Actions

As we discussed earlier, Wordpress has two types of hooks: actions and filters.
It should be clear by now how to use Laravel Events in the same way as Wordpress
actions. But, lets go over this using our store example.

Let's suppose our customer has already picked out their books, and added it to
the cart. We have our `Checkout` model ready, called `$checkout`, and the
customer has just pressed the "Check out" button on the site. We go through some
logic to verify payment and shipping and whatnot, and everything's fine, so once
that's all done, we can fire an event to indicate that checkout has completed.

We create this event with the command:

```shell
php artisan make:even CheckoutComplete
```

Our event class might look like this:

```php
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class CheckoutComplete
{
    use Dispatchable, SerializesModels;

    public Checkout $checkout;

    public function __construct(Checkout $checkout)
    {
        $this->checkout = $checkout;
    }
}
```

And then, we'd dispatch it like this:

```php
use Illuminate\Support\Facades\Event;
use App\Events\CheckoutComplete;

Event::dispatch(new CheckoutComplete($checkout));
```

All of this might be similar, in Wordpress to the following:

```php
do_action( 'checkout_complete', $checkout );
```

Obviously the Wordpress code is much shorter, but the Laravel code gives us more
type-safety, and some more flexibility, since we can easily add whatever we want
to that event model.

#### Listening for the event

All we've done so far is create an event and dispatch it. Now we hook into it by
using a listener.

Let's suppose whenever a customer makes a purchase, they get one reward point for
every book they purchased, and the points are redeemable for discounts in the
future.

So, we use our `CheckoutComplete` event and create a listener that awards these
points.

So, our listener can be as simple as:

```php
use App\Events\CheckoutComplete;
use App\Service\RewardPoints;

class GiveRewardPoints
{
    protected RewardPoints $service;

    public function __construct(RewardPoints $rewardsService)
    {
        $this->service = $rewardsService;
    }

    public function handle(CheckoutComplete $checkout)
    {
        $service->award($checkout->customer, $checkout->books()->count());
    }
}
```

We register this listener, as we explained above, in a service provider like:

```php
Event::listen(CheckoutComplete::class, GiveRewardPoints::class);
```

You can register as many listeners for an event as you like.

All of this might be something like the following in Wordpress.

```php
function give_reward_points( array $checkout ) {
    $rewardsService->award( $checkout['customer_id'], count( $checkout['books'] ) );
}

add_action( 'checkout_complete', 'give_reward_points' );
```

### Filters

Actions are easy, but filters are a little less obvious. To understand how we
can use events like Wordpress filters, we need to note that since an event is an
object with values on it, we can modify those values on the event. This gives us
much more flexibility than Wordpress filters, which only give us the option of
returning a new value.

For our example, let's suppose our customer has just entered their address
information during checkout. We might need to do some validation on that
address. Normally in Laravel, you would probably throw a `ValidationException`
in this sort of case, but let's try something a little different.

First, we'll create a `CheckoutAddressEntered` event:

```php
class CheckoutAddressEntered
{
    public Checkout $checkout;
    public Address $address;
    public array $errors = [];
}
```

We'll suppose that the `$address` object is some sort of data transfer object
that just holds the address information. The implementation isn't important for
our example.

Now, in our controller, we might have some logic like this:

```php
$addressEntered = new CheckoutAddressEntered();
$addressEntered->checkout = $checkout;
$addressEntered->address = $address;

Event::dispatch($addressEntered);

if (count($addressEntered->errors)) {
    return new JsonResponse(['errors' => $addressEntered->errors]);
}

return new JsonResponse(['data' => $checkout]);
```

So, what did we do here exactly? We don't have any errors on `$addressEntered`
here. Let's check out our listener.

```php
class ValidateAddress
{
    public function __construct(protected AddressValidator $validator) { /**/ }
    
    public function handle(CheckoutAddressEntered $evt)
    {
        if (!$validator->validate($evt->address)) {
            $evt->errors[] = 'Address validation failed';
        }
    }
}
```

So, in our listener, we validated the address, and if it failed, we appended to
the `errors` array with a failure message. When we called `Event::dispatch`, our
listeners were run with the same `$addressEntered` object being passed to the
listener. Each non-queued listener is run before `Event::dispatch` finishes, so,
any changes made to the event are carried over.

If we were to implement this in Wordpress, it might look like this:

```php
$errors = apply_filters( 'checkout_address_entered', [], $address, $checkout );
if ( count( $errors ) ) {
    wp_send_json_error( $errors, 400 );
} else {
    wp_send_json_success( $checkout );
}
```

And then, our callback would be:

```php
function validate_address( array $errors, array $address, array $checkout ) {
    if ( ! $addressValidator->validate( $address ) ) {
        $errors[] = 'Address validation failed';
    }
}

add_filter( 'checkout_address_entered', 'validate_address', 10, 3 );
```

We might have another listener that checks that all of the books purchased can
be legally sold in the customer's country.

One **very important thing to note** is that for this to work properly, the
listener *cannot* be a [queued listener][]. If it is, the
validation will happen outside of the request, after the response has already
been sent to the client. If you used the `make:listener` artisan command to
create the listener class, you'll need to remove the `ShouldQueue` trait from
that class.

## Conclusion

If you're coming from Wordpress to Laravel, there are a lot of new things to
learn. With hooks being such an integral part of Wordpress, hopefully learning
how Laravel events work will help make that transition.

[hooks]: https://developer.wordpress.org/plugins/hooks/
[events]: https://laravel.com/docs/9.x/events
[service provider]: https://laravel.com/docs/9.x/providers
[relationship]: https://laravel.com/docs/9.x/eloquent-relationships
[queued listener]: https://laravel.com/docs/9.x/events#queued-event-listeners
