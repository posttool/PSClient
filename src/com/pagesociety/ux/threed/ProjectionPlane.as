package com.pagesociety.ux.threed
{
	import flash.geom.Point;
	

	public class ProjectionPlane {
		//
		public static const PARALLEL:uint = 0;
		public static const PERSPECTIVE:uint = 1;
		//
		private static var type:uint = PARALLEL;
		private static var fovy:Number = 90;
		private static var aspectRatio:Number = 1;
		private static var near:Number = 1;
		private static var far:Number = 500;
		private static var viewPortDistance:Number = 3;
		//
		private static var normalize:Matrix = computeNormalize();
		private static var modelView:Matrix = computeModelView();
		private static var viewPort:Matrix = computeViewPort(208, 208);
	
		public function ProjectionPlane() 
		{
		}
	
		/**
		 * Not really a rendering, just a list of 2 coordinates.
		 * @return a list of 2d points
		 */
		public function render2d(t:Transformer, vertices:Polygon3):Array 
		{
			var points:Array = new Array();
			for (var i:uint = 0; i < vertices.size(); i++) 
			{
				var p3d:Matrix = getMatrix(vertices.getPoint(i));
				var p2d:Point3 = transform(p3d, t);
				points.push(get2dPoint(p2d));
			}
			return points;
		}
	
		
		private function get2dPoint(p3d:Point3):Point
		{
			var p2d:Point = new Point(p3d.x, p3d.y);
			return p2d;
		}
	
		private function transform(vertex:Matrix, transform:Transformer):Point3 
		{
			var transformed:Matrix = Matrix.multiply(transform.getMatrix(), vertex);
			transformed = Matrix.multiply(normalize, transformed);
			transformed = Matrix.multiply(modelView, transformed);
			switch (type) {
				case PARALLEL :
					var par_proj:Matrix = new Matrix(4);
					par_proj.loadIdentity();
					par_proj.setValue(2, 2, 0);
					transformed = Matrix.multiply(par_proj, transformed);
					break;
				case PERSPECTIVE :
					var h:Number = transformed.getValue(2, 0) / viewPortDistance;
					if (h == 0)
						return new Point3(0, 0, 0);
					transformed = Matrix.multiplyScalar(transformed, h);
					break;
			}
			transformed = Matrix.multiply(viewPort, transformed);
			return getPoint(transformed);
		}
	
		public function transform3d2d(p:Point3):Point 
		{
			var mxP:Matrix = getMatrix(p);
			var p2d:Point3 = transform(mxP, new Transformer());
			return new Point(p2d.x, p2d.y);
		}
	
		/**
		 * Makes a 4x1 column matrix and adds the xyz
		 * 
		 * @param point
		 * @return
		 */
		private function getMatrix(point:Point3):Matrix 
		{
			var p:Matrix = new Matrix(4, 1);
			p.setValue(0, 0, point.x);
			p.setValue(1, 0, point.y);
			p.setValue(2, 0, point.z);
			p.setValue(3, 0, 1);
			return p;
		}
	
		/**
		 * Extracts the x and y from a 4x4 matrix
		 * 
		 * @param viewingPlanePosition
		 * @return
		 */
		private function getPoint(position:Matrix):Point3 
		{
			var x:Number = position.getValue(0, 0);
			var y:Number = position.getValue(1, 0);
			var z:Number = position.getValue(2, 0);
			var w:Number = position.getValue(3, 0);
			/*
			 * if (w != 0) { float inv = 1.0f / w; return new Point((int) (x * inv),
			 * (int) (y * inv), (int) (z * inv)); }
			 */
			return new Point3(x, y, z);
		}
	
		private static function computeNormalize():Matrix 
		{
			var t:Transformer = new Transformer();
			t.scale(1, 1, 1);
			//t.translate(0, 0, 0);
			return t.getMatrix();
		}
	
		private static function computeModelView():Matrix 
		{
			// height = fovy for parallel projection
			var h:Number = fovy;
			// aspectRatio * height
			var w:Number = aspectRatio * h;
			// far - near : clipping plane
			var d:Number = far - near;
			// build projection matrix 4x4 all cells 0
			var view:Matrix = new Matrix(4, 4);
			view.loadIdentity();
			// from m3g.Camera.setParallel
			view.setValue(0, 0, 2 / w);
			view.setValue(1, 1, 2 / h);
			view.setValue(2, 2, -2 / d);
			view.setValue(2, 3, -(near + far) / d);
			view.setValue(3, 2, -1);
			return view;
		}
	
		private static function computeViewPort(w:Number, h:Number):Matrix 
		{
			aspectRatio = w / h;
			// - sign in both matrices to move origin to bottom left
			var t:Transformer = new Transformer();
			t.scale(50, 50, 0);
			//t.translate(1,1, 0);
			return t.getMatrix();
		}
	}
}