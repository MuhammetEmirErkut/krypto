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
    ldc "Hello, World!"
    astore 0
    getstatic java/lang/System/out Ljava/io/PrintStream;
    aload 0
    invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
    ldc 10
    istore 1
    ldc 20
    istore 2
    iload 1
    iload 2
    iadd
    istore 3
    getstatic java/lang/System/out Ljava/io/PrintStream;
    iload 3
    invokevirtual java/io/PrintStream/println(I)V
    iload 3
    ldc 25
    if_icmpgt L4
    iconst_0
    goto L3
L4:
    iconst_1
L3:
    ifeq L2
    getstatic java/lang/System/out Ljava/io/PrintStream;
    ldc "Sum is greater than 25"
    invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
    goto L1
L2:
    getstatic java/lang/System/out Ljava/io/PrintStream;
    ldc "Sum is 25 or less"
    invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
L1:
    return
.end method

.method public static main([Ljava/lang/String;)V
    .limit stack 100
    .limit locals 100
    invokestatic Main/main()V
    return
.end method
