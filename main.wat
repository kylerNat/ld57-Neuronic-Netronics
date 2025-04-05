(import "js" "mem" (memory 32))
(import "js" "shared_mem" (memory 1 1 shared))

(func $sin (import "js" "sin") (param f32) (result f32))
(func $cos (import "js" "cos") (param f32) (result f32))
(func $exp (import "js" "exp") (param f32) (result f32))
(func $f32print (import "js" "print") (param f32))
(func $i32print (import "js" "print") (param i32))
(func $draw_text (import "js" "draw_text") (param i32 i32 f32 f32))

(func $randi (result i32) (local i32)
    ;; https://nullprogram.com/blog/2018/07/31/
    i32.const 0x130000
    i32.const 0x130000 i32.load
    local.tee 0
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
    i32.xor
    local.tee 0
    i32.store
    local.get 0)

(func $randf (result f32)
      call $randi
      f32.convert_i32_u
      f32.const 0x1.000000010000000100000001p-32
      f32.mul)

(func $randf_s (result f32)
      call $randi
      f32.convert_i32_u
      f32.const 0x1.000000010000000100000001p-31
      f32.mul
      f32.const 1
      f32.sub)

(func $draw_rect (param $x f32) (param $y f32) (param $rx f32) (param $ry f32) (param $color i32)
      (local $x_min i32)
      (local $x_max i32)
      (local $y_min i32)
      (local $y_max i32)
      (local $x_min4 i32)
      (local $x_max4 i32)
      (local $iy i32)
      (local $ix i32)
      (local $bound v128)
      (local $vx v128)
      (local $ptr_base i32)
      (local $ptr i32)
      (local $color4 v128)
      (local $mask v128)

      v128.const i32x4 0 0 0 0
      local.get $x local.get $rx f32.sub f32.floor i32.trunc_sat_f32_s i32x4.replace_lane 0
      local.get $x local.get $rx f32.add f32.ceil i32.trunc_sat_f32_s  i32x4.replace_lane 1
      local.get $y local.get $ry f32.sub f32.floor i32.trunc_sat_f32_s i32x4.replace_lane 2
      local.get $y local.get $ry f32.add f32.ceil i32.trunc_sat_f32_s  i32x4.replace_lane 3

      v128.const i32x4 0 0 0 0 i32x4.max_s v128.const i32x4 639 639 479 479 i32x4.min_s
      local.tee $bound i32x4.extract_lane 0 local.set $x_min
      local.get $bound i32x4.extract_lane 1 local.set $x_max
      local.get $bound i32x4.extract_lane 2 local.set $y_min
      local.get $bound i32x4.extract_lane 3 local.set $y_max

      local.get $color i32x4.splat local.set $color4

      local.get $x_min
      local.get $x_max
      i32.lt_s
      local.get $y_min
      local.tee $iy
      local.get $y_max
      i32.lt_s
      i32.and
      if $nonzero
      (loop $y_loop
            local.get $iy
            i32.const 2560 i32.mul
            local.set $ptr_base
            local.get $x_min
            i32.const 0xFFFF_FFFC
            i32.and
            local.set $ix
            (loop $x_loop
                  local.get $ix i32x4.splat
                  v128.const i32x4 0 1 2 3 i32x4.add
                  local.tee $vx
                  local.get $x_min i32x4.splat
                  i32x4.gt_s

                  local.get $vx
                  local.get $x_max i32x4.splat
                  i32x4.le_s
                  v128.and
                  ;; v128.const i32x4 0xFF 0xFF 0xFF 0xFF
                  ;; i32x4.mul

                  local.tee $mask
                  local.get $color4
                  v128.and

                  ;; get current pixel colors
                  local.get $ptr_base
                  local.get $ix i32.const 4 i32.mul
                  i32.add
                  local.tee $ptr
                  v128.load
                  local.get $mask
                  v128.andnot
                  v128.or
                  local.set $mask

                  local.get $ptr
                  local.get $mask
                  v128.store

                  local.get $ix
                  i32.const 4 i32.add
                  local.tee $ix
                  local.get $x_max
                  i32.le_s
                  br_if $x_loop)

            local.get $iy
            i32.const 1 i32.add
            local.tee $iy
            local.get $y_max
            i32.le_s
            br_if $y_loop)
      end

      )

