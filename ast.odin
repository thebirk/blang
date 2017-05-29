#import . "lexer.odin";

NodeType :: enum {
	Literal,
	BinaryOp,
	UnaryOp,
}

Node :: struct {
	type: NodeType,
	file: string,
	line, char: int,
}

LiteralType :: enum {
	Integer,
	Float,
	String,
	Ident,
	True,
	False,
}

Literal :: struct {
	using node: Node,
	ltype: LiteralType,
	i: i64,
	f: f64,
	s: string,
}

BinaryOpType :: enum {
	Add,
	Sub,
	Multiply,
	Divide,
	Modulo,
}

BinaryOp :: struct {
	using node: Node,
	op: BinaryOpType,
	lhs, rhs: ^Node,
}

UnaryOpType :: enum {
	Plus,
	Minus,
}

UnaryOp :: struct {
	using node: Node,
	op: UnaryOpType,
	rhs: ^Node,
}

// TODO(thebirk): This needs to be freed after an ast is used. Dont do it yet as we only ever load one file
global_string_pool: [dynamic]string;
strdup :: proc(s: string) -> string {
	ns := make([]byte, len(s));
	copy(ns, []byte(s));
	append(global_string_pool, string(ns));
	return string(ns);
}

set_location_from_token :: proc(n: ^Node, t: Token) {
	n.line = t.line;
	n.char = t.char;
}

make_binop :: proc() -> ^BinaryOp {
	n := new(BinaryOp);
	n.type = NodeType.BinaryOp;
	return n;
}

make_unaryop :: proc() -> ^UnaryOp {
	n := new(UnaryOp);
	n.type = NodeType.UnaryOp;
	return n;
}

make_ident_literal :: proc(t: Token) -> ^Literal {
	n := new(Literal);
	n.type = NodeType.Literal;
	n.ltype = LiteralType.Ident;
	n.s = strdup(t.lexeme);
	set_location_from_token(n, t);
	return n;
}

make_string_literal :: proc(t: Token) -> ^Literal {
	n := new(Literal);
	n.type = NodeType.Literal;
	n.ltype = LiteralType.String;
	n.s = strdup(t.lexeme);
	set_location_from_token(n, t);
	return n;
}

make_number_literal :: proc(t: Token) -> ^Literal {
	n := new(Literal);
	n.type = NodeType.Literal;
	set_location_from_token(n, t);

	number := t.(Token.Number);
	match number.ntype {
		case NumberType.Integer: {
			n.ltype = LiteralType.Integer;
			n.i = number.si;
		}
		case NumberType.Float: {
			n.ltype = LiteralType.Float;
			n.f = number.float;
		}

		case: {
			assert(false); // We should not be here!
		}
	}

	return n;
}