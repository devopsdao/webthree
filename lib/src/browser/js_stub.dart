// Stubs for JS interop annotations from dart:js_interop for non-web platforms.
library js_interop_stubs;

/// An annotation that indicates a library, class, or member is implemented
/// directly in JavaScript.
///
/// Used with `dart:js_interop`.
///
/// All external members of a class or library with this annotation implicitly
/// have it as well.
///
/// Specifying [name] customizes the JavaScript name to use. By default the
/// dart name is used. It is not valid to specify a custom [name] for class
/// instance members.
class JS {
  final String? name;
  const JS([this.name]);
}

/// An annotation that indicates a [JS] annotated class is structural and does
/// not have a known JavaScript prototype.
///
/// Used with `dart:js_interop`.
///
/// A class marked with [anonymous] must have an unnamed factory constructor
/// with no positional arguments, only named arguments. Invoking the constructor
/// desugars to creating a JavaScript object literal with name-value pairs
/// corresponding to the parameter names and values.
const Object anonymous =
    _Anonymous(); // Type Object pour correspondre à l'annotation réelle

/// [staticInterop] enables the [JS] annotated class to be treated as a "static"
/// interop class.
///
/// Used with `dart:js_interop`.
///
/// These classes allow interop with native types, like the ones in `package:web`.
/// These classes should not contain any instance members, inherited or
/// otherwise, and should instead use static extension members.
const Object staticInterop =
    _StaticInterop(); // Type Object pour correspondre à l'annotation réelle

class _Anonymous {
  const _Anonymous();
}

class _StaticInterop {
  const _StaticInterop();
}
