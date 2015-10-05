package com.pagesociety.ux.threed
{
    public class Renderer
    {
        private var _projection:ProjectionPlane;
        private var _transform:Array;
        
        public function Renderer()
        {
            _projection = new ProjectionPlane();
            _transform = new Array();
            _transform.push(new Transformer());
        }

    }
}