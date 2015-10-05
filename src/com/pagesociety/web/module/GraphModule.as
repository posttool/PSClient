package com.pagesociety.web.module
{
    import com.pagesociety.persistence.Entity;
    import com.pagesociety.web.ModuleConnection;
    import com.pagesociety.web.amf.AmfLong;
    
    public class GraphModule extends ModuleConnection
    {
        public static var GRAPH_ENTITY:String = "Graph";
        public static var GRAPH_FIELD_ID:String = "id";
        public static var GRAPH_FIELD_CREATOR:String = "creator";
        public static var GRAPH_FIELD_DATE_CREATED:String = "date_created";
        public static var GRAPH_FIELD_LAST_MODIFIED:String = "last_modified";
        public static var GRAPH_FIELD_NAME:String = "name";
        public static var GRAPH_FIELD_TYPE:String = "type";

        public static var GRAPHVERTEX_ENTITY:String = "GraphVertex";
        public static var GRAPHVERTEX_FIELD_ID:String = "id";
        public static var GRAPHVERTEX_FIELD_CREATOR:String = "creator";
        public static var GRAPHVERTEX_FIELD_DATE_CREATED:String = "date_created";
        public static var GRAPHVERTEX_FIELD_LAST_MODIFIED:String = "last_modified";
        public static var GRAPHVERTEX_FIELD_GRAPH:String = "graph";
        public static var GRAPHVERTEX_FIELD_VERTEX_ID:String = "vertex_id";
        public static var GRAPHVERTEX_FIELD_VERTEX_CLASS:String = "vertex_class";
        public static var GRAPHVERTEX_FIELD_DATA:String = "data";
        public static var GRAPHVERTEX_FIELD_METADATA:String = "metadata";

        public static var GRAPHDIRECTEDEDGE_ENTITY:String = "GraphDirectedEdge";
        public static var GRAPHDIRECTEDEDGE_FIELD_ID:String = "id";
        public static var GRAPHDIRECTEDEDGE_FIELD_CREATOR:String = "creator";
        public static var GRAPHDIRECTEDEDGE_FIELD_DATE_CREATED:String = "date_created";
        public static var GRAPHDIRECTEDEDGE_FIELD_LAST_MODIFIED:String = "last_modified";
        public static var GRAPHDIRECTEDEDGE_FIELD_GRAPH:String = "graph";
        public static var GRAPHDIRECTEDEDGE_FIELD_TYPE:String = "type";
        public static var GRAPHDIRECTEDEDGE_FIELD_ORIGIN:String = "origin";
        public static var GRAPHDIRECTEDEDGE_FIELD_DESTINATION:String = "destination";
        public static var GRAPHDIRECTEDEDGE_FIELD_WEIGHT:String = "weight";
        public static var GRAPHDIRECTEDEDGE_FIELD_DATA:String = "data";
        public static var GRAPHDIRECTEDEDGE_FIELD_METADATA:String = "metadata";

        public static var GRAPHUNDIRECTEDEDGE_ENTITY:String = "GraphUndirectedEdge";
        public static var GRAPHUNDIRECTEDEDGE_FIELD_ID:String = "id";
        public static var GRAPHUNDIRECTEDEDGE_FIELD_CREATOR:String = "creator";
        public static var GRAPHUNDIRECTEDEDGE_FIELD_DATE_CREATED:String = "date_created";
        public static var GRAPHUNDIRECTEDEDGE_FIELD_LAST_MODIFIED:String = "last_modified";
        public static var GRAPHUNDIRECTEDEDGE_FIELD_GRAPH:String = "graph";
        public static var GRAPHUNDIRECTEDEDGE_FIELD_TYPE:String = "type";
        public static var GRAPHUNDIRECTEDEDGE_FIELD_VERTICES:String = "vertices";
        public static var GRAPHUNDIRECTEDEDGE_FIELD_WEIGHT:String = "weight";
        public static var GRAPHUNDIRECTEDEDGE_FIELD_DATA:String = "data";
        public static var GRAPHUNDIRECTEDEDGE_FIELD_METADATA:String = "metadata";


        // CreateGraph returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_CREATEGRAPH:String = "GraphModule/CreateGraph";
        public static function CreateGraph(a1:String, a2:int, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_CREATEGRAPH, [a1, a2], on_complete, on_error);      
        }

        // UpdateGraph returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_UPDATEGRAPH:String = "GraphModule/UpdateGraph";
        public static function UpdateGraph(a1:AmfLong, a2:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_UPDATEGRAPH, [a1, a2], on_complete, on_error);      
        }

        // DeleteGraph returns List 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_DELETEGRAPH:String = "GraphModule/DeleteGraph";
        public static function DeleteGraph(a1:AmfLong, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_DELETEGRAPH, [a1], on_complete, on_error);      
        }

        // CreateVertex returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_CREATEVERTEX:String = "GraphModule/CreateVertex";
        public static function CreateVertex(a1:AmfLong, a2:String, a3:String, a4:Entity, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_CREATEVERTEX, [a1, a2, a3, a4], on_complete, on_error);     
        }

        // UpdateVertex returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_UPDATEVERTEX:String = "GraphModule/UpdateVertex";
        public static function UpdateVertex(a1:AmfLong, a2:String, a3:String, a4:Entity, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_UPDATEVERTEX, [a1, a2, a3, a4], on_complete, on_error);     
        }

        // DeleteVertex returns List 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_DELETEVERTEX:String = "GraphModule/DeleteVertex";
        public static function DeleteVertex(a1:AmfLong, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_DELETEVERTEX, [a1], on_complete, on_error);     
        }

        // CreateEdge returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_CREATEEDGE:String = "GraphModule/CreateEdge";
        public static function CreateEdge(a1:AmfLong, a2:Entity, a3:Entity, a4:Entity, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_CREATEEDGE, [a1, a2, a3, a4], on_complete, on_error);       
        }

        // DeleteEdge returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_DELETEEDGE:String = "GraphModule/DeleteEdge";
        public static function DeleteEdge(a1:AmfLong, a2:AmfLong, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_DELETEEDGE, [a1, a2], on_complete, on_error);       
        }

        // UpdateEdge returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_UPDATEEDGE:String = "GraphModule/UpdateEdge";
        public static function UpdateEdge(a1:AmfLong, a2:AmfLong, a3:AmfLong, a4:AmfLong, a5:String, a6:AmfLong, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_UPDATEEDGE, [a1, a2, a3, a4, a5, a6], on_complete, on_error);       
        }

        // CloneGraph returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_CLONEGRAPH:String = "GraphModule/CloneGraph";
        public static function CloneGraph(a1:AmfLong, a2:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_CLONEGRAPH, [a1, a2], on_complete, on_error);       
        }

        // GetUserGraphs returns PagingQueryResult 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_GETUSERGRAPHS:String = "GraphModule/GetUserGraphs";
        public static function GetUserGraphs(a1:int, a2:int, a3:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_GETUSERGRAPHS, [a1, a2, a3], on_complete, on_error);        
        }

        // GetGraphsForUser returns PagingQueryResult 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_GETGRAPHSFORUSER:String = "GraphModule/GetGraphsForUser";
        public static function GetGraphsForUser(a1:AmfLong, a2:int, a3:int, a4:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_GETGRAPHSFORUSER, [a1, a2, a3, a4], on_complete, on_error);     
        }

        // GetGraphForUserByName returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_GETGRAPHFORUSERBYNAME:String = "GraphModule/GetGraphForUserByName";
        public static function GetGraphForUserByName(a1:AmfLong, a2:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_GETGRAPHFORUSERBYNAME, [a1, a2], on_complete, on_error);        
        }

        // GetUserGraphByName returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_GETUSERGRAPHBYNAME:String = "GraphModule/GetUserGraphByName";
        public static function GetUserGraphByName(a1:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_GETUSERGRAPHBYNAME, [a1], on_complete, on_error);       
        }

        // GetGraphVertices returns PagingQueryResult 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_GETGRAPHVERTICES:String = "GraphModule/GetGraphVertices";
        public static function GetGraphVertices(a1:AmfLong, a2:int, a3:int, a4:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_GETGRAPHVERTICES, [a1, a2, a3, a4], on_complete, on_error);     
        }

        // GetGraphVerticesByClass returns PagingQueryResult 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_GETGRAPHVERTICESBYCLASS:String = "GraphModule/GetGraphVerticesByClass";
        public static function GetGraphVerticesByClass(a1:AmfLong, a2:String, a3:int, a4:int, a5:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_GETGRAPHVERTICESBYCLASS, [a1, a2, a3, a4, a5], on_complete, on_error);      
        }

        // GetGraphVerticeById returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_GETGRAPHVERTICEBYID:String = "GraphModule/GetGraphVerticeById";
        public static function GetGraphVerticeById(a1:AmfLong, a2:String, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_GETGRAPHVERTICEBYID, [a1, a2], on_complete, on_error);      
        }

        // FillVertexData returns Entity 
        // throws WebApplicationException, PersistenceException
        public static var METHOD_FILLVERTEXDATA:String = "GraphModule/FillVertexData";
        public static function FillVertexData(a1:AmfLong, a2:int, on_complete:Function, on_error:Function):void
        {
            doModule(METHOD_FILLVERTEXDATA, [a1, a2], on_complete, on_error);       
        }

    }
}