package com.pagesociety.ux.decorator
{
	import flash.filters.ColorMatrixFilter;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Text extends TextField
	{
		public static var SYSTEM_FONTS:Array = [
			"_sans", "Arial", "Verdana", "Courier", "Courier New"
		];
		
		public static function isSystemFont(f:String):Boolean
		{
			return SYSTEM_FONTS.indexOf(f)!=-1;
		}
		
		public function Text()
		{
			super();
			
        	embedFonts = true;
        	antiAliasType = AntiAliasType.ADVANCED;
        	gridFitType = GridFitType.PIXEL;
        	sharpness = 0;
        	thickness = 0;
        	selectable = false;
        	width = 100;
//        	condenseWhite = true;
       
 		}
		
		public function get textFormat():TextFormat
		{
			return defaultTextFormat;
		}
		
		public function set textFormat(format:TextFormat):void
		{
		
			embedFonts = !isSystemFont(format.font);
			try { defaultTextFormat = format; } catch (e:Error) {}
			
		
		}
		
	
		// coloring
		private static const byteToPerc:Number = 1 / 0xff;

		private var $textField:TextField;
		private var $textColor:int=-1;
		private var $selectedColor:int=-1;
		private var $selectionColor:int=-1;
		private var colorMatrixFilter:ColorMatrixFilter;
	
		public function set normalColor(c:int):void 
		{  
			$textColor = c;
			updateFilter();
		}
		public function get normalColor():int 
		{
			return $textColor;
		}
		public function set selectionColor(c:int):void 
		{
			$selectionColor = c;
			updateFilter();
		}
		public function get selectionColor():int 
		{
			return $selectionColor;
		}
		public function set selectedColor(c:int):void 
		{
			$selectedColor = c;
			updateFilter();
		}
		public function get selectedColor():int 
		{
			return $selectedColor;
		}
		
		private function updateFilter():void 
		{
			textFormat.color = $textColor;
			defaultTextFormat = textFormat;
		}
		private function updateFilterA():void 
		{
			textColor = 0xff0000;

			var o:Array = splitRGB($selectionColor);
			var r:Array = splitRGB($textColor);
			var g:Array = splitRGB($selectedColor);
			
			var ro:int = o[0];
			var go:int = o[1];
			var bo:int = o[2];
			
			var rr:Number = ((r[0] - 0xff) - o[0]) * byteToPerc + 1;
			var rg:Number = ((r[1] - 0xff) - o[1]) * byteToPerc + 1;
			var rb:Number = ((r[2] - 0xff) - o[2]) * byteToPerc + 1;

			var gr:Number = ((g[0] - 0xff) - o[0]) * byteToPerc + 1 - rr;
			var gg:Number = ((g[1] - 0xff) - o[1]) * byteToPerc + 1 - rg;
			var gb:Number = ((g[2] - 0xff) - o[2]) * byteToPerc + 1 - rb;
			
			if (colorMatrixFilter == null)
				colorMatrixFilter = new ColorMatrixFilter();
			colorMatrixFilter.matrix = [rr, gr, 0, 0, ro, rg, gg, 0, 0, go, rb, gb, 0, 0, bo, 0, 0, 0, 1, 0];
			
			filters = [colorMatrixFilter];
			
		}
		
		private static function splitRGB(color:uint):Array 
		{
			
			return [color >> 16 & 0xff, color >> 8 & 0xff, color & 0xff];
		}
		
		
		
		
		// TODO
		// the embedFonts prop should be controlled on a field by field basic and depend on the style name. 
		// a multi style text field must use all system fonts or all embedded or it will not work.
//		override public function set styleSheet(ss:StyleSheet):void
//		{
//			var f:Array = new Array();
//			ss.styleNames.forEach(function(s:*,i:uint,a:Array):void
//			{
//				var ff:String = ss.getStyle(s).fontFamily;
//				if (ff!=null && f.indexOf(ff)==-1)
//					f.push(ff);
//			});
//			var b:Boolean = false;
//			f.forEach(function(s:*,i:uint,a:Array):void
//			{
//				trace(s+" "+isSystemFont(s));
//				if (!isSystemFont(s))
//					b = true;
//			});
//			embedFonts = b;
//			super.styleSheet = ss;
//		}
		
	}
}






// from flex docs
// TextField

