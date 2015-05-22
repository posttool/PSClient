package com.pagesociety.ux.system
{
	import com.pagesociety.persistence.Entity;
	
	public interface ISystem
	{
		function init(map:Entity, selected_node_id:int, selected_resource_index:uint):void;
		function initEnd():void;
		function set systemProperties(props:Object):void;
		function get selectedNode():Entity;
		function get selectedIndex():uint;
		function render():void;
	}
}