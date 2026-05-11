.class public Main
.super java/lang/Object


.method public <init>()V
    aload_0
    invokenonvirtual java/lang/Object/<init>()V
    return
.end method

.method public static findMinIndex([III)I
    .limit stack 100
    .limit locals 100
    iload 1
    istore 3
    aload 0
    iload 1
    iaload
    istore 4
    iload 1
    ldc 1
    iadd
    istore 5
L2:
    iload 5
    iload 2
    if_icmplt L4
    iconst_0
    goto L3
L4:
    iconst_1
L3:
    ifeq L1
    aload 0
    iload 5
    iaload
    iload 4
    if_icmplt L8
    iconst_0
    goto L7
L8:
    iconst_1
L7:
    ifeq L6
    aload 0
    iload 5
    iaload
    dup
    istore 4
    pop
    iload 5
    dup
    istore 3
    pop
    goto L5
L6:
L5:
    iload 5
    ldc 1
    iadd
    dup
    istore 5
    pop
    goto L2
L1:
    iload 3
    ireturn
.end method

.method public static swap([III)V
    .limit stack 100
    .limit locals 100
    aload 0
    iload 1
    iaload
    istore 3
    aload 0
    iload 1
    aload 0
    iload 2
    iaload
    dup_x2
    iastore
    pop
    aload 0
    iload 2
    iload 3
    dup_x2
    iastore
    pop
    return
.end method

.method public static selectionSort([II)V
    .limit stack 100
    .limit locals 100
    ldc 0
    istore 2
L10:
    iload 2
    iload 1
    ldc 1
    isub
    if_icmplt L12
    iconst_0
    goto L11
L12:
    iconst_1
L11:
    ifeq L9
    aload 0
    iload 2
    iload 1
    invokestatic Main/findMinIndex([III)I
    istore 3
    aload 0
    iload 2
    iload 3
    invokestatic Main/swap([III)V
    iload 2
    ldc 1
    iadd
    dup
    istore 2
    pop
    goto L10
L9:
    return
.end method

.method public static printArray([II)V
    .limit stack 100
    .limit locals 100
    ldc 0
    istore 2
L14:
    iload 2
    iload 1
    if_icmplt L16
    iconst_0
    goto L15
L16:
    iconst_1
L15:
    ifeq L13
    getstatic java/lang/System/out Ljava/io/PrintStream;
    aload 0
    iload 2
    iaload
    invokevirtual java/io/PrintStream/println(I)V
    iload 2
    ldc 1
    iadd
    dup
    istore 2
    pop
    goto L14
L13:
    return
.end method

.method public static main()V
    .limit stack 100
    .limit locals 100
    ldc 5
    newarray int
    dup
    ldc 0
    ldc 64
    iastore
    dup
    ldc 1
    ldc 25
    iastore
    dup
    ldc 2
    ldc 12
    iastore
    dup
    ldc 3
    ldc 22
    iastore
    dup
    ldc 4
    ldc 11
    iastore
    astore 0
    ldc 5
    istore 1
    getstatic java/lang/System/out Ljava/io/PrintStream;
    ldc "Original array:"
    invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
    aload 0
    iload 1
    invokestatic Main/printArray([II)V
    aload 0
    iload 1
    invokestatic Main/selectionSort([II)V
    getstatic java/lang/System/out Ljava/io/PrintStream;
    ldc "Sorted array:"
    invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
    aload 0
    iload 1
    invokestatic Main/printArray([II)V
    return
.end method

.method public static main([Ljava/lang/String;)V
    .limit stack 100
    .limit locals 100
    invokestatic Main/main()V
    return
.end method