(func $draw_circle (param $x f32) (param $y f32) (param $r f32) (param $color i32)
      (local $x_min i32)
      (local $x_max i32)
      (local $y_min i32)
      (local $y_max i32)
      (local $iy i32)
      (local $ix i32)
      (local $bound v128)
      (local $vx v128)
      (local $vysq v128)
      (local $vx0 v128)
      (local $vy0 v128)
      (local $ptr_base i32)
      (local $ptr i32)
      (local $rsq v128)
      (local $color4 v128)
      (local $mask v128)

      local.get $x f32x4.splat local.set $vx0
      local.get $y f32x4.splat local.set $vy0

      v128.const i32x4 0 0 0 0
      local.get $x local.get $r f32.sub f32.floor i32.trunc_sat_f32_s i32x4.replace_lane 0
      local.get $x local.get $r f32.add f32.ceil i32.trunc_sat_f32_s  i32x4.replace_lane 1
      local.get $y local.get $r f32.sub f32.floor i32.trunc_sat_f32_s i32x4.replace_lane 2
      local.get $y local.get $r f32.add f32.ceil i32.trunc_sat_f32_s  i32x4.replace_lane 3

      v128.const i32x4 0 0 0 0 i32x4.max_s v128.const i32x4 639 639 479 479 i32x4.min_s
      local.tee $bound i32x4.extract_lane 0 local.set $x_min
      local.get $bound i32x4.extract_lane 1 local.set $x_max
      local.get $bound i32x4.extract_lane 2 local.set $y_min
      local.get $bound i32x4.extract_lane 3 local.set $y_max

      local.get $r local.get $r f32.mul f32x4.splat local.set $rsq

      local.get $color i32x4.splat local.set $color4

      local.get $x_min
      local.get $x_max
      i32.lt_s
      local.get $y_min
      local.tee $iy
      local.get $y_max
      i32.lt_s
      i32.and
      local.get $x_min
      i32.const 0xFFFF_FFFC
      i32.and
      local.set $x_min
      if $nonzero
      (loop $y_loop
            local.get $iy
            i32.const 2560 i32.mul
            local.set $ptr_base
            local.get $iy i32x4.splat f32x4.convert_i32x4_s
            local.get $vy0 f32x4.sub
            local.tee $vysq
            local.get $vysq
            f32x4.mul
            local.set $vysq
            local.get $x_min local.set $ix
            (loop $x_loop
                  local.get $ix i32x4.splat
                  v128.const i32x4 0 1 2 3 i32x4.add
                  f32x4.convert_i32x4_s
                  local.get $vx0 f32x4.sub
                  local.tee $vx
                  local.get $vx
                  f32x4.mul
                  local.get $vysq
                  f32x4.add
                  local.get $rsq
                  f32x4.lt

                  local.tee $mask
                  local.get $color4
                  v128.and

                  ;; get current pixel colors
                  local.get $ptr_base
                  local.get $ix i32.const 4 i32.mul
                  i32.add
                  local.tee $ptr
                  v128.load
                  local.get $mask
                  v128.andnot
                  v128.or
                  local.set $mask

                  local.get $ptr
                  local.get $mask
                  v128.store

                  local.get $ix
                  i32.const 4 i32.add
                  local.tee $ix
                  local.get $x_max
                  i32.le_s
                  br_if $x_loop)

            local.get $iy
            i32.const 1 i32.add
            local.tee $iy
            local.get $y_max
            i32.le_s
            br_if $y_loop)
      end

      )

