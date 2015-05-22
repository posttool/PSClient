// $ANTLR 3.1 C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g 2008-10-02 16:58:58
package com.pagesociety.ux.style{
    import org.antlr.runtime.*;
        

    import org.antlr.runtime.tree.*;


    public class PSStyleSheetParser extends Parser {
        public static const tokenNames:Array = [
            "<invalid>", "<EOR>", "<DOWN>", "<UP>", "TROOT", "TSTYLE", "TBODY", "TPROP_SIMPLE", "TPROP_BLOCK", "IDENTIFIER", "COMMENT", "LINE_COMMENT", "WS", "'{'", "'}'", "':'", "';'"
        ];
        public static const TPROP_SIMPLE:int=7;
        public static const TSTYLE:int=5;
        public static const WS:int=12;
        public static const T__16:int=16;
        public static const T__15:int=15;
        public static const LINE_COMMENT:int=11;
        public static const T__14:int=14;
        public static const IDENTIFIER:int=9;
        public static const T__13:int=13;
        public static const TBODY:int=6;
        public static const TROOT:int=4;
        public static const TPROP_BLOCK:int=8;
        public static const COMMENT:int=10;
        public static const EOF:int=-1;

        // delegates
        // delegators


            public function PSStyleSheetParser(input:TokenStream, state:RecognizerSharedState = null) {
                super(input, state);
            }
            
        protected var adaptor:TreeAdaptor = new CommonTreeAdaptor();

        public function set treeAdaptor(adaptor:TreeAdaptor):void {
            this.adaptor = adaptor;
        }
        public function get treeAdaptor():TreeAdaptor {
            return adaptor;
        }

        public override function get tokenNames():Array { return PSStyleSheetParser.tokenNames; }
        public override function get grammarFileName():String { return "C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g"; }


        // $ANTLR start prog
        // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:14:1: prog : ( style )* -> ^( TROOT ( style )* ) ;
        public final function prog():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var style1:ParserRuleReturnScope = null;


            var stream_style:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule style");
            try {
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:15:3: ( ( style )* -> ^( TROOT ( style )* ) )
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:15:5: ( style )*
                {
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:15:5: ( style )*
                loop1:
                do {
                    var alt1:int=2;
                    var LA1_0:int = input.LA(1);

                    if ( (LA1_0==9) ) {
                        alt1=1;
                    }


                    switch (alt1) {
                	case 1 :
                	    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:15:5: style
                	    {
                	    pushFollow(FOLLOW_style_in_prog64);
                	    style1=style();

                	    state._fsp--;

                	    stream_style.add(style1.tree);

                	    }
                	    break;

                	default :
                	    break loop1;
                    }
                } while (true);



                // AST REWRITE
                // elements: style
                // token labels: 
                // rule labels: retval
                // token list labels: 
                // rule list labels: 
                retval.tree = root_0;
                var stream_retval:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"token retval",retval!=null?retval.tree:null);

                root_0 = Object(adaptor.nil());
                // 15:12: -> ^( TROOT ( style )* )
                {
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:15:15: ^( TROOT ( style )* )
                    {
                    var root_1:Object = Object(adaptor.nil());
                    root_1 = Object(adaptor.becomeRoot(Object(adaptor.create(TROOT, "TROOT")), root_1));

                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:15:23: ( style )*
                    while ( stream_style.hasNext ) {
                        adaptor.addChild(root_1, stream_style.nextTree());

                    }
                    stream_style.reset();

                    adaptor.addChild(root_0, root_1);
                    }

                }

                retval.tree = root_0;retval.tree = root_0;
                }

                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end prog

        // $ANTLR start style
        // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:18:1: style : styleName '{' body '}' -> ^( TSTYLE styleName body ) ;
        public final function style():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var char_literal3:Token=null;
            var char_literal5:Token=null;
            var styleName2:ParserRuleReturnScope = null;

            var body4:ParserRuleReturnScope = null;


            var char_literal3_tree:Object=null;
            var char_literal5_tree:Object=null;
            var stream_13:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 13");
            var stream_14:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 14");
            var stream_styleName:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule styleName");
            var stream_body:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule body");
            try {
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:19:3: ( styleName '{' body '}' -> ^( TSTYLE styleName body ) )
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:19:5: styleName '{' body '}'
                {
                pushFollow(FOLLOW_styleName_in_style90);
                styleName2=styleName();

                state._fsp--;

                stream_styleName.add(styleName2.tree);
                char_literal3=Token(matchStream(input,13,FOLLOW_13_in_style92));  
                stream_13.add(char_literal3);

                pushFollow(FOLLOW_body_in_style94);
                body4=body();

                state._fsp--;

                stream_body.add(body4.tree);
                char_literal5=Token(matchStream(input,14,FOLLOW_14_in_style96));  
                stream_14.add(char_literal5);



                // AST REWRITE
                // elements: styleName, body
                // token labels: 
                // rule labels: retval
                // token list labels: 
                // rule list labels: 
                retval.tree = root_0;
                var stream_retval:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"token retval",retval!=null?retval.tree:null);

                root_0 = Object(adaptor.nil());
                // 19:28: -> ^( TSTYLE styleName body )
                {
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:19:31: ^( TSTYLE styleName body )
                    {
                    var root_1:Object = Object(adaptor.nil());
                    root_1 = Object(adaptor.becomeRoot(Object(adaptor.create(TSTYLE, "TSTYLE")), root_1));

                    adaptor.addChild(root_1, stream_styleName.nextTree());
                    adaptor.addChild(root_1, stream_body.nextTree());

                    adaptor.addChild(root_0, root_1);
                    }

                }

                retval.tree = root_0;retval.tree = root_0;
                }

                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end style

        // $ANTLR start styleName
        // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:22:1: styleName : ( IDENTIFIER | IDENTIFIER ':' IDENTIFIER );
        public final function styleName():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var IDENTIFIER6:Token=null;
            var IDENTIFIER7:Token=null;
            var char_literal8:Token=null;
            var IDENTIFIER9:Token=null;

            var IDENTIFIER6_tree:Object=null;
            var IDENTIFIER7_tree:Object=null;
            var char_literal8_tree:Object=null;
            var IDENTIFIER9_tree:Object=null;

            try {
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:23:3: ( IDENTIFIER | IDENTIFIER ':' IDENTIFIER )
                var alt2:int=2;
                var LA2_0:int = input.LA(1);

                if ( (LA2_0==9) ) {
                    var LA2_1:int = input.LA(2);

                    if ( (LA2_1==15) ) {
                        alt2=2;
                    }
                    else if ( (LA2_1==13) ) {
                        alt2=1;
                    }
                    else {
                        throw new NoViableAltException("", 2, 1, input);

                    }
                }
                else {
                    throw new NoViableAltException("", 2, 0, input);

                }
                switch (alt2) {
                    case 1 :
                        // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:23:5: IDENTIFIER
                        {
                        root_0 = Object(adaptor.nil());

                        IDENTIFIER6=Token(matchStream(input,IDENTIFIER,FOLLOW_IDENTIFIER_in_styleName121)); 
                        IDENTIFIER6_tree = Object(adaptor.create(IDENTIFIER6));
                        adaptor.addChild(root_0, IDENTIFIER6_tree);


                        }
                        break;
                    case 2 :
                        // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:24:5: IDENTIFIER ':' IDENTIFIER
                        {
                        root_0 = Object(adaptor.nil());

                        IDENTIFIER7=Token(matchStream(input,IDENTIFIER,FOLLOW_IDENTIFIER_in_styleName129)); 
                        IDENTIFIER7_tree = Object(adaptor.create(IDENTIFIER7));
                        adaptor.addChild(root_0, IDENTIFIER7_tree);

                        char_literal8=Token(matchStream(input,15,FOLLOW_15_in_styleName131)); 
                        char_literal8_tree = Object(adaptor.create(char_literal8));
                        adaptor.addChild(root_0, char_literal8_tree);

                        IDENTIFIER9=Token(matchStream(input,IDENTIFIER,FOLLOW_IDENTIFIER_in_styleName133)); 
                        IDENTIFIER9_tree = Object(adaptor.create(IDENTIFIER9));
                        adaptor.addChild(root_0, IDENTIFIER9_tree);


                        }
                        break;

                }
                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end styleName

        // $ANTLR start body
        // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:27:1: body : ( property )* -> ^( TBODY ( property )* ) ;
        public final function body():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var property10:ParserRuleReturnScope = null;


            var stream_property:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule property");
            try {
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:28:3: ( ( property )* -> ^( TBODY ( property )* ) )
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:28:5: ( property )*
                {
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:28:5: ( property )*
                loop3:
                do {
                    var alt3:int=2;
                    var LA3_0:int = input.LA(1);

                    if ( (LA3_0==9) ) {
                        alt3=1;
                    }


                    switch (alt3) {
                	case 1 :
                	    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:28:5: property
                	    {
                	    pushFollow(FOLLOW_property_in_body152);
                	    property10=property();

                	    state._fsp--;

                	    stream_property.add(property10.tree);

                	    }
                	    break;

                	default :
                	    break loop3;
                    }
                } while (true);



                // AST REWRITE
                // elements: property
                // token labels: 
                // rule labels: retval
                // token list labels: 
                // rule list labels: 
                retval.tree = root_0;
                var stream_retval:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"token retval",retval!=null?retval.tree:null);

                root_0 = Object(adaptor.nil());
                // 28:15: -> ^( TBODY ( property )* )
                {
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:28:18: ^( TBODY ( property )* )
                    {
                    var root_1:Object = Object(adaptor.nil());
                    root_1 = Object(adaptor.becomeRoot(Object(adaptor.create(TBODY, "TBODY")), root_1));

                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:28:26: ( property )*
                    while ( stream_property.hasNext ) {
                        adaptor.addChild(root_1, stream_property.nextTree());

                    }
                    stream_property.reset();

                    adaptor.addChild(root_0, root_1);
                    }

                }

                retval.tree = root_0;retval.tree = root_0;
                }

                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end body

        // $ANTLR start property
        // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:31:1: property : IDENTIFIER ':' ( IDENTIFIER )+ ';' -> ^( TPROP_SIMPLE ( IDENTIFIER )+ ) ;
        public final function property():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var IDENTIFIER11:Token=null;
            var char_literal12:Token=null;
            var IDENTIFIER13:Token=null;
            var char_literal14:Token=null;

            var IDENTIFIER11_tree:Object=null;
            var char_literal12_tree:Object=null;
            var IDENTIFIER13_tree:Object=null;
            var char_literal14_tree:Object=null;
            var stream_15:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 15");
            var stream_IDENTIFIER:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token IDENTIFIER");
            var stream_16:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 16");

            try {
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:32:3: ( IDENTIFIER ':' ( IDENTIFIER )+ ';' -> ^( TPROP_SIMPLE ( IDENTIFIER )+ ) )
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:32:5: IDENTIFIER ':' ( IDENTIFIER )+ ';'
                {
                IDENTIFIER11=Token(matchStream(input,IDENTIFIER,FOLLOW_IDENTIFIER_in_property178));  
                stream_IDENTIFIER.add(IDENTIFIER11);

                char_literal12=Token(matchStream(input,15,FOLLOW_15_in_property180));  
                stream_15.add(char_literal12);

                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:32:20: ( IDENTIFIER )+
                var cnt4:int=0;
                loop4:
                do {
                    var alt4:int=2;
                    var LA4_0:int = input.LA(1);

                    if ( (LA4_0==9) ) {
                        alt4=1;
                    }


                    switch (alt4) {
                	case 1 :
                	    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:32:20: IDENTIFIER
                	    {
                	    IDENTIFIER13=Token(matchStream(input,IDENTIFIER,FOLLOW_IDENTIFIER_in_property182));  
                	    stream_IDENTIFIER.add(IDENTIFIER13);


                	    }
                	    break;

                	default :
                	    if ( cnt4 >= 1 ) break loop4;
                            throw new EarlyExitException(4, input);

                    }
                    cnt4++;
                } while (true);

                char_literal14=Token(matchStream(input,16,FOLLOW_16_in_property185));  
                stream_16.add(char_literal14);



                // AST REWRITE
                // elements: IDENTIFIER
                // token labels: 
                // rule labels: retval
                // token list labels: 
                // rule list labels: 
                retval.tree = root_0;
                var stream_retval:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"token retval",retval!=null?retval.tree:null);

                root_0 = Object(adaptor.nil());
                // 32:36: -> ^( TPROP_SIMPLE ( IDENTIFIER )+ )
                {
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:32:39: ^( TPROP_SIMPLE ( IDENTIFIER )+ )
                    {
                    var root_1:Object = Object(adaptor.nil());
                    root_1 = Object(adaptor.becomeRoot(Object(adaptor.create(TPROP_SIMPLE, "TPROP_SIMPLE")), root_1));

                    if ( !(stream_IDENTIFIER.hasNext) ) {
                        throw new RewriteEarlyExitException();
                    }
                    while ( stream_IDENTIFIER.hasNext ) {
                        adaptor.addChild(root_1, stream_IDENTIFIER.nextNode());

                    }
                    stream_IDENTIFIER.reset();

                    adaptor.addChild(root_0, root_1);
                    }

                }

                retval.tree = root_0;retval.tree = root_0;
                }

                retval.stop = input.LT(-1);

                retval.tree = Object(adaptor.rulePostProcessing(root_0));
                adaptor.setTokenBoundaries(retval.tree, Token(retval.start), Token(retval.stop));

            }
            catch (re:RecognitionException) {
                reportError(re);
                recoverStream(input,re);
                retval.tree = Object(adaptor.errorNode(input, Token(retval.start), input.LT(-1), re));

            }
            finally {
            }
            return retval;
        }
        // $ANTLR end property


           // Delegated rules


     

        public static const FOLLOW_style_in_prog64:BitSet = new BitSet([0x00000202, 0x00000000]);
        public static const FOLLOW_styleName_in_style90:BitSet = new BitSet([0x00002000, 0x00000000]);
        public static const FOLLOW_13_in_style92:BitSet = new BitSet([0x00004200, 0x00000000]);
        public static const FOLLOW_body_in_style94:BitSet = new BitSet([0x00004000, 0x00000000]);
        public static const FOLLOW_14_in_style96:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_IDENTIFIER_in_styleName121:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_IDENTIFIER_in_styleName129:BitSet = new BitSet([0x00008000, 0x00000000]);
        public static const FOLLOW_15_in_styleName131:BitSet = new BitSet([0x00000200, 0x00000000]);
        public static const FOLLOW_IDENTIFIER_in_styleName133:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_property_in_body152:BitSet = new BitSet([0x00000202, 0x00000000]);
        public static const FOLLOW_IDENTIFIER_in_property178:BitSet = new BitSet([0x00008000, 0x00000000]);
        public static const FOLLOW_15_in_property180:BitSet = new BitSet([0x00000200, 0x00000000]);
        public static const FOLLOW_IDENTIFIER_in_property182:BitSet = new BitSet([0x00010200, 0x00000000]);
        public static const FOLLOW_16_in_property185:BitSet = new BitSet([0x00000002, 0x00000000]);

    }
}