package com.pagesociety.web.module
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.web.ModuleConnection;
	import com.pagesociety.web.amf.AmfLong;
	
	public class TreeModule extends ModuleConnection
	{
		
		public static var MODULE_NAME:String = "PosteraTreeModule";
		
		public static var TREE_ENTITY:String = "Tree";
		public static var TREE_FIELD_ID:String = "id";
		public static var TREE_FIELD_CREATOR:String = "creator";
		public static var TREE_FIELD_DATE_CREATED:String = "date_created";
		public static var TREE_FIELD_LAST_MODIFIED:String = "last_modified";
		public static var TREE_FIELD_NAME:String = "name";
		public static var TREE_FIELD_ROOT:String = "root";

		public static var TREENODE_ENTITY:String = "TreeNode";
		public static var TREENODE_FIELD_ID:String = "id";
		public static var TREENODE_FIELD_CREATOR:String = "creator";
		public static var TREENODE_FIELD_DATE_CREATED:String = "date_created";
		public static var TREENODE_FIELD_LAST_MODIFIED:String = "last_modified";
		public static var TREENODE_FIELD_TREE:String = "tree";
		public static var TREENODE_FIELD_NODE_ID:String = "node_id";
		public static var TREENODE_FIELD_NODE_CLASS:String = "node_class";
		public static var TREENODE_FIELD_PARENT_NODE:String = "parent_node";
		public static var TREENODE_FIELD_CHILDREN:String = "children";
		public static var TREENODE_FIELD_DATA:String = "data";
		public static var TREENODE_FIELD_METADATA:String = "metadata";


// TODO move to Postera TreeNode
		// DeleteFromEditTree returns List 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_DELETEFROMEDITTREE:String = MODULE_NAME+"/DeleteFromEditTree";
		public static function DeleteFromEditTree(a1:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_DELETEFROMEDITTREE, [a1], on_complete, on_error);		
		}
		
		// DeleteFromArchive returns List 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_DELETEFROMARCHIVE:String = MODULE_NAME+"/DeleteFromArchive";
		public static function DeleteFromArchive(a1:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_DELETEFROMARCHIVE, [a1], on_complete, on_error);		
		}
		
		// GetPublicTree returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_GETPUBLICTREE:String = MODULE_NAME+"/GetPublicTree";
		public static function GetPublicTree(on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETPUBLICTREE, [], on_complete, on_error);		
		}
		
		// ArchiveTreeNode returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_ARCHIVETREENODE:String = MODULE_NAME+"/ArchiveTreeNode";
		public static function ArchiveTreeNode(edit_tree_node_id:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_ARCHIVETREENODE, [edit_tree_node_id], on_complete, on_error);		
		}

		// UnarchiveTreeNode returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_UNARCHIVETREENODE:String = MODULE_NAME+"/UnarchiveTreeNode";
		public static function UnarchiveTreeNode(archive_tree_node_id:AmfLong, edit_tree_node_parent_id:AmfLong, parent_idx:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_UNARCHIVETREENODE, [archive_tree_node_id,edit_tree_node_parent_id, parent_idx], on_complete, on_error);		
		}

		// GetArchiveTree returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_GETARCHIVETREE:String = MODULE_NAME+"/GetArchiveTree";
		public static function GetArchiveTree(on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETARCHIVETREE, [], on_complete, on_error);		
		}
