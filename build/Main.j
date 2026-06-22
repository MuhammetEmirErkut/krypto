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
    ldc "Muhammet"
    astore 0
    ldc 0
    istore 1
L2:
    iload 1
    ldc 3
    if_icmplt L4
    iconst_0
    goto L3
L4:
    iconst_1
L3:
    ifeq L1
    getstatic java/lang/System/out Ljava/io/PrintStream;
    aload 0
    invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
    iload 1
    ldc 1
    iadd
    dup
    istore 1
    pop
    goto L2
L1:
    return
.end method

.method public static main([Ljava/lang/String;)V
    .limit stack 100
    .limit locals 100
    invokestatic Main/main()V
    return
.end method
