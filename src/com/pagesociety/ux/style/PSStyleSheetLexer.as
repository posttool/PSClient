// $ANTLR 3.1 C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g 2008-10-02 16:58:58
package com.pagesociety.ux.style{
    import org.antlr.runtime.*;
        

    public class PSStyleSheetLexer extends Lexer {
        public static const TPROP_SIMPLE:int=7;
        public static const TSTYLE:int=5;
        public static const WS:int=12;
        public static const T__16:int=16;
        public static const T__15:int=15;
        public static const LINE_COMMENT:int=11;
        public static const T__14:int=14;
        public static const T__13:int=13;
        public static const IDENTIFIER:int=9;
        public static const TBODY:int=6;
        public static const TROOT:int=4;
        public static const TPROP_BLOCK:int=8;
        public static const COMMENT:int=10;
        public static const EOF:int=-1;

        // delegates
        // delegators

        public function PSStyleSheetLexer(input:CharStream = null, state:RecognizerSharedState = null) {
            super(input, state);

            dfa6 = new DFA(this, 6,
                        "1:1: Tokens : ( T__13 | T__14 | T__15 | T__16 | IDENTIFIER | COMMENT | LINE_COMMENT | WS );",
                        DFA6_eot, DFA6_eof, DFA6_min,
                        DFA6_max, DFA6_accept, DFA6_special,
                        DFA6_transition);


        }
        public override function get grammarFileName():String { return "C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g"; }

        // $ANTLR start T__13
        public final function mT__13():void {
            try {
                var _type:int = T__13;
                var _channel:int = DEFAULT_TOKEN_CHANNEL;
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:7:7: ( '{' )
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:7:9: '{'
                {
                match(123); 

                }

                this.state.type = _type;
                this.state.channel = _channel;
            }
            finally {
            }
        }
        // $ANTLR end T__13

        // $ANTLR start T__14
        public final function mT__14():void {
            try {
                var _type:int = T__14;
                var _channel:int = DEFAULT_TOKEN_CHANNEL;
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:8:7: ( '}' )
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:8:9: '}'
                {
                match(125); 

                }

                this.state.type = _type;
                this.state.channel = _channel;
            }
            finally {
            }
        }
        // $ANTLR end T__14

        // $ANTLR start T__15
        public final function mT__15():void {
            try {
                var _type:int = T__15;
                var _channel:int = DEFAULT_TOKEN_CHANNEL;
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:9:7: ( ':' )
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:9:9: ':'
                {
                match(58); 

                }

                this.state.type = _type;
                this.state.channel = _channel;
            }
            finally {
            }
        }
        // $ANTLR end T__15

        // $ANTLR start T__16
        public final function mT__16():void {
            try {
                var _type:int = T__16;
                var _channel:int = DEFAULT_TOKEN_CHANNEL;
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:10:7: ( ';' )
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:10:9: ';'
                {
                match(59); 

                }

                this.state.type = _type;
                this.state.channel = _channel;
            }
            finally {
            }
        }
        // $ANTLR end T__16

        // $ANTLR start IDENTIFIER
        public final function mIDENTIFIER():void {
            try {
                var _type:int = IDENTIFIER;
                var _channel:int = DEFAULT_TOKEN_CHANNEL;
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:36:3: ( ( '#' | 'a' .. 'z' | 'A' .. 'Z' | '.' | '_' | '0' .. '9' )+ )
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:36:7: ( '#' | 'a' .. 'z' | 'A' .. 'Z' | '.' | '_' | '0' .. '9' )+
                {
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:36:7: ( '#' | 'a' .. 'z' | 'A' .. 'Z' | '.' | '_' | '0' .. '9' )+
                var cnt1:int=0;
                loop1:
                do {
                    var alt1:int=2;
                    var LA1_0:int = input.LA(1);

                    if ( (LA1_0==35||LA1_0==46||(LA1_0>=48 && LA1_0<=57)||(LA1_0>=65 && LA1_0<=90)||LA1_0==95||(LA1_0>=97 && LA1_0<=122)) ) {
                        alt1=1;
                    }


                    switch (alt1) {
                	case 1 :
                	    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:
                	    {
                	    if ( input.LA(1)==35||input.LA(1)==46||(input.LA(1)>=48 && input.LA(1)<=57)||(input.LA(1)>=65 && input.LA(1)<=90)||input.LA(1)==95||(input.LA(1)>=97 && input.LA(1)<=122) ) {
                	        input.consume();

                	    }
                	    else {
                	        throw recover(new MismatchedSetException(null,input));
                	    }


                	    }
                	    break;

                	default :
                	    if ( cnt1 >= 1 ) break loop1;
                            throw new EarlyExitException(1, input);

                    }
                    cnt1++;
                } while (true);


                }

                this.state.type = _type;
                this.state.channel = _channel;
            }
            finally {
            }
        }
        // $ANTLR end IDENTIFIER

        // $ANTLR start COMMENT
        public final function mCOMMENT():void {
            try {
                var _type:int = COMMENT;
                var _channel:int = DEFAULT_TOKEN_CHANNEL;
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:39:3: ( '/*' ( options {greedy=false; } : . )* '*/' )
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:39:7: '/*' ( options {greedy=false; } : . )* '*/'
                {
                matchString("/*"); 

                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:39:12: ( options {greedy=false; } : . )*
                loop2:
                do {
                    var alt2:int=2;
                    var LA2_0:int = input.LA(1);

                    if ( (LA2_0==42) ) {
                        var LA2_1:int = input.LA(2);

                        if ( (LA2_1==47) ) {
                            alt2=2;
                        }
                        else if ( ((LA2_1>=0 && LA2_1<=46)||(LA2_1>=48 && LA2_1<=65534)) ) {
                            alt2=1;
                        }


                    }
                    else if ( ((LA2_0>=0 && LA2_0<=41)||(LA2_0>=43 && LA2_0<=65534)) ) {
                        alt2=1;
                    }


                    switch (alt2) {
                	case 1 :
                	    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:39:40: .
                	    {
                	    matchAny(); 

                	    }
                	    break;

                	default :
                	    break loop2;
                    }
                } while (true);

                matchString("*/"); 

                _channel=HIDDEN;

                }

                this.state.type = _type;
                this.state.channel = _channel;
            }
            finally {
            }
        }
        // $ANTLR end COMMENT

        // $ANTLR start LINE_COMMENT
        public final function mLINE_COMMENT():void {
            try {
                var _type:int = LINE_COMMENT;
                var _channel:int = DEFAULT_TOKEN_CHANNEL;
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:42:3: ( '//' (~ ( '\\n' | '\\r' ) )* ( '\\r' )? '\\n' )
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:42:5: '//' (~ ( '\\n' | '\\r' ) )* ( '\\r' )? '\\n'
                {
                matchString("//"); 

                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:42:10: (~ ( '\\n' | '\\r' ) )*
                loop3:
                do {
                    var alt3:int=2;
                    var LA3_0:int = input.LA(1);

                    if ( ((LA3_0>=0 && LA3_0<=9)||(LA3_0>=11 && LA3_0<=12)||(LA3_0>=14 && LA3_0<=65534)) ) {
                        alt3=1;
                    }


                    switch (alt3) {
                	case 1 :
                	    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:42:10: ~ ( '\\n' | '\\r' )
                	    {
                	    if ( (input.LA(1)>=0 && input.LA(1)<=9)||(input.LA(1)>=11 && input.LA(1)<=12)||(input.LA(1)>=14 && input.LA(1)<=65534) ) {
                	        input.consume();

                	    }
                	    else {
                	        throw recover(new MismatchedSetException(null,input));
                	    }


                	    }
                	    break;

                	default :
                	    break loop3;
                    }
                } while (true);

                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:42:24: ( '\\r' )?
                var alt4:int=2;
                var LA4_0:int = input.LA(1);

                if ( (LA4_0==13) ) {
                    alt4=1;
                }
                switch (alt4) {
                    case 1 :
                        // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:42:24: '\\r'
                        {
                        match(13); 

                        }
                        break;

                }

                match(10); 
                _channel=HIDDEN;

                }

                this.state.type = _type;
                this.state.channel = _channel;
            }
            finally {
            }
        }
        // $ANTLR end LINE_COMMENT

        // $ANTLR start WS
        public final function mWS():void {
            try {
                var _type:int = WS;
                var _channel:int = DEFAULT_TOKEN_CHANNEL;
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:45:3: ( ( ' ' | '\\t' | '\\r' | '\\n' )+ )
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:45:7: ( ' ' | '\\t' | '\\r' | '\\n' )+
                {
                // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:45:7: ( ' ' | '\\t' | '\\r' | '\\n' )+
                var cnt5:int=0;
                loop5:
                do {
                    var alt5:int=2;
                    var LA5_0:int = input.LA(1);

                    if ( ((LA5_0>=9 && LA5_0<=10)||LA5_0==13||LA5_0==32) ) {
                        alt5=1;
                    }


                    switch (alt5) {
                	case 1 :
                	    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:
                	    {
                	    if ( (input.LA(1)>=9 && input.LA(1)<=10)||input.LA(1)==13||input.LA(1)==32 ) {
                	        input.consume();

                	    }
                	    else {
                	        throw recover(new MismatchedSetException(null,input));
                	    }


                	    }
                	    break;

                	default :
                	    if ( cnt5 >= 1 ) break loop5;
                            throw new EarlyExitException(5, input);

                    }
                    cnt5++;
                } while (true);

                 _channel=HIDDEN; 

                }

                this.state.type = _type;
                this.state.channel = _channel;
            }
            finally {
            }
        }
        // $ANTLR end WS

        public override function mTokens():void {
            // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:1:8: ( T__13 | T__14 | T__15 | T__16 | IDENTIFIER | COMMENT | LINE_COMMENT | WS )
            var alt6:int=8;
            alt6 = dfa6.predict(input);
            switch (alt6) {
                case 1 :
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:1:10: T__13
                    {
                    mT__13(); 

                    }
                    break;
                case 2 :
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:1:16: T__14
                    {
                    mT__14(); 

                    }
                    break;
                case 3 :
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:1:22: T__15
                    {
                    mT__15(); 

                    }
                    break;
                case 4 :
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:1:28: T__16
                    {
                    mT__16(); 

                    }
                    break;
                case 5 :
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:1:34: IDENTIFIER
                    {
                    mIDENTIFIER(); 

                    }
                    break;
                case 6 :
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:1:45: COMMENT
                    {
                    mCOMMENT(); 

                    }
                    break;
                case 7 :
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:1:53: LINE_COMMENT
                    {
                    mLINE_COMMENT(); 

                    }
                    break;
                case 8 :
                    // C:\\eclipse_workspace\\PSWebGen\\ux\\PSStyleSheet.g:1:66: WS
                    {
                    mWS(); 

                    }
                    break;

            }

        }



        private const DFA6_eot:Array =
            DFA.unpackEncodedString("\x0a\u80ff\xff");
        private const DFA6_eof:Array =
            DFA.unpackEncodedString("\x0a\u80ff\xff");
        private const DFA6_min:Array =
            DFA.unpackEncodedString("\x01\x09\x05\u80ff\xff\x01\x2a\x03"+
            "\u80ff\xff", true);
        private const DFA6_max:Array =
            DFA.unpackEncodedString("\x01\x7d\x05\u80ff\xff\x01\x2f\x03"+
            "\u80ff\xff", true);
        private const DFA6_accept:Array =
            DFA.unpackEncodedString("\x01\u80ff\xff\x01\x01\x01\x02\x01"+
            "\x03\x01\x04\x01\x05\x01\u80ff\xff\x01\x08\x01\x06\x01\x07");
        private const DFA6_special:Array =
            DFA.unpackEncodedString("\x0a\u80ff\xff");
        private const DFA6_transition:Array = [
                DFA.unpackEncodedString("\x02\x07\x02\u80ff\xff\x01\x07"+
                "\x12\u80ff\xff\x01\x07\x02\u80ff\xff\x01\x05\x0a\u80ff\xff"+
                "\x01\x05\x01\x06\x0a\x05\x01\x03\x01\x04\x05\u80ff\xff\x1a"+
                "\x05\x04\u80ff\xff\x01\x05\x01\u80ff\xff\x1a\x05\x01\x01"+
                "\x01\u80ff\xff\x01\x02"),
                DFA.unpackEncodedString(""),
                DFA.unpackEncodedString(""),
                DFA.unpackEncodedString(""),
                DFA.unpackEncodedString(""),
                DFA.unpackEncodedString(""),
                DFA.unpackEncodedString("\x01\x08\x04\u80ff\xff\x01\x09"),
                DFA.unpackEncodedString(""),
                DFA.unpackEncodedString(""),
                DFA.unpackEncodedString("")
        ];
        protected var dfa6:DFA;  // initialized in constructor
     

    }
}