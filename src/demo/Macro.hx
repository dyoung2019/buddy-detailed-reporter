package;

import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.ExprTools;

class Foo {
  public function new() { }
  public macro function member_func(inst_expr:Expr, val:Expr)
  {
    trace("----------> "+inst_expr.toString());
    trace("inst_expr: "+inst_expr);
    trace("typeof inst_expr: "+Context.typeof(inst_expr));
    trace("local class: "+Context.getLocalClass());
    return macro trace("Hello!");
  }
}

class Bar extends Foo {
  public function new() { super(); }
}