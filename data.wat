(memory $mem 1)
(data (i32.const 0) "\00\00\00\00\00\00\00\00")
(export "mem" (memory $mem))

(memory $shared_mem 1 1 shared)
(export "shared_mem" (memory $shared_mem))
