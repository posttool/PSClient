package com.pagesociety.ux.component
{
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.component.text.Link;
	import com.pagesociety.ux.decorator.MaskedDecorator;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	import com.pagesociety.ux.layout.GridLayout;
	import com.pagesociety.ux.layout.Layout;
	import com.pagesociety.ux.layout.TableLayout;
	
	import flash.utils.getTimer;

	public class Container extends Component
	{
		protected var _children:Array;
		protected var _layout:Layout;
		protected var _width_for_unset:Number;
		protected var _height_for_unset:Number;

		public function Container(parent:Container, index:int=-1)
		{
			_children = new Array();
			super(parent, index);
		}
	
		public function addComponent(child:Component, index:int=-1):void
		{
			if (index<0 || index>children.length)
				index = children.length;
			children.splice(index,0,child);
			child.setParent(this);
		}
		
		
		public function removeComponent(child:Component):void
		{
			children.splice(_children.indexOf(child),1);
			child.destroy();
		}
		
		public function reIndexComponent(child:Component, new_index:int):void
		{
			if (child.parent!=this)
				throw new Error("Can't re-index a component that is not my child");
			if (new_index<0)
				new_index = 0;
			children.splice(indexOf(child),1);
			children.splice(new_index,0,child);
		}
		
		public function clear():void
		{
			while(_children.length!=0)
			{
				var c:Component = _children.pop();
				c.destroy();
				c = null;
			}
		}
		
		override public function destroy():void
		{
			clear();
			super.destroy();
		}
		
		public function hideAll():void
		{
			for (var i:uint=0; i < _children.length; i++)
			{
				var c:Component = Component(_children[i]);
				c.visible = false;
			}
		}
		
		public function showChild(c:Component):void
		{
			hideAll();
			c.visible = true;
		}
	
		public function indexOf(c:Component):int
		{
			return children.indexOf(c);
		}
		
		public function getById(id:String):Component
		{
			if (_id==id)
				return this;
			for (var i:uint=0; i<_children.length; i++)
			{
				if (_children[i] is Container)
				{
					var cc:Component = _children[i].getById(id);
					if (cc!=null)
						return cc;
				}
			}
			return null;
		}
		
		public function addEventListenerToChildren(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			for (var i:uint=0; i<children.length; i++)
			{
				var c:Component = Component(_children[i]);
				c.addEventListener(type,listener,useCapture,priority,useWeakReference);
				if (c is Container)
					(c as Container).addEventListenerToChildren(type,listener,useCapture,priority,useWeakReference);
			}
		}
		
		
		
		override public function render():void
		{
			if (!visible)
			{
				super.render();
				return;
			}
			
			var t:int = getTimer();
			var times:Array = new Array();
			times.push(t);
		
			if (decorator is MaskedDecorator)
			{
				var masked:MaskedDecorator = decorator as MaskedDecorator;
				
				if (masked.contentSizeProvider == null)
				{
					// the bounding box of the union of the children or the children's layouts
					//or...
					if (_layout!=null)
					{
						// DEPRECATED use of layout to set content size of MaskedDecorator... use MaskedDecorator.contentSizeProvider
						masked.contentHeight = _layout.calculateHeight();
						masked.contentWidth = _layout.calculateWidth();
						// DEPRECATED use of layout to set content size of MaskedDecorator... use MaskedDecorator.contentSizeProvider
					}
				}
				else
				{
					var size:Object = masked.contentSizeProvider(this);
					masked.contentHeight = size.height;
					masked.contentWidth = size.width;
				}
			}


			for (var i:uint=0; i < _children.length; i++)
			{
				var c:Component = _children[i];
				c.render();
				var tt:Number = getTimer() - times[times.length-1];
				times.push(getTimer())
				if (tt>100)
					trace("That's a really slow component! "+tt+" "+c)
			}
			
			if (_layout!=null)
				_layout.layout();
			

			super.render();
				//trace(">"+toStringIndented()+"  "+(getTimer()-t)+"ms  child_times="+times);

		}
		

		private var _x_guides:Array;
		private var _y_guides:Array;

		public function setXGuide(index:uint,x:int,type:uint=PIXEL):void
		{
			if (_x_guides==null)
				_x_guides = new Array(16);
			_x_guides[index] = {'val':x,'type':type};
		}
		
		public function setYGuide(index:uint,y:int,type:uint=PIXEL):void
		{
			if (_y_guides==null)
				_y_guides = new Array(16);
			_y_guides[index] = {'val':y,'type':type};
		}
		
		public function get xGuides():Array
		{
			var g:Array = _x_guides;
			var p:Container = _parent;
			while (g==null && p!=null)
			{
				g = p.xGuides;
				p = p.parent;
			}
			return g;
		}
		
		public function get yGuides():Array
		{
			var g:Array = _y_guides;
			var p:Container = _parent;
			while (g==null && p!=null)
			{
				g = p.yGuides;
				p = p.parent;
			}
			return g;
		}

		public function set layout(l:Layout):void
		{
			_layout = l;
			if (_layout!=null)
				_layout.container = this;
		}
		
		public function get layout():Layout
		{
			return _layout;
		}
		
		public function get children():Array
		{
			return _children;
		}
		
		public function get lastChild():Component
		{
			if (_children.length==0)
				return null;
			return _children[_children.length-1];
		}
		
		public function get firstChild():Component
		{
			if (_children.length==0)
				return null;
			return _children[0];
		}


		public function ensureVisibility(c:Component):void
		{
			if (c==null)
				return;
			//trace("CONTAINER ENSURE VIS "+this+" "+c);
			//trace("if this is scrolling and c is one of my descendants, get position of c relative to me... scroll");
//			if (decorator is ScrollingDecorator)
//			{
//				render();  // make sure that everything is layed out...
//				
//				var sdec:ScrollingDecorator = decorator as ScrollingDecorator;
//				var p0:Point = application.getLocation(c);
//				var p1:Point = application.getLocation(this);
//				if (sdec.scrollsHorizontally())
//				{
//					var x:Number = p0.x - p1.x;
//					if (!sdec.isDisplayingHorizontal(x+c.width) && c.width < width)
//					{
//						sdec.setScrollHorizontal(x-sdec.width+c.width);
//					}
//					else if (!sdec.isDisplayingHorizontal(x))
//					{
//						sdec.setScrollHorizontal(x-5);
//					}
//				}
//				if (sdec.scrollsVertically())
//				{
//					var y:Number = p0.y - p1.y;
//					if (!sdec.isDisplayingVertical(y+c.height) && c.height < height)
//					{
//						sdec.setScrollVertical(y-sdec.height+c.height+10);
//					}
//					else if (!sdec.isDisplayingVertical(y))
//					{
//						sdec.setScrollVertical(y-5);
//					}
//				}	
//			}
		}

//causes circular references... todo	
		override public function get width():Number
		{
//			if (_width_type==Component.SIZE_TYPE_UNSET && layout != null)
//				return layout.calculateWidth();
//			else
				return super.width;
		}
		
		override public function get height():Number
		{
//			if (_height_type==Component.SIZE_TYPE_UNSET && layout != null)
//				return layout.calculateHeight();
//			else
				return super.height;
		}
		
		public function get widthForUnsetChild():Number
		{
			calc_size_for_unset_width();
			return _width_for_unset;
		}
		
		public function get heightForUnsetChild():Number
		{
			calc_size_for_unset_height();
			return _height_for_unset;
		}
		
		
		
		private function calc_size_for_unset_height():void
		{
			if (_layout == null)
			{
				_height_for_unset = height;
				return;
			}
			
			if (_layout is FlowLayout)
			{
				var flow:FlowLayout = _layout as FlowLayout;
				_height_for_unset = flow.calculateHeightForUnset();
				return;
			}
			
			if (_layout is GridLayout)
			{
				var grid:GridLayout = _layout as GridLayout;
				_height_for_unset = grid.cellHeight - _layout.margin.top - _layout.margin.bottom;
				return;
			}
			
			if (_layout is TableLayout)
			{
				var tl:TableLayout = _layout as TableLayout;
				_height_for_unset =  tl.calculateHeightForUnset();
				return;
			}
			
		}
		
		private function calc_size_for_unset_width():void
		{
			if (_layout == null)
			{
				_width_for_unset = width;
				return;
			}
			
			if (_layout is FlowLayout)
			{
				var flow:FlowLayout = _layout as FlowLayout;
				_width_for_unset = flow.calculateWidthForUnset();
				return;
			}
			
			if (_layout is GridLayout)
			{
				var grid:GridLayout = _layout as GridLayout;
				_width_for_unset = grid.cellWidth - _layout.margin.left - _layout.margin.right;
				return;
			}
			
			if (_layout is TableLayout)
			{
				var tl:TableLayout = _layout as TableLayout;
				_width_for_unset = tl.calculateWidthForUnset();
				return;
			}
			
			
		}
		/*
		width,  "i am always first"
		height, "not always... there are instances where i am first"
		width,  "where?"
		height, "i cant remember offhand. i don't generally 'keep score'"
		width,  "oh, i see- are you implying that i do?"
		height, "you started this innane conversation"
		width,  "i guess you are right."
		*/
		
		
		// stacks of flow containers
		protected var _stack:Array;
		public function top():Container
		{
			if (_stack==null)
			{
				_stack = new Array();
				_stack.push(this);
			}
			return _stack[_stack.length-1];
		}
		
		public function begin_column(style_props:Object=null):Container
		{
			var c:Container = new Container(top());
			c.layout = new FlowLayout(FlowLayout.TOP_TO_BOTTOM);
			if (style_props!=null)
				application.style.apply(c, style_props);
			_stack.push(c);
			return c;
		}
		
		public function BC(parent:Container = null,style_props:Object=null):Container
		{
			var c:Container  = new Container(parent==null?top():parent);
			c.layout 		 = null;
			if (style_props != null)
				application.style.apply(c, style_props);
			if (_stack!=null)
				_stack.push(c);
			return c;
		}
		
		public function end_column():void
		{
			_stack.pop();//validate?
		}

		
		public function EC():void
		{
			_stack.pop();//validate?
		}
		
		public function begin_row(style_props:Object=null):Container
		{
			var c:Container = new Container(top());
			c.layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
			if (style_props!=null)
				application.style.apply(c, style_props);
			_stack.push(c);
			return c;
		}
		
		public function end_row():void
		{
			_stack.pop();
		}
		
		public function add_label(text:String, style:String=null, multiline:Boolean=false):Label
		{
			if (text.indexOf("<")!=-1)
				text = "<span class='"+style+"'>"+text+"</span>";
			var l:Label = new Label(top());
			l.text = text;
			l.multiline = multiline;
			if (style!=null)
				l.fontStyle = style;
			return l;
		}
		
		protected function add_link(text:String, style:String=null, on_click:Function=null):Link
		{
			var l:Link = new Link(top());
			l.text = text;
			if (style!=null)
				l.styleName = style;
			if (on_click!=null)
				l.addEventListener(ComponentEvent.CLICK, on_click);
			return l;
		}
		
		
		// more container helpers
		public function center_horz(c:Component,offset:Number=0):void
		{
			if (c==null)
				return;
			if (c is Container)
			{
				var cc:Container = c as Container;
				if (cc.layout!=null)
				{
					c.x = (width - cc.layout.calculateWidth())/2 + offset;
					return;
				}
			}
			
			c.x = (width - c.width)/2 + offset;
		}
		
		public function center_vert(c:Component,offset:Number=0):void
		{
			if (c==null)
				return;
			if (c is Container)
			{
				var cc:Container = c as Container;
				if (cc.layout!=null)
				{
					c.y = (height - cc.layout.calculateHeight())/2 + offset;
					return;
				}
			}
			
			c.y = (height - c.height)/2 + offset;
		}
		
		protected function center(c:Component,xoff:Number=0,yoff:Number=0):void
		{
			center_horz(c,xoff);
			center_vert(c,yoff);
		}
	}
}