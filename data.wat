(memory $mem 25)
(data (i32.const 0x130000) "\01\01\01\01\02\02\02\02\03\03\03\03\04\04\04\04")
(data (i32.const 0x155000) "Thanks for playing!Made by Kyler Natividad in 48 hours for Ludum Dare 57(ps. wishlist Primordialis on steam)")
(export "mem" (memory $mem))

(memory $shared_mem 1 1 shared)
(export "shared_mem" (memory $shared_mem))

(func $hashi (param i32) (result i32)
    ;; https://nullprogram.com/blog/2018/07/31/
    local.get 0
    local.get 0
    i32.const 16
    i32.shr_u
    i32.xor

    i32.const 0x7feb352d
    i32.mul

    local.tee 0
    local.get 0
    i32.const 15
    i32.shr_u
    i32.xor

    i32.const 0x846ca68b
    i32.mul

    local.tee 0
    local.get 0
    i32.const 16
    i32.shr_u
    i32.xor)

(func $init
      (local $i i32)

      (loop $l
            i32.const 0x130800
            local.get $i
            i32.const 4 i32.mul
            i32.add

            local.get $i
            call $hashi
            f32.convert_i32_u
            f32.const 0x1.000000010000000100000001p-32
            f32.mul
            f32.store

            local.get $i
            i32.const 1 i32.add
            local.tee $i
            i32.const 1024
            i32.lt_s
            br_if $l)
      )

(start $init)
