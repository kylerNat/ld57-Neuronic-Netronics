(memory $mem 32)
(data (i32.const 0x130000) "\01\01\01\01")
(data (i32.const 0x140000) "hello world")
(export "mem" (memory $mem))

(memory $shared_mem 1 1 shared)
(export "shared_mem" (memory $shared_mem))
