package com.pagesociety.persistence
{
    public class Types
    {
    public static var TYPE_UNDEFINED:uint = 0x000;
    /**
     * The array type must be used in conjunction with any other type. For
     * example, a date array is indicated by the following
     * <code>TYPE_ARRAY | TYPE_DATE</code>.
     */
    public static var TYPE_ARRAY:uint = 0x001;
    /**
     * Corresponds to the Java Boolean type.
     */
    public static var TYPE_BOOLEAN:uint = 0x002;
    /**
     * Corresponds to the Java Integer type.
     */
    public static var TYPE_INT:uint = 0x004;
    /**
     * Corresponds to the Java Long type.
     */
    public static var TYPE_LONG:uint = 0x008;
    /**
     * Corresponds to the Java Double type.
     */
    public static var TYPE_DOUBLE:uint = 0x010;
    /**
     * Corresponds to the Java Float type.
     */
    public static var TYPE_FLOAT:uint = 0x020;
    /**
     * Corresponds to the Java String type. This type as well as the 'text' type
     * both represent Strings. The difference between the two is that this
     * should be of a known (or maximum) length, where as the text type is of an
     * unknown maximum length.
     * 
     * @see #TYPE_TEXT
     */
    public static var TYPE_STRING:uint = 0x040;
    /**
     * Corresponds to the Java String type. This type of string is specified
     * when a maximum length of the number of characters in the string cannot be
     * safely determined.
     * 
     * @see #TYPE_STRING
     */
    public static var TYPE_TEXT:uint = 0x080;
    /**
     * Corresponds to the Java Date type.
     */
    public static var TYPE_DATE:uint = 0x100;
    /**
     * Corresponds to the Java byte[] type.
     */
    public static var TYPE_BLOB:uint = 0x200;
    /**
     * A reference to another entity type. Any field that is typed as a
     * reference or a reference array must specify the name of the entity
     * definition to which it refers.
     */
    public static var TYPE_REFERENCE:uint = 0x400;

    }
}