// end of postera tree node methods
		
		
		
		
		
		
		
		// GetTreeByName returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETTREEBYNAME:String = MODULE_NAME+"/GetTreeByName";
		public static function GetTreeByName(name:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETTREEBYNAME, [name], on_complete, on_error);		
		}

		// getAncestors returns List 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_GETANCESTORS:String = MODULE_NAME+"/getAncestors";
		public static function getAncestors(entity_node_id:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETANCESTORS, [entity_node_id], on_complete, on_error);		
		}

		// GetTreeNodesByClass returns List 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETTREENODESBYCLASS:String = MODULE_NAME+"/GetTreeNodesByClass";
		public static function GetTreeNodesByClass(tree_id:AmfLong, node_classname:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETTREENODESBYCLASS, [tree_id, node_classname], on_complete, on_error);		
		}

		// CreateTree returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_CREATETREE:String = MODULE_NAME+"/CreateTree";
		public static function CreateTree(name:String, root_class:String, root_id:String, root_data:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CREATETREE, [name, root_class, root_id, root_data], on_complete, on_error);		
		}

		// CloneTree returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_CLONETREE:String = MODULE_NAME+"/CloneTree";
		public static function CloneTree(tree_id:AmfLong, new_tree_name:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CLONETREE, [tree_id, new_tree_name], on_complete, on_error);		
		}

		// GetTreeNodeById returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETTREENODEBYID:String = MODULE_NAME+"/GetTreeNodeById";
		public static function GetTreeNodeById(tree_id:AmfLong, node_id:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETTREENODEBYID, [tree_id, node_id], on_complete, on_error);		
		}

		// UpdateTreeNode returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_UPDATETREENODE:String = MODULE_NAME+"/UpdateTreeNode";
		public static function UpdateTreeNode(tree_node_id:AmfLong, node_class:String, node_id:String, data:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_UPDATETREENODE, [tree_node_id, node_class, node_id, data], on_complete, on_error);		
		}

		// GetEditTree returns Entity 
		// throws PersistenceException, WebApplicationException
		public static var METHOD_GETEDITTREE:String = MODULE_NAME+"/GetEditTree";
		public static function GetEditTree(on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETEDITTREE, [], on_complete, on_error);		
		}
		
		public static function GetEditTree1(user_id:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETEDITTREE, [user_id], on_complete, on_error);		
		}

		// GetTrees returns List 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETTREES:String = MODULE_NAME+"/GetTrees";
		public static function GetTrees(on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETTREES, [], on_complete, on_error);		
		}

		// UpdateTree returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_UPDATETREE:String = MODULE_NAME+"/UpdateTree";
		public static function UpdateTree(tree_id:AmfLong, root_node:String, a3:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_UPDATETREE, [tree_id, root_node, a3], on_complete, on_error);		
		}

		// GetTreeForUserByName returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETTREEFORUSERBYNAME:String = MODULE_NAME+"/GetTreeForUserByName";
		public static function GetTreeForUserByName(user_id:AmfLong, name:String, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETTREEFORUSERBYNAME, [user_id, name], on_complete, on_error);		
		}

		// ReparentTreeNode returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_REPARENTTREENODE:String = MODULE_NAME+"/ReparentTreeNode";
		public static function ReparentTreeNode(entity_node_id:AmfLong, new_parent_id:AmfLong, new_parent_child_index:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_REPARENTTREENODE, [entity_node_id, new_parent_id, new_parent_child_index], on_complete, on_error);		
		}

		// DeleteTreeNode returns List 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_DELETETREENODE:String = MODULE_NAME+"/DeleteTreeNode";
		public static function DeleteTreeNode(entity_node_id:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_DELETETREENODE, [entity_node_id], on_complete, on_error);		
		}

		// CreateTreeNode returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_CREATETREENODE:String = MODULE_NAME+"/CreateTreeNode";
		public static function CreateTreeNode(a1:AmfLong, a2:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CREATETREENODE, [a1, a2], on_complete, on_error);		
		}

		// CreateTreeNode returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_CREATETREENODE1:String = MODULE_NAME+"/CreateTreeNode";
		public static function CreateTreeNode1(parent_node_id:AmfLong, node_class:String, node_id:String, data:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CREATETREENODE1, [parent_node_id, node_class, node_id, data], on_complete, on_error);		
		}

		// CreateTreeNode returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_CREATETREENODE2:String = MODULE_NAME+"/CreateTreeNode";
		public static function CreateTreeNode2(parent_node_id:AmfLong, parent_child_index:int, node_class:String, node_id:String, data:Entity, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_CREATETREENODE2, [parent_node_id, parent_child_index, node_class, node_id, data], on_complete, on_error);		
		}

		// DeleteTree returns List 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_DELETETREE:String = MODULE_NAME+"/DeleteTree";
		public static function DeleteTree(tree_id:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_DELETETREE, [tree_id], on_complete, on_error);		
		}

		// GetTreesForUser returns List 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_GETTREESFORUSER:String = MODULE_NAME+"/GetTreesForUser";
		public static function GetTreesForUser(user_id:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_GETTREESFORUSER, [user_id], on_complete, on_error);		
		}

		// FillNode returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_FILLNODE:String = MODULE_NAME+"/FillNode";
		public static function FillNode(node_id:AmfLong, subtree_fill_depth:int, data_ref_fill_depth:int, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_FILLNODE, [node_id, subtree_fill_depth, data_ref_fill_depth], on_complete, on_error);		
		}
		
		/**
		 * returns the completely filled node and masks all parent refs */
		// FillSystemNode returns Entity 
		// throws WebApplicationException, PersistenceException
		public static var METHOD_FILLSYSTEMNODE:String = MODULE_NAME+"/FillSystemNode";
		public static function FillSystemNode(node_id:AmfLong, on_complete:Function, on_error:Function):void
		{
			doModule(METHOD_FILLSYSTEMNODE, [node_id], on_complete, on_error);		
		}
		
		

	}
}
