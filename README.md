# purescript-biscotti-session

This library provides tools to manage sessions in PureScript. It makes the
assumption that your session data is JSON-serializable (using the Argonaut
`EncodeJson` and `DecodeJson` type classes). Two session stores are provided:
`Cookie` and `Memory`.

`Session` provides 4 basic functions: `create`, `get`, `set` and `destroy`.

* `create` takes a `SessionStore` and your session data and returns a
  [Cookie](https://github.com/drewolson/purescript-biscotti-cookie) representing
  your new session.
* `get` takes a `SessionStore` and a `Cookie` and returns your session data, if
  available.
* `set` takes a `SessionStore`, your session data and your current session
  `Cookie`. It returns a new session `Cookie`.
* `destroy` takes a `SessionStore` and your session `Cookie` and returns a new,
empty session `Cookie`.

## Session Stores

### Cookie Store

The `Cookie` session store uses
[libsodium](https://github.com/jedisct1/libsodium.js) to encrypt and decrypt
session data directly in the cookie. You'll need to install the npm package
`libsodium-wrappers`:

```text
npm install libsodium-wrappers
```

You create a `Cookie` store by calling `Biscotti.Session.cookieStore` with a
name for your session cookie and a `libsodium`-compatible secret, hex encoded.

```purescript
import Biscotti.Session as Session

let store = Session.cookieStore "_my_app" "724b092810ec86d7e35c9d067702b31ef90bc43a7b598626749914d6a3e033ed"
```

**Note**: This is an example secret.  Please don't
commit your production secret to your git repo or post it on the internet. Also,
please don't use this secret as it is already posted on the internet. It's
literally right above this paragraph and you're reading this on the internet.

### Memory Store

The `Memory` session store uses an in-memory map to store sessions. This is
primarily for development purposes as it will not persist sessions across
multiple application servers. You'll need to install two npm packages to
generate UUIDs:

```text
npm install uuid uuid-validate
```

You create a `Memory` store by calling `Biscotti.Session.memoryStore` with a
name for your session cookie. Note that this returns a `Effect SessionStore`
because it requires initializing a `Ref`.

```purescript
import Biscotti.Session as Session

launchAff_ do
  store <- liftEffect $ Session.memoryStore "_my_app"
```

## Running the tests

```text
spago test
```

## License

MIT
