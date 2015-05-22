package com.pagesociety.persistence
{
	public class Query
	{

		
		public static const PREDICATE_ITER_TYPE				:uint = 0x80;
		public static const EQ 								:uint = 0x81;
		public static const GT 								:uint = 0x82;
		public static const GTE 							:uint = 0x83;
		public static const LT  							:uint = 0x84;
		public static const LTE 							:uint = 0x85;
		public static const STARTSWITH 						:uint = 0x86;
		public static const IS_ANY_OF						:uint = 0x87;
		
		public static const BETWEEN_ITER_TYPE				:uint = 0x100;
		public static const BETWEEN_INCLUSIVE_ASC 			:uint = 0x101;
		public static const BETWEEN_EXCLUSIVE_ASC 			:uint = 0x102;
		public static const BETWEEN_START_INCLUSIVE_ASC		:uint = 0x103;
		public static const BETWEEN_END_INCLUSIVE_ASC		:uint = 0x104;
		public static const BETWEEN_INCLUSIVE_DESC 			:uint = 0x105;
		public static const BETWEEN_EXCLUSIVE_DESC 			:uint = 0x106;
		public static const BETWEEN_START_INCLUSIVE_DESC	:uint = 0x107;
		public static const BETWEEN_END_INCLUSIVE_DESC		:uint = 0x108;	
		
		public static const SET_ITER_TYPE					:uint = 0x200;
		public static const SET_CONTAINS_ALL				:uint = 0x201;
		public static const SET_CONTAINS_ANY				:uint = 0x202;
		
		public static const FREETEXT_ITER_TYPE				:uint = 0x400;
		public static const FREETEXT_CONTAINS_ALL			:uint = 0x401;
		public static const FREETEXT_CONTAINS_ANY			:uint = 0x402;
		public static const FREETEXT_CONTAINS_PHRASE		:uint = 0x403;


		public static const BEGIN_INTERSECTION		:uint = 996;
		public static const END_INTERSECTION		:uint = 997;
		public static const BEGIN_UNION				:uint = 998;
		public static const END_UNION				:uint = 999;


		public static const  ASC			:uint = 0x00;
		public static const  DESC		   	:uint = 0x01;

	}
}