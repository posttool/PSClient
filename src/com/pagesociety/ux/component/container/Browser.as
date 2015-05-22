package com.pagesociety.ux.component.container
{
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.IKeyListener;
	import com.pagesociety.ux.ISelectable;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.decorator.Decorator;
	import com.pagesociety.ux.decorator.ScrollAreaDecorator;
	import com.pagesociety.ux.decorator.ScrollBarDecorator;
	import com.pagesociety.ux.decorator.ScrollingDecorator;
	import com.pagesociety.ux.event.BrowserEvent;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.event.FocusEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	import com.pagesociety.ux.layout.GridLayout;
	import com.pagesociety.ux.layout.Layout;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	[Event(type="com.pagesociety.ux.event.BrowserEvent",name="single_click")]
	[Event(type="com.pagesociety.ux.event.BrowserEvent",name="double_click")]
	[Event(type="com.pagesociety.ux.event.BrowserEvent",name="dragging")]
	[Event(type="com.pagesociety.ux.event.BrowserEvent",name="item_remove")]
	[Event(type="com.pagesociety.ux.event.BrowserEvent",name="item_add")]
	[Event(type="com.pagesociety.ux.event.BrowserEvent",name="item_reorder")]
	[Event(type="com.pagesociety.ux.event.BrowserEvent",name="select")]
	[Event(type="com.pagesociety.ux.event.ComponentEvent",name="change_value")]
	
	public class Browser extends ScrollingContainer implements IKeyListener,IEditor
	{
		public static const DECORATOR_SCROLL_AREA:uint = 0;
		public static const DECORATOR_SCROLL_BAR:uint = 1;
		public static const DECORATOR_NO_SCROLL:uint = 2;
		public static const LAYOUT_FLOW_HORIZONTAL:uint = 0;
		public static const LAYOUT_FLOW_VERTICAL:uint = 1;
		public static const LAYOUT_GRID_HORIZONTAL:uint = 2;
		public static const LAYOUT_GRID_VERTICAL:uint = 3;
		
		private var _decorator_type:uint;
		private var _layout_type:uint;
		private var _selectable:Boolean;
		private var _reorderable:Boolean;
		private var _deletable:Boolean;
		private var _copy_on_drop:Boolean;
		private var _allows_duplicates:Boolean;
		private var _drop_targets_for_children:Array;

		protected var _view:Function;
		protected var _data:Array;
		
		protected var _selected_index:int;
		protected var _selected_component:Component; 
		
		private var _dirty:Boolean = false;
		private var _will_auto_unfocus_selection:Boolean = true;
		
		public function Browser(parent:Container)
		{
			super(parent);
			layout = get_items_layout(LAYOUT_GRID_VERTICAL);
			decorator = get_items_decorator(DECORATOR_SCROLL_BAR);
			_selectable = true;
			_reorderable = false;
			_deletable = false;
			_copy_on_drop = true;
			_allows_duplicates = true;
			_selected_index = -1;
			_drop_targets_for_children = new Array();	
		}
		
		public function set layoutType(t:uint):void
		{
			layout = get_items_layout(t) 
		}
		
		public function set decoratorType(t:uint):void
		{
			decorator = get_items_decorator(t);
		}
		
		override public function set decorator(new_decorator:Decorator):void
		{
			super.decorator = new_decorator;
			for (var i:uint=0; i<children.length; i++)
			{
				setup_component_for_drag_and_drop_and_click(children[i]);
			}
		}

		public function get selectionIndex():int
		{
			return _selected_index;
		}
		
		public function set selectionIndex(i:int):void
		{
			do_select_component(children[i]);
		}

		public function get selectionComponent():Component
		{
			return _selected_component;
		}
		
		public function set selectionComponent(c:Component):void
		{
			do_select_component(c);
		}
		
		public function set cellRenderer(f:Function):void
		{
			_view = f;
			create_ui();
		}
		
		public function set cellWidth(w:Number):void
		{
			Object(layout).cellWidth = w;
		}
		
		public function get cellWidth():Number
		{
			return Object(layout).cellWidth;
		}
		
		public function set cellHeight(h:Number):void
		{
			Object(layout).cellHeight = h;
		}
		
		public function get cellHeight():Number
		{
			return Object(layout).cellHeight;
		}
		
		public function get value():Object
		{
			var a:Array = new Array();
			for (var i:uint=0; i<_children.length; i++)
				if (_children[i].userObject != null)
					a.push(_children[i].userObject);
			return a;
		}
		
		public function set value(o:Object):void
		{
			_data = o as Array;
			create_ui();
		}
		
		protected function create_ui():void
		{
			clear();
			if (_data==null)
				return;
			for (var i:uint=0; i<_data.length; i++)
			{
				if (_data[i]==null)
					continue;
				var c:Component = create_view(this, _data[i]);
			}
			_dirty = false;
		}
		
		public function get dirty():Boolean
		{
			return _dirty;
		}
		
		public function set dirty(b:Boolean):void
		{
			_dirty = b;
		}
		
		public function addValue(o:Object):Component
		{
			var c:Component =  create_view(this, o);
			_dirty = true;
			return c;
		}
		
		private function create_view(parent:Container,o:Object):Component
		{
			if (_view==null)
				throw new Error("Browser requires a cellRenderer to function this way.");
			var c:Component = _view(parent, o);
			if (c.userObject == null)
				c.userObject = o;
			setup_component_for_drag_and_drop_and_click(c);
			return c;
		}
		
		public function addDropTargetForChildren(c:Container):void
		{
			if (c==null)
				throw new Error("NULL is not a valid drop target");
			if (_drop_targets_for_children.indexOf(c)==-1)
				_drop_targets_for_children.push(c);
			update_children_drop_targets();
		}
		
		public function removeDropTargetsForChildren():void
		{
			_drop_targets_for_children = [];
			update_children_drop_targets();
		}
		
		private function update_children_drop_targets():void
		{
			for (var i:uint=0; i<children.length; i++)
			{
				var c:Component = children[i];
				setup_component_for_drag_and_drop_and_click(c);
			}
		}
		
		protected function setup_component_for_drag_and_drop_and_click(c:Component):void
		{
			if (c.decorator==null || !_selectable)
				return;
			c.setDropTargets(_drop_targets_for_children);
			c.addEventListenerIfUnhandled(ComponentEvent.CLICK, do_click_component_event);
			c.addEventListenerIfUnhandled(ComponentEvent.DOUBLE_CLICK, do_double_click_component_event);
		}
		
		public function get reorderable():Boolean
		{
			return _reorderable;
		}
		
		public function set reorderable(b:Boolean):void
		{
			_reorderable = b;
		}

		public function get selectable():Boolean
		{
			return _selectable;
		}
		
		public function set selectable(b:Boolean):void
		{
			_selectable = b;
		}
		
		public function get deletable():Boolean
		{
			return _deletable;
		}
		
		public function set deletable(b:Boolean):void
		{
			_deletable = b;
		}
		
		public function get copyOnDrop():Boolean
		{
			return _copy_on_drop;
		}
		
		public function set copyOnDrop(b:Boolean):void
		{
			_copy_on_drop = b;
		}
		
		public function get allowsDuplicates():Boolean
		{
			return _allows_duplicates;
		}
		
		public function set allowsDuplicates(b:Boolean):void
		{
			_allows_duplicates = b;
		}
		
		public function get willAutoUnfocusSelections():Boolean
		{
			return _will_auto_unfocus_selection;
		}
		
		public function set willAutoUnfocusSelections(b:Boolean):void
		{
			_will_auto_unfocus_selection = b;
		}

		override public function addComponent(c:Component,i:int=-1):void
		{
			super.addComponent(c,i);
			_dirty = true;
		}
		
		override public function set width(w:Number):void
		{
			super.width = w;
			contentHeight = layout.calculateHeight();
		}
		
		override public function set height(h:Number):void
		{
			super.height = h;
		}
		
		private function get_items_decorator(type:uint):Decorator
		{
			_decorator_type = type;
			switch(type)
			{
				case DECORATOR_NO_SCROLL:
					return new Decorator();
				case DECORATOR_SCROLL_AREA:
					return new ScrollAreaDecorator(ScrollingDecorator.SCROLL_TYPE_VALUE_VERTICAL);
				case DECORATOR_SCROLL_BAR:
					return new ScrollBarDecorator(ScrollingDecorator.SCROLL_TYPE_VALUE_VERTICAL);
			}
			return null;
		}
		
		private function get_items_layout(type:uint, params:Object=null):Layout
		{
			_layout_type = type;
			switch(type){
				case LAYOUT_FLOW_HORIZONTAL:
					return new FlowLayout(FlowLayout.LEFT_TO_RIGHT, params);
				case LAYOUT_FLOW_VERTICAL:
					return new FlowLayout(FlowLayout.TOP_TO_BOTTOM, params);
				case LAYOUT_GRID_HORIZONTAL:
					return new GridLayout(GridLayout.GROW_HORIZONTALLY, params);
				case LAYOUT_GRID_VERTICAL:
					return new GridLayout(GridLayout.GROW_VERTICALLY, params);
				default:
					return null;
			}
		}

	
//		

		private function do_click_component_event(c:ComponentEvent):void
		{
			do_select_component(c.component);
			render();
			dispatchEvent(new BrowserEvent(BrowserEvent.SELECT, this, c.component));
			dispatchEvent(new BrowserEvent(BrowserEvent.SINGLE_CLICK, this, c.component));
		}
		
		private function do_double_click_component_event(c:ComponentEvent):void
		{
			do_select_component(c.component);
			render();
			dispatchEvent(new BrowserEvent(BrowserEvent.SELECT, this, c.component));
			dispatchEvent(new BrowserEvent(BrowserEvent.DOUBLE_CLICK, this, c.component));
		}
			
		protected function do_select_component(c:Component):void
		{
			if (c==_selected_component)
				return;
			set_selectable(_selected_component, false);
			_selected_component = c;
			_selected_index = children.indexOf(_selected_component);
			set_selectable(_selected_component, true);
		}
		
		private function set_selectable(o:*, b:Boolean):void
		{
			var s:ISelectable = o as ISelectable;
			if (s != null)
			{
				s.selected = b;
				o.render();
			}
		}
	
		private function ui_value_change(e:BrowserEvent):void
		{
			_dirty = true;
			dispatchEvent(e);
			dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE, this));
		}
		
		override public function onFocus(e:FocusEvent):void
		{
			if (e.type==FocusEvent.UNFOCUS_CHILD && _will_auto_unfocus_selection && !e.component.hasAncestor(this))
			{
				for (var i:uint=0; i<children.length; i++)
				{
					if (children[i] is ISelectable)
						children[i].selected = false;
				}
				render();
			}
		}
		
		/** drag and drop */
		
		protected var _drag_start_index:uint;
		protected var _drag_over_index:int = -1;
		protected var _drag_empty:Component;

		override public function onDragStart(c:Component):void
		{
			if (c.parent!=this)
			{
				return;
			}
			do_select_component(c);
			_drag_start_index = indexOf(c);
		}
		
		private function yo(y:Number):Number
		{
			var yo:Number = y;
			if (decorator is ScrollingDecorator)
				yo += scrollingDecorator.getScrollVertical();
			return yo;
		}
				
		override public function onDragOver(c:Component,x:Number,y:Number):void
		{
			var i:uint = layout.calculateIndex(x,yo(y));
			if (i==_drag_over_index)
				return;
			_drag_over_index = i;
			if (c.parent!=this)
			{
				if (_drag_empty==null)
				{
					_drag_empty = new Container(this);
					doDragAddComponent(_drag_empty,_drag_over_index);
				}
				else
				{
					doDragReIndexComponent(_drag_empty,_drag_over_index);
				}
				render();
				dispatchEvent(new BrowserEvent(BrowserEvent.DRAGGING, this, c, _drag_over_index));
				return;
			}
			else if (_reorderable)
			{
				doDragReIndexComponent(c,_drag_over_index);
				render();
				dispatchEvent(new BrowserEvent(BrowserEvent.DRAGGING, this,  c, _drag_over_index));
			}
		}
		
		private function doDragAddComponent(c:Component,i:int):void
		{
			//c is already added at the end of the list...
			reIndexComponent(c,i);
		}
		
		private function doDragReIndexComponent(c:Component, i:int):void
		{
			reIndexComponent(c,i);
		}
		
		private function doDragRemoveComponent(c:Component):void
		{
			removeComponent(c);
		}
		
		override public function onDragExit(c:Component):void
		{
			_drag_over_index = -1;
			if (c.parent!=this)
			{
				if (_drag_empty!=null)
				{
					doDragRemoveComponent(_drag_empty);
					_drag_empty = null;
				}
				render();
				dispatchEvent(new BrowserEvent(BrowserEvent.DRAGGING, this, c));
				return;
			}
			else if (_reorderable)
			{
				doDragReIndexComponent(c,_drag_start_index);
				render();
				dispatchEvent(new BrowserEvent(BrowserEvent.DRAGGING, this, c));
			}
			
		}
		
		override public function onDrop(c:Component,x:Number,y:Number):void
		{
			_drag_over_index = -1;
			if (c.parent!=this)
			{
				if (_drag_empty!=null)
				{
					doDragRemoveComponent(_drag_empty);
					_drag_empty = null;
				}
				
				if (c.parent is Browser )
				{
					var b:Browser = c.parent as Browser;
					if (!b.copyOnDrop)
					{
						b.doDragRemoveComponent(c);
						b.render();
						b.ui_value_change(new BrowserEvent(BrowserEvent.REMOVE, this, c));//component removed from the browser the component was dragged from
					}
				}
				//
				if (!_allows_duplicates)
				{
//					var a:Array = value as Array;
//					if (a.indexOf(c.userObject)!=-1)
//					{
//						render();
//						return;
//					}
				}
				var i:uint = layout.calculateIndex(x, yo(y));
				var cc:Component = create_view(this,c.userObject);
				doDragAddComponent(cc, i);
				render();
				ui_value_change(new BrowserEvent(BrowserEvent.ADD, this, cc, i));//component added at index
				return;
			}
			//trace("ON ME "+this+"/"+c+" at "+x+","+y);
			else if (_reorderable)
			{
				
				render();
				var o:uint = layout.calculateIndex(x, yo(y));
				if (o==_drag_start_index)
					return;
				ui_value_change(new BrowserEvent(BrowserEvent.REORDER, this, _selected_component, _drag_over_index));//order of items changed
			}
			
		}
		
		///// KEYLISTENER
		
		public function onKeyRelease(e:KeyboardEvent):void
		{
			if (e.keyCode==Keyboard.DELETE && _deletable)
			{
				doDragRemoveComponent(_selected_component);
				render();
				ui_value_change(new BrowserEvent(BrowserEvent.REMOVE, this, _selected_component));//component removed
				return;
			}
			
		}
		
		public function onKeyPress(e:KeyboardEvent):void
		{
			
		}

	}
}