/* props
alwaysShowSelection : Boolean - When set to true and the text field is not in focus, Flash Player highlights the selection in the text field in gray.
antiAliasType : String - The type of anti-aliasing used for this text field.
autoSize : String - Controls automatic sizing and alignment of text fields.
background : Boolean - Specifies whether the text field has a background fill.
backgroundColor : uint - The color of the text field background.
border : Boolean - Specifies whether the text field has a border.
borderColor : uint - The color of the text field border.
bottomScrollV : int - [read-only] An integer (1-based index) that indicates the bottommost line that is currently visible in the specified text field.
caretIndex : int - [read-only] The index of the insertion point (caret) position.
condenseWhite : Boolean - A Boolean value that specifies whether extra white space (spaces, line breaks, and so on) in a text field with HTML text should be removed.
defaultTextFormat : TextFormat - Specifies the format applied to newly inserted text, such as text inserted with the replaceSelectedText() method or text entered by a user.
displayAsPassword : Boolean - Specifies whether the text field is a password text field.
embedFonts : Boolean - Specifies whether to render by using embedded font outlines.
gridFitType : String - The type of grid fitting used for this text field.
htmlText : String - Contains the HTML representation of the text field's contents.
length : int - [read-only] The number of characters in a text field.
maxChars : int - The maximum number of characters that the text field can contain, as entered by a user.
maxScrollH : int - [read-only] The maximum value of scrollH.
maxScrollV : int - [read-only] The maximum value of scrollV.
mouseWheelEnabled : Boolean - A Boolean value that indicates whether Flash Player should automatically scroll multiline text fields when the user clicks a text field and rolls the mouse wheel.
multiline : Boolean - Indicates whether the text field is a multiline text field.
numLines : int - [read-only] Defines the number of text lines in a multiline text field.
restrict : String - Indicates the set of characters that a user can enter into the text field.
scrollH : int - The current horizontal scrolling position.
scrollV : int - The vertical position of text in a text field.
selectable : Boolean - A Boolean value that indicates whether the text field is selectable.
selectionBeginIndex : int - [read-only] The zero-based character index value of the first character in the current selection.
selectionEndIndex : int - [read-only] The zero-based character index value of the last character in the current selection.
sharpness : Number - The sharpness of the glyph edges in this text field.
styleSheet : StyleSheet - Attaches a style sheet to the text field.
*tabEnabled : Boolean - Specifies whether this object is in the tab order.
*tabIndex : int - Specifies the tab ordering of objects in a SWF file.
text : String - A string that is the current text in the text field.
textColor : uint - The color of the text in a text field, in hexadecimal format.
textHeight : Number - [read-only] The height of the text in pixels.
textWidth : Number - [read-only] The width of the text in pixels.
thickness : Number - The thickness of the glyph edges in this text field.
type : String - The type of the text field.
useRichTextClipboard : Boolean - Specifies whether to copy and paste the text formatting along with the text.
wordWrap : Boolean - A Boolean value that indicates whether the text field has word wrap.
*/


/* methods
appendText(newText:String):void - Appends the string specified by the newText parameter to the end of the text of the text field.
getCharBoundaries(charIndex:int):Rectangle - Returns a rectangle that is the bounding box of the character.
getCharIndexAtPoint(x:Number, y:Number):int - Returns the zero-based index value of the character at the point specified by the x and y parameters.
getFirstCharInParagraph(charIndex:int):int - Given a character index, returns the index of the first character in the same paragraph.
getImageReference(id:String):DisplayObject - Returns a DisplayObject reference for the given id, for an image or SWF file that has been added to an HTML-formatted text field by using an <img> tag.
getLineIndexAtPoint(x:Number, y:Number):int - Returns the zero-based index value of the line at the point specified by the x and y parameters.
getLineIndexOfChar(charIndex:int):int - Returns the zero-based index value of the line containing the character specified by the charIndex parameter.
getLineLength(lineIndex:int):int - Returns the number of characters in a specific text line.
getLineMetrics(lineIndex:int):TextLineMetrics - Returns metrics information about a given text line.
getLineOffset(lineIndex:int):int - Returns the character index of the first character in the line that the lineIndex parameter specifies.
getLineText(lineIndex:int):String - Returns the text of the line specified by the lineIndex parameter. 
getParagraphLength(charIndex:int):int - Given a character index, returns the length of the paragraph containing the given character.
getTextFormat(beginIndex:int = -1, endIndex:int = -1):TextFormat - Returns a TextFormat object that contains formatting information for the range of text that the beginIndex and endIndex parameters specify.
replaceSelectedText(value:String):void - Replaces the current selection with the contents of the value parameter.
replaceText(beginIndex:int, endIndex:int, newText:String):void - Replaces the range of characters that the beginIndex and endIndex parameters specify with the contents of the newText parameter.
setSelection(beginIndex:int, endIndex:int):void
Sets as selected the text designated by the index values of the first and last characters, which are specified with the beginIndex and endIndex parameters.
setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1):void - Applies the text formatting that the format parameter specifies to the specified text in a text field.
*/