(func $update_particles
      (local $n_particles i32)
      (local $i i32)
      (local $i4 i32)
      (local $x v128)
      (local $y v128)
      (local $dx v128)
      (local $dy v128)
      (local $p i32)
      (local $mx f32)
      (local $my f32)
      (local $rx v128)
      (local $ry v128)
      (local $rsq v128)
      i32.const 0x130FFC ;; n_particles
      i32.load
      local.set $n_particles

      i32.const 0x12c000 f32.load
      local.set $mx

      i32.const 0x12c004 f32.load
      local.set $my

      i32.const 0x12c008 i32.load
      i32.const 1 i32.and
      (if
        (then
          local.get $n_particles
          i32.const 4 i32.mul
          local.set $i4

          ;; x
          i32.const 0x131000 local.get $i4 i32.add
          local.get $mx
          f32.store

          ;; y
          i32.const 0x132000 local.get $i4 i32.add
          local.get $my
          f32.store

          ;; dx
          i32.const 0x133000 local.get $i4 i32.add
          f32.const 0
          f32.store

          ;; dy
          i32.const 0x134000 local.get $i4 i32.add
          f32.const 0
          f32.store

          local.get $n_particles
          i32.const 1 i32.add
          local.set $n_particles
          i32.const 0x130FFC ;; n_particles
          local.get $n_particles
          i32.store
          ))

      block $break
      (loop $particle_loop
            local.get $i
            i32.const 4 i32.mul
            local.set $i4

            i32.const 0x131000 local.get $i4 i32.add v128.load local.set $x
            i32.const 0x132000 local.get $i4 i32.add v128.load local.set $y
            i32.const 0x133000 local.get $i4 i32.add v128.load local.set $dx
            i32.const 0x134000 local.get $i4 i32.add v128.load local.set $dy

            local.get $i
            local.get $n_particles
            i32.ge_s
            br_if $break

            local.get $x local.get $dx f32x4.add
            local.set $x
            local.get $y local.get $dy f32x4.add
            local.set $y

            local.get $dx v128.const f32x4 0.99 0.99 0.99 0.99 f32x4.mul
            local.get $mx f32x4.splat local.get $x f32x4.sub local.tee $rx
            v128.const f32x4 0.01 0.01 0.01 0.01 f32x4.mul f32x4.add
            local.set $dx

            local.get $dy v128.const f32x4 0.99 0.99 0.99 0.99 f32x4.mul
            local.get $my f32x4.splat local.get $y f32x4.sub local.tee $ry
            v128.const f32x4 0.01 0.01 0.01 0.01 f32x4.mul f32x4.add
            local.set $dy

            ;; v128.const f32x4 -1 -1 -1 -1
            local.get $ry local.get $ry f32x4.mul
            local.get $rx local.get $rx f32x4.mul
            f32x4.add
            ;; v128.const f32x4 1 1 1 1
            ;; f32x4.max
            ;; f32x4.div
            i32x4.neg ;; wtf, I found this on accident but it's an approximation for the reciprocal
            local.set $rsq

            local.get $dx
            local.get $rx local.get $ry f32x4.sub local.get $rsq f32x4.mul f32x4.add
            local.set $dx

            local.get $dy
            local.get $rx local.get $ry f32x4.add local.get $rsq f32x4.mul f32x4.add
            local.set $dy

            i32.const 0x131000 local.get $i4 i32.add local.get $x  v128.store
            i32.const 0x132000 local.get $i4 i32.add local.get $y  v128.store
            i32.const 0x133000 local.get $i4 i32.add local.get $dx v128.store
            i32.const 0x134000 local.get $i4 i32.add local.get $dy v128.store

            local.get $x f32x4.extract_lane 0
            local.get $y f32x4.extract_lane 0
            f32.const 5
            i32.const 0xFF0000FF
            call $draw_circle

            local.get $i
            i32.const 1 i32.add
            local.get $n_particles
            i32.ge_s
            br_if $break

            local.get $x f32x4.extract_lane 1
            local.get $y f32x4.extract_lane 1
            f32.const 5
            i32.const 0xFF00FF00
            call $draw_circle

            local.get $i
            i32.const 2 i32.add
            local.get $n_particles
            i32.ge_s
            br_if $break

            local.get $x f32x4.extract_lane 2
            local.get $y f32x4.extract_lane 2
            f32.const 5
            i32.const 0xFFFF0000
            call $draw_circle

            local.get $i
            i32.const 3 i32.add
            local.get $n_particles
            i32.ge_s
            br_if $break

            local.get $x f32x4.extract_lane 3
            local.get $y f32x4.extract_lane 3
            f32.const 5
            i32.const 0xFFFFFFFF
            call $draw_circle

            ;; local.get $x
            ;; i32x4.trunc_sat_f32x4_s
            ;; v128.const i32x4 0 0 0 0 i32x4.max_s
            ;; v128.const i32x4 639 639 639 639 i32x4.min_s
            ;; local.get $y
            ;; i32x4.trunc_sat_f32x4_s
            ;; v128.const i32x4 0 0 0 0 i32x4.max_s
            ;; v128.const i32x4 479 479 479 479 i32x4.min_s
            ;; v128.const i32x4 640 640 640 640
            ;; i32x4.mul
            ;; i32x4.add
            ;; v128.const i32x4 4 4 4 4
            ;; i32x4.mul

            ;; local.tee $x ;; repurposing to be the pixel index
            ;; i32x4.extract_lane 0
            ;; i32.const 0xFFFFFFFF ;; pixel color
            ;; i32.store

            ;; local.get $i
            ;; i32.const 1 i32.add
            ;; local.get $n_particles
            ;; i32.ge_s
            ;; br_if $break

            ;; local.get $x
            ;; i32x4.extract_lane 1
            ;; i32.const 0xFFFFFFFF ;; pixel color
            ;; i32.store

            ;; local.get $i
            ;; i32.const 2 i32.add
            ;; local.get $n_particles
            ;; i32.ge_s
            ;; br_if $break

            ;; local.get $x
            ;; i32x4.extract_lane 2
            ;; i32.const 0xFFFFFFFF ;; pixel color
            ;; i32.store

            ;; local.get $i
            ;; i32.const 3 i32.add
            ;; local.get $n_particles
            ;; i32.ge_s
            ;; br_if $break

            ;; local.get $x
            ;; i32x4.extract_lane 3
            ;; i32.const 0xFFFFFFFF ;; pixel color
            ;; i32.store

            local.get $i
            i32.const 4
            i32.add
            local.tee $i
            local.get $n_particles
            i32.lt_s
            br_if $particle_loop)
      end
      )

