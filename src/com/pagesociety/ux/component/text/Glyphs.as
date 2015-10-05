package com.pagesociety.ux.component.text {

        public class Glyphs {


    public static const XTRA_GLYPHS:Array = [
//  "©®™¡¤¦§¨ª«¬¯‾–—°±²³´µ¶†‡‰‹›·¸¹º»¼½¾¿•◊…“”„‘’‚′″⁄←↑→↓↔♠♣♥♦",//SYMBOLS
    "€¢£؋¥ƒ₣₢៛ ៛元₡₱฿圓元₫﷼₤₩₮₨₦Динруб₴",//CURRENCY
    "ÀÁÂÃÄÅÆŒÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØŠÙÚÛÜÝŸßàáâãäåæçèéêëìíîïðñòóôõöœøšùúûüýþÿ",  //LATIN
    "ΑΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρςστυφχψωϑϒϖ",              //GREEK
    "÷×∀∂∃∅∇∈∉∋∏∑−∗√∝∞∠∧∨∩∪∫∴∼≅≈≠≡≤≥⊂⊃⊄⊆⊇⊕⊗⊥⋅℘ℑℜℵ"+"ƒ"]; //MATH
    
    //There is actually an ethiopian character in there that sort of looks like a pretzel.
    //In  the FLA file.
    //It is not an empty string.
    //This glyph is embedded into our flash font files and used as the character
    //for which a font has not representation. This way we can garuntee that drawing this
    //character will draw the [] that fonts use for an undefined glyph. We can then
    //use that glyph to determine which glyphs a font doesnt implement.
    public static const NO_GLYPH_FOR:String = "ወ";
    
        }
}