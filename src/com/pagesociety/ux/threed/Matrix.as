package com.pagesociety.ux.threed
{
	import com.pagesociety.util.StringBuffer;
	public class Matrix {
		
		private var _rows:int;
		private var _cols:int;
		private var _values:Array;
	
		public function Matrix(rows:int, cols:int=-1, value:Number=0) // throws ArithmeticException 
		{
			if (cols==-1)
				cols = rows;
			if (rows <= 0 || cols <= 0) 
				throw new Error("Matrix must be bigger than "+rows+"x"+cols);

			_rows = rows;
			_cols = cols;
			_values = new Array(rows);
			for (var row:uint = 0; row < rows; row++) 
			{
				_values[row] = new Array(cols);
				for (var col:uint = 0; col < cols; ++col) 
				{
					_values[row][col] = value ;
				}
			}
		}
		
		public function loadIdentity():void
		{
			if (_rows != _cols) 
				throw new Error("Matrix loadIdentity error: Incompatible size");
			
			for (var row:uint = 0; row < _rows; row++) 
				for (var col:uint = 0; col < _cols; ++col) 
					_values[row][col] = 0 ;

			for (var i:uint=0; i<_rows; i++)
				_values[i][i] = 1;
		}
	
		public function clone():Matrix
		 {
			var m:Matrix = new Matrix(_rows,_cols);
			for (var row:uint = 0; row < _rows; row++) {
				for (var col:uint = 0; col < _cols; ++col) {
					m._values[row][col] = _values[row][col];
				}
			}
			return m;
		}
	
		public function getValue(row:int, col:int):Number 
		{
			return _values[row][col];
		}
	
		public function setValue(row:int, col:int, value:Number):void
		{
			_values[row][col] = value;
		}
	
		public function equals(o:Object):Boolean 
		{
			var m:Matrix = o as Matrix;
			if (o == null)
				return false;
			if (m._rows != _rows || m._cols != _cols) 
				return false;
			
			for (var row:uint = 0; row < _rows; row++) 
			{
				for (var col:uint = 0; col < _cols; ++col) 
				{
					if (m._values[row][col] != _values[row][col]) 
					{
						return false;
					}
				}
			}
			return true;
		}
	
		public static function add(a:Matrix, b:Matrix):Matrix
		{
			if (a._rows != b._rows || a._cols != b._cols) 
				throw new Error("Matrix add error: Incompatible size");

			var result:Matrix = new Matrix(a._rows, a._cols);
			for (var row:int = 0; row < a._rows; row++) 
			{
				for (var col:uint = 0; col < a._cols; col++) 
				{
					result._values[row][col] = a._values[row][col] + b._values[row][col];
				}
			}
			return result;
		}
	
		public static function subtract(a:Matrix, b:Matrix):Matrix
		{
			if (a._rows != b._rows || a._cols != b._cols) 
				throw new Error("Matrix subtract error: Incompatible size");

			var result:Matrix = new Matrix(a._rows, a._cols);
			for (var row:int = 0; row < a._rows; row++) 
			{
				for (var col:uint = 0; col < a._cols; col++) 
				{
					result._values[row][col] = a._values[row][col] - b._values[row][col];
				}
			}
			return result;
		}
	
		public static function multiplyScalar(a:Matrix, b:Number):Matrix
		{
			var result:Matrix = new Matrix(a._rows, a._cols);
			for (var row:int = 0; row < a._rows; row++) 
			{
				for (var col:uint = 0; col < a._cols; col++) 
				{
					result._values[row][col] = a._values[row][col] * b;
				}
			}
			return result;
		}
	
		public static function multiply(a:Matrix, b:Matrix):Matrix
		{
			if (a._cols != b._rows) 
				throw new Error("Matrix multiply error: Incompatible size");
			
			var result:Matrix = new Matrix(a._rows, b._cols);
			for (var row:int = 0; row < a._rows; row++) 
			{
				for (var col:uint = 0; col < b._cols; col++)
				{ 
					var sum:Number = 0.0;
					for (var i:int = 0; i < a._cols; ++i)
					{
						sum += a._values[row][i] * b._values[i][col];
					}
					result._values[row][col] = sum;
				}
			}
			return result;
		}
			
		
		public function toString():String
		{
			var b:StringBuffer = new StringBuffer();
			b.append("Matrix [\n");
			for (var row:int = 0; row <_rows; row++) 
			{
				for (var col:int = 0; col < _cols; col++) 
				{
					b.append(_values[row][col]+"");
					b.append("\t");
				}
				b.append("\n");
			}
			b.append("]");
			return b.toString();
		}
	}
}