(func $oscillator (param $x0 f32) (param $decay f32) (param $k f32) (param $address i32) (result f32)
      (local $x f32)
      (local $dx f32)

      local.get $address

      local.get $address
      i32.const 4 i32.add f32.load
      local.set $dx

      local.get $address
      f32.load
      local.tee $x

      local.get $dx
      f32.add
      local.tee $x
      f32.store

      local.get $dx

      local.get $x local.get $x0 f32.sub
      local.get $k f32.mul
      f32.sub

      local.get $decay f32.mul
      local.set $dx

      local.get $address
      i32.const 4 i32.add
      local.get $dx
      f32.store

      local.get $x)

(func $lowpass (param $x f32) (param $decay f32) (param $address i32) (result f32)
      local.get $address
      local.get $address
      f32.load
      local.get $x
      f32.sub
      local.get $decay f32.mul
      local.get $x
      f32.add
      local.tee $x
      f32.store
      local.get $x)

(func $highpass (param $x f32) (param $decay f32) (param $address i32) (result f32)
      local.get $x
      local.get $x
      local.get $decay
      local.get $address
      call $lowpass
      f32.sub)

(func $process_audio
      (local $played i32)
      (local $writ i32)
      (local $end i32)
      (local $ptr i32)
      (local $osc f32)
      (local $noise f32)
      (local $clicked i32)
      i32.const 32768 ;; played samples
      i32.atomic.load (memory 1)
      local.tee $played

      i32.const 2047 ;; how many samples we try to stay ahead-1
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

      i32.const 0x12c008 i32.load
      ;; i32.const 1 i32.and
      local.set $clicked

      ;; local.get $clicked
      ;; (if
      ;;   (then
      ;;     f32.const 0.5
      ;;     local.set $noise)
      ;;   (else
      ;;     f32.const 0
      ;;     local.set $noise))

      (loop $audio_loop
            local.get $writ
            i32.const 1 i32.add
            local.set $writ

            local.get $clicked
            (if
              (then
                call $randf_s
                f32.const 0.001 f32.mul
                local.set $noise)
              (else
                f32.const 0
                local.set $noise))

            local.get $noise

            f32.const 0.9995 f32.const 0.01 i32.const 0x12F004 call $oscillator

            ;; local.get $noise
            ;; f32.const 0.9998 f32.const 0.02 i32.const 0x13000c call $oscillator

            local.get $noise
            f32.const 0.9997 f32.const 0.01618 i32.const 0x13000c call $oscillator

            ;; f32.const 0.25 f32.mul
            ;; f32.add
            ;; f32.const 0.25 f32.mul
            f32.add

            f32.const 0
            local.set $noise

            ;; f32.const 0.9999 f32.const 0.002 i32.const 0x13000c call $oscillator
            ;; f32.const 0.9999 f32.const 0.003.0 i32.const 0x13000c call $oscillator

            ;; f32.const 0.01 i32.const 0x13002c call $lowpass
            ;; f32.const 0.01 i32.const 0x13003c call $lowpass
            ;; f32.const 0.01 i32.const 0x130028 call $highpass

            local.set $osc

            local.get $ptr i32.const 4 i32.add
            i32.const 32767 i32.and
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
    )

(func $saw (param f32) (result f32)
      local.get 0
      local.get 0
      f32.floor
      f32.sub)

(func $lerp (param f32 f32 f32) (result f32)
      f32.const 1
      local.get 2
      f32.sub
      local.get 0
      f32.mul
      local.get 1
      local.get 2
      f32.mul
      f32.add)

(func (export "update")
      (local $i i32)
      (local $x i32)
      (local $y i32)
      (local $r f32)
      (local $offset_x f32)
      (local $offset_y f32)

      ;; i32.const 0x12c008 i32.load
      ;; (if (then
      ;;       i32.const 0x12c000 f32.load
      ;;       f32.neg
      ;;       local.set $offset_x

      ;;       i32.const 0x12c004 f32.load
      ;;       f32.neg
      ;;       local.set $offset_y))

      (loop $i_loop
            local.get $i
            i32.const 640
            i32.rem_u
            local.set $x

            local.get $i
            i32.const 640
            i32.div_u
            local.set $y

            ;; get the pixel address
            local.get $i
            i32.const 4
            i32.mul

            local.get $x
            f32.convert_i32_s
            local.get $offset_x
            f32.add
            f32.const 0.01 f32.mul
            call $saw
            f32.const 0x1FE f32.mul
            f32.const 0.1 f32.mul
            i32.trunc_f32_s
            i32.const 0xFF i32.and

            local.get $y
            f32.convert_i32_s
            local.get $offset_y
            f32.add
            f32.const 0.01 f32.mul
            call $saw
            f32.const 0x1FE0000 f32.mul
            f32.const 0.1 f32.mul
            i32.trunc_f32_s
            i32.const 0xFF0000 i32.and
            i32.or

            i32.const 0xFF000000
            i32.or

            ;;motion blur
            ;; local.get $i
            ;; i32.const 4
            ;; i32.mul
            ;; i32.load
            ;; i32.const 0xfefefefe i32.and
            ;; i32.const 1
            ;; i32.shr_u
            ;; i32.or

            i32.store

            local.get $i
            i32.const 1
            i32.add
            local.tee $i
            i32.const 307200
            i32.lt_s
            br_if $i_loop)

      i32.const 0x0014_0000
      i32.const 11
      i32.const 0x12c000 f32.load
      i32.const 0x12c004 f32.load
      call $draw_text

      call $update_particles
      call $process_audio
      )
