package test.javadoc.classes;

/// A class with javadoc
public class MyClass {
    /// Some constructor for this class
    public MyClass() {}

    /// There's a nested class!
    public static class SomeInnerClass {}

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
    /// @param a some param
    /// @param <A> some type param
    /// @throws IllegalStateException if illegal state occurs
    public final <A> void bar(A a) throws IllegalStateException {}

    /// A method without an implementation
    /// @return that returns a {@link Object}
    /// @deprecated Do not use.
    @Deprecated
    public native Object baz();

    /// A static method
    /// @return that returns something
    public static int someStaticMethod() { return 0; }
}