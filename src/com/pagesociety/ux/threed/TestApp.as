package com.pagesociety.ux.threed
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class TestApp extends Sprite
	{
		private var tri:Polygon3;
		private var box:Polygon3;
		private var r:ProjectionPlane;
		private var t:Transformer;
		private var t0:Transformer;
		
		public function TestApp()
		{
			tri = new Polygon3();
			tri.addPoint(new Point3(-15, -5, 0));
			tri.addPoint(new Point3(15, -15, 0));
			tri.addPoint(new Point3(0, 20, 0));
			tri.addPoint(new Point3(-15, -5, 0));
			
			box = new Polygon3();
			box.addPoint(new Point3(0,0,0));
			box.addPoint(new Point3(10,0,0));
			box.addPoint(new Point3(10,10,0));
			box.addPoint(new Point3(0,10,0));
			box.addPoint(new Point3(0,0,0));
			box.addPoint(new Point3(0,0,-10));
			box.addPoint(new Point3(10,0,-10));
			box.addPoint(new Point3(10,10,-10));
			box.addPoint(new Point3(0,10,-10));
			
			r = new ProjectionPlane();
			t = new Transformer();
			t0 = new Transformer();
			t0.translate(5,5,-5);
			addEventListener(Event.ENTER_FRAME, render);
		}
		
		private function render(e:Event):void
		{
			graphics.clear();

			t.rotate(3,0,1,0);
			t.scale(1.002,1.001,1);

			graphics.lineStyle(1,0,1);
			draw(r.render2d(t,tri));

			t0.rotate(2,.6,2,3);
			t0.scale(1.003,1.002,1);

			graphics.lineStyle(1,0xff0000,1);
			draw(r.render2d(t0,box));
		}
		
		private function draw(a:Array):void
		{
			graphics.moveTo(a[0].x+100,a[0].y+100);
			for (var i:uint=0; i<a.length; i++)
			{
				graphics.lineTo(a[i].x+100,a[i].y+100);
			}
		}

	}
}