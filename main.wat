(import "js" "mem" (memory 25))
(import "js" "shared_mem" (memory 1 1 shared))

(func $sin (import "js" "sin") (param f32) (result f32))
(func $cos (import "js" "cos") (param f32) (result f32))
(func $exp (import "js" "exp") (param f32) (result f32))
(func $f32print (import "js" "print") (param f32))
(func $i32print (import "js" "print") (param i32))
(func $f32draw (import "js" "draw_number") (param f32 f32 f32))
(func $i32draw (import "js" "draw_number") (param i32 f32 f32))
(func $draw_text (import "js" "draw_text") (param i32 i32 f32 f32))
(func $save_data (import "js" "save_data") (param i32 i32))
(func $load_data (import "js" "load_data") (param i32) (result i32))
(func $load_saved_level (import "js" "load_saved_level"))

(func $serialize_stats (result i32)
      (local $ptr i32)

      i32.const 0x170000 local.set $ptr

      local.get $ptr
      i32.const 0x0133004
      i32.load
      i32.store
      local.get $ptr
      i32.const 4 i32.add
      local.set $ptr

      local.get $ptr
      i32.const 0x0134004
      i32.load
      i32.store
      local.get $ptr
      i32.const 4 i32.add
      local.set $ptr

      local.get $ptr
      i32.const 0x170000
      i32.sub
      )

(func $deserialize_stats
      (local $ptr i32)

      i32.const 0x170000 local.set $ptr

      i32.const 0x0133004
      local.get $ptr
      i32.load
      i32.store
      local.get $ptr
      i32.const 4 i32.add
      local.set $ptr

      i32.const 0x0134004
      local.get $ptr
      i32.load
      i32.store
      local.get $ptr
      i32.const 4 i32.add
      local.set $ptr
      )

(func $load_stats
      i32.const 0
      call $load_data
      (if (then
            call $deserialize_stats))
      )

(func $serialize_solution (result i32)
      (local $ptr i32)
      (local $n_nodes i32)
      (local $n_links i32)
      (local $i i32)
      (local $i4 i32)

      i32.const 0x170000 local.set $ptr

      i32.const 0x132000 i32.load local.set $n_nodes
      i32.const 0x132010 i32.load local.set $n_links

      local.get $ptr
      local.get $n_nodes
      i32.store
      local.get $ptr
      i32.const 4 i32.add
      local.set $ptr

      local.get $n_nodes
      i32.eqz
      if $node_if
      else
      (loop $node_loop
            local.get $i
            i32.const 4
            i32.mul
            local.set $i4

            local.get $ptr
            i32.const 0x146000 local.get $i4 i32.add i32.load
            i32.store
            local.get $ptr
            i32.const 4 i32.add
            local.set $ptr

            local.get $ptr
            i32.const 0x140000 local.get $i4 i32.add f32.load
            f32.store
            local.get $ptr
            i32.const 4 i32.add
            local.set $ptr

            local.get $ptr
            i32.const 0x141000 local.get $i4 i32.add f32.load
            f32.store
            local.get $ptr
            i32.const 4 i32.add
            local.set $ptr

            local.get $i
            i32.const 1
            i32.add
            local.tee $i
            local.get $n_nodes
            i32.lt_s
            br_if $node_loop)
      end ;; node_if

      local.get $ptr
      local.get $n_links
      i32.store
      local.get $ptr
      i32.const 4 i32.add
      local.set $ptr

      i32.const 0 local.set $i
      local.get $n_links
      i32.eqz
      if $link_if
      else
      (loop $link_loop
            local.get $i
            i32.const 4
            i32.mul
            local.set $i4

            local.get $ptr
            i32.const 0x160000 local.get $i4 i32.add i32.load
            i32.store
            local.get $ptr
            i32.const 4 i32.add
            local.set $ptr

            local.get $ptr
            i32.const 0x161000 local.get $i4 i32.add i32.load
            i32.store
            local.get $ptr
            i32.const 4 i32.add local.set $ptr

            local.get $ptr
            i32.const 0x162000 local.get $i4 i32.add f32.load
            f32.store
            local.get $ptr
            i32.const 4 i32.add local.set $ptr

            local.get $i
            i32.const 1
            i32.add
            local.tee $i
            local.get $n_links
            i32.lt_s
            br_if $link_loop)
      end ;; node_if
      local.get $ptr
      i32.const 0x170000
      i32.sub
      )

(func $deserialize_solution
      (local $ptr i32)
      (local $n_nodes i32)
      (local $n_links i32)
      (local $i i32)
      (local $i4 i32)
      (local $type i32)

      i32.const 0x170000 local.set $ptr

      local.get $ptr
      i32.load
      local.set $n_nodes
      local.get $ptr
      i32.const 4 i32.add
      local.set $ptr

      i32.const 0x132000 local.get $n_nodes i32.store

      local.get $n_nodes
      i32.eqz
      if $node_if
      else
      (loop $node_loop
            local.get $i
            i32.const 4
            i32.mul
            local.set $i4

            i32.const 0x146000 local.get $i4 i32.add
            local.get $ptr
            i32.load
            local.tee $type
            i32.store
            local.get $ptr
            i32.const 4 i32.add
            local.set $ptr

            ;; local.get $type i32.eqz
            i32.const 1
            (if
              (then
                i32.const 0x140000 local.get $i4 i32.add
                local.get $ptr
                f32.load
                f32.store
                local.get $ptr
                i32.const 4 i32.add
                local.set $ptr

                i32.const 0x141000 local.get $i4 i32.add
                local.get $ptr
                f32.load
                f32.store
                local.get $ptr
                i32.const 4 i32.add
                local.set $ptr

                i32.const 0x142000 local.get $i4 i32.add f32.const 0 f32.store
                i32.const 0x143000 local.get $i4 i32.add f32.const 0 f32.store
                i32.const 0x144000 local.get $i4 i32.add f32.const 5 f32.store
                i32.const 0x145000 local.get $i4 i32.add f32.const 0 f32.store
                i32.const 0x147000 local.get $i4 i32.add f32.const 0 f32.store
                i32.const 0x148000 local.get $i4 i32.add f32.const 0 f32.store
                i32.const 0x149000 local.get $i4 i32.add f32.const 0 f32.store
                )
              (else
                local.get $ptr
                i32.const 8 i32.add
                local.set $ptr))

            local.get $i
            i32.const 1
            i32.add
            local.tee $i
            local.get $n_nodes
            i32.lt_s
            br_if $node_loop)
      end ;; node_if

      local.get $ptr
      i32.load
      local.set $n_links
      local.get $ptr
      i32.const 4 i32.add
      local.set $ptr

      i32.const 0x132010 local.get $n_links i32.store

      i32.const 0 local.set $i
      local.get $n_links
      i32.eqz
      if $link_if
      else
      (loop $link_loop
            local.get $i
            i32.const 4
            i32.mul
            local.set $i4


            i32.const 0x160000 local.get $i4 i32.add
            local.get $ptr
            i32.load
            i32.store
            local.get $ptr
            i32.const 4 i32.add
            local.set $ptr

            i32.const 0x161000 local.get $i4 i32.add
            local.get $ptr
            i32.load
            i32.store
            local.get $ptr
            i32.const 4 i32.add local.set $ptr

            i32.const 0x162000 local.get $i4 i32.add
            local.get $ptr
            f32.load
            f32.store
            local.get $ptr
            i32.const 4 i32.add local.set $ptr

            i32.const 0x163000 local.get $i4 i32.add f32.const 0.0 f32.store
            i32.const 0x164000 local.get $i4 i32.add f32.const 0.0 f32.store
            i32.const 0x165000 local.get $i4 i32.add f32.const 0.0 f32.store

            local.get $i
            i32.const 1
            i32.add
            local.tee $i
            local.get $n_links
            i32.lt_s
            br_if $link_loop)
      end ;; link_if
      )

(func $hash2d (param $x i32) (param $y i32) (result f32)
      local.get $x
      local.get $y
      i32.const 1618 i32.mul
      i32.add
      i32.const 1023 i32.and
      i32.const 4 i32.mul
      i32.const 0x130800 i32.add
      f32.load)

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

