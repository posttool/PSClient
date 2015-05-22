package com.pagesociety.ux.event
{
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Tree;
	import com.pagesociety.ux.component.TreeNode;

	public class TreeEvent extends ComponentEvent
	{
		public static var REMOVED:uint = 0;
		public static var ADDED:uint = 1;
		public static var REORDERED:uint = 2;
		public static var SELECT:uint = 3;
		public static var ACTION:uint = 4;
		
		private var _type:uint;
		private var _target:TreeNode;
		private var _new_index:int;
		
		public function TreeEvent(t:Tree, type:uint, target:TreeNode, new_index:int=-1)
		{
			super(CHANGE_VALUE, t);
			_type = type;
			_target = target;
			_new_index = new_index;
		}
		
		public function get changeType():uint
		{
			return _type;
		}
		
		public function get changeTarget():Component
		{
			return _target;
		}
		
		public function get changeIndex():uint
		{
			return _new_index;
		}
		
	}
}