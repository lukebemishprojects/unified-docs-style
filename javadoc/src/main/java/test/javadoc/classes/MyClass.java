package test.javadoc.classes;

/// A class with javadoc
/// @since 1.0.0
public class MyClass {
    /// Some constructor for this class
    public MyClass() {}

    /// There's a nested class!
    public sealed interface SomeInnerClass permits SomeInnerImpl {}

    /// A nested record!
    /// @since 1.0.1
    public record SomeInnerImpl(int foo, String bar) implements SomeInnerClass {}

    /// A static field
    public static final int FOO = 1;

    /// An instance field
    public final int foo = 1;

    /// An instance method. The description has stuff in *italics* and **bold** and <del>strikethrough</del>.
    /// And also a table:
    ///
    /// | Header  | Another header |
    /// |---------|----------------|
    /// | field 1 | something      |
    /// | field 2 | something else |
    ///
    /// And also a block quote because why not:
    /// > Block quote here!
    ///
    /// ...And a list.
    ///
    ///  * A
    ///  * B
    ///      * C
    ///
    ///  1. A
    ///  2. B
    ///  3. C
    ///      1. D
    ///
    /// @param a some param
    /// @param <A> some type param
    /// @throws IllegalStateException if illegal state occurs
    /// @since 1.0.2
    public final <A> void bar(A a) throws IllegalStateException {}

    /// A method without an implementation
    /// @return an {@link Object}
    /// @deprecated Do not use.
    @Deprecated
    public native Object baz();

    /// A static method. Has snippets!
    /// {@snippet :
    /// public static void main(String... args) {
    ///     System.out.println("Hello, World!"); // @highlight regex='".*"'
    ///     System.out.println("Hello, World!"); // @highlight regex='".*"' type=italic
    ///     System.out.println("Hello, World!"); // @highlight regex='".*"' type=highlighted
    /// }
    /// }
    /// There can also be plain inline {@code code}.
    /// @return that returns something
    /// @since 1.0.2
    public static int someStaticMethod() { return 0; }
}