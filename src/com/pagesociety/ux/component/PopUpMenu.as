package com.pagesociety.ux.component
{
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.IKeyListener;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.component.text.Link;
	import com.pagesociety.ux.decorator.InputDecorator;
	import com.pagesociety.ux.decorator.ScrollAreaDecorator;
	import com.pagesociety.ux.decorator.ScrollBarDecorator;
	import com.pagesociety.ux.decorator.ScrollingDecorator;
	import com.pagesociety.ux.event.ComponentEvent;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
/**
 * 

var p:PopUpMenu = new PopUpMenu("popup", PopUpMenu.TYPE_SCROLL_BAR);
p.button.label = "Choose a state";
for (var j:uint=0; j<states.length; j++)
	p.addOption(states[j]);
addComponent(p);
 
 * 
 */
 	[Event(type="com.pagesociety.ux.event.ComponentEvent",name="change_value")]
	public class PopUpMenu extends Container implements IKeyListener, IEditor
	{
		public static var TYPE_SCROLL_BAR:uint = 0;
		public static var TYPE_AREA_SCROLL:uint = 1;
		
		protected var _button:Button;
		protected var _menu_container:Container;
		protected var _menu:Menu;
		protected var _menu_background:Component;
		protected var _scrolling:ScrollingDecorator;

		protected var _line_height:Number = 17;
		protected var _link_style:String = "Link";
		
		protected var _dirty:Boolean = false;

		protected var _menu_background_top_padding:uint = 3;
		protected var _menu_background_bottom_padding:uint = 4;
		
		protected var _offset:Point = new Point();

		public function PopUpMenu(parent:Container, type:uint)
		{
			super(parent);
			
			_button = new Button(this);
			_button.addEventListener(ComponentEvent.MOUSE_DOWN, click_button);
			_button.decorator.tabEnabled = true;
			_button.decorator.tabIndex = InputDecorator.TAB_INDEX++;
			_button.decorator.addEventListener(FocusEvent.FOCUS_IN, on_focus);
			
			_menu_container = new Container(this);
			_menu_container.visible = false;
			
			_menu_background = new Component(_menu_container);
			_menu_background.backgroundVisible = true;
			_menu_background.backgroundAlpha = 1;
			_menu_background.backgroundColor = 0xffffff;
			_menu_background.backgroundShadowSize = 22;
			_menu_background.backgroundShadowStrength = .3;
			
			_scrolling = (type == TYPE_AREA_SCROLL)
				? new ScrollAreaDecorator(ScrollingDecorator.SCROLL_TYPE_VALUE_VERTICAL) 
				: new ScrollBarDecorator(ScrollingDecorator.SCROLL_TYPE_VALUE_VERTICAL);
			_menu = new Menu(_menu_container);
			_menu.decorator = _scrolling;
			_menu.addEventListener(ComponentEvent.CHANGE_VALUE, select_menu_option);

			styleName = "PopUpMenu";
		}
		
		private function on_focus(e:FocusEvent):void
		{
			application.focusManager.setFocus(this);
		}
		
		public function get button():Button
		{
			return _button;
		}
		
		public function get menu():Menu
		{
			return _menu;
		}
		
		public function get menuBackground():Component
		{
			return _menu_background;
		}
		
		public function set lineHeight(h:Number):void
		{
			_line_height = h;
		}
		
		public function get lineHeight():Number
		{
			return _line_height;
		}
		
		public function set linkStyle(h:String):void
		{
			_link_style = h;
		}
		
		public function get linkStyle():String
		{
			return _link_style;
		}
		
		
		public function get value():Object
		{
			if (menu.selectedComponent==null)
				return null;
			else if (_menu.selectedComponent.userObject==null)
				return Label(_menu.selectedComponent).text;
			else
				return _menu.selectedComponent.userObject;
		}
		
		public function set value(o:Object):void
		{
			for (var i:uint=0; i<_menu.children.length; i++)
			{
				if ((_menu.children[i].userObject != null && _menu.children[i].userObject==o) 
					|| (_menu.children[i].text==o))
				{
					selectedIndex = i;
					return;
				}
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
		
		public function get selectedIndex():uint
		{
			return _menu.selectedIndex;
		}
		
		public function set selectedIndex(i:uint):void
		{
			_menu.selectedIndex = i;
			_button.label = Label(_menu.selectedComponent).text;
		}

		override public function clear():void
		{
			_menu.clear();
		}
		
		public function addOption(name:String, value:Object=null):Label
		{
			var _link:Link 		= new Link(_menu);
			_link.height 		= _line_height;
			_link.widthDelta 	= -10;
			_link.text 			= name;
			_link.userObject 	= value;
			_link.styleName 	= _link_style;
			_link.backgroundVisible = true;
			_link.backgroundAlpha = 0;
			
//			var h:Number = _menu.children.length*_line_height;
//			_menu.height					= h;
//			_scrolling.contentHeight 		= h;
//			_menu_background.height 		= h+20;
//			_menu_background.y				= -10;
			
			return _link;
		}
		
		private function click_button(e:ComponentEvent):void
		{
			application.focusManager.setFocus(this);
			show_menu();
		}
		
		private function show_menu():void
		{
			application.pushTakeOver(_menu_container, cancel_menu, 0, 0, false, _button, _offset);
			_button.visible = false;
			//_menu_container.visible = true;
			render();
		}
		
		private function select_menu_option_no_close(c:Component):void
		{
			_menu.selectComponent(c);
			_dirty = true;
			render();
		}
		
		private function select_menu_option(e:ComponentEvent):void
		{
			//trace("PopUpMenu.select_menu_option");
			_button.label = Label(_menu.selectedComponent).text;
			_button.render();
			close_menu();
			_dirty = true;
			dispatchEvent(new ComponentEvent(ComponentEvent.CHANGE_VALUE, this));
		}
		
		private function cancel_menu(e:*):void
		{
			close_menu();
		}
		
		private function close_menu():void
		{
			//trace("PopUpMenu.close_menu");
			application.hideTakeOver();
			_button.visible = true;
			//_menu_container.visible = false;
			render();
		}
		
		
		override public function render():void
		{
			var app_h:Number = application.height;
			var button_p:Point = application.getLocation(_button);
			
			var stage_above:Number = button_p.y - _line_height ;
			var stage_below:Number = app_h - button_p.y  - _line_height;
			var menu_line_y:Number = _menu.selectedIndex * _line_height;
			var menu_above:Number = (_menu.selectedIndex - 1) * _line_height;
			var menu_below:Number = (_menu.children.length - _menu.selectedIndex) * _line_height;
			var menu_height:Number = _menu.children.length * _line_height;
			
			var so:Number = 0;
			var mh:Number = 100;
			var my:Number = 0;
			
			if (menu_above > stage_above && menu_below > stage_below)
			{
				my = -stage_above;
				so = menu_above - stage_above + _line_height;
				mh = stage_above + stage_below;
			}
			else if (menu_below > stage_below)
			{
				my = -menu_line_y;			
				so = 0;
				mh = menu_above + stage_below + _line_height;
			}
			else if (menu_above > stage_above)
			{
				my = -stage_above;
				so = menu_above - stage_above + _line_height;
				mh = stage_above + menu_below;
			}
			else
			{
				my = -menu_line_y;
				so = 0;
				mh = menu_height;
			}
			
			_offset.y = my;
			//_menu_container.y =  my;
			_menu_container.height = mh;
			_menu.height = mh - _menu.y;
			_menu_background.height = mh + _menu_background_top_padding + _menu_background_bottom_padding;
			_menu_background.y = -_menu_background_top_padding;
			_scrolling.setScrollVertical(so);

			super.render();
		}
		
		// KeyListener
		private var _last_key_time:Number = 0;
		private var _keyboard_accumulator:String;
		public function onKeyRelease(e:KeyboardEvent):void
		{
			if (!_menu_container.visible)
			{
				if (e.keyCode==Keyboard.ENTER)
				{
					show_menu();
					return;
				}
				return;
			}
			
			if (getTimer()-_last_key_time > 500)
				_keyboard_accumulator = "";
			_last_key_time = getTimer();
			
			if (e.keyCode==Keyboard.ENTER)
			{
				select_menu_option(null);
				return;
			}
			
			var new_index:int;
			if (e.keyCode==Keyboard.UP)
			{
				new_index = _menu.selectedIndex-1;
				if (new_index<0)
					return;
				select_menu_option_no_close(_menu.children[new_index]);
				render();
				return;
				
			}
			if (e.keyCode==Keyboard.DOWN)
			{
				new_index = _menu.selectedIndex+1;
				if (new_index>=_menu.children.length)
					return;
				select_menu_option_no_close(_menu.children[new_index]);
				render();
				return;
			}
			
			if (e.keyCode<32 || e.keyCode>128)
				return;
			
			_keyboard_accumulator += String.fromCharCode(e.keyCode).toLowerCase();
			for (var i:uint=0; i<_menu.children.length; i++)
			{
				var v:String = Label(_menu.children[i]).text;
				if (v.substring(0,_keyboard_accumulator.length).toLowerCase()==_keyboard_accumulator)
				{
					select_menu_option_no_close(_menu.children[i]);
					break;
				}
			}
		}
		
		public function onKeyPress(e:KeyboardEvent):void
		{
			
		}
	}
}