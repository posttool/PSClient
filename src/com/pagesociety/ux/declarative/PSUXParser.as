// $ANTLR 3.1 C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g 2008-10-02 14:58:47
package com.pagesociety.ux.declarative {
    import org.antlr.runtime.*;
        

    import org.antlr.runtime.tree.*;


    public class PSUXParser extends Parser {
        public static const tokenNames:Array = [
            "<invalid>", "<EOR>", "<DOWN>", "<UP>", "TROOT", "TBLOCK", "TBODY", "TPROP_SIMPLE", "TPROP_BLOCK", "IDENTIFIER", "COMMENT", "LINE_COMMENT", "WS", "'{'", "'}'", "':'", "';'"
        ];
        public static const TPROP_SIMPLE:int=7;
        public static const WS:int=12;
        public static const T__16:int=16;
        public static const T__15:int=15;
        public static const LINE_COMMENT:int=11;
        public static const T__14:int=14;
        public static const IDENTIFIER:int=9;
        public static const T__13:int=13;
        public static const TBODY:int=6;
        public static const TROOT:int=4;
        public static const TBLOCK:int=5;
        public static const TPROP_BLOCK:int=8;
        public static const COMMENT:int=10;
        public static const EOF:int=-1;

        // delegates
        // delegators


            public function PSUXParser(input:TokenStream, state:RecognizerSharedState = null) {
                super(input, state);
            }
            
        protected var adaptor:TreeAdaptor = new CommonTreeAdaptor();

        public function set treeAdaptor(adaptor:TreeAdaptor):void {
            this.adaptor = adaptor;
        }
        public function get treeAdaptor():TreeAdaptor {
            return adaptor;
        }

        public override function get tokenNames():Array { return PSUXParser.tokenNames; }
        public override function get grammarFileName():String { return "C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g"; }


        // $ANTLR start prog
        // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:13:1: prog : block -> ^( TROOT block ) ;
        public final function prog():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var block1:ParserRuleReturnScope = null;


            var stream_block:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule block");
            try {
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:14:3: ( block -> ^( TROOT block ) )
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:14:5: block
                {
                pushFollow(FOLLOW_block_in_prog61);
                block1=block();

                state._fsp--;

                stream_block.add(block1.tree);


                // AST REWRITE
                // elements: block
                // token labels: 
                // rule labels: retval
                // token list labels: 
                // rule list labels: 
                retval.tree = root_0;
                var stream_retval:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"token retval",retval!=null?retval.tree:null);

                root_0 = Object(adaptor.nil());
                // 14:11: -> ^( TROOT block )
                {
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:14:14: ^( TROOT block )
                    {
                    var root_1:Object = Object(adaptor.nil());
                    root_1 = Object(adaptor.becomeRoot(Object(adaptor.create(TROOT, "TROOT")), root_1));

                    adaptor.addChild(root_1, stream_block.nextTree());

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

        // $ANTLR start block
        // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:17:1: block : IDENTIFIER ( IDENTIFIER )? '{' body '}' -> ^( TBLOCK ( IDENTIFIER )+ body ) ;
        public final function block():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var IDENTIFIER2:Token=null;
            var IDENTIFIER3:Token=null;
            var char_literal4:Token=null;
            var char_literal6:Token=null;
            var body5:ParserRuleReturnScope = null;


            var IDENTIFIER2_tree:Object=null;
            var IDENTIFIER3_tree:Object=null;
            var char_literal4_tree:Object=null;
            var char_literal6_tree:Object=null;
            var stream_IDENTIFIER:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token IDENTIFIER");
            var stream_13:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 13");
            var stream_14:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 14");
            var stream_body:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule body");
            try {
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:18:3: ( IDENTIFIER ( IDENTIFIER )? '{' body '}' -> ^( TBLOCK ( IDENTIFIER )+ body ) )
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:18:5: IDENTIFIER ( IDENTIFIER )? '{' body '}'
                {
                IDENTIFIER2=Token(matchStream(input,IDENTIFIER,FOLLOW_IDENTIFIER_in_block82));  
                stream_IDENTIFIER.add(IDENTIFIER2);

                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:18:16: ( IDENTIFIER )?
                var alt1:int=2;
                var LA1_0:int = input.LA(1);

                if ( (LA1_0==9) ) {
                    alt1=1;
                }
                switch (alt1) {
                    case 1 :
                        // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:18:16: IDENTIFIER
                        {
                        IDENTIFIER3=Token(matchStream(input,IDENTIFIER,FOLLOW_IDENTIFIER_in_block84));  
                        stream_IDENTIFIER.add(IDENTIFIER3);


                        }
                        break;

                }

                char_literal4=Token(matchStream(input,13,FOLLOW_13_in_block87));  
                stream_13.add(char_literal4);

                pushFollow(FOLLOW_body_in_block89);
                body5=body();

                state._fsp--;

                stream_body.add(body5.tree);
                char_literal6=Token(matchStream(input,14,FOLLOW_14_in_block91));  
                stream_14.add(char_literal6);



                // AST REWRITE
                // elements: IDENTIFIER, body
                // token labels: 
                // rule labels: retval
                // token list labels: 
                // rule list labels: 
                retval.tree = root_0;
                var stream_retval:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"token retval",retval!=null?retval.tree:null);

                root_0 = Object(adaptor.nil());
                // 18:41: -> ^( TBLOCK ( IDENTIFIER )+ body )
                {
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:18:44: ^( TBLOCK ( IDENTIFIER )+ body )
                    {
                    var root_1:Object = Object(adaptor.nil());
                    root_1 = Object(adaptor.becomeRoot(Object(adaptor.create(TBLOCK, "TBLOCK")), root_1));

                    if ( !(stream_IDENTIFIER.hasNext) ) {
                        throw new RewriteEarlyExitException();
                    }
                    while ( stream_IDENTIFIER.hasNext ) {
                        adaptor.addChild(root_1, stream_IDENTIFIER.nextNode());

                    }
                    stream_IDENTIFIER.reset();
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
        // $ANTLR end block

        // $ANTLR start body
        // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:21:1: body : ( property )* ( block )* -> ^( TBODY ( property )* ( block )* ) ;
        public final function body():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var property7:ParserRuleReturnScope = null;

            var block8:ParserRuleReturnScope = null;


            var stream_block:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule block");
            var stream_property:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule property");
            try {
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:22:3: ( ( property )* ( block )* -> ^( TBODY ( property )* ( block )* ) )
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:22:5: ( property )* ( block )*
                {
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:22:5: ( property )*
                loop2:
                do {
                    var alt2:int=2;
                    var LA2_0:int = input.LA(1);

                    if ( (LA2_0==9) ) {
                        var LA2_1:int = input.LA(2);

                        if ( (LA2_1==15) ) {
                            alt2=1;
                        }


                    }


                    switch (alt2) {
                	case 1 :
                	    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:22:5: property
                	    {
                	    pushFollow(FOLLOW_property_in_body117);
                	    property7=property();

                	    state._fsp--;

                	    stream_property.add(property7.tree);

                	    }
                	    break;

                	default :
                	    break loop2;
                    }
                } while (true);

                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:22:15: ( block )*
                loop3:
                do {
                    var alt3:int=2;
                    var LA3_0:int = input.LA(1);

                    if ( (LA3_0==9) ) {
                        alt3=1;
                    }


                    switch (alt3) {
                	case 1 :
                	    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:22:15: block
                	    {
                	    pushFollow(FOLLOW_block_in_body120);
                	    block8=block();

                	    state._fsp--;

                	    stream_block.add(block8.tree);

                	    }
                	    break;

                	default :
                	    break loop3;
                    }
                } while (true);



                // AST REWRITE
                // elements: property, block
                // token labels: 
                // rule labels: retval
                // token list labels: 
                // rule list labels: 
                retval.tree = root_0;
                var stream_retval:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"token retval",retval!=null?retval.tree:null);

                root_0 = Object(adaptor.nil());
                // 22:22: -> ^( TBODY ( property )* ( block )* )
                {
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:22:25: ^( TBODY ( property )* ( block )* )
                    {
                    var root_1:Object = Object(adaptor.nil());
                    root_1 = Object(adaptor.becomeRoot(Object(adaptor.create(TBODY, "TBODY")), root_1));

                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:22:33: ( property )*
                    while ( stream_property.hasNext ) {
                        adaptor.addChild(root_1, stream_property.nextTree());

                    }
                    stream_property.reset();
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:22:43: ( block )*
                    while ( stream_block.hasNext ) {
                        adaptor.addChild(root_1, stream_block.nextTree());

                    }
                    stream_block.reset();

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
        // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:25:1: property : ( IDENTIFIER ':' IDENTIFIER ';' -> ^( TPROP_SIMPLE ( IDENTIFIER )+ ) | IDENTIFIER ':' block -> ^( TPROP_BLOCK IDENTIFIER block ) );
        public final function property():ParserRuleReturnScope {
            var retval:ParserRuleReturnScope = new ParserRuleReturnScope();
            retval.start = input.LT(1);

            var root_0:Object = null;

            var IDENTIFIER9:Token=null;
            var char_literal10:Token=null;
            var IDENTIFIER11:Token=null;
            var char_literal12:Token=null;
            var IDENTIFIER13:Token=null;
            var char_literal14:Token=null;
            var block15:ParserRuleReturnScope = null;


            var IDENTIFIER9_tree:Object=null;
            var char_literal10_tree:Object=null;
            var IDENTIFIER11_tree:Object=null;
            var char_literal12_tree:Object=null;
            var IDENTIFIER13_tree:Object=null;
            var char_literal14_tree:Object=null;
            var stream_15:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 15");
            var stream_IDENTIFIER:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token IDENTIFIER");
            var stream_16:RewriteRuleTokenStream=new RewriteRuleTokenStream(adaptor,"token 16");
            var stream_block:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"rule block");
            try {
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:26:3: ( IDENTIFIER ':' IDENTIFIER ';' -> ^( TPROP_SIMPLE ( IDENTIFIER )+ ) | IDENTIFIER ':' block -> ^( TPROP_BLOCK IDENTIFIER block ) )
                var alt4:int=2;
                var LA4_0:int = input.LA(1);

                if ( (LA4_0==9) ) {
                    var LA4_1:int = input.LA(2);

                    if ( (LA4_1==15) ) {
                        var LA4_2:int = input.LA(3);

                        if ( (LA4_2==9) ) {
                            var LA4_3:int = input.LA(4);

                            if ( (LA4_3==16) ) {
                                alt4=1;
                            }
                            else if ( (LA4_3==9||LA4_3==13) ) {
                                alt4=2;
                            }
                            else {
                                throw new NoViableAltException("", 4, 3, input);

                            }
                        }
                        else {
                            throw new NoViableAltException("", 4, 2, input);

                        }
                    }
                    else {
                        throw new NoViableAltException("", 4, 1, input);

                    }
                }
                else {
                    throw new NoViableAltException("", 4, 0, input);

                }
                switch (alt4) {
                    case 1 :
                        // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:26:5: IDENTIFIER ':' IDENTIFIER ';'
                        {
                        IDENTIFIER9=Token(matchStream(input,IDENTIFIER,FOLLOW_IDENTIFIER_in_property148));  
                        stream_IDENTIFIER.add(IDENTIFIER9);

                        char_literal10=Token(matchStream(input,15,FOLLOW_15_in_property150));  
                        stream_15.add(char_literal10);

                        IDENTIFIER11=Token(matchStream(input,IDENTIFIER,FOLLOW_IDENTIFIER_in_property152));  
                        stream_IDENTIFIER.add(IDENTIFIER11);

                        char_literal12=Token(matchStream(input,16,FOLLOW_16_in_property154));  
                        stream_16.add(char_literal12);



                        // AST REWRITE
                        // elements: IDENTIFIER
                        // token labels: 
                        // rule labels: retval
                        // token list labels: 
                        // rule list labels: 
                        retval.tree = root_0;
                        var stream_retval:RewriteRuleSubtreeStream=new RewriteRuleSubtreeStream(adaptor,"token retval",retval!=null?retval.tree:null);

                        root_0 = Object(adaptor.nil());
                        // 26:35: -> ^( TPROP_SIMPLE ( IDENTIFIER )+ )
                        {
                            // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:26:38: ^( TPROP_SIMPLE ( IDENTIFIER )+ )
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
                        break;
                    case 2 :
                        // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:27:5: IDENTIFIER ':' block
                        {
                        IDENTIFIER13=Token(matchStream(input,IDENTIFIER,FOLLOW_IDENTIFIER_in_property169));  
                        stream_IDENTIFIER.add(IDENTIFIER13);

                        char_literal14=Token(matchStream(input,15,FOLLOW_15_in_property171));  
                        stream_15.add(char_literal14);

                        pushFollow(FOLLOW_block_in_property173);
                        block15=block();

                        state._fsp--;

                        stream_block.add(block15.tree);


                        // AST REWRITE
                        // elements: block, IDENTIFIER
                        // token labels: 
                        // rule labels: retval
                        // token list labels: 
                        // rule list labels: 
                        retval.tree = root_0;
                        stream_retval=new RewriteRuleSubtreeStream(adaptor,"token retval",retval!=null?retval.tree:null);

                        root_0 = Object(adaptor.nil());
                        // 27:26: -> ^( TPROP_BLOCK IDENTIFIER block )
                        {
                            // C:\\eclipse_workspace\\PSWebGen\\ux\\PSUX.g:27:29: ^( TPROP_BLOCK IDENTIFIER block )
                            {
                            root_1 = Object(adaptor.nil());
                            root_1 = Object(adaptor.becomeRoot(Object(adaptor.create(TPROP_BLOCK, "TPROP_BLOCK")), root_1));

                            adaptor.addChild(root_1, stream_IDENTIFIER.nextNode());
                            adaptor.addChild(root_1, stream_block.nextTree());

                            adaptor.addChild(root_0, root_1);
                            }

                        }

                        retval.tree = root_0;retval.tree = root_0;
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
        // $ANTLR end property


           // Delegated rules


     

        public static const FOLLOW_block_in_prog61:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_IDENTIFIER_in_block82:BitSet = new BitSet([0x00002200, 0x00000000]);
        public static const FOLLOW_IDENTIFIER_in_block84:BitSet = new BitSet([0x00002000, 0x00000000]);
        public static const FOLLOW_13_in_block87:BitSet = new BitSet([0x00004200, 0x00000000]);
        public static const FOLLOW_body_in_block89:BitSet = new BitSet([0x00004000, 0x00000000]);
        public static const FOLLOW_14_in_block91:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_property_in_body117:BitSet = new BitSet([0x00000202, 0x00000000]);
        public static const FOLLOW_block_in_body120:BitSet = new BitSet([0x00000202, 0x00000000]);
        public static const FOLLOW_IDENTIFIER_in_property148:BitSet = new BitSet([0x00008000, 0x00000000]);
        public static const FOLLOW_15_in_property150:BitSet = new BitSet([0x00000200, 0x00000000]);
        public static const FOLLOW_IDENTIFIER_in_property152:BitSet = new BitSet([0x00010000, 0x00000000]);
        public static const FOLLOW_16_in_property154:BitSet = new BitSet([0x00000002, 0x00000000]);
        public static const FOLLOW_IDENTIFIER_in_property169:BitSet = new BitSet([0x00008000, 0x00000000]);
        public static const FOLLOW_15_in_property171:BitSet = new BitSet([0x00000200, 0x00000000]);
        public static const FOLLOW_block_in_property173:BitSet = new BitSet([0x00000002, 0x00000000]);

    }
}