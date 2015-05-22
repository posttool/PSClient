package com.pagesociety.ux.decorator
{
	import com.pagesociety.ux.component.Tree;
	import com.pagesociety.ux.component.TreeNode;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	

	public class TreeDecorator extends MaskedDecorator 
	{
	
		private var _tree:Tree;
		private var treeLines:Sprite;
		
		private var _line_thickness:Number =1;
		private var _line_color:uint =0;
		private var _line_alpha:Number =1;
		
		
		public function TreeDecorator(t:Tree) 
		{
			super();
			this._tree = t;
		}
			
		override public function initGraphics():void
		{ 
			super.initGraphics();
			
			treeLines = new Sprite();
			background.addChild(treeLines);
		}
		
		override public function decorate():void
		{
			treeLines.graphics.clear();
			if (_tree.children.length!=0)
				drawLines(_tree.children[0], treeLines);
		}
		
		/* lines between tree nodes */
		public function drawLines(p:TreeNode, mc:Sprite):void
		{
			if (p.childNodes.length==0)
				return; 
			var g:Graphics = mc.graphics;
			g.lineStyle(_line_thickness, _line_color, _line_alpha); 
			var x0:Number = p.x + p.width/2;
			var y0:Number = p.y + p.height;
			var xleft:Number = p.childNodes[0].x + p.width/2;
			var xright:Number = p.childNodes[p.childNodes.length-1].x + p.width/2;
			var ymid:Number = y0 + ( p.childNodes[0].y  - y0 )/2;
			g.moveTo(x0, y0);
			g.lineTo(x0, ymid);
			g.moveTo(xleft, ymid);
			g.lineTo(xright, ymid);
			for (var i:uint=0; i < p.childNodes.length; i++) {
				var x1:Number = p.childNodes[i].x + p.width/2;
				var y1:Number = p.childNodes[i].y ;
				g.moveTo(x1, ymid);
				g.lineTo(x1, y1);
				drawLines(p.childNodes[i], mc);
			}
		}
		

		public function set lineThickness(s:Number):void
		{
			_line_thickness = s;
		}
		
		public function get lineThickness():Number
		{
			return _line_thickness;
		}
		
		public function set lineColor(s:uint):void
		{
			_line_color = s;
		}
		
		public function get lineColor():uint
		{
			return _line_color;
		}
		
		public function set lineAlpha(s:Number):void
		{
			_line_alpha = s;
		}
		
		public function get lineAlpha():Number
		{
			return _line_alpha;
		}
		
	}
}