package com.pagesociety.ux.component.container
{
	
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.ux.IEditor;
	import com.pagesociety.ux.Margin;
	import com.pagesociety.ux.component.Button;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.text.Pager;
	import com.pagesociety.ux.event.BrowserEvent;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.layout.FlowLayout;
	import com.pagesociety.web.ErrorMessage;
	
	[Event(type="com.pagesociety.ux.component.container.BrowserPager",name="select_item")]
	public class BrowserPager extends Container 
	{
		
		public static const SELECT_ITEM:String 	= "select_item";
		public static const ADD_ITEM:String 	= "add_item";

		protected var _results:Array;
		
		protected var _buttons:Container;
		protected var _add_button:Button;
		protected var _pager:Pager;
		protected var _browser:Browser;
		
		private var _first_time:Boolean = true;
		
		public function BrowserPager(parent:Container,add_button:Boolean=true)
		{
			super(parent);
			
			_buttons = new Container(this);
			_buttons.layout = new FlowLayout(FlowLayout.LEFT_TO_RIGHT);
			if (add_button)
			{
				_add_button = new Button(_buttons);
				_add_button.label = "add ...";
				_add_button.addEventListener(ComponentEvent.CLICK, on_add);
			}
			
			create_pager();

			_browser = new Browser(this);
			_browser.decoratorType = Browser.DECORATOR_SCROLL_BAR;
			_browser.layoutType = Browser.LAYOUT_GRID_VERTICAL;
			Object(_browser.layout).cellWidth = 180;
			Object(_browser.layout).cellHeight = 15;
			_browser.layout.margin.top = 5;
			_browser.layout.margin.left = 5;
			_browser.addEventListener(BrowserEvent.SINGLE_CLICK, on_select);
		}
		
		protected function create_pager():void
		{
			_pager = new Pager(_buttons);	
			_pager.pageSize = 15;
			_pager.addEventListener(ComponentEvent.CHANGE_VALUE, on_update);
		}
		
		protected function do_select_entities():void
		{
			throw new Error("PagerBrowser.do_select_entities must be defined by a service that returns " + 
					"PagingQueryResult to on_results");
		}
		
		public function set cellRenderer(f:Function):void
		{
			_browser.cellRenderer = f;
		}
		
		public function set cellWidth(w:Number):void
		{
			_browser.cellWidth = w;
		}
		
		public function get cellWidth():Number
		{
			return _browser.cellWidth;
		}
		
		public function set cellHeight(h:Number):void
		{
			_browser.cellHeight = h;
		}
		
		public function get cellHeight():Number
		{
			return _browser.cellHeight;
		}
		
		override public function render():void
		{
			if (visible && _first_time)
			{
				_first_time = false;
				selectEntities();
			}
			
			super.render();			
		}
		
		public function selectEntities():void
		{
			decorator.rasterize = true;
			//_browser.clear();
			//render();
			
			do_select_entities();
		}
		
		protected function on_results(o:Object):void
		{
			_pager.totalCount 		= o.totalCount;
			_pager.visible 			= (_pager.totalCount>_pager.pageSize);
			_browser.value 			= o.entities;

			decorator.rasterize 	= false;
			render();
		} 

		protected function on_update(e:ComponentEvent):void
		{
			selectEntities();
		}
		
		protected function on_results_err(e:ErrorMessage):void
		{
			//dispatchComponentEvent(PosteraAdmin.ERROR, this, e);
		}
		
		private function on_select(e:BrowserEvent):void
		{
			dispatchComponentEvent(SELECT_ITEM,this,e.changeTarget.userObject);
		}
		
		private function on_add(e:ComponentEvent):void
		{
			dispatchComponentEvent(ADD_ITEM,this);
		}
		
		////////////////////
		public function get value():Object { 
//			if (userObject!=null)
//				return userObject;
			if (_browser.selectionComponent!=null)
				return _browser.selectionComponent.userObject;
			else
				return null;
		}
		
	}
}