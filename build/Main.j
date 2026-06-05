.class public Main
.super java/lang/Object


.method public <init>()V
    aload_0
    invokenonvirtual java/lang/Object/<init>()V
    return
.end method

.method public static main()V
    .limit stack 100
    .limit locals 100
    ldc 10
    istore 0
    ldc 20
    istore 1
    getstatic java/lang/System/out Ljava/io/PrintStream;
    iload 0
    iload 1
    iadd
    invokevirtual java/io/PrintStream/println(I)V
    return
.end method

.method public static main([Ljava/lang/String;)V
    .limit stack 100
    .limit locals 100
    invokestatic Main/main()V
    return
.end method
