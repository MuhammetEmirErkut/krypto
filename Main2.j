.class public Main
.super java/lang/Object

.field public static result I

.method public <init>()V
    aload_0
    invokenonvirtual java/lang/Object/<init>()V
    return
.end method

.method public static fibonacci(I)I
    .limit stack 100
    .limit locals 100
    iload 0
    ldc 1
    if_icmple L4
    iconst_0
    goto L3
L4:
    iconst_1
L3:
    ifeq L2
    iload 0
    ireturn
    goto L1
L2:
L1:
    iload 0
    ldc 1
    isub
    invokestatic Main/fibonacci(I)I
    iload 0
    ldc 2
    isub
    invokestatic Main/fibonacci(I)I
    iadd
    ireturn
.end method

.method public static main([Ljava/lang/String;)V
    .limit stack 100
    .limit locals 100
    ldc 10
    invokestatic Main/fibonacci(I)I
    istore 1
    getstatic java/lang/System/out Ljava/io/PrintStream;
    iload 1
    invokevirtual java/io/PrintStream/println(I)V
    return
.end method
