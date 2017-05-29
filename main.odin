#import "fmt.odin";
#import . "lexer.odin";
#import . "parser.odin";
#import . "ast.odin";

// Crash: https://gist.github.com/anonymous/ecfd39c1cdeb5be41f6d7a3310fcac4d

indents := 0;
indent :: proc() {
	for i in 1..indents {
		fmt.printf("  ");
	}
}

print_expression :: proc(expr: ^Node) {
	match expr.type {
		case NodeType.BinaryOp: {
			n := ^BinaryOp(expr);
			indent();
			fmt.println(n^);
			indents++;
			print_expression(n.lhs);
			print_expression(n.rhs);
			indents--;
		}
		case NodeType.UnaryOp: {
			n := ^UnaryOp(expr);
			indent();
			fmt.println(n^);
			indents++;
			print_expression(n.rhs);
			indents--;
		}
		case NodeType.Literal: {
			n := ^Literal(expr);
			indent();
			fmt.println(n^);
		}

		case: {
			fmt.println("Unimplemented print_expression!");
		}
	}
}

#import . "sys/windows.odin";
#foreign_system_library "kernel32.lib" when ODIN_OS == "windows";
CreateThread :: proc(sec: rawptr, stack: i32, func: rawptr, par: rawptr, flags: i32, id: rawptr) -> Handle #foreign kernel32;

thread :: proc() {
	for i := 0; i < 250; i++ {
		parser := new(Parser);
		init_parser(parser, "test.b");
		expr := parse_expression(parser);
		free(parser);
		//free(global_string_pool);
		//free(parser.tokens);
		//reserve(global_string_pool, 10);
		//reserve(parser.tokens, 10);
	}
}

main :: proc() {
//	t1 := CreateThread(nil, 0, rawptr(thread), nil, 0, nil);
//	WaitForSingleObject(t1, INFINITE);

	t1 := CreateThread(nil, 0, rawptr(thread), nil, 0, nil);
	t2 := CreateThread(nil, 0, rawptr(thread), nil, 0, nil);
	t3 := CreateThread(nil, 0, rawptr(thread), nil, 0, nil);
	t4 := CreateThread(nil, 0, rawptr(thread), nil, 0, nil);

	WaitForSingleObject(t1, INFINITE);
	WaitForSingleObject(t2, INFINITE);
	WaitForSingleObject(t3, INFINITE);
	WaitForSingleObject(t4, INFINITE);


/*	parser := new(Parser);
	init_parser(parser, "test.b");

	expr := parse_expression(parser);
	//print_expression(expr);*/
}