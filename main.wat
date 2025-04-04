(import "js" "mem" (memory 1))
(import "js" "shared_mem" (memory 1 1 shared))

(func $gl_clearColor (import "gl" "clearColor") (param f32 f32 f32 f32))
(func $gl_clear (import "gl" "clear") (param i32))

(func $sin (import "js" "sin") (param f32) (result f32))
(func $cos (import "js" "cos") (param f32) (result f32))

(func $process_audio (local $played i32) (local $writ i32) (local $end i32) (local $ptr i32) (local $osc f32) (local $phase f32)
       i32.const 32768 ;; played samples
       i32.atomic.load (memory 1)
       local.tee $played

       i32.const 1023 ;; how many samples we try to stay ahead
       i32.add
       local.set $end

       i32.const 32772 ;; written samples
       i32.load (memory 1)
       local.tee $writ

       local.get $played
       i32.lt_u
       (if (result i32)
         (then
           local.get $played
           local.tee $writ)
         (else
           local.get $writ))

       i32.const 8191 i32.and
       i32.const 4 i32.mul
       local.set $ptr

       i32.const 8
       f32.load
       local.set $phase

       (loop $audio_loop
             (; f32.const 8 f32.load ;)
             local.get $writ
             i32.const 1 i32.add
             local.set $writ

             local.get $phase
             i32.const 4 f32.load
             call $sin
             f32.const 1 f32.add
             f32.const 0.5 f32.mul
             (; local.tee $osc local.get $osc f32.mul ;)
             (; local.tee $osc local.get $osc f32.mul ;)
             f32.const 0.25 f32.mul
             f32.add
             local.tee $phase
             call $sin
             local.set $osc

             local.get $ptr
             i32.const 4
             i32.add
             i32.const 32767
             i32.and
             local.tee $ptr
             local.get $osc
             f32.store (memory 1)

             local.get $writ
             local.get $end
             i32.lt_u
             br_if $audio_loop)

       i32.const 32772 ;; written samples
       local.get $writ
       i32.store (memory 1)

       i32.const 8
       local.get $phase
       f32.store
       )

(func (export "update") (local f32 i32 f32) (local $vtemp v128)
      i32.const 4 f32.load
      f32.const 0.01 f32.add
      local.tee 0
      i32.const 4 local.get 0 f32.store

      call $sin
      f32.const 1.0 f32.add
      f32.const 0.2 f32.mul
      local.tee 0 local.get 0
      f32.mul
      local.tee 2

      i32.const 0 f32.load
      f32.add
      local.tee 0
      i32.const 0 local.get 0 f32.store

      f32x4.splat
      v128.const f32x4 0 2.094 4.188 0
      f32x4.add

      local.tee $vtemp
      f32x4.extract_lane 0
      call $sin f32.const 0.1 f32.mul f32.const 0.5 f32.add

      local.get $vtemp
      f32x4.extract_lane 1
      call $sin f32.const 0.1 f32.mul f32.const 0.5 f32.add

      local.get $vtemp
      f32x4.extract_lane 2
      call $sin f32.const 0.1 f32.mul f32.const 0.5 f32.add

      f32.const 1
      call $gl_clearColor
      i32.const 0x00004000 ;;CLEAR_BUFFER_BIT
      call $gl_clear

      call $process_audio
      )