(func $randi (result i32) (local i32)
    ;; https://nullprogram.com/blog/2018/07/31/
    i32.const 0x12d000
    i32.const 0x12d000 i32.load
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

(func $randi32x4 (result v128) (local v128)
    ;; https://nullprogram.com/blog/2018/07/31/
    i32.const 0x12d000
    i32.const 0x12d000 v128.load
    local.tee 0
    local.get 0
    i32.const 16
    i32x4.shr_u
    v128.xor

    v128.const i32x4 0x7feb352d 0x7feb352d 0x7feb352d 0x7feb352d
    i32x4.mul

    local.tee 0
    local.get 0
    i32.const 15
    i32x4.shr_u
    v128.xor

    v128.const i32x4 0x846ca68b 0x846ca68b 0x846ca68b 0x846ca68b
    i32x4.mul

    local.tee 0
    local.get 0
    i32.const 16
    i32x4.shr_u
    v128.xor
    local.tee 0
    v128.store
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

(func $draw_arrow (param $x f32) (param $y f32) (param $rx f32) (param $ry f32) (param $dir f32) (param $color i32)
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
      (local $vy v128)
      (local $vy0 v128)
      (local $vx0 v128)
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

      local.get $y f32x4.splat i32x4.trunc_sat_f32x4_s local.set $vy0
      local.get $x local.get $rx local.get $dir f32.mul f32.add f32x4.splat i32x4.trunc_sat_f32x4_s local.set $vx0

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

            local.get $iy i32x4.splat
            local.get $vy0 i32x4.sub
            i32x4.abs
            local.set $vy

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

                  local.get $vy
                  local.get $vx
                  local.get $vx0
                  i32x4.sub
                  i32x4.abs
                  i32x4.lt_s
                  v128.and

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

(func $draw_arrow_horizontal (param $x f32) (param $y f32) (param $rx f32) (param $ry f32) (param $color i32)
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
      (local $vy v128)
      (local $vy0 v128)
      (local $vx0 v128)
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

      local.get $y local.get $ry f32.add f32x4.splat i32x4.trunc_sat_f32x4_s local.set $vy0
      local.get $x f32x4.splat i32x4.trunc_sat_f32x4_s local.set $vx0

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

            local.get $iy i32x4.splat
            local.get $vy0 i32x4.sub
            i32x4.abs
            local.set $vy

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

                  local.get $vx
                  local.get $vx0
                  i32x4.sub
                  i32x4.abs
                  local.get $vy
                  i32x4.lt_s
                  v128.and

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

(func $draw_circle_screenspace (param $x f32) (param $y f32) (param $r f32) (param $color i32)
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
      (local $scale f32)

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
                  ;; call $randf_s
                  ;; f32.const 100.0 f32.mul
                  ;; f32x4.splat
                  ;; f32x4.add
                  local.get $rsq

                  ;; v128.const i32x4 0 0 0 0
                  ;; call $randf f32x4.replace_lane 0
                  ;; call $randf f32x4.replace_lane 1
                  ;; call $randf f32x4.replace_lane 2
                  ;; call $randf f32x4.replace_lane 3
                  ;; v128.const f32x4 0.5 0.5 0.5 0.5 f32x4.mul
                  ;; v128.const f32x4 0.5 0.5 0.5 0.5 f32x4.add
                  ;; f32x4.mul

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
      (local $scale f32)

      i32.const 0x130810 f32.load local.set $scale
      local.get $x i32.const 0x130808 f32.load f32.add local.get $scale f32.mul local.set $x
      local.get $y i32.const 0x13080c f32.load f32.add local.get $scale f32.mul local.set $y
      local.get $r local.get $scale f32.mul local.set $r

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
                  ;; call $randf_s
                  ;; f32.const 100.0 f32.mul
                  ;; f32x4.splat
                  ;; f32x4.add
                  local.get $rsq

                  ;; v128.const i32x4 0 0 0 0
                  ;; call $randf f32x4.replace_lane 0
                  ;; call $randf f32x4.replace_lane 1
                  ;; call $randf f32x4.replace_lane 2
                  ;; call $randf f32x4.replace_lane 3
                  ;; v128.const f32x4 0.5 0.5 0.5 0.5 f32x4.mul
                  ;; v128.const f32x4 0.5 0.5 0.5 0.5 f32x4.add
                  ;; f32x4.mul

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

(func $draw_ring_screenspace (param $x f32) (param $y f32) (param $ro f32) (param $ri f32) (param $color i32)
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
      (local $rosq v128)
      (local $risq v128)
      (local $dsq v128)
      (local $color4 v128)
      (local $mask v128)
      (local $scale f32)

      local.get $ro local.get $ri f32.lt
      (if (then
            local.get $ro local.set $scale
            local.get $ri local.set $ro
            local.get $scale local.set $ri))

      local.get $x f32x4.splat local.set $vx0
      local.get $y f32x4.splat local.set $vy0

      v128.const i32x4 0 0 0 0
      local.get $x local.get $ro f32.sub f32.floor i32.trunc_sat_f32_s i32x4.replace_lane 0
      local.get $x local.get $ro f32.add f32.ceil i32.trunc_sat_f32_s  i32x4.replace_lane 1
      local.get $y local.get $ro f32.sub f32.floor i32.trunc_sat_f32_s i32x4.replace_lane 2
      local.get $y local.get $ro f32.add f32.ceil i32.trunc_sat_f32_s  i32x4.replace_lane 3

      v128.const i32x4 0 0 0 0 i32x4.max_s v128.const i32x4 639 639 479 479 i32x4.min_s
      local.tee $bound i32x4.extract_lane 0 local.set $x_min
      local.get $bound i32x4.extract_lane 1 local.set $x_max
      local.get $bound i32x4.extract_lane 2 local.set $y_min
      local.get $bound i32x4.extract_lane 3 local.set $y_max

      local.get $ro local.get $ro f32.mul f32x4.splat local.set $rosq
      local.get $ri local.get $ri f32.mul f32x4.splat local.set $risq

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
                  local.tee $dsq
                  local.get $rosq
                  f32x4.lt

                  local.get $dsq
                  local.get $risq
                  f32x4.gt
                  v128.and

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

(func $draw_ring (param $x f32) (param $y f32) (param $ro f32) (param $ri f32) (param $color i32)
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
      (local $rosq v128)
      (local $risq v128)
      (local $dsq v128)
      (local $color4 v128)
      (local $mask v128)
      (local $scale f32)

      local.get $ro local.get $ri f32.lt
      (if (then
            local.get $ro local.set $scale
            local.get $ri local.set $ro
            local.get $scale local.set $ri))

      i32.const 0x130810 f32.load local.set $scale
      local.get $x i32.const 0x130808 f32.load f32.add local.get $scale f32.mul local.set $x
      local.get $y i32.const 0x13080c f32.load f32.add local.get $scale f32.mul local.set $y
      local.get $ri local.get $scale f32.mul local.set $ri
      local.get $ro local.get $scale f32.mul local.set $ro

      local.get $x f32x4.splat local.set $vx0
      local.get $y f32x4.splat local.set $vy0

      v128.const i32x4 0 0 0 0
      local.get $x local.get $ro f32.sub f32.floor i32.trunc_sat_f32_s i32x4.replace_lane 0
      local.get $x local.get $ro f32.add f32.ceil i32.trunc_sat_f32_s  i32x4.replace_lane 1
      local.get $y local.get $ro f32.sub f32.floor i32.trunc_sat_f32_s i32x4.replace_lane 2
      local.get $y local.get $ro f32.add f32.ceil i32.trunc_sat_f32_s  i32x4.replace_lane 3

      v128.const i32x4 0 0 0 0 i32x4.max_s v128.const i32x4 639 639 479 479 i32x4.min_s
      local.tee $bound i32x4.extract_lane 0 local.set $x_min
      local.get $bound i32x4.extract_lane 1 local.set $x_max
      local.get $bound i32x4.extract_lane 2 local.set $y_min
      local.get $bound i32x4.extract_lane 3 local.set $y_max

      local.get $ro local.get $ro f32.mul f32x4.splat local.set $rosq
      local.get $ri local.get $ri f32.mul f32x4.splat local.set $risq

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
                  local.tee $dsq
                  local.get $rosq
                  f32x4.lt

                  local.get $dsq
                  local.get $risq
                  f32x4.gt
                  v128.and

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

(func $draw_line
      (param $xa f32) (param $ya f32)
      (param $xb f32) (param $yb f32)
      (param $r f32) (param $color i32)
      (local $x_min i32)
      (local $x_max i32)
      (local $y_min i32)
      (local $y_max i32)
      (local $iy i32)
      (local $ix i32)
      (local $bound v128)
      (local $vx v128)
      (local $vy v128)
      (local $rx v128)
      (local $ry v128)
      (local $vx0 v128)
      (local $vy0 v128)
      (local $dot v128)
      (local $dx v128)
      (local $dy v128)
      (local $len v128)
      (local $invlen v128)
      (local $ptr_base i32)
      (local $ptr i32)
      (local $rsq v128)
      (local $color4 v128)
      (local $mask v128)
      (local $scale f32)

      i32.const 0x130810 f32.load local.set $scale
      local.get $xa i32.const 0x130808 f32.load f32.add local.get $scale f32.mul local.set $xa
      local.get $ya i32.const 0x13080c f32.load f32.add local.get $scale f32.mul local.set $ya
      local.get $xb i32.const 0x130808 f32.load f32.add local.get $scale f32.mul local.set $xb
      local.get $yb i32.const 0x13080c f32.load f32.add local.get $scale f32.mul local.set $yb
      local.get $r local.get $scale f32.mul local.set $r


      local.get $xa f32x4.splat local.set $vx0
      local.get $ya f32x4.splat local.set $vy0

      local.get $xb local.get $xa f32.sub f32x4.splat local.set $dx
      local.get $yb local.get $ya f32.sub f32x4.splat local.set $dy

      v128.const f32x4 1 1 1 1
      local.get $dx local.get $dx f32x4.mul
      local.get $dy local.get $dy f32x4.mul
      f32x4.add
      f32x4.sqrt
      local.tee $len
      f32x4.div
      local.tee $invlen local.get $dx f32x4.mul local.set $dx
      local.get $invlen local.get $dy f32x4.mul local.set $dy

      v128.const i32x4 0 0 0 0
      local.get $xa local.get $xb f32.min local.get $r f32.sub f32.floor i32.trunc_sat_f32_s i32x4.replace_lane 0
      local.get $xa local.get $xb f32.max local.get $r f32.add f32.ceil i32.trunc_sat_f32_s  i32x4.replace_lane 1
      local.get $ya local.get $yb f32.min local.get $r f32.sub f32.floor i32.trunc_sat_f32_s i32x4.replace_lane 2
      local.get $ya local.get $yb f32.max local.get $r f32.add f32.ceil i32.trunc_sat_f32_s  i32x4.replace_lane 3

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
            local.set $vy
            local.get $x_min local.set $ix
            (loop $x_loop
                  local.get $ix i32x4.splat
                  v128.const i32x4 0 1 2 3 i32x4.add
                  f32x4.convert_i32x4_s
                  local.get $vx0 f32x4.sub

                  local.tee $vx local.get $dx f32x4.mul
                  local.get $vy local.get $dy f32x4.mul
                  f32x4.add
                  v128.const f32x4 0 0 0 0 f32x4.max
                  local.get $len f32x4.min
                  local.set $dot

                  local.get $vx
                  local.get $dot local.get $dx f32x4.mul
                  f32x4.sub
                  local.set $rx

                  local.get $vy
                  local.get $dot local.get $dy f32x4.mul
                  f32x4.sub
                  local.set $ry

                  local.get $rx local.get $rx f32x4.mul
                  local.get $ry local.get $ry f32x4.mul
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

(func $draw_link_line
      (param $xa f32) (param $ya f32)
      (param $xb f32) (param $yb f32)
      (param $r f32) (param $color i32)
      (local $x_min i32)
      (local $x_max i32)
      (local $y_min i32)
      (local $y_max i32)
      (local $iy i32)
      (local $ix i32)
      (local $bound v128)
      (local $vx v128)
      (local $vy v128)
      (local $rx v128)
      (local $ry v128)
      (local $vx0 v128)
      (local $vy0 v128)
      (local $dot v128)
      (local $dx v128)
      (local $dy v128)
      (local $len v128)
      (local $invlen v128)
      (local $ptr_base i32)
      (local $ptr i32)
      (local $rsq v128)
      (local $color4 v128)
      (local $mask v128)
      (local $scale f32)

      i32.const 0x130810 f32.load local.set $scale
      local.get $xa i32.const 0x130808 f32.load f32.add local.get $scale f32.mul local.set $xa
      local.get $ya i32.const 0x13080c f32.load f32.add local.get $scale f32.mul local.set $ya
      local.get $xb i32.const 0x130808 f32.load f32.add local.get $scale f32.mul local.set $xb
      local.get $yb i32.const 0x13080c f32.load f32.add local.get $scale f32.mul local.set $yb
      local.get $r local.get $scale f32.mul local.set $r


      local.get $xa f32x4.splat local.set $vx0
      local.get $ya f32x4.splat local.set $vy0

      local.get $xb local.get $xa f32.sub f32x4.splat local.set $dx
      local.get $yb local.get $ya f32.sub f32x4.splat local.set $dy

      v128.const f32x4 1 1 1 1
      local.get $dx local.get $dx f32x4.mul
      local.get $dy local.get $dy f32x4.mul
      f32x4.add
      f32x4.sqrt
      local.tee $len
      f32x4.div
      local.tee $invlen local.get $dx f32x4.mul local.set $dx
      local.get $invlen local.get $dy f32x4.mul local.set $dy

      v128.const i32x4 0 0 0 0
      local.get $xa local.get $xb f32.min local.get $r f32.sub f32.floor i32.trunc_sat_f32_s i32x4.replace_lane 0
      local.get $xa local.get $xb f32.max local.get $r f32.add f32.ceil i32.trunc_sat_f32_s  i32x4.replace_lane 1
      local.get $ya local.get $yb f32.min local.get $r f32.sub f32.floor i32.trunc_sat_f32_s i32x4.replace_lane 2
      local.get $ya local.get $yb f32.max local.get $r f32.add f32.ceil i32.trunc_sat_f32_s  i32x4.replace_lane 3

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
            local.set $vy
            local.get $x_min local.set $ix
            (loop $x_loop
                  local.get $ix i32x4.splat
                  v128.const i32x4 0 1 2 3 i32x4.add
                  f32x4.convert_i32x4_s
                  local.get $vx0 f32x4.sub

                  local.tee $vx local.get $dx f32x4.mul
                  local.get $vy local.get $dy f32x4.mul
                  f32x4.add
                  v128.const f32x4 0 0 0 0 f32x4.max
                  local.get $len f32x4.min
                  local.set $dot

                  local.get $vx
                  local.get $dot local.get $dx f32x4.mul
                  f32x4.sub
                  local.set $rx

                  local.get $vy
                  local.get $dot local.get $dy f32x4.mul
                  f32x4.sub
                  local.set $ry

                  local.get $rx local.get $rx f32x4.mul
                  local.get $ry local.get $ry f32x4.mul
                  f32x4.add
                  local.get $rsq

                  ;; middle thining
                  local.get $dot local.get $invlen f32x4.mul
                  v128.const f32x4 0.5 0.5 0.5 0.5 f32x4.sub
                  f32x4.abs
                  v128.const f32x4 0.05 0.05 0.05 0.05 f32x4.add
                  f32x4.mul

                  ;; v128.const i32x4 0 0 0 0
                  ;; call $randf_s f32x4.replace_lane 0
                  ;; call $randf_s f32x4.replace_lane 1
                  ;; call $randf_s f32x4.replace_lane 2
                  ;; call $randf_s f32x4.replace_lane 3
                  ;; v128.const f32x4 4 4 4 4 f32x4.mul
                  ;; f32x4.add

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

(func $draw_link
      (param $x1 f32) (param $y1 f32)
      (param $x2 f32) (param $y2 f32)
      (param $t f32) (param $r f32) (param $color i32)
      (param $sign i32)

      local.get $t local.get $t
      f32.floor f32.sub
      local.set $t

      local.get $x1 local.get $y1
      local.get $x2 local.get $y2
      local.get $r f32.const 0.8 f32.mul
      local.get $t
      f32.const 3.14159265358979323846264338327950 f32.mul
      call $sin
      f32.add
      local.get $color
      call $draw_link_line

      local.get $x1 local.get $x2 local.get $t call $lerp
      local.get $y1 local.get $y2 local.get $t call $lerp
      local.get $r
      local.get $sign
      (if (param f32 f32 f32)
        (then
          local.get $color
          call $draw_circle)
        (else
          local.get $r f32.const 0.8 f32.mul
          i32.const 0xFF_70_90_90
          call $draw_ring))

      local.get $t
      f32.const 0.25 f32.add
      local.tee $t local.get $t
      f32.floor f32.sub
      local.set $t

      local.get $x1 local.get $x2 local.get $t call $lerp
      local.get $y1 local.get $y2 local.get $t call $lerp
      local.get $r
      local.get $sign
      (if (param f32 f32 f32)
        (then
          local.get $color
          call $draw_circle)
        (else
          local.get $r f32.const 0.8 f32.mul
          i32.const 0xFF_70_90_90
          call $draw_ring))

      local.get $t
      f32.const 0.25 f32.add
      local.tee $t local.get $t
      f32.floor f32.sub
      local.set $t

      local.get $x1 local.get $x2 local.get $t call $lerp
      local.get $y1 local.get $y2 local.get $t call $lerp
      local.get $r
      local.get $sign
      (if (param f32 f32 f32)
        (then
          local.get $color
          call $draw_circle)
        (else
          local.get $r f32.const 0.8 f32.mul
          i32.const 0xFF_70_90_90
          call $draw_ring))

      local.get $t
      f32.const 0.25 f32.add
      local.tee $t local.get $t
      f32.floor f32.sub
      local.set $t

      local.get $x1 local.get $x2 local.get $t call $lerp
      local.get $y1 local.get $y2 local.get $t call $lerp
      local.get $r
      local.get $sign
      (if (param f32 f32 f32)
        (then
          local.get $color
          call $draw_circle)
        (else
          local.get $r f32.const 0.8 f32.mul
          i32.const 0xFF_70_90_90
          call $draw_ring))
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
      (local $scale f32)
      i32.const 0x130FFC ;; n_particles
      i32.load
      local.set $n_particles

      i32.const 0x130810 f32.load local.set $scale
      i32.const 0x12c000 f32.load local.get $scale f32.div local.set $mx
      i32.const 0x12c004 f32.load local.get $scale f32.div local.set $my

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

(func $is_linked (param $a i32) (param $b i32) (result i32)
      (local $n_links i32)
      (local $i i32)
      (local $i4 i32)
      (local $A i32)
      (local $B i32)

      i32.const 0x132010 i32.load local.set $n_links

      local.get $n_links
      local.set $i
      block $break
      (loop $link_loop
            local.get $i
            i32.eqz
            br_if $break

            local.get $i
            i32.const 1 i32.sub
            local.tee $i
            i32.const 4 i32.mul
            local.set $i4

            i32.const 0x160000 local.get $i4 i32.add i32.load local.set $A
            i32.const 0x161000 local.get $i4 i32.add i32.load local.set $B

            local.get $a local.get $A i32.eq
            local.get $b local.get $B i32.eq
            i32.and

            local.get $a local.get $B i32.eq
            local.get $b local.get $A i32.eq
            i32.and

            i32.or
            (if (then local.get $i i32.const 1 i32.add return))

            br $link_loop)
      end
      i32.const 0)

(func $update_links
      (local $n_links i32)
      (local $clicked_link i32)
      (local $hovered_link i32)
      (local $clicked_node i32)
      (local $temp f32)
      (local $i i32)
      (local $i4 i32)
      (local $a i32)
      (local $a4 i32)
      (local $b i32)
      (local $b4 i32)
      (local $strength f32)
      (local $phase f32)
      (local $r f32)
      (local $dr f32)
      (local $activation f32)
      (local $target f32)
      (local $flow_dir i32)

      (local $ax f32)
      (local $ay f32)
      (local $bx f32)
      (local $by f32)
      (local $adx f32)
      (local $ady f32)
      (local $bdx f32)
      (local $bdy f32)

      (local $dx f32)
      (local $dy f32)
      (local $fx f32)
      (local $fy f32)
      (local $f f32)
      (local $d f32)
      (local $invr f32)
      (local $dot f32)

      (local $mx f32)
      (local $my f32)
      (local $clicked i32)
      (local $clicking i32)
      (local $right_clicked i32)

      (local $rmx f32)
      (local $rmy f32)
      (local $scale f32)

      i32.const 0x132010 i32.load local.set $n_links

      i32.const 0x132004 i32.load local.set $clicked_node
      i32.const 0x132014 i32.load local.set $clicked_link

      i32.const 0x130810 f32.load local.set $scale
      i32.const 0x12c000 f32.load local.get $scale f32.div i32.const 0x130808 f32.load f32.sub local.set $mx
      i32.const 0x12c004 f32.load local.get $scale f32.div i32.const 0x13080c f32.load f32.sub local.set $my

      i32.const 0x12c008 i32.load
      local.tee $clicking
      i32.const 1 i32.and
      local.set $clicked

      local.get $clicking
      (if (then) (else i32.const 0 local.set $clicked_link))

      i32.const 0x12c00c i32.load
      i32.const 1 i32.and
      local.set $right_clicked

      local.get $n_links
      local.set $i
      block $break
      (loop $link_loop
            local.get $i
            i32.eqz
            br_if $break

            local.get $i
            i32.const 1 i32.sub
            local.tee $i
            i32.const 4 i32.mul
            local.set $i4

            i32.const 0x160000 local.get $i4 i32.add i32.load local.set $a
            i32.const 0x161000 local.get $i4 i32.add i32.load local.set $b
            i32.const 0x162000 local.get $i4 i32.add f32.load local.set $strength
            i32.const 0x163000 local.get $i4 i32.add f32.load local.set $r
            i32.const 0x164000 local.get $i4 i32.add f32.load local.set $dr
            i32.const 0x165000 local.get $i4 i32.add f32.load local.set $phase

            local.get $a
            i32.const 4 i32.mul
            local.set $a4

            local.get $b
            i32.const 4 i32.mul
            local.set $b4

            i32.const 0x140000 local.get $a4 i32.add f32.load local.set $ax
            i32.const 0x141000 local.get $a4 i32.add f32.load local.set $ay
            ;; i32.const 0x142000 local.get $a4 i32.add f32.load local.set $adx
            ;; i32.const 0x143000 local.get $a4 i32.add f32.load local.set $ady

            i32.const 0x140000 local.get $b4 i32.add f32.load local.set $bx
            i32.const 0x141000 local.get $b4 i32.add f32.load local.set $by
            ;; i32.const 0x142000 local.get $b4 i32.add f32.load local.set $bdx
            ;; i32.const 0x143000 local.get $b4 i32.add f32.load local.set $bdy

            local.get $bx local.get $ax f32.sub local.set $dx
            local.get $by local.get $ay f32.sub local.set $dy

            f32.const 1
            local.get $dx local.get $dx f32.mul
            local.get $dy local.get $dy f32.mul
            f32.add
            f32.sqrt
            local.tee $d
            f32.const 1 f32.max
            f32.div
            local.tee $invr
            f32.const -128 f32.mul
            f32.const 1.0 f32.add
            f32.const 0.01 f32.mul
            local.set $f

            ;; local.get $dx local.get $f f32.mul local.set $fx
            ;; local.get $dy local.get $f f32.mul local.set $fy

            ;; local.get $adx local.get $fx f32.add local.set $adx
            ;; local.get $ady local.get $fy f32.add local.set $ady

            ;; local.get $bdx local.get $fx f32.sub local.set $bdx
            ;; local.get $bdy local.get $fy f32.sub local.set $bdy

            ;; i32.const 0x142000 local.get $a4 i32.add local.get $adx f32.store
            ;; i32.const 0x143000 local.get $a4 i32.add local.get $ady f32.store
            ;; i32.const 0x142000 local.get $b4 i32.add local.get $bdx f32.store
            ;; i32.const 0x143000 local.get $b4 i32.add local.get $bdy f32.store

            ;; local.get $strength f32.const 0 f32.gt local.set $flow_dir
            i32.const 1 local.set $flow_dir

            i32.const 0x148000
            local.get $a4 local.get $b4 local.get $flow_dir select
            i32.add f32.load
            local.get $strength f32.mul
            local.set $activation

            i32.const 0x149000 local.get $b4 local.get $a4 local.get $flow_dir select i32.add
            i32.const 0x149000 local.get $b4 local.get $a4 local.get $flow_dir select i32.add
            f32.load local.get $activation f32.add f32.store

            f32.const 0.0078125 local.get $strength f32.abs f32.mul
            local.get $phase f32.add local.set $phase

            local.get $ax local.get $ay
            local.get $bx local.get $by
            local.get $phase
            local.get $r local.get $strength f32.abs f32.mul
            i32.const 0xFFC0705F
            local.get $strength f32.const 0 f32.gt
            call $draw_link

            local.get $dx local.get $invr f32.mul local.set $dx
            local.get $dy local.get $invr f32.mul local.set $dy

            local.get $strength
            local.get $d f32.const 0.5 f32.mul f32.const 24 f32.sub
            f32.mul
            local.set $strength

            local.get $d f32.const 0.5 f32.mul local.set $f
            local.get $ax local.get $dx local.get $f local.get $strength f32.add f32.mul f32.add
            local.get $ay local.get $dy local.get $f local.get $strength f32.add f32.mul f32.add
            local.get $r f32.const 1.5 f32.mul
            i32.const 0xFFFFFFFF
            call $draw_circle

            local.get $dx local.get $mx local.get $ax f32.sub local.tee $rmx f32.mul
            local.get $dy local.get $my local.get $ay f32.sub local.tee $rmy f32.mul
            f32.add
            f32.const 28 f32.max
            local.get $d f32.const 28 f32.sub f32.min
            local.set $dot

            local.get $rmx local.get $dx local.get $dot f32.mul f32.sub local.tee $rmx local.get $rmx f32.mul
            local.get $rmy local.get $dy local.get $dot f32.mul f32.sub local.tee $rmy local.get $rmy f32.mul
            f32.add

            f32.const 100

            f32.lt
            local.get $clicked_node i32.eqz i32.and
            local.get $clicked_link i32.eqz i32.and
            (if (then
                  local.get $dr f32.const 0.1 f32.add local.set $dr

                  local.get $i
                  i32.const 1 i32.add
                  local.set $hovered_link

                  local.get $right_clicked
                  (if (then
                        local.get $i
                        call $delete_link
                        br $link_loop
                        ))
                  ))

            local.get $clicked_link local.get $i i32.const 1 i32.add i32.eq
            (if  (then
                   local.get $dot
                   f32.const 28 f32.sub
                   local.get $d f32.const 56 f32.sub f32.div
                   f32.const 2 f32.mul
                   f32.const 1 f32.sub
                   local.set $strength
                   i32.const 0x162000 local.get $i4 i32.add local.get $strength f32.store
                   i32.const 0x0132020 local.get $strength f32.store
                   ))

            local.get $dr
            f32.const 0.95 f32.mul
            f32.const 5 local.get $r f32.sub f32.const 0.05 f32.mul
            f32.add
            local.set $dr

            local.get $r local.get $dr f32.add local.set $r

            i32.const 0x163000 local.get $i4 i32.add local.get $r f32.store
            i32.const 0x164000 local.get $i4 i32.add local.get $dr f32.store
            i32.const 0x165000 local.get $i4 i32.add local.get $phase f32.store

            br $link_loop)
      end

      local.get $clicked
      local.get $hovered_link i32.eqz i32.eqz
      i32.and
      (if (then
            local.get $hovered_link
            local.set $clicked_link
            ))

      i32.const 0x132014 local.get $clicked_link i32.store
      i32.const 0x132018 local.get $hovered_link i32.store
      )

(func $delete_link (param $i i32)
      (local $n_links i32)
      (local $i4 i32)
      (local $j4 i32)

      local.get $i
      i32.const 4 i32.mul
      local.set $i4

      i32.const 0x0132010 i32.load
      i32.const 1 i32.sub
      local.tee $n_links
      i32.const 4 i32.mul
      local.set $j4
      i32.const 0x160000 local.get $i4 i32.add i32.const 0x160000 local.get $j4 i32.add i32.load i32.store
      i32.const 0x161000 local.get $i4 i32.add i32.const 0x161000 local.get $j4 i32.add i32.load i32.store
      i32.const 0x162000 local.get $i4 i32.add i32.const 0x162000 local.get $j4 i32.add f32.load f32.store
      i32.const 0x163000 local.get $i4 i32.add i32.const 0x163000 local.get $j4 i32.add f32.load f32.store
      i32.const 0x164000 local.get $i4 i32.add i32.const 0x164000 local.get $j4 i32.add f32.load f32.store
      i32.const 0x165000 local.get $i4 i32.add i32.const 0x165000 local.get $j4 i32.add f32.load f32.store

      i32.const 0x0132010
      local.get $n_links
      i32.store
      )

(func $create_node (param $x f32) (param $y f32) (param $type i32) (result i32)
      (local $n_nodes i32)
      (local $i4 i32)
      i32.const 0x132000 i32.load
      local.tee $n_nodes
      i32.const 4 i32.mul
      local.set $i4

      i32.const 0x0133010 i32.const 0 i32.store ;; reset solved case count
      i32.const 0x0134010 i32.const 0 i32.store ;; reset secret solved case count

      i32.const 0x140000 local.get $i4 i32.add local.get $x f32.store
      i32.const 0x141000 local.get $i4 i32.add local.get $y f32.store
      i32.const 0x142000 local.get $i4 i32.add f32.const 0 f32.store
      i32.const 0x143000 local.get $i4 i32.add f32.const 0 f32.store
      i32.const 0x144000 local.get $i4 i32.add f32.const 5 f32.store
      i32.const 0x145000 local.get $i4 i32.add f32.const 0 f32.store
      i32.const 0x146000 local.get $i4 i32.add local.get $type i32.store
      i32.const 0x147000 local.get $i4 i32.add f32.const 0 f32.store
      i32.const 0x148000 local.get $i4 i32.add f32.const 0 f32.store
      i32.const 0x149000 local.get $i4 i32.add f32.const 0 f32.store
      i32.const 0x132000
      local.get $n_nodes
      i32.const 1 i32.add
      local.tee $n_nodes
      i32.store
      local.get $n_nodes
      )

(func $create_link (param $i i32) (param $j i32)
      (local $existing i32)
      (local $l i32)
      (local $l4 i32)

      local.get $i local.get $j
      i32.eq
      (if (then return))

      i32.const 0x130008
      i32.const 0x130008
      f32.load f32.const 0.02 f32.add f32.store

      i32.const 0x0133010 i32.const 0 i32.store ;; reset solved case count
      i32.const 0x0134010 i32.const 0 i32.store ;; reset secret solved case count

      i32.const 0x132010 i32.load
      local.set $l

      local.get $i local.get $j
      call $is_linked
      local.tee $existing
      (if
        (then
          local.get $existing
          i32.const 1 i32.sub
          local.set $l
          )
        (else
          i32.const 0x132010
          local.get $l
          i32.const 1 i32.add
          i32.store))

      local.get $l
      i32.const 4 i32.mul
      local.set $l4

      i32.const 0x160000 local.get $l4 i32.add local.get $i i32.store
      i32.const 0x161000 local.get $l4 i32.add local.get $j i32.store

      i32.const 0x162000 local.get $l4 i32.add f32.const 1.0 f32.store
      i32.const 0x163000 local.get $l4 i32.add f32.const 0.0 f32.store
      i32.const 0x164000 local.get $l4 i32.add f32.const 0.0 f32.store
      i32.const 0x165000 local.get $l4 i32.add f32.const 0.0 f32.store)

(func $delete_node (param $i i32)
      (local $n_nodes i32)
      (local $n_links i32)
      (local $l i32)
      (local $i4 i32)
      (local $j4 i32)
      (local $A i32)
      (local $B i32)

      local.get $i
      i32.const 4 i32.mul
      local.set $i4

      i32.const 0x0132000 i32.load
      i32.const 1 i32.sub
      local.tee $n_nodes
      i32.const 4 i32.mul
      local.set $j4
      i32.const 0x140000 local.get $i4 i32.add i32.const 0x140000 local.get $j4 i32.add f32.load f32.store
      i32.const 0x141000 local.get $i4 i32.add i32.const 0x141000 local.get $j4 i32.add f32.load f32.store
      i32.const 0x142000 local.get $i4 i32.add i32.const 0x142000 local.get $j4 i32.add f32.load f32.store
      i32.const 0x143000 local.get $i4 i32.add i32.const 0x143000 local.get $j4 i32.add f32.load f32.store
      i32.const 0x144000 local.get $i4 i32.add i32.const 0x144000 local.get $j4 i32.add f32.load f32.store
      i32.const 0x145000 local.get $i4 i32.add i32.const 0x145000 local.get $j4 i32.add f32.load f32.store
      i32.const 0x146000 local.get $i4 i32.add i32.const 0x146000 local.get $j4 i32.add f32.load f32.store
      i32.const 0x147000 local.get $i4 i32.add i32.const 0x147000 local.get $j4 i32.add f32.load f32.store
      i32.const 0x148000 local.get $i4 i32.add i32.const 0x148000 local.get $j4 i32.add f32.load f32.store
      i32.const 0x149000 local.get $i4 i32.add i32.const 0x149000 local.get $j4 i32.add f32.load f32.store

      i32.const 0x132000
      local.get $n_nodes
      i32.store

      i32.const 0x132010 i32.load local.set $n_links

      local.get $n_links
      local.set $l
      block $break
      (loop $link_loop
            local.get $l
            i32.eqz
            br_if $break

            local.get $l
            i32.const 1 i32.sub
            local.tee $l
            i32.const 4 i32.mul
            local.set $i4

            i32.const 0x160000 local.get $i4 i32.add i32.load local.set $A
            i32.const 0x161000 local.get $i4 i32.add i32.load local.set $B

            local.get $i local.get $A i32.eq
            local.get $i local.get $B i32.eq
            i32.or
            (if (then
                  local.get $l
                  call $delete_link)
              (else
                local.get $n_nodes local.get $A i32.eq
                (if (then
                      i32.const 0x160000 local.get $i4 i32.add local.get $i i32.store))

                local.get $n_nodes local.get $B i32.eq
                (if (then
                      i32.const 0x161000 local.get $i4 i32.add local.get $i i32.store))
                ))

            br $link_loop)
      end)

(func $update_nodes
      (local $n_nodes i32)
      (local $temp f32)
      (local $i i32)
      (local $i4 i32)
      (local $j i32)
      (local $j4 i32)
      (local $x f32)
      (local $y f32)
      (local $dx f32)
      (local $dy f32)
      (local $r f32)
      (local $dr f32)

      (local $nx f32)
      (local $ny f32)
      (local $ndx f32)
      (local $ndy f32)
      (local $nr f32)
      (local $ndr f32)

      (local $rx f32)
      (local $ry f32)
      (local $mx f32)
      (local $my f32)
      (local $msq f32)
      (local $clicked i32)
      (local $clicking i32)
      (local $right_clicked i32)
      (local $clicked_node i32)
      (local $clicked_link i32)
      (local $hovered_link i32)
      (local $is_clicked_node i32)
      (local $pending_node i32)
      (local $pending_link i32)
      (local $best_node i32)
      (local $best_distsq f32)
      (local $scale f32)
      (local $activation f32)
      (local $target f32)
      (local $type i32)
      (local $interactive i32)
      (local $solved i32)
      (local $secret_solved i32)
      (local $new_node i32)

      i32.const 1 local.set $solved
      i32.const 1 local.set $secret_solved

      i32.const 0x132000 i32.load local.set $n_nodes
      i32.const 0x132004 i32.load local.set $clicked_node
      i32.const 0x132008 i32.load local.set $pending_node
      i32.const 0x13200c i32.load local.set $pending_link
      i32.const 0x132014 i32.load local.set $clicked_link
      i32.const 0x132018 i32.load local.set $hovered_link
      i32.const 0x13201c i32.load local.set $new_node

      i32.const 0x130810 f32.load local.set $scale
      i32.const 0x12c000 f32.load local.get $scale f32.div i32.const 0x130808 f32.load f32.sub local.set $mx
      i32.const 0x12c004 f32.load local.get $scale f32.div i32.const 0x13080c f32.load f32.sub local.set $my

      i32.const 0x12c008 i32.load
      local.tee $clicking
      i32.const 1 i32.and
      local.set $clicked

      i32.const 0x12c00c i32.load
      i32.const 1 i32.and
      local.set $right_clicked

      f32.const 8192.0
      local.set $best_distsq

      local.get $pending_node
      (if (then ;; draw and remove links for pending node
          local.get $clicked_node
          i32.const 1 i32.sub
          i32.const 4 i32.mul
          local.set $i4

          local.get $pending_node
          i32.const 1 i32.sub
          i32.const 4 i32.mul
          local.set $j4

          i32.const 0x140000 local.get $i4 i32.add f32.load local.set $x
          i32.const 0x141000 local.get $i4 i32.add f32.load local.set $y

          i32.const 0x140000 local.get $j4 i32.add f32.load local.set $nx
          i32.const 0x141000 local.get $j4 i32.add f32.load local.set $ny

          local.get $nx local.get $ny
          local.get $x local.get $y

          f32.const 0.0
          f32.const 5.0
          i32.const 0xFF905049
          i32.const 1
          call $draw_link

          local.get $nx local.get $x f32.sub local.set $rx
          local.get $ny local.get $y f32.sub local.set $ry

          local.get $rx local.get $rx f32.mul
          local.get $ry local.get $ry f32.mul
          f32.add

          f32.const 8192.0

          f32.gt
          (if (then
                i32.const 0
                local.set $pending_node
                ))
          ))

      local.get $pending_link
      (if (then
          local.get $pending_link
          i32.const 1 i32.sub
          i32.const 4 i32.mul
          local.set $i4

          i32.const 0x140000 local.get $i4 i32.add f32.load local.set $x
          i32.const 0x141000 local.get $i4 i32.add f32.load local.set $y

          local.get $mx local.get $my
          local.get $x local.get $y

          f32.const 0.0
          f32.const 5.0
          i32.const 0xFF905049
          i32.const 1
          call $draw_link
          ))

      local.get $n_nodes
      local.tee $i
      i32.eqz
      if $nonzero
      else
      (loop $node_loop
            block $skip_if_delete
            local.get $i
            i32.const 1
            i32.sub
            local.tee $i
            i32.const 4 i32.mul
            local.set $i4
            i32.const 0x140000 local.get $i4 i32.add f32.load local.set $x
            i32.const 0x141000 local.get $i4 i32.add f32.load local.set $y
            i32.const 0x142000 local.get $i4 i32.add f32.load local.set $dx
            i32.const 0x143000 local.get $i4 i32.add f32.load local.set $dy
            i32.const 0x144000 local.get $i4 i32.add f32.load local.set $r
            i32.const 0x145000 local.get $i4 i32.add f32.load local.set $dr
            i32.const 0x146000 local.get $i4 i32.add i32.load local.set $type

            local.get $type i32.const 1 i32.and i32.eqz local.set $interactive

            i32.const 0x147000 local.get $i4 i32.add f32.load local.set $target

            local.get $type i32.const 1 i32.eq
            (if
              (then
                i32.const 0x148000 local.get $i4 i32.add
                f32.load
                local.set $activation
                )
              (else
                i32.const 0x148000 local.get $i4 i32.add
                i32.const 0x149000 local.get $i4 i32.add f32.load
                f32.const 1 f32.min
                f32.const -1 f32.max
                local.tee $activation
                f32.store
                ))

            local.get $dr
            local.get $activation f32.const 0.1 f32.mul f32.add
            local.set $dr

            i32.const 0x149000 local.get $i4 i32.add i32.const 0 i32.store

            local.get $interactive
            (if (then
                  local.get $x local.get $dx f32.add local.set $x
                  local.get $y local.get $dy f32.add local.set $y
                  ))

            local.get $dx f32.const 0.5 f32.mul local.set $dx
            local.get $dy f32.const 0.5 f32.mul local.set $dy

            local.get $dr
            f32.const 0.95 f32.mul
            i32.const 0x130804 i32.load i32.const 0xFFFFFF i32.and f32.convert_i32_s
            f32.const 0.2 f32.mul call $sin f32.const 0.005 f32.mul f32.add
            f32.const 16 local.get $r f32.sub f32.const 0.05 f32.mul
            f32.add
            local.set $dr

            local.get $r local.get $dr f32.add local.set $r

            local.get $x local.get $mx f32.sub local.set $rx
            local.get $y local.get $my f32.sub local.set $ry
            local.get $rx local.get $rx f32.mul
            local.get $ry local.get $ry f32.mul
            f32.add
            local.tee $msq
            local.get $r local.get $r f32.mul
            f32.lt
            local.get $interactive i32.and
            local.get $hovered_link i32.eqz i32.and
            (if
              (then
                local.get $dr f32.const 0.1 f32.add local.set $dr

                local.get $clicked
                local.get $clicked_node i32.eqz i32.and
                local.get $clicked_link i32.eqz i32.and
                (if
                  (then
                    local.get $i
                    i32.const 1 i32.add
                    local.set $clicked_node

                    local.get $dr f32.const -1.0 f32.add local.set $dr
                    ))
                )
              (else
                local.get $msq
                f32.const 900
                f32.lt
                local.get $hovered_link i32.eqz i32.and
                (if
                  (then
                    local.get $mx
                    local.get $my
                    f32.const 6
                    i32.const 0xFFFFFFFF
                    call $draw_circle
                    local.get $clicked
                    local.get $clicked_node i32.eqz i32.and
                    local.get $clicked_link i32.eqz i32.and
                    (if (then
                          local.get $i
                          i32.const 1 i32.add
                          local.set $pending_link
                          ))
                    ))
                ))

            local.get $msq
            f32.const 900
            f32.lt
            local.get $pending_link i32.eqz i32.eqz i32.and
            local.get $clicking i32.eqz i32.and
            (if (then
                  local.get $pending_link
                  i32.const 1 i32.sub
                  local.get $i
                  call $create_link
                  i32.const 0 local.set $pending_link
                  ))

            local.get $right_clicked
            local.get $clicked_node i32.eqz
            local.get $clicked_link i32.eqz i32.and
            i32.and
            local.get $interactive i32.and
            (if
              (then
                local.get $x local.get $mx f32.sub local.set $rx
                local.get $y local.get $my f32.sub local.set $ry
                local.get $rx local.get $rx f32.mul
                local.get $ry local.get $ry f32.mul
                f32.add
                local.get $r local.get $r f32.mul
                f32.lt
                (if
                  (then
                    local.get $i
                    call $delete_node
                    br $skip_if_delete
                    ))
                ))

            local.get $n_nodes
            local.tee $j
            local.get $i
            i32.const 1 i32.add
            i32.gt_s
            if $j_nonzero
            (loop $lop
                  local.get $j
                  i32.const 1
                  i32.sub
                  local.tee $j
                  i32.const 4 i32.mul
                  local.set $j4

                  i32.const 0x140000 local.get $j4 i32.add f32.load local.set $nx
                  i32.const 0x141000 local.get $j4 i32.add f32.load local.set $ny
                  i32.const 0x142000 local.get $j4 i32.add f32.load local.set $ndx
                  i32.const 0x143000 local.get $j4 i32.add f32.load local.set $ndy
                  i32.const 0x144000 local.get $j4 i32.add f32.load local.set $nr
                  i32.const 0x145000 local.get $j4 i32.add f32.load local.set $ndr

                  local.get $nx local.get $x f32.sub local.set $rx
                  local.get $ny local.get $y f32.sub local.set $ry

                  local.get $r local.get $nr f32.add
                  local.tee $temp
                  local.get $temp
                  f32.mul
                  local.tee $temp

                  local.get $rx local.get $rx f32.mul
                  local.get $ry local.get $ry f32.mul
                  f32.add
                  local.tee $temp

                  local.get $best_distsq
                  f32.lt

                  local.get $clicked_node i32.const 1 i32.sub local.get $i i32.eq
                  local.tee $is_clicked_node
                  local.get $clicked_node i32.const 1 i32.sub local.get $j i32.eq
                  i32.or

                  i32.and

                  local.get $i local.get $j
                  call $is_linked i32.eqz i32.and

                  local.get $new_node i32.and
                  (if
                    (then
                      local.get $j
                      local.get $i
                      local.get $is_clicked_node
                      select
                      i32.const 1 i32.add
                      local.set $pending_node

                      local.get $temp
                      local.set $best_distsq
                      ))

                  local.get $temp

                  f32.gt
                  (if
                    (then
                      local.get $r local.get $nr f32.add

                      f32.const 1
                      local.get $temp
                      f32.sqrt
                      f32.div

                      f32.sub
                      f32.const 0.0002 f32.mul
                      local.set $temp

                      local.get $rx local.get $temp f32.mul local.set $rx
                      local.get $ry local.get $temp f32.mul local.set $ry

                      local.get $dx
                      local.get $rx
                      f32.sub
                      local.set $dx

                      local.get $dy
                      local.get $ry
                      f32.sub
                      local.set $dy

                      local.get $ndx
                      local.get $rx
                      f32.add
                      local.set $ndx

                      local.get $ndy
                      local.get $ry
                      f32.add
                      local.set $ndy
                      ))

                  ;; i32.const 0x140000 local.get $j4 i32.add local.get $nx  f32.store
                  ;; i32.const 0x141000 local.get $j4 i32.add local.get $ny  f32.store
                  i32.const 0x142000 local.get $j4 i32.add local.get $ndx f32.store
                  i32.const 0x143000 local.get $j4 i32.add local.get $ndy f32.store
                  ;; i32.const 0x144000 local.get $j4 i32.add local.get $nr  f32.store
                  ;; i32.const 0x145000 local.get $j4 i32.add local.get $ndr f32.store

                  local.get $j
                  local.get $i
                  i32.const 1 i32.add
                  i32.gt_s
                  br_if $lop)
            end

            local.get $clicked_node local.get $i i32.const 1 i32.add i32.eq
            (if
              (then
                local.get $mx local.set $x
                local.get $my local.set $y

                local.get $dr f32.const -0.1 f32.add local.set $dr

                local.get $clicking
                i32.eqz
                (if (then
                      local.get $pending_node
                      i32.eqz
                      (if (then)
                        (else ;; create link
                          local.get $pending_node i32.const 1 i32.sub local.tee $j
                          i32.const 4 i32.mul
                          local.set $j4

                          i32.const 0x146000 local.get $j4 i32.add i32.load local.set $type

                          local.get $type i32.const 3 i32.eq
                          (if (result i32 i32)
                            (then
                              local.get $i
                              local.get $j
                              )
                            (else
                              local.get $j
                              local.get $i
                              ))

                          call $create_link
                          ))
                      i32.const 0 local.set $pending_node
                      i32.const 0 local.set $clicked_node
                      i32.const 0 local.set $new_node
                      ))
              ))

            ;; local.get $i
            ;; local.get $x
            ;; f32.const 3.0 f32.sub
            ;; local.get $y
            ;; f32.const 3.0 f32.sub
            ;; call $i32draw

            local.get $interactive
            (if (then)
              (else
                local.get $x
                local.get $y
                local.get $r f32.const 5 f32.add

                local.get $type i32.const 3 i32.eq
                local.get $type i32.const 5 i32.eq
                i32.or
                (if (result i32)
                  (then
                      i32.const 0xFF10E030
                      i32.const 0xFF1000A0
                      local.get $target local.get $activation f32.sub f32.abs f32.const 0.1 f32.lt

                      ;; set solved to 0 if it's true and this check is false
                      local.get $type i32.const 3 i32.eq
                      local.get $solved
                      i32.and
                      (if (param i32) (result i32) (then local.tee $solved))

                      local.get $type i32.const 5 i32.eq
                      local.get $secret_solved
                      i32.and
                      (if (param i32) (result i32) (then local.tee $secret_solved))
                      select
                      )
                  (else
                    i32.const 0xFFFF905F
                    ))
                call $draw_circle
                ))

            local.get $x
            local.get $y
            local.get $r
            i32.const 0xFF302025
            i32.const 0xFF90607F
            local.get $type i32.const 3 i32.eq
            local.get $type i32.const 5 i32.eq
            i32.or
            select
            call $draw_circle

            local.get $type i32.const 3 i32.eq
            local.get $type i32.const 5 i32.eq
            i32.or
            (if (then
                  local.get $target
                  f32.const 0 f32.ge
                  (if
                    (then
                      local.get $x
                      local.get $y
                      local.get $r local.get $target f32.mul
                      i32.const 0xFF_70_90_90
                      call $draw_circle)
                    (else
                      local.get $x
                      local.get $y
                      local.get $r
                      local.get $r f32.const 1 local.get $target f32.add f32.const 0.1 f32.max f32.mul
                      i32.const 0xFF_70_90_90
                      call $draw_ring))
                  ))

            local.get $activation
            f32.const 0 f32.ge
            (if
              (then
                local.get $x
                local.get $y
                local.get $r local.get $activation f32.mul
                i32.const 0xFF50FFFF
                call $draw_circle)
              (else
                local.get $x
                local.get $y
                local.get $r
                local.get $r f32.const 1 local.get $activation f32.add f32.const 0.1 f32.max f32.mul
                i32.const 0xFF50FFFF
                call $draw_ring))

            local.get $type i32.const 3 i32.eq
            local.get $type i32.const 5 i32.eq
            i32.or
            (if (then
                  local.get $x
                  local.get $y
                  local.get $r local.get $target f32.abs f32.const 0.03 f32.add f32.mul
                  local.get $r local.get $target f32.abs f32.const 0.03 f32.sub f32.mul
                  i32.const 0xFF_70_A0_9F
                  call $draw_ring
                ))

            i32.const 0x140000 local.get $i4 i32.add local.get $x  f32.store
            i32.const 0x141000 local.get $i4 i32.add local.get $y  f32.store
            i32.const 0x142000 local.get $i4 i32.add local.get $dx f32.store
            i32.const 0x143000 local.get $i4 i32.add local.get $dy f32.store
            i32.const 0x144000 local.get $i4 i32.add local.get $r  f32.store
            i32.const 0x145000 local.get $i4 i32.add local.get $dr f32.store

            end ;; skip if delete

            local.get $i
            i32.const 0
            i32.gt_s
            br_if $node_loop)
      end

      local.get $clicking
      (if (then)
        (else
          i32.const 0 local.set $pending_link
          ))

      local.get $clicked
      local.get $clicked_node i32.eqz i32.and
      local.get $hovered_link i32.eqz i32.and
      local.get $pending_link i32.eqz i32.and
      (if
        (then
          local.get $n_nodes
          i32.const 4 i32.mul
          local.set $i4

          local.get $mx local.get $my
          i32.const 0
          call $create_node
          local.set $clicked_node
          i32.const 1 local.set $new_node
          ))

      local.get $clicked_node
      local.get $clicked_link
      i32.or
      (if
        (then
          i32.const 0x0133010 i32.const 0 i32.store ;; reset solved count if the solution was touched
          i32.const 0x0134010 i32.const 0 i32.store ;; reset secret solved count if the solution was touched
          ))

      local.get $solved
      local.get $clicked_node i32.eqz i32.and
      local.get $clicked_link i32.eqz i32.and
      (if
        (then
          i32.const 0x0133008
          i32.const 0x0133008
          i32.load
          i32.const 1 i32.add
          i32.store
          )
        (else
          i32.const 0x0133008
          i32.const 0
          i32.store))

      local.get $secret_solved
      local.get $clicked_node i32.eqz i32.and
      local.get $clicked_link i32.eqz i32.and
      (if
        (then
          i32.const 0x0134008
          i32.const 0x0134008
          i32.load
          i32.const 1 i32.add
          i32.store
          )
        (else
          i32.const 0x0134008
          i32.const 0
          i32.store))

      i32.const 0x0132004 local.get $clicked_node i32.store
      i32.const 0x0132008 local.get $pending_node i32.store
      i32.const 0x013200c local.get $pending_link i32.store
      i32.const 0x013201c local.get $new_node i32.store
      )

(func $wave_gen_sin (param $target f32) (param $decay f32) (param $frequency f32) (param $address i32) (result f32)
      (local $phase f32)
      (local $amplitude f32)

      local.get $address
      local.get $address
      f32.load
      local.tee $phase
      f32.const 0.159154943091895 f32.mul
      local.tee $phase
      local.get $phase
      f32.floor
      f32.sub
      local.get $frequency
      f32.add
      f32.const 6.283185307179586 f32.mul
      local.tee $phase
      f32.store

      local.get $address
      i32.const 4 i32.add
      local.tee $address
      local.get $address
      f32.load
      local.tee $amplitude
      local.get $target
      f32.sub
      local.get $decay f32.mul
      local.get $target
      f32.add
      local.tee $amplitude
      f32.store
      local.get $phase
      call $sin
      local.get $amplitude
      f32.mul)

(func $wave_gen_saw (param $target f32) (param $decay f32) (param $frequency f32) (param $address i32) (result f32)
      (local $phase f32)
      (local $amplitude f32)

      local.get $address
      local.get $address
      f32.load
      local.tee $phase
      local.get $phase
      f32.floor
      f32.sub
      local.get $frequency
      f32.add
      local.tee $phase
      f32.store

      local.get $address
      i32.const 4 i32.add
      local.tee $address
      local.get $address
      f32.load
      local.tee $amplitude
      local.get $target
      f32.sub
      local.get $decay f32.mul
      local.get $target
      f32.add
      local.tee $amplitude
      f32.store
      local.get $phase
      call $saw
      local.get $amplitude
      f32.mul)

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
      i32.const 1 i32.and
      local.set $clicked

      local.get $clicked
      (if
        (then
          i32.const 0x130010
          i32.const 0x130010
          f32.load
          f32.const 0.2 f32.add
          f32.store
          ))

      i32.const 0x12c00c i32.load
      i32.const 1 i32.and
      (if
        (then
          i32.const 0x130014
          i32.const 0x130014
          f32.load
          f32.const 10.2 f32.add
          f32.store
          ))

      (loop $audio_loop
            local.get $writ
            i32.const 1 i32.add
            local.set $writ

            call $randf_s
            f32.const 0.5 f32.mul
            local.set $noise

            local.get $noise
            i32.const 0x132008 i32.load ;; pending_node
            i32.eqz
            i32.eqz
            i32.const 0x013200c i32.load ;; pending_link
            i32.eqz
            i32.eqz
            i32.or
            f32.convert_i32_s
            f32.mul
            f32.const 1.5
            f32.mul
            f32.const 0.9999 f32.const 0.0005 i32.const 0x130004 call $oscillator
            f32.const 0.9 i32.const 0x13002c call $lowpass
            f32.const 0.9 i32.const 0x130030 call $lowpass
            f32.const 0.9 i32.const 0x130034 call $lowpass
            f32.const 0.89 i32.const 0x130038 call $highpass
            f32.const 0.89 i32.const 0x13003c call $highpass
            f32.const 0.89 i32.const 0x130040 call $highpass
            ;; f32.const 0.9995 f32.const 0.0005 i32.const 0x12F00c call $oscillator

            local.get $noise
            f32.const 0.9998 f32.const 0.001 i32.const 0x13000c call $oscillator
            f32.const 0.999 i32.const 0x130044 call $lowpass
            f32.const 0.8 i32.const 0x130048 call $highpass
            f32.const 0.5 f32.mul
            f32.add

            local.get $noise
            f32.const 0.9990 f32.const 0.002 i32.const 0x130014 call $oscillator
            f32.const 0.999 i32.const 0x13004c call $lowpass
            ;; f32.const 0.9 i32.const 0x130054 call $lowpass
            f32.const 0.9 i32.const 0x130050 call $highpass
            f32.const 0.1 f32.mul
            f32.add

            local.get $noise
            f32.const 0.1 f32.mul
            ;; f32.const 0.999 i32.const 0x15004c call $lowpass
            f32.const 0.9999 i32.const 0x15004c call $lowpass
            ;; drop f32.const 1
            f32.const 0.9999 f32.const 0.01 i32.const 0x150008 call $wave_gen_sin
            ;; f32.const 0.999 f32.const 0.006 i32.const 0x150000 call $wave_gen_sin
            f32.add

            local.get $noise
            f32.const 0.01 f32.mul
            f32.const 0.9996 f32.const 0.008 i32.const 0x150014 call $oscillator
            f32.const 0.9999 i32.const 0x15001c call $lowpass
            f32.add

            local.get $noise
            f32.const 0.001 f32.mul
            f32.const 0.9996 f32.const 0.01 i32.const 0x150024 call $oscillator
            f32.const 0.9999 i32.const 0x15002c call $lowpass
            f32.const 1.2 f32.mul
            f32.add

            local.get $noise
            f32.const 0.001 f32.mul
            f32.const 0.9996 f32.const 0.01666666 i32.const 0x150034 call $oscillator
            f32.const 0.9999 i32.const 0x15003c call $lowpass
            f32.const 1.4 f32.mul
            f32.add

            local.get $noise
            f32.const 0.001 f32.mul
            f32.const 0.9999 f32.const 0.03333333 i32.const 0x150044 call $oscillator
            f32.const 0.9999 i32.const 0x15004c call $lowpass
            f32.const 2.0 f32.mul
            f32.add

            local.get $noise
            i32.const 0x0133100
            f32.load
            local.tee $osc
            local.get $osc
            f32.mul
            f32.mul
            f32.const 0.015 f32.mul
            f32.const 0.99 i32.const 0x150070 call $lowpass
            f32.const 0.95 f32.const 0.001 i32.const 0x150064 call $oscillator
            f32.const 0.95 f32.const 0.002 i32.const 0x150074 call $oscillator
            ;; f32.const 0.95 f32.const 0.004 i32.const 0x150084 call $oscillator
            ;; f32.const 0.9999 i32.const 0x15006c call $lowpass
            f32.const 2.0 f32.mul
            f32.add

            local.get $noise
            f32.const 0.015 f32.mul
            f32.const 0.99 i32.const 0x150080 call $lowpass
            f32.const 0.999 f32.const 0.001 i32.const 0x150084 call $oscillator
            local.get $noise
            f32.mul
            f32.const 0.9999 f32.const 0.0001 i32.const 0x150094 call $oscillator
            f32.const 0.99 i32.const 0x150090 call $lowpass
            f32.const 0.15 f32.mul
            f32.add

            local.get $noise
            f32.const 0.015 f32.mul
            f32.const 0.999 i32.const 0x150100 call $lowpass
            f32.const 0.9997 f32.const 0.005 i32.const 0x150104 call $wave_gen_saw
            ;; f32.const 0.99 f32.const 0.0601 i32.const 0x150114 call $oscillator
            f32.const 0.006 f32.mul
            f32.add

            local.get $noise
            f32.const 0.015 f32.mul
            f32.const 0.999 i32.const 0x150110 call $lowpass
            f32.const 0.999 f32.const 0.001 i32.const 0x150114 call $oscillator
            local.get $noise
            f32.mul
            f32.const 0.995 i32.const 0x150120 call $lowpass
            f32.const 0.995 i32.const 0x150130 call $lowpass
            ;; f32.const 0.95 i32.const 0x150140 call $lowpass
            f32.const 0.997 f32.const 0.007 i32.const 0x150124 call $oscillator
            f32.const 0.14 f32.mul
            f32.add

            local.get $noise
            f32.const 0.015 f32.mul
            f32.const 0.0 f32.const 0.5
            i32.const 0x0132014 i32.load i32.eqz
            select
            f32.add
            f32.const 0.995 i32.const 0x150130 call $lowpass
            f32.const 0.9995
            i32.const 0x0132020 f32.load f32.abs
            local.tee $osc
            local.get $osc
            f32.mul
            f32.const 0.01 f32.mul
            f32.const 0.001 f32.add
            i32.const 0x150134 call $wave_gen_sin
            ;; f32.const 0.99 f32.const 0.0601 i32.const 0x150114 call $oscillator
            f32.const 0.016 f32.mul
            f32.add

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

(func $fbm (param $x f32) (param $y f32) (result f32)
      local.get $x
      i32.trunc_f32_s
      local.get $y
      i32.trunc_f32_s
      call $hash2d

      local.get $x
      f32.const 2.0 f32.mul
      local.tee $x
      i32.trunc_f32_s
      local.get $y
      f32.const 2.0 f32.mul
      local.tee $y
      i32.trunc_f32_s
      call $hash2d
      f32.add

      local.get $x
      f32.const 2.0 f32.mul
      local.tee $x
      i32.trunc_f32_s
      local.get $y
      f32.const 2.0 f32.mul
      local.tee $y
      i32.trunc_f32_s
      call $hash2d
      f32.add
      f32.const 0.25 f32.mul

      )

(func $handle_buttons
      (local $mx f32)
      (local $my f32)
      (local $clicked i32)
      (local $level i32)
      (local $color i32)
      i32.const 0x12c008 i32.load
      i32.const 1 i32.and
      local.set $clicked

      i32.const 0x133000 i32.load local.set $level

      i32.const 0x12c000 f32.load local.set $mx
      i32.const 0x12c004 f32.load local.set $my

      i32.const 0x133004 i32.load
      local.get $level i32.shr_u
      i32.const 1 i32.and
      ;; i32.const 1 i32.or ;; CHEAT
      if $level_completed

      i32.const 0xFF_80_60_75 local.set $color
      local.get $mx f32.const 608 f32.sub f32.abs
      f32.const 16 f32.lt

      local.get $my f32.const 240 f32.sub f32.abs
      f32.const 32 f32.lt
      i32.and
      (if (then
            i32.const 0xFF_FF_FF_FF local.set $color
            local.get $clicked
            (if (then
                  i32.const 0x12c008 i32.const 0 i32.store
                  i32.const 0x150118
                  i32.const 0x150118
                  f32.load
                  f32.const 1.5 f32.add
                  f32.store

                  local.get $level
                  i32.const 1 i32.add
                  i32.const 1 ;; do_load
                  call $levels
                  ))
        ))

      f32.const 608 f32.const 240
      f32.const 16 f32.const 32
      f32.const 1
      local.get $color
      call $draw_arrow
      end ;; level_completed

      local.get $level i32.const 1 i32.ne
      if $prev

      i32.const 0xFF_80_60_75 local.set $color
      local.get $mx f32.const 32 f32.sub f32.abs
      f32.const 16 f32.lt

      local.get $my f32.const 240 f32.sub f32.abs
      f32.const 32 f32.lt
      i32.and
      (if (then
            i32.const 0xFF_FF_FF_FF local.set $color
            local.get $clicked
            (if (then
                  i32.const 0x12c008 i32.const 0 i32.store
                  i32.const 0x150118
                  i32.const 0x150118
                  f32.load
                  f32.const 1.5 f32.add
                  f32.store

                  local.get $level
                  i32.const 1 i32.sub
                  i32.const 1 ;; do_load
                  call $levels
                  ))
        ))

      f32.const 32 f32.const 240
      f32.const 16 f32.const 32
      f32.const -1
      local.get $color
      call $draw_arrow

      end ;; prev

      ;; secret button
      i32.const 0x134004
      i32.load
      if $secret

      i32.const 0xFF_80_60_75 local.set $color
      local.get $mx f32.const 320 f32.sub f32.abs
      f32.const 32 f32.lt

      local.get $my f32.const 450 f32.sub f32.abs
      f32.const 16 f32.lt
      i32.and
      (if (then
            i32.const 0xFF_FF_FF_FF local.set $color
            local.get $clicked
            (if (then
                  i32.const 0x12c008 i32.const 0 i32.store
                  i32.const 0x150118
                  i32.const 0x150118
                  f32.load
                  f32.const 1.5 f32.add
                  f32.store

                  i32.const 0x134024
                  i32.const 1
                  i32.store
                  ))
        ))

      f32.const 320 f32.const 450
      f32.const 32 f32.const 16
      local.get $color
      call $draw_arrow_horizontal

      end ;; secret

      )

(func $handle_movement
      (local $mx f32)
      (local $my f32)
      (local $px f32)
      (local $py f32)
      (local $sx f32)
      (local $sy f32)
      (local $scale f32)
      (local $pan_clicking i32)

      i32.const 0x132004 i32.load i32.eqz ;; clicked_node
      i32.const 0x132014 i32.load i32.eqz ;; clicked_link
      i32.or
      (if (then) (else return))

      i32.const 0x12c000 f32.load local.set $mx
      i32.const 0x12c004 f32.load local.set $my

      i32.const 0x12c010 i32.load
      local.tee $pan_clicking
      i32.const 1 i32.and
      (if (then
            i32.const 0x130818 local.get $mx f32.store
            i32.const 0x13081c local.get $my f32.store
            ))

      i32.const 0x130808 f32.load local.set $px
      i32.const 0x13080c f32.load local.set $py

      i32.const 0x130810 f32.load local.set $scale

      local.get $px
      local.get $mx local.get $scale f32.div
      f32.sub local.set $px

      local.get $py
      local.get $my local.get $scale f32.div
      f32.sub local.set $py

      i32.const 0x130810
      i32.const 0x130810 f32.load
      i32.const 0x12c014 f32.load ;; wheel
      f32.const -0.001
      f32.mul
      call $exp
      f32.mul
      f32.store

      local.get $pan_clicking
      (if (then
            i32.const 0x130818 f32.load local.set $sx
            i32.const 0x13081c f32.load local.set $sy

            f32.const 1 i32.const 0x130810 f32.load f32.div local.set $scale

            local.get $mx local.get $sx f32.sub local.get $scale f32.mul local.get $px f32.add local.set $px
            local.get $my local.get $sy f32.sub local.get $scale f32.mul local.get $py f32.add local.set $py

            i32.const 0x130818 local.get $mx f32.store
            i32.const 0x13081c local.get $my f32.store

            ))

      i32.const 0x130810 f32.load local.set $scale
      local.get $mx local.get $scale f32.div
      local.get $px f32.add local.set $px
      local.get $my local.get $scale f32.div
      local.get $py f32.add local.set $py

      i32.const 0x130808 local.get $px f32.store
      i32.const 0x13080c local.get $py f32.store
      )

(func $blend_color (param $color1 i32) (param $color2 i32) (param $t f32) (result i32)
      (local $tv v128)

      v128.const i32x4 0 0 0 0
      local.get $color1
      i32x4.replace_lane 0
      v128.const i8x16 0 16 16 16 1 16 16 16 2 16 16 16 3 16 16 16
      i8x16.swizzle
      f32x4.convert_i32x4_s

      v128.const f32x4 1 1 1 1
      local.get $t
      f32x4.splat
      local.tee $tv
      f32x4.sub
      f32x4.mul

      v128.const i32x4 0 0 0 0
      local.get $color2
      i32x4.replace_lane 0
      v128.const i8x16 0 16 16 16 1 16 16 16 2 16 16 16 3 16 16 16
      i8x16.swizzle
      f32x4.convert_i32x4_s
      local.get $tv
      f32x4.mul

      f32x4.add
      i32x4.trunc_sat_f32x4_s
      v128.const i32x4 0xFF 0xFF 0xFF 0xFF i32x4.min_s
      v128.const i8x16 0 4 8 12 0 0 0 0 0 0 0 0 0 0 0 0
      i8x16.swizzle
      i32x4.extract_lane 0
      i32.const 0xFFFF1FFF i32.and
      )

(func $do_credits
      (local $credit_scroll f32)
      i32.const 0x0134024
      i32.const 0x0134024
      f32.load
      local.tee $credit_scroll
      f32.const 2500
      f32.const 0.005
      call $lerp
      f32.store

      ;; move the camera
      i32.const 0x13080c
      i32.const 0x13080c f32.load
      f32.const 3 f32.sub
      f32.const -3000
      f32.max
      f32.store

      i32.const 0x155000 i32.const 19
      f32.const 307
      f32.const 740
      local.get $credit_scroll
      f32.const 0.2 f32.mul
      f32.const 500
      f32.min
      f32.sub
      call $draw_text

      i32.const 0x155013 i32.const 53
      f32.const 215
      f32.const 550
      local.get $credit_scroll
      f32.const 0.2 f32.mul
      f32.const 500
      f32.min
      f32.sub
      call $draw_text

      i32.const 0x155048 i32.const 36
      f32.const 262
      f32.const 515
      local.get $credit_scroll
      f32.const 0.2 f32.mul
      f32.const 500
      f32.min
      f32.sub
      call $draw_text
      )

(func (export "update")
      (local $i i32)
      (local $x i32)
      (local $y i32)
      (local $base i32)
      (local $vx v128)
      (local $vy0 v128)
      (local $vy v128)
      (local $vptr v128)
      (local $r f32)
      (local $offset_x v128)
      (local $offset_y v128)
      (local $level i32)
      (local $credits i32)
      (local $credit_scroll f32)
      (local $time i32)
      (local $background_blur f32)
      (local $background_color i32)
      (local $flames f32)

      i32.const 0x133000 i32.load local.tee $level
      i32.eqz
      (if (then
            i32.const 1 ;; level
            local.tee $level
            i32.const 1 ;; do_load
            call $levels
            ))

      ;; time
      i32.const 0x0130804
      i32.const 0x0130804
      i32.load
      i32.const 1
      i32.add
      local.tee $time
      i32.store

      ;; call $randf_s
      ;; f32.const 1.0 f32.mul
      ;; i32.trunc_f32_s
      ;; i32x4.splat
      ;; local.set $offset_x

      ;; ;; call $randf_s
      ;; ;; f32.const 1.5 f32.mul
      ;; ;; i32.trunc_f32_s
      ;; ;; i32x4.splat
      ;; ;; local.set $offset_y

      local.get $time i32.const 0x7F i32.and
      i32.eqz
      (if (then
            call $serialize_solution
            local.get $level
            call $save_data

            call $serialize_stats
            local.get 0
            call $save_data))

      i32.const 0x0134024 ;; credits
      i32.load
      local.set $credits

      i32.const 0x0134024 ;; credits
      f32.load
      local.set $credit_scroll

      ;; f32.const 0.2
      i32.const 0x0133010 i32.load ;; count solved cases
      i32.popcnt
      i32.const 0x0134010 i32.load
      i32.popcnt
      i32.add
      f32.convert_i32_u

      local.tee $flames
      i32.const 0x0133100 local.get $flames f32.store

      ;; f32.div
      f32.const -0.5 f32.mul
      f32.const -1.5 f32.add
      call $exp
      local.set $background_blur

      ;; i32.const 0xFF302034
      ;; local.set $background_color

      (loop $y_loop
            local.get $y
            i32x4.splat
            local.set $vy0
            local.get $y
            i32.const 2560 i32.mul
            local.set $base
            i32.const 0 local.set $x

            i32.const 0xFF302034

            local.get $credits
            (if (param i32) (result i32)
              (then
                i32.const 0x000000
                local.get $y
                f32.convert_i32_s
                local.get $credit_scroll
                f32.const -500.0
                f32.add
                f32.add
                f32.const 0.001 f32.mul
                f32.const 0 f32.max
                f32.const 1 f32.min
                call $blend_color
                  ))
            local.set $background_color

            (loop $x_loop
                  local.get $x
                  i32.const 4 i32.mul
                  local.get $base
                  i32.add

                  local.get $vy0
                  call $randi32x4
                  local.tee $offset_y
                  i32.const 31
                  i32x4.shr_s
                  i32x4.add
                  ;; local.get $offset_y
                  ;; v128.const i32x4 1 1 1 1
                  ;; v128.and
                  ;; i32x4.add
                  v128.const i32x4 0 0 0 0 i32x4.max_s
                  v128.const i32x4 479 479 479 479 i32x4.min_s
                  local.tee $vy
                  v128.const i32x4 640 640 640 640 i32x4.mul

                  local.get $x
                  i32x4.splat
                  v128.const i32x4 0 1 2 3
                  i32x4.add

                  local.tee $vx
                  call $randi32x4
                  local.tee $offset_x
                  i32.const 31
                  i32x4.shr_s
                  i32x4.add
                  local.get $offset_x
                  v128.const i32x4 1 1 1 1
                  v128.and
                  i32x4.add
                  v128.const i32x4 0 0 0 0 i32x4.max_s
                  v128.const i32x4 639 639 639 639 i32x4.min_s
                  local.tee $vx
                  i32x4.add
                  v128.const i32x4 4 4 4 4 i32x4.mul

                  local.tee $vptr
                  local.get $vptr
                  i32x4.extract_lane 0
                  i32.load
                  local.get $background_color
                  local.get $background_blur
                  call $blend_color
                  i32x4.replace_lane 0
                  local.tee $vptr

                  local.get $vptr
                  i32x4.extract_lane 1
                  i32.load
                  local.get $background_color
                  local.get $background_blur
                  call $blend_color
                  i32x4.replace_lane 1
                  local.tee $vptr

                  local.get $vptr
                  i32x4.extract_lane 2
                  i32.load
                  local.get $background_color
                  local.get $background_blur
                  call $blend_color
                  i32x4.replace_lane 2
                  local.tee $vptr

                  local.get $vptr
                  i32x4.extract_lane 3
                  i32.load
                  local.get $background_color
                  local.get $background_blur
                  call $blend_color
                  i32x4.replace_lane 3
                  local.tee $vptr

                  v128.store

                  local.get $x
                  i32.const 4 i32.add
                  local.tee $x
                  i32.const 640
                  i32.lt_s
                  br_if $x_loop)
            local.get $y
            i32.const 1 i32.add
            local.tee $y
            i32.const 480
            i32.lt_s
            br_if $y_loop)

      ;; (loop $i_loop
      ;;       local.get $i
      ;;       i32.const 640
      ;;       i32.rem_u
      ;;       local.set $x

      ;;       local.get $i
      ;;       i32.const 640
      ;;       i32.div_u
      ;;       local.set $y

      ;;       ;; get the pixel address
      ;;       local.get $i
      ;;       i32.const 4
      ;;       i32.mul

      ;;       i32.const 0x402039

      ;;       local.get $x
      ;;       call $randf_s
      ;;       f32.const 1.5 f32.mul
      ;;       i32.trunc_f32_s
      ;;       i32.add

      ;;       i32x4.splat
      ;;       v128.const i32x4 0 0 0 0 i32x4.max_s
      ;;       v128.const i32x4 639 0 0 0 i32x4.min_s
      ;;       i32x4.extract_lane 0

      ;;       local.get $y
      ;;       call $randf_s
      ;;       f32.const 1.5 f32.mul
      ;;       i32.trunc_f32_s
      ;;       i32.add

      ;;       i32x4.splat
      ;;       v128.const i32x4 0 0 0 0 i32x4.max_s
      ;;       v128.const i32x4 479 0 0 0 i32x4.min_s
      ;;       i32x4.extract_lane 0
      ;;       i32.const 640 i32.mul
      ;;       i32.add

      ;;       i32.const 4
      ;;       i32.mul
      ;;       i32.load
      ;;       f32.const 0.9
      ;;       call $blend_color

      ;;       local.get $credits
      ;;       (if (param i32) (result i32)
      ;;         (then
      ;;           i32.const 0x000000
      ;;           local.get $y
      ;;           f32.convert_i32_s
      ;;           local.get $credit_scroll
      ;;           f32.const -500.0
      ;;           f32.add
      ;;           f32.add
      ;;           f32.const 0.001 f32.mul
      ;;           f32.const 0 f32.max
      ;;           f32.const 1 f32.min
      ;;           call $blend_color
      ;;             ))

      ;;       i32.const 0xFF000000
      ;;       i32.or

      ;;       ;; ;; motion blur
      ;;       ;; local.get $i
      ;;       ;; i32.const 4
      ;;       ;; i32.mul
      ;;       ;; i32.load
      ;;       ;; i32.const 0xfefefefe i32.and
      ;;       ;; i32.const 1
      ;;       ;; i32.shr_u
      ;;       ;; i32.or

      ;;       i32.store

      ;;       local.get $i
      ;;       i32.const 1
      ;;       i32.add
      ;;       local.tee $i
      ;;       i32.const 307200
      ;;       i32.lt_s
      ;;       br_if $i_loop)

      local.get $credits
      if $do_credits

      call $do_credits

      else
      call $handle_movement

      local.get $level
      i32.const 0
      call $levels

      ;; i32.const 0x0014_0000
      ;; i32.const 11
      ;; i32.const 0x12c000 f32.load
      ;; i32.const 0x12c004 f32.load
      ;; call $draw_text

      ;; call $update_particles
      call $handle_buttons

      ;; local.get $level
      ;; i32.const 0x0133004 i32.load
      ;; i32.const 0x13300c i32.load
      i32.const 0x133000 i32.load
      call $i32print
      end

      call $update_links
      call $update_nodes

      call $process_audio
      )

(func $validate (param $i i32) (param $max_cases i32) (param $time_mask i32)
      (local $case_number i32)
      (local $solved_cases i32)
      (local $y f32)
      (local $shake_x f32)
      (local $shake_y f32)
      (local $shake_dx f32)
      (local $shake_dy f32)
      (local $bell_pointer i32)
      (local $was_solved i32)

      i32.const 0x0133014 f32.load local.set $shake_x
      i32.const 0x0133018 f32.load local.set $shake_y
      i32.const 0x013301c f32.load local.set $shake_dx
      i32.const 0x0133020 f32.load local.set $shake_dy

      i32.const 0x133010 i32.load local.set $solved_cases

      i32.const 0x13300c i32.load local.set $case_number

      i32.const 0x0130804 i32.load
      local.get $time_mask i32.and i32.eqz
      (if (then
            i32.const 0x133008 i32.load
            i32.const 30 i32.gt_s
            (if (then
                  i32.const 0x150018
                  local.tee $bell_pointer
                  i32.const 0x0133010 i32.load ;; count solved cases
                  i32.popcnt
                  i32.const 4 i32.add
                  local.get $max_cases i32.sub
                  i32.const 0x10 i32.mul
                  i32.add
                  local.get $bell_pointer
                  f32.load
                  f32.const 0.5 f32.add
                  f32.store

                  i32.const 0x133010
                  i32.const 0x133010 i32.load
                  i32.const 1 local.get $case_number i32.shl
                  i32.or
                  local.tee $solved_cases
                  i32.store
                  local.get $solved_cases
                  i32.const 1 local.get $max_cases i32.shl
                  i32.const 1 i32.sub
                  i32.xor
                  i32.eqz
                  (if (then
                        i32.const 0x133004
                        i32.const 0x133004 i32.load
                        local.tee $was_solved
                        i32.const 1 local.get $i i32.shl i32.or
                        i32.store

                        local.get $was_solved
                        i32.const 1 local.get $i i32.shl i32.and
                        (if (then)
                          (else
                            i32.const 0x150088
                            i32.const 0x150088
                            f32.load
                            f32.const 0.5 f32.add
                            f32.store
                            ))
                        ))
                  )
              (else
                i32.const 0x150108
                i32.const 0x150108
                f32.load
                f32.const 10.5 f32.add
                f32.store

                i32.const 0x0133010 i32.const 0 i32.store

                local.get $shake_dx call $randf_s f32.const 5.0 f32.mul f32.add local.set $shake_dx
                local.get $shake_dy call $randf_s f32.const 5.0 f32.mul f32.add local.set $shake_dy
                ))

            i32.const 0x13300c
            local.get $case_number
            i32.const 1 i32.add
            local.get $max_cases i32.rem_s
            i32.store
            ))

      local.get $shake_x local.get $shake_dx f32.add local.set $shake_x
      local.get $shake_y local.get $shake_dy f32.add local.set $shake_y

      local.get $shake_dx f32.const 0.90 f32.mul local.get $shake_x f32.const 1.0 f32.mul f32.sub local.set $shake_dx
      local.get $shake_dy f32.const 0.90 f32.mul local.get $shake_y f32.const 1.0 f32.mul f32.sub local.set $shake_dy

      i32.const 0x0133014 local.get $shake_x  f32.store
      i32.const 0x0133018 local.get $shake_y  f32.store
      i32.const 0x013301c local.get $shake_dx f32.store
      i32.const 0x0133020 local.get $shake_dy f32.store

      local.get $max_cases
      f32.convert_i32_s
      f32.const -16 f32.mul
      f32.const 256 f32.add
      local.set $y
      i32.const 0 local.set $i
      (loop $case_loop
            f32.const 565 local.get $shake_x f32.add
            local.get $y  local.get $shake_y f32.add
            f32.const 10.5 f32.const 7.5
            local.get $i local.get $case_number i32.eq
            select
            f32.const 6.5
            i32.const 0xFF0000FF
            i32.const 0xFFFFFFFF
            local.get $shake_dx local.get $shake_dx f32.mul
            local.get $shake_dy local.get $shake_dy f32.mul
            f32.add
            local.get $shake_x local.get $shake_x f32.mul
            local.get $shake_y local.get $shake_y f32.mul
            f32.add
            f32.add
            f32.const 0.05 f32.gt
            select
            call $draw_ring_screenspace

            local.get $solved_cases
            i32.const 1 local.get $i i32.shl
            i32.and
            (if (then
                  f32.const 565 local.get $shake_x f32.add
                  local.get $y  local.get $shake_y f32.add
                  f32.const 5
                  i32.const 0xFFFFFFFF
                  call $draw_circle_screenspace

                  ))

            local.get $y
            f32.const 32 f32.add
            local.set $y

            local.get $i
            i32.const 1 i32.add
            local.tee $i
            local.get $max_cases
            i32.lt_s
            br_if $case_loop)
      )

(func $validate_secret (param $i i32) (param $max_cases i32) (param $time_mask i32)
      (local $case_number i32)
      (local $solved_cases i32)
      (local $x f32)
      (local $shake_x f32)
      (local $shake_y f32)
      (local $shake_dx f32)
      (local $shake_dy f32)
      (local $bell_pointer i32)

      i32.const 0x0134014 f32.load local.set $shake_x
      i32.const 0x0134018 f32.load local.set $shake_y
      i32.const 0x013401c f32.load local.set $shake_dx
      i32.const 0x0134020 f32.load local.set $shake_dy

      i32.const 0x134010 i32.load local.set $solved_cases

      i32.const 0x13400c i32.load local.set $case_number

      i32.const 0x0130804 i32.load
      local.get $time_mask i32.and i32.eqz
      (if (then
            i32.const 0x134008 i32.load
            i32.const 30 i32.gt_s
            (if (then
                  i32.const 0x150018
                  local.tee $bell_pointer
                  i32.const 0x0134010 i32.load ;; count solved cases
                  i32.popcnt
                  i32.const 4 i32.add
                  local.get $max_cases i32.sub
                  i32.const 0x10 i32.mul
                  i32.add
                  local.get $bell_pointer
                  f32.load
                  f32.const 0.5 f32.add
                  f32.store

                  i32.const 0x134010
                  i32.const 0x134010 i32.load
                  i32.const 1 local.get $case_number i32.shl
                  i32.or
                  local.tee $solved_cases
                  i32.store
                  local.get $solved_cases
                  i32.const 1 local.get $max_cases i32.shl
                  i32.const 1 i32.sub
                  i32.xor
                  i32.eqz
                  (if (then
                        i32.const 0x134004 i32.load
                        (if (then)
                          (else
                            i32.const 0x150088
                            i32.const 0x150088
                            f32.load
                            f32.const 0.5 f32.add
                            f32.store
                            ))

                        i32.const 0x134004 i32.const 1 i32.store))
                  )
              (else
                i32.const 0x0134010 i32.const 0 i32.store

                local.get $shake_dx call $randf_s f32.const 5.0 f32.mul f32.add local.set $shake_dx
                local.get $shake_dy call $randf_s f32.const 5.0 f32.mul f32.add local.set $shake_dy
                ))

            i32.const 0x13400c
            local.get $case_number
            i32.const 1 i32.add
            local.get $max_cases i32.rem_s
            i32.store
            ))

      local.get $shake_x local.get $shake_dx f32.add local.set $shake_x
      local.get $shake_y local.get $shake_dy f32.add local.set $shake_y

      local.get $shake_dx f32.const 0.90 f32.mul local.get $shake_x f32.const 1.0 f32.mul f32.sub local.set $shake_dx
      local.get $shake_dy f32.const 0.90 f32.mul local.get $shake_y f32.const 1.0 f32.mul f32.sub local.set $shake_dy

      i32.const 0x0134014 local.get $shake_x  f32.store
      i32.const 0x0134018 local.get $shake_y  f32.store
      i32.const 0x013401c local.get $shake_dx f32.store
      i32.const 0x0134020 local.get $shake_dy f32.store

      local.get $max_cases
      f32.convert_i32_s
      f32.const 20 f32.mul
      f32.const 300 f32.add
      local.set $x
      i32.const 0 local.set $i
      (loop $case_loop
            local.get $x   local.get $shake_x f32.add
            f32.const 1998 local.get $shake_y f32.add
            f32.const 16.5 f32.const 12.5
            local.get $i local.get $case_number i32.eq
            select
            f32.const 10.5
            i32.const 0xFF0000FF
            i32.const 0xFFFFFFFF
            local.get $shake_dx local.get $shake_dx f32.mul
            local.get $shake_dy local.get $shake_dy f32.mul
            f32.add
            local.get $shake_x local.get $shake_x f32.mul
            local.get $shake_y local.get $shake_y f32.mul
            f32.add
            f32.add
            f32.const 0.05 f32.gt
            select
            call $draw_ring

            local.get $solved_cases
            i32.const 1 local.get $i i32.shl
            i32.and
            (if (then
                  local.get $x   local.get $shake_x f32.add
                  f32.const 1998 local.get $shake_y f32.add
                  f32.const 8.5
                  i32.const 0xFFFFFFFF
                  call $draw_circle

                  ))

            local.get $x
            f32.const 40 f32.sub
            local.set $x

            local.get $i
            i32.const 1 i32.add
            local.tee $i
            local.get $max_cases
            i32.lt_s
            br_if $case_loop)
      )

(func $levels (param $i i32) (param $do_load i32)
      (local $case_number i32)
      (local $temp f32)
      (local $old_level i32)

      i32.const 0x13300c i32.load local.set $case_number

      local.get $do_load
      (if (then
            i32.const 0x133000 i32.load local.tee $old_level
            i32.eqz
            (if (then)
              (else
                call $serialize_solution
                local.get $old_level
                call $save_data
                ))
            i32.const 0x133000 local.get $i i32.store

            i32.const 0x130008 i32.const 0 i32.store
            i32.const 0x13000c i32.const 0 i32.store
            i32.const 0x130010 i32.const 0 i32.store
            i32.const 0x130014 i32.const 0 i32.store
            i32.const 0x130018 i32.const 0 i32.store
            i32.const 0x13001c i32.const 0 i32.store

            i32.const 0x130808 f32.const 0.0 f32.store
            i32.const 0x13080c f32.const 0.0 f32.store
            i32.const 0x130810 f32.const 1.0 f32.store

            i32.const 0x132000 i32.const 0 i32.store
            i32.const 0x132004 i32.const 0 i32.store
            i32.const 0x132008 i32.const 0 i32.store
            i32.const 0x132010 i32.const 0 i32.store
            i32.const 0x132014 i32.const 0 i32.store

            i32.const 0x0133008 i32.const 0 i32.store
            i32.const 0x013300c i32.const 0 i32.store
            i32.const 0x0133010 i32.const 0 i32.store

            i32.const 0x0134008 i32.const 0 i32.store
            i32.const 0x013400c i32.const 0 i32.store
            i32.const 0x0134010 i32.const 0 i32.store
            ))
      block $ret
      block $level10
      block $level9
      block $level8
      block $level7
      block $level6
      block $level5
      block $level4
      block $level3
      block $level2
      block $level1
      block $level0
      local.get $i
      br_table $level0 $level1 $level2 $level3 $level4 $level5 $level6 $level7 $level8 $level9 $level10
      end ;; level0
      end ;; level1
      local.get $do_load
      (if (then
            f32.const 128.0 f32.const 240.0
            i32.const 1
            call $create_node drop

            f32.const 512.0 f32.const 240.0
            i32.const 3
            call $create_node drop

            f32.const 360 f32.const 2048.0
            i32.const 5
            call $create_node drop

            f32.const 280 f32.const 2048.0
            i32.const 5
            call $create_node drop

            ;; targets
            i32.const 0x147004 f32.const 0.5 f32.store
            )
        (else
          ;; set inputs
          i32.const 0x148000
          f32.const 0.5
          f32.const 0.0
          local.get $case_number
          select
          f32.store

          ;; targets
          i32.const 0x147004
          f32.const 0.5
          f32.const 0.0
          local.get $case_number
          select
          f32.store

          i32.const 0x147008
          f32.const 0.5
          f32.const 0.0
          local.get $case_number
          select
          f32.store

          i32.const 0x13400c i32.load
          local.set $case_number
          i32.const 0x14700c
          f32.const 0.5
          f32.const 0.0
          local.get $case_number
          i32.const 2 i32.and
          select
          f32.store

          local.get $i
          i32.const 2
          i32.const 0x7F
          call $validate

          local.get $i
          i32.const 4
          i32.const 0x7F
          call $validate_secret
          ))
      br $ret
      end ;; level2
      local.get $do_load
      (if (then
            f32.const 128.0 f32.const 240.0
            i32.const 1
            call $create_node drop

            f32.const 512.0 f32.const 240.0
            i32.const 3
            call $create_node drop

            ;; targets
            i32.const 0x147004 f32.const 0.5 f32.store
            )
        (else
          ;; set inputs
          i32.const 0x148000
          f32.const 0.9
          f32.const 0.0
          local.get $case_number
          select
          f32.store

          ;; targets
          i32.const 0x147004
          f32.const -0.5
          f32.const 0.0
          local.get $case_number
          select
          f32.store

          local.get $i
          i32.const 2
          i32.const 0x7F
          call $validate
          ))
      br $ret
      end ;; level3
      local.get $do_load
      (if (then
            f32.const 128.0 f32.const 240.0
            i32.const 1
            call $create_node drop

            f32.const 512.0 f32.const 240.0
            i32.const 3
            call $create_node drop
            )
        (else
          ;; set inputs
          i32.const 0x148000
          f32.const 0.5
          f32.const 0.0
          local.get $case_number
          select
          f32.store

          ;; targets
          i32.const 0x147004
          f32.const 1.0
          f32.const 0.0
          local.get $case_number
          select
          f32.store

          local.get $i
          i32.const 2
          i32.const 0x7F
          call $validate
          ))
      br $ret
      end ;; level4
      local.get $do_load
      (if (then
            f32.const 128.0 f32.const 150.0
            i32.const 1
            call $create_node drop

            f32.const 128.0 f32.const 330.0
            i32.const 1
            call $create_node drop

            f32.const 512.0 f32.const 240.0
            i32.const 3
            call $create_node drop
            )
        (else
          ;; set inputs
          i32.const 0x148000
          f32.const 0.5
          f32.const 0.0
          local.get $case_number
          i32.const 1 i32.and
          select
          f32.store

          i32.const 0x148004
          f32.const 0.5
          f32.const 0.0
          local.get $case_number
          i32.const 2 i32.and
          select
          f32.store

          ;; targets
          i32.const 0x147008
          f32.const 0.0
          f32.const 0.5
          local.get $case_number i32.eqz
          select
          f32.store

          local.get $i
          i32.const 4
          i32.const 0x7F
          call $validate
          ))
      br $ret
      end ;; level5
      local.get $do_load
      (if (then
            f32.const 128.0 f32.const 240.0
            i32.const 1
            call $create_node drop

            f32.const 512.0 f32.const 240.0
            i32.const 3
            call $create_node drop

            i32.const 0x148000
            f32.const 0.0
            f32.store
            i32.const 0x147004
            f32.const 0.5
            f32.store
            )
        (else
          ;; set inputs
          i32.const 0x148000
          f32.const 0.5
          f32.const 0.0
          local.get $case_number
          select
          f32.store

          ;; targets
          i32.const 0x147004
          f32.const 0.0
          f32.const 0.5
          local.get $case_number
          select
          f32.store

          local.get $i
          i32.const 2
          i32.const 0x7F
          call $validate
          ))
      br $ret
      end ;; level6
      local.get $do_load
      (if (then
            f32.const 128.0 f32.const 150.0
            i32.const 1
            call $create_node drop

            f32.const 128.0 f32.const 330.0
            i32.const 1
            call $create_node drop

            f32.const 512.0 f32.const 240.0
            i32.const 3
            call $create_node drop
            )
        (else
          ;; set inputs
          i32.const 0x148000
          f32.const 0.5
          f32.const 0.0
          local.get $case_number
          i32.const 1 i32.and
          select
          f32.store

          i32.const 0x148004
          f32.const 0.5
          f32.const 0.0
          local.get $case_number
          i32.const 2 i32.and
          select
          f32.store

          ;; targets
          i32.const 0x147008
          f32.const 0.5
          f32.const 0.0
          local.get $case_number i32.const 3 i32.eq
          select
          f32.store

          local.get $i
          i32.const 4
          i32.const 0x7F
          call $validate
          ))
      br $ret
      end ;; level7
      local.get $do_load
      (if (then
            f32.const 128.0 f32.const 240.0
            i32.const 1
            call $create_node drop

            f32.const 512.0 f32.const 240.0
            i32.const 3
            call $create_node drop
            )
        (else
          ;; set inputs
          i32.const 0x148000
          f32.const 0.0
          f32.const 0.5
          local.get $case_number
          i32.const 1 i32.and
          select
          local.tee $temp
          local.get $temp f32.neg
          local.get $case_number
          i32.const 2 i32.and
          select
          f32.store

          ;; targets
          i32.const 0x147004
          f32.const 0.0
          f32.const 0.5
          local.get $case_number
          i32.const 1 i32.and
          select
          f32.store

          local.get $i
          i32.const 3
          i32.const 0x7F
          call $validate
          ))

      br $ret
      end ;; level8
      local.get $do_load
      (if (then
            f32.const 128.0 f32.const 150.0
            i32.const 1
            call $create_node drop

            f32.const 128.0 f32.const 330.0
            i32.const 1
            call $create_node drop

            f32.const 512.0 f32.const 240.0
            i32.const 3
            call $create_node drop
            )
        (else
          ;; set inputs
          i32.const 0x148000
          f32.const 0.5
          f32.const 0.0
          local.get $case_number
          i32.const 1 i32.and
          select
          f32.store

          i32.const 0x148004
          f32.const 0.5
          f32.const 0.0
          local.get $case_number
          i32.const 2 i32.and
          select
          f32.store

          ;; targets
          i32.const 0x147008
          f32.const 0.5
          f32.const 0.0
          local.get $case_number i32.const 2 i32.eq
          local.get $case_number i32.const 1 i32.eq
          i32.or
          select
          f32.store

          local.get $i
          i32.const 4
          i32.const 0x7F
          call $validate
          ))
      br $ret
      end ;; level9
      local.get $do_load
      (if (then
            f32.const 128.0 f32.const 240.0
            i32.const 1
            call $create_node drop

            f32.const 512.0 f32.const 180.0
            i32.const 3
            call $create_node drop

            f32.const 512.0 f32.const 300.0
            i32.const 3
            call $create_node drop
            )
        (else
          ;; set inputs
          i32.const 0x148000
          local.get $case_number
          f32.convert_i32_s
          f32.const 0.333333333 f32.mul
          f32.store

          ;; targets
          i32.const 0x147004
          f32.const 0.5
          f32.const 0.0
          local.get $case_number
          i32.const 1 i32.and
          select
          f32.store

          i32.const 0x147008
          f32.const 0.5
          f32.const 0.0
          local.get $case_number
          i32.const 2 i32.and
          select
          f32.store

          local.get $i
          i32.const 4
          i32.const 0x7F
          call $validate
          ))
      br $ret
      end ;;level10
      local.get $do_load
      (if (then
            call $load_saved_level
            call $deserialize_solution
            return
            ))

      end ;; ret

      local.get $do_load
      (if (then
            local.get $i
            call $load_data
            (if (then
                  call $deserialize_solution))
            ))
      )

;; (func $test_setup
;;       ;; i32.const 1
;;       ;; i32.const 1
;;       ;; call $levels
;;       ;; i32.const 0x0134024 i32.const 0 i32.store
;;       ;; i32.const 0x0134028 i32.const 0 i32.store
;;       i32.const 0x0134004 i32.const 0 i32.store

;;       i32.const 0x0133004 i32.const 0x3FF i32.store
;;       )
;; (start $test_setup)

(start $load_